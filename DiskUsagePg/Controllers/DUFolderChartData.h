//
//  DUFolderInfoTopEntries.h
//  DiskUsagePg
//
//  Created by Roman Masek on 5/11/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DUFolderInfo.h"

@interface DUFolderChartData : NSObject {
@private
    DUFolderInfo *_folder;
    NSUInteger _shareThreshold;
    
    NSMutableArray *_currentSectors;
    NSMapTable *_sectorsCache;
    NSMutableArray *_colors;
    NSColor *_othersColor;
    NSUInteger _nextColor;
}

- (id)initWithFolder:(DUFolderInfo *)folder shareThreshold:(NSUInteger)shareThreshold;
- (NSArray *)sectors;

- (void)update;

@property (readonly, retain) DUFolderInfo *folder;

@end

@interface DUFolderChartSector : NSObject {
@private
    DUFolderInfo *_folder;
    long _size;
    NSColor *_color;
}

- (id)initWithFolder:(DUFolderInfo *)folder size:(long)size;

@property (nonatomic, retain) DUFolderInfo *folder;
@property (nonatomic) long size;
@property (nonatomic, retain) NSColor *color;

@end
