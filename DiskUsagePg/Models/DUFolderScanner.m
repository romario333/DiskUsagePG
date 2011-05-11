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
    
    DUFolderInfo *rootFolder = [[DUFolderInfo alloc] initWithURL:folderUrl];
    
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
    
    DUFolderInfo *currentFolder = rootFolder;
    NSUInteger currentLevel = 1;
    DUFolderInfo *subfolder = nil;
    for (NSURL *url in dirEnumerator)
    {
        NSNumber *isDirectory = nil;
        [url getResourceValue:&isDirectory forKey:NSURLIsDirectoryKey error:NULL];

//        NSString *dirFlag = @"";
//        if ([isDirectory boolValue])
//            dirFlag = @"(d)";
//        NSLog(@"[%lu] %@ %@", [dirEnumerator level], [url path], dirFlag);
        
        if (dirEnumerator.level > currentLevel)
        {
            // we're going deeper in folder hierarchy
            
            // TODO: NSAssert considered harmful, proc?
            // TODO: proc to nejde strcit dovnitr NSAssertu?
            NSString *assertDesc = [NSString stringWithFormat:@"'%@' expected, got '%@' instead.", subfolder.url, url];
            NSAssert([[url URLByDeletingLastPathComponent] isEqualTo:subfolder.url], assertDesc);
            
            currentFolder = subfolder;
            subfolder = nil;
        }
        else if (dirEnumerator.level < currentLevel)
        {
            // we are going back up in folder hierarchy
            for (NSUInteger i = dirEnumerator.level; i < currentLevel; i++)
            {
                currentFolder = [currentFolder parentFolder];
            }
            NSAssert(currentFolder != nil, @"currentFolder should not be nil, ever.");
        }
        currentLevel = dirEnumerator.level;
        
        if ([isDirectory boolValue])
        {
            // potential subfolder to process, store it for next iteration
            subfolder = [[DUFolderInfo alloc] initWithURL:url];
            [currentFolder addSubfolder:subfolder];
            [subfolder release];
        }
        else
        {
            NSNumber *fileSize;
            [url getResourceValue:&fileSize forKey:NSURLFileSizeKey error:NULL];
            currentFolder.size += [fileSize longValue];
        }

        
    }
    
    [fileManager release];
    
    // TODO: tohle jako fakt a proc me nevaruje clang?
    return [rootFolder autorelease];
}

@end
