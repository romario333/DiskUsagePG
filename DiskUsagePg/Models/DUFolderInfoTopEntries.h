//
//  DUFolderInfoTopEntries.h
//  DiskUsagePg
//
//  Created by Roman Masek on 5/11/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DUFolderInfo.h"

@interface DUFolderInfoTopEntries : NSObject {
@private
    NSArray *_originalEntries;
    NSUInteger _shareThreshold;
    NSDictionary *_colorForEntry;
}

- (id)initWithArray:(NSArray *)folders shareThreshold:(NSUInteger)shareThreshold;
- (NSArray *)topEntries;

@end

@interface DUFolderInfoOthersEntry : NSObject {
@private
    long size;
}

@property (nonatomic) long size;

@end
