//
//  DUFolderTreeItem.h
//  DiskUsagePg
//
//  Created by Roman Masek on 5/14/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DUFolderInfo.h"

// TODO: nemohl by tohle nahradit NSArrayController ?
@interface DUFolderTreeItem : NSObject {
@private
    BOOL _isExpanded;
    BOOL _isSelected;
    DUFolderInfo *_folder;
    
    NSMutableArray *_childrenCache;
}

- (id)initWithFolder:(DUFolderInfo *)folder;

// TODO: natvrdo sorteni podle size desc, fuj
/** @brief Returns children of this tree item. 
 *  @return Array of <code>DUFolderTreeItem</code> objects representing children of this item.
 *
 *  Children are loaded and sorted by size first time you call this method. If you want to update
 *  children, call <code>invalidate</code>.
 **/
- (NSArray *)children;

/** @brief Invalidates children cached on the first call of <code>children</code>.
 *
 **/
- (void)invalidate;

/** @brief Returns <code>YES</code> if this tree item can be expanded.
 **/
- (BOOL)isExpandable;

@property (nonatomic, retain) DUFolderInfo *folder;
// TODO: doimplementovat
@property BOOL isExpanded;
@property BOOL isSelected;

@end
