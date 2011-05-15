//
//  DUFolderTreeItem.m
//  DiskUsagePg
//
//  Created by Roman Masek on 5/14/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "DUFolderTreeItem.h"

@implementation DUFolderTreeItem

@synthesize folder = _folder;

- (id)initWithFolder:(DUFolderInfo *)folder
{
    self = [super init];
    if (self) {
        self.folder = folder;
        _fileSizeFormatter = [[DUFileSizeFormatter alloc] initWithStyle:DUFileSizeFormatterOSNativeUnits | DUFileSizeFormatterLocalizedFormat];
    }
    
    return self;
}

- (void)dealloc
{
    if (_childrenCache != nil)
    {
        [_childrenCache release];
    }
    if (_sortedChildrenCache != nil)
    {
        [_sortedChildrenCache release];
    }
    
    [_folder release];
    [_fileSizeFormatter release];
    [super dealloc];
}

- (NSArray *)children
{
    static NSUInteger cacheInitialCapacity = 10;
    
    if (_childrenCache == nil)
    {
        _childrenCache = [[NSMapTable alloc] initWithKeyOptions:NSMapTableStrongMemory valueOptions:NSMapTableStrongMemory capacity:cacheInitialCapacity];
        _childrenCacheShouldBeUpdated = YES;
    }
    
    if (_childrenCacheShouldBeUpdated)
    {
        if (_sortedChildrenCache == nil)
        {
            _sortedChildrenCache = [[NSMutableArray alloc] initWithCapacity:cacheInitialCapacity];
        }
        [_sortedChildrenCache removeAllObjects];
        
        NSArray *subfolders = [_folder.subfolders copy];
        for (DUFolderInfo *folder in subfolders)
        {
            DUFolderTreeItem *folderItem = [[_childrenCache objectForKey:folder] retain];
            // TODO: neresim tu pripad, kdy foldery zacnou mizet?
            if (folderItem == nil)
            {
//                NSLog(@"New folder detected");
                folderItem = [[DUFolderTreeItem alloc] initWithFolder:folder];
                [_childrenCache setObject:folderItem forKey:folder];
            }
            [_sortedChildrenCache addObject:folderItem];
            [folderItem release];
        }
        [subfolders release];
        
        NSSortDescriptor *sortDesc = [NSSortDescriptor sortDescriptorWithKey:@"folder.size" ascending:NO];
        [_sortedChildrenCache sortUsingDescriptors:[NSArray arrayWithObject:sortDesc]];
        
        _childrenCacheShouldBeUpdated = NO;

    }
    
    return _sortedChildrenCache;
}

- (BOOL)isLeaf
{
    // TODO: kdybych chtel jo optimalizovat, tak zaridim, aby se tady deti nesortili 
    return [[self children] count] == 0;
}

- (void)updateChildrenCache
{
    [super willChangeValueForKey:@"children"]; // TODO: neslo by pres selector?
    
    if (_childrenCache != nil)
    {
        for (DUFolderTreeItem *child in [_childrenCache objectEnumerator])
        {
            [child updateChildrenCache];
        }
    }
    _childrenCacheShouldBeUpdated = YES;
    
    [super didChangeValueForKey:@"children"];
}

- (NSString *)folderName
{
    return [_folder.url lastPathComponent];
}

- (NSString *)folderSize
{
    return [_fileSizeFormatter stringFromFileSize:_folder.size];
}

@end
