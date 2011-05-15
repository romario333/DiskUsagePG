//
//  DUFolderTreeItem.h
//  DiskUsagePg
//
//  Created by Roman Masek on 5/14/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DUFolderInfo.h"
#import "DUFileSizeFormatter.h"

// TODO: jedina funkce tohoto objektu je serazovat foldery podle velikosti. Nemohl
// by to delat primo NSTreeController?
@interface DUFolderTreeItem : NSObject {
@private
    BOOL _isExpanded;
    BOOL _isSelected;
    DUFolderInfo *_folder;
    
    NSMapTable *_childrenCache;
    NSMutableArray *_sortedChildrenCache;
    BOOL _childrenCacheShouldBeUpdated;
    DUFileSizeFormatter *_fileSizeFormatter;
}

- (id)initWithFolder:(DUFolderInfo *)folder;

/** @brief Returns children of this tree item. 
 *  @return Array of <code>DUFolderTreeItem</code> objects representing children of this item.
 *
 *  Children are loaded and sorted by size first time you call this method. If you want to update
 *  children, call <code>invalidate</code>.
 **/
- (NSArray *)children;

- (BOOL)isLeaf;

- (void)updateChildrenCache;


@property (nonatomic, retain) DUFolderInfo *folder;

- (NSString *)folderName;
- (NSString *)folderSize;

@end
