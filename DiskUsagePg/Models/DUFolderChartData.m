//
//  DUFolderInfoTopEntries.m
//  DiskUsagePg
//
//  Created by Roman Masek on 5/11/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "DUFolderInfoTopEntries.h"


@implementation DUFolderInfoTopEntries

+ (void)initialize
{
    [super initialize];
}

- (id)initWithArray:(NSArray *)folders shareThreshold:(NSUInteger)shareThreshold
{
    
    self = [super init];
    if (self) {
        _originalEntries = [folders retain];
        _shareThreshold = shareThreshold;
        _colorForEntry = [[NSMutableDictionary alloc] init];
    }
    
    return self;
}

- (void)dealloc
{
    [_originalEntries release];
    [_colorForEntry release];
    [super dealloc];
}

- (NSArray *)topEntries
{
    NSMutableArray *topEntries = [NSMutableArray array];
    DUFolderInfoOthersEntry *others = [[[DUFolderInfoOthersEntry alloc] init] autorelease];
    
    long totalSize = 0;
    for (DUFolderInfo *folder in _originalEntries)
    {
        totalSize += [folder size];
    }
    
    for (DUFolderInfo *folder in _originalEntries)
    {
        double folderShare = [folder size] / (double)totalSize;
        NSUInteger folderShareInt = (NSUInteger)(folderShare * 100);
        if (folderShareInt > _shareThreshold)
        {
            [topEntries addObject:folder];
        }
        else
        {
            others.size += [folder size];
        }
    }
    
    if (others.size > 0)
    {
        [topEntries addObject:others];
    }
    
    return topEntries;
}

@end

@implementation DUFolderInfoOthersEntry
@synthesize size;
@end

