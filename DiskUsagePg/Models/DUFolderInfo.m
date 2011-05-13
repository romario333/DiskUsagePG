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
    // TODO: mam rozlezly synchronized vsude mozne a tohle bude taky btw asi zpomalovat
    @synchronized(_subfolders)
    {
        [_subfolders addObject:subfolder];
    }
}

- (NSArray *)subfolders
{
    return _subfolders;
}

- (NSString *)description
{
    return [_url path];
}

- (long)sizeWithSubfolders
{
    return _size;
}

- (void)addToSize:(long)increment
{
    _size += increment;
    [_parentFolder addToSize:increment];
}

@end
