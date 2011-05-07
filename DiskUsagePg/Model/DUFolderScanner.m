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
    
    DUFolderInfo *rootFolder = [[DUFolderInfo alloc] initWithURL:folderUrl parentFolder:nil];
    
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
    
    DUFolderInfo *folder = rootFolder;
    NSUInteger level = 0;
    for (NSURL *url in dirEnumerator)
    {
//        NSLog(@"file=%@", url);
//        NSLog(@"level=%lu", [dirEnumerator level]);
        
        NSNumber *isDirectory = nil;
        [url getResourceValue:&isDirectory forKey:NSURLIsDirectoryKey error:NULL];
        
        
        if (dirEnumerator.level > level)
        {
            // we are going deeper down in folder hierarchy
            NSURL *folderURL;
            if ([isDirectory boolValue])
            {
                folderURL = url;
            }
            else
            {
                folderURL = [url URLByDeletingLastPathComponent];
            }
            
            DUFolderInfo *childFolder = [[DUFolderInfo alloc] initWithURL:folderURL parentFolder:nil];
            [folder addSubfolder:childFolder];
            folder = childFolder;
            [childFolder release];
        }
        else if (dirEnumerator.level < level)
        {
            // we are going back up in folder hierarchy
            folder = [folder parentFolder];
            if (folder == nil)
            {
                // we are back at top
                folder = rootFolder;
            }
        }
        level = dirEnumerator.level;
        
        if (![isDirectory boolValue])
        {
            // add file size to directory info
            NSNumber *fileSize;
            [url getResourceValue:&fileSize forKey:NSURLFileSizeKey error:NULL];
            folder.size += [fileSize longValue];
        }
    }
    
    [fileManager release];
    
    // TODO: tohle jako fakt a proc me nevaruje clang?
    return [rootFolder autorelease];
}

@end
