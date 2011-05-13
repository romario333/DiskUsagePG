//
//  DUSortedFolderInfo.h
//  DiskUsagePg
//
//  Created by Roman Masek on 5/13/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DUFolderInfo.h"

// TODO: presunout asi do modelu
@interface DUFolderTreeData : NSObject {
@private
    DUFolderInfo *_folder;
    NSMutableArray *_sortedSubfolders;
    NSUInteger _subfolderCount;
}

- (id)initWithFolder:(DUFolderInfo *)folder;
- (void)update;
- (DUFolderTreeData *)subfolderAtIndex:(NSUInteger)index;
- (NSUInteger)subfolderCount;

- (DUFolderInfo *)folder;

- (void)_sort;

@end
