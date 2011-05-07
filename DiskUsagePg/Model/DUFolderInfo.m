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
    [_subfolders dealloc];
    [_parentFolder dealloc];
    [_url dealloc];
    
    [super dealloc];
}

- (id)initWithURL:(NSURL *)url parentFolder:(DUFolderInfo *)parentFolder
{
    self = [super init];
    if (self) {
        // TODO: doufam, ze mam takhle spravne
        _url = [url retain];
        _parentFolder = [parentFolder retain];
        _subfolders = [[NSMutableArray alloc] init];
    }
    
    return self;
}

+ (id)folderInfoWithURL:(NSURL *)url parentFolder:(DUFolderInfo *)parentFolder
{
    DUFolderInfo *folderInfo = [[[DUFolderInfo alloc] initWithURL:url parentFolder:parentFolder] autorelease];
    return folderInfo;
}

- (void)addSubfolder:(DUFolderInfo *)subfolder
{
    [_subfolders addObject:subfolder];
}

- (NSArray *)subfolders
{
    return _subfolders;
}

@end
