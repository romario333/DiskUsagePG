//
//  DUFolderInfoTopEntries.m
//  DiskUsagePg
//
//  Created by Roman Masek on 5/11/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "DUFolderChartData.h"


@implementation DUFolderChartData

- (id)initWithFolder:(DUFolderInfo *)folder shareThreshold:(NSUInteger)shareThreshold
{
    
    self = [super init];
    if (self) {
        _folder = [folder retain];
        _shareThreshold = shareThreshold;
        _currentSectors = [[NSMutableArray alloc] init];
        _sectorsCache = [[NSMapTable alloc] initWithKeyOptions:NSMapTableStrongMemory valueOptions:NSMapTableStrongMemory capacity:50];
        
        _colors = [[NSMutableArray alloc] init];
        NSColorList *colorList = [NSColorList colorListNamed:@"Apple"];
        for (NSString *colorKey in [colorList allKeys])
        {
            [_colors addObject:[colorList colorWithKey:colorKey]];
        }
        
    }
    
    return self;
}

- (void)dealloc
{
    [_folder release];
    [_currentSectors release];
    [_sectorsCache release];
    [_colors release];
    [super dealloc];
}

- (void)update
{
    NSMutableArray *subfolders = [_folder.subfolders copy];
    
    NSMutableArray *sectorCandidates = [[NSMutableArray alloc] init];
    for (DUFolderInfo *folder in subfolders)
    {
        // I will duplicate size, don't forget that size on DUFolderInfo can be moving target (if scan is in progress).
        long sectorSize = folder.size;

        DUFolderChartSector *sectorCandidate;
        if ([_sectorsCache objectForKey:folder] != nil)
        {
            // I already have sector instance for this folder, use it
            sectorCandidate = [[_sectorsCache objectForKey:folder] retain];
            sectorCandidate.size = sectorSize;
        }
        else
        {
            sectorCandidate = [[DUFolderChartSector alloc] initWithFolder:folder size:sectorSize];
        }
        
        [sectorCandidates addObject: sectorCandidate];
        [sectorCandidate release];
    }
    
    long totalSize = 0;
    for (DUFolderChartSector *sectorCandidate in sectorCandidates)
    {
        totalSize += [sectorCandidate size];
    }
    
    NSSortDescriptor *sortDesc = [NSSortDescriptor sortDescriptorWithKey:@"size" ascending:NO];
    [sectorCandidates sortUsingDescriptors:[NSArray arrayWithObject:sortDesc]];
    
    
    
    [_currentSectors removeAllObjects];
    NSUInteger othersShare = 0;
    for (DUFolderChartSector *sectorCandidate in sectorCandidates)
    {
        NSUInteger sectorShare = (NSUInteger)(([sectorCandidate.folder size] / (double)totalSize) * 100);
        if (sectorShare > _shareThreshold)
        {
            if ([_sectorsCache objectForKey:sectorCandidate.folder] == nil)
            {
                // new sector, assign it next color and put it to cache
                NSLog(@"New color for %@", sectorCandidate.folder);
                sectorCandidate.color = [_colors objectAtIndex:_nextColor];
                _nextColor++;
                [_sectorsCache setObject:sectorCandidate forKey:sectorCandidate.folder];
            }
            [_currentSectors addObject:sectorCandidate];
        }
        else
        {
            othersShare += sectorCandidate.size;
        }
    }
    
    [sectorCandidates release];
}

- (NSArray *)sectors
{
    return _currentSectors;
}

@end

@implementation DUFolderChartSector
@synthesize folder=_folder, size=_size, color=_color;

- (id)initWithFolder:(DUFolderInfo *)folder size:(long)size
{
    self = [super init];
    if (self)
    {
        self.folder = folder;
        self.size = size;
    }
    return self;
}

- (void)dealloc
{
    [_folder release];
    if (_color != nil)
    {
        [_color release];
    }
    [super dealloc];
}

@end

