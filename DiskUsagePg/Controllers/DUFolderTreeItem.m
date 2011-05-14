//
//  DUFolderTreeItem.m
//  DiskUsagePg
//
//  Created by Roman Masek on 5/14/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "DUFolderTreeItem.h"


@implementation DUFolderTreeItem

@synthesize isExpanded = _isExpanded, isSelected = _isSelected, folder = _folder;

- (id)initWithFolder:(DUFolderInfo *)folder
{
    self = [super init];
    if (self) {
        self.folder = folder;
    }
    
    return self;
}

- (void)dealloc
{
    [_folder release];
    [super dealloc];
}

- (NSArray *)children
{
    if (_childrenCache == nil)
    {
        NSMutableArray *subfolders = [_folder.subfolders mutableCopy];
        
        NSSortDescriptor *sortDesc = [NSSortDescriptor sortDescriptorWithKey:@"size" ascending:NO];
        [subfolders sortUsingDescriptors:[NSArray arrayWithObject:sortDesc]];
        
        _childrenCache = [[NSMutableArray alloc] init];
        for (DUFolderInfo *folder in subfolders)
        {
            DUFolderTreeItem *child = [[DUFolderTreeItem alloc] initWithFolder:folder];
            [_childrenCache addObject:child];
            [child release];
        }
        [subfolders release];

    }
    return _childrenCache;
}

- (void)invalidate
{
    if (_childrenCache != nil)
    {
        for (DUFolderTreeItem *child in _childrenCache)
        {
            [child invalidate];
        }
        
        // TODO: zkusit, jestli by se zrychlilo, kdybych volal removeAllObjects
        // a cache nevytvarel znovu
        [_childrenCache release];
        _childrenCache = nil;
    }
}

- (BOOL)isExpandable
{
    // TODO: kdybych chtel jo optimalizovat, tak zaridim, aby se tady deti nesortili 
    return [[self children] count] > 0;
}


@end
