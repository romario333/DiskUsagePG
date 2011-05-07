//
//  DUFolderScanner.m
//  DiskUsagePg
//
//  Created by Roman Masek on 5/7/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "DUFolderScanner.h"


@implementation DUFolderScanner

- (id)init
{
    self = [super init];
    if (self) {
        // Initialization code here.
    }
    
    return self;
}

- (void)dealloc
{
    [super dealloc];
}

- (DUFolderInfo *)scanFolder:(NSURL *)folderUrl
{
    // TODO: kontrola, ze folderUrl existuje, je to adresar
    
    NSMutableDictionary *folderInfos = [[NSMutableDictionary alloc] init];
    
    DUFolderInfo *rootFolder = [[DUFolderInfo alloc] initWithURL:folderUrl parentFolder:nil];
    [folderInfos setObject:rootFolder forKey:folderUrl];
    
    // TODO: existuje i NSURLFileAllocatedSizeKey
    NSArray *keysToRead = [NSArray arrayWithObjects:NSURLIsDirectoryKey, NSURLFileSizeKey, nil];
    NSFileManager *fileManager = [[NSFileManager alloc] init];
    NSDirectoryEnumerator *dirEnumerator = [fileManager
                                            enumeratorAtURL:folderUrl 
                                            includingPropertiesForKeys:keysToRead 
                                            options:0 
                                            errorHandler:^BOOL(NSURL *url, NSError *error) {
                                                return NO;
                                            }];
    
    for (NSURL *url in dirEnumerator)
    {
        NSNumber *isDirectory = nil;
        [url getResourceValue:&isDirectory forKey:NSURLIsDirectoryKey error:NULL];
        
        //NSLog(@"url=%@; withoutLastPathComponent=%@;", url, [url URLByDeletingLastPathComponent]);
        
        NSURL *folderURL;
        if ([isDirectory boolValue])
        {
            folderURL = url;
        }
        else
        {
            folderURL = [url URLByDeletingLastPathComponent];
        }
        
        DUFolderInfo *folderInfo = [folderInfos objectForKey:folderURL];
        if (folderInfo == nil)
        {
            folderInfo = [[DUFolderInfo alloc] initWithURL:folderURL parentFolder:nil];
            NSLog(@"retainCount1=%lu", [folderInfo retainCount]);
            [folderInfos setObject:folderInfo forKey:folderURL];
            NSLog(@"retainCount2=%lu", [folderInfo retainCount]);
            [folderInfo release];
            NSLog(@"retainCount3=%lu", [folderInfo retainCount]);

        }
        
        if (![isDirectory boolValue])
        {
            // add file size to directory info
            NSNumber *fileSize;
            [url getResourceValue:&fileSize forKey:NSURLFileSizeKey error:NULL];
            folderInfo.size += [fileSize longValue];
        }
    }
    
    // create parent-child relationships between directories
    for (NSURL *childURL in [folderInfos keyEnumerator])
    {
        DUFolderInfo *child = [folderInfos objectForKey:childURL];
        DUFolderInfo *parent = [folderInfos objectForKey:[childURL URLByDeletingLastPathComponent]];
        [parent addSubfolder:child];
    }
    
    // TODO: ACH JO, PROC TO PADA, KDYZ RELEASUJU folderInfos ??
    [fileManager release];
    [folderInfos release];
    
    return rootFolder;
}

@end
