//
//  DUFolderInfoTopEntries.m
//  DiskUsagePg
//
//  Created by Roman Masek on 5/11/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "DUFolderInfoTopEntries.h"


@implementation DUFolderInfoTopEntries

- (id)initWithArray:(NSArray *)folders shareThreshold:(NSUInteger)shareThreshold
{
    self = [super init];
    if (self) {
        _originalEntries = [folders retain];
        _shareThreshold = shareThreshold;
    }
    
    return self;
}

- (void)dealloc
{
    [_originalEntries release];
    [super dealloc];
}

- (NSArray *)topEntries
{
    NSMutableArray *topEntries = [NSMutableArray array];
    DUFolderInfoOthersEntry *others = [[[DUFolderInfoOthersEntry alloc] init] autorelease];
    
    long totalSize = 0;
    for (DUFolderInfo *folder in _originalEntries)
    {
        totalSize += [folder sizeWithSubfolders];
    }
    
    for (DUFolderInfo *folder in _originalEntries)
    {
        double folderShare = [folder sizeWithSubfolders] / (double)totalSize;
        NSUInteger folderShareInt = (NSUInteger)(folderShare * 100);
        if (folderShareInt > _shareThreshold)
        {
            [topEntries addObject:folder];
        }
        else
        {
            others.sizeWithSubfolders += [folder sizeWithSubfolders];
        }
    }
    
    if (others.sizeWithSubfolders > 0)
    {
        [topEntries addObject:others];
    }
    
    return topEntries;
}

@end

@implementation DUFolderInfoOthersEntry
@synthesize sizeWithSubfolders;
@end

