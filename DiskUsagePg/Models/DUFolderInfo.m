//
//  DUFolderInfo.m
//  DiskUsagePg
//
//  Created by Roman Masek on 5/6/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "DUFolderInfo.h"


@implementation DUFolderInfo

@synthesize parentFolder = _parentFolder, url = _url, size = _size;

- (id)init
{
    // TODO: jakpak resit tohle?
    @throw [NSException exceptionWithName:@"shit" reason:@"happens" userInfo:nil];
}

- (void)dealloc
{
    [_subfolders release];
    [_url release];
    
    [super dealloc];
}

- (id)initWithURL:(NSURL *)url
{
    self = [super init];
    if (self) {
        // TODO: doufam, ze mam takhle spravne
        _url = [url retain];
        _subfolders = [[NSMutableArray alloc] init];
    }
    
    return self;
}

+ (id)folderInfoWithURL:(NSURL *)url
{
    DUFolderInfo *folderInfo = [[[DUFolderInfo alloc] initWithURL:url] autorelease];
    return folderInfo;
}

- (void)addSubfolder:(DUFolderInfo *)subfolder
{
    subfolder.parentFolder = self;
    [_subfolders addObject:subfolder];
}

- (NSArray *)subfolders
{
    return _subfolders;
}

- (long)sizeWithSubfolders
{
    long totalSize = self.size;
    for (DUFolderInfo *subfolder in _subfolders)
    {
        totalSize += [subfolder sizeWithSubfolders];
    }
    return totalSize;
}

- (NSString *)description
{
    return [_url path];
}

- (void)sort
{
    NSSortDescriptor *sortDesc = [NSSortDescriptor sortDescriptorWithKey:@"sizeWithSubfolders" ascending:NO];
    [_subfolders sortUsingDescriptors:[NSArray arrayWithObject:sortDesc]];
    
    for (DUFolderInfo *subfolder in _subfolders)
    {
        [subfolder sort];
    }
}

@end
