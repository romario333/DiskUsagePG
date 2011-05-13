//
//  DUSortedFolderInfo.m
//  DiskUsagePg
//
//  Created by Roman Masek on 5/13/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "DUFolderTreeData.h"

// TODO: lepsi nazev, nejaky view, wrapper, neco takovyho
@implementation DUFolderTreeData

- (id)initWithFolder:(DUFolderInfo *)folder
{
    self = [super init];
    if (self) {
        _folder = [folder retain];
        _subfolderCount = [_folder.subfolders count];
    }
    
    return self;
}

- (void)update
{
    [self _sort];
}

- (void)_sort
{
    if (_sortedSubfolders != nil) {
        [_sortedSubfolders release];
    }

    _sortedSubfolders = [_folder.subfolders mutableCopy];  
    
    NSSortDescriptor *sortDesc = [NSSortDescriptor sortDescriptorWithKey:@"size" ascending:NO];
    [_sortedSubfolders sortUsingDescriptors:[NSArray arrayWithObject:sortDesc]];

    _subfolderCount = [_sortedSubfolders count];
}

- (DUFolderTreeData *)subfolderAtIndex:(NSUInteger)index
{
    // TODO: co kdyz mezitim nektere pribyly?
    if (_sortedSubfolders == nil) {
        [self _sort];
    }
    DUFolderInfo *subfolder = [_sortedSubfolders objectAtIndex:index];
    // TODO: dalo by se nejak tomuhle autoreleasu vyhnout?
    return [[[DUFolderTreeData alloc] initWithFolder:subfolder] autorelease];
}

- (NSUInteger)subfolderCount
{
    return _subfolderCount;
}

- (DUFolderInfo *)folder
{
    return _folder;
}

- (void)dealloc
{
    [_folder release];
    [super dealloc];
}

@end
