//
//  DUFolderScanner.m
//  DiskUsagePg
//
//  Created by Roman Masek on 5/7/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "DUScanFolderOperation.h"


@implementation DUScanFolderOperation

@synthesize folderInfo = _folderInfo;

- (id)initWithFolder:(NSURL *)folderURL
{
    self = [super init];
    if (self) {
        _folderInfo = [[DUFolderInfo alloc] initWithURL:folderURL];
    }
    
    return self;
}

- (void)dealloc
{
    [_folderInfo release];
    [super dealloc];
}

- (void)main {
    @try {
        NSAutoreleasePool* pool = [[NSAutoreleasePool alloc] init];
        
        [self _scanFolder];
        
        [pool release];
    }
    @catch(...) {
        // TODO: co to aspon nekam zapsat?
        // Do not rethrow exceptions.
    }    
}

- (void)_scanFolder
{
    // TODO: kontrola, ze folderUrl existuje, je to adresar
    
    DUFolderInfo *rootFolder = _folderInfo;
    
    // TODO: existuje i NSURLFileAllocatedSizeKey
    NSArray *keysToRead = [NSArray arrayWithObjects:NSURLIsDirectoryKey, NSURLFileSizeKey, nil];
    NSFileManager *fileManager = [[NSFileManager alloc] init];
    NSDirectoryEnumerator *dirEnumerator = [fileManager
                                            enumeratorAtURL:rootFolder.url 
                                            includingPropertiesForKeys:keysToRead 
                                            options:0 
                                            errorHandler:^BOOL(NSURL *url, NSError *error) {
                                                NSLog(@"error=%@", error);
                                                return YES;
                                            }];
    
    DUFolderInfo *currentFolder = rootFolder;
    NSUInteger currentLevel = 1;
    DUFolderInfo *subfolder = nil;
    for (NSURL *url in dirEnumerator)
    {
        if ([self isCancelled])
		{
			break;	// user cancelled this operation
		}
        
        NSNumber *isDirectory = nil;
        [url getResourceValue:&isDirectory forKey:NSURLIsDirectoryKey error:NULL];

//        NSString *dirFlag = @"";
//        if ([isDirectory boolValue])
//            dirFlag = @"(d)";
//        NSLog(@"[%lu] %@ %@", [dirEnumerator level], [url path], dirFlag);
        
        if (dirEnumerator.level > currentLevel)
        {
            // we're going deeper in folder hierarchy
            NSAssert([[url URLByDeletingLastPathComponent] isEqualTo:subfolder.url], ([NSString stringWithFormat:@"'%@' expected, got '%@' instead.", subfolder.url, url]));
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
            [currentFolder addToSize:[fileSize longValue]];
        }

        
    }
    
    [fileManager release];
}

@end
