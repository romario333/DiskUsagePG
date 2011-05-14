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
        
        for (int i = 80; i >= 20; i -= 20)
        {
            CGFloat component = i / 100.0;
            [_colors addObject:[NSColor colorWithDeviceRed:0.0 green:component blue:0.0 alpha:1.0]];
            [_colors addObject:[NSColor colorWithDeviceRed:component green:0.0 blue:0.0 alpha:1.0]];
            [_colors addObject:[NSColor colorWithDeviceRed:0.0 green:0.0 blue:component alpha:1.0]];
        }
        
//        NSUInteger baseColorsCount = [_colors count];
//        for (NSUInteger offset = 10; offset < 100; offset += 10)
//        {
//            for (NSUInteger i = 0; i < baseColorsCount; i++)
//            {
//                CGFloat hue, saturation, brightness, alpha;
//                [[_colors objectAtIndex:i] getHue:&hue saturation:&saturation brightness:&brightness alpha:&alpha];
//                brightness += offset;
//                [_colors addObject:[NSColor colorWithCalibratedHue:hue saturation:saturation brightness:brightness alpha:alpha]];
//            }
//        }
        
        // TODO: kde beru jistotu, ze tam neco takovyho bude?
        
//        NSColorList *colorList = [NSColorList colorListNamed:@"Web Safe Colors"];
//        for (NSString *colorKey in [colorList allKeys])
//        {
//            [_colors addObject:[colorList colorWithKey:colorKey]];
//        }
//        _nextColor = 70;
        _othersColor = [[NSColor colorWithDeviceRed:0.4 green:0.4 blue:0.4 alpha:1.0] retain];
        
        
    }
    
    return self;
}

- (void)dealloc
{
    [_folder release];
    [_currentSectors release];
    [_sectorsCache release];
    [_colors release];
    [_othersColor release];
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
    [subfolders release];
    
    long totalSize = 0;
    for (DUFolderChartSector *sectorCandidate in sectorCandidates)
    {
        totalSize += [sectorCandidate size];
    }
    
    NSSortDescriptor *sortDesc = [NSSortDescriptor sortDescriptorWithKey:@"size" ascending:NO];
    [sectorCandidates sortUsingDescriptors:[NSArray arrayWithObject:sortDesc]];
    
    
    
    [_currentSectors removeAllObjects];
    NSUInteger othersSize
    = 0;
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
            othersSize += sectorCandidate.size;
        }
    }
    
    DUFolderChartSector *othersSector = [[DUFolderChartSector alloc] initWithFolder:nil size:othersSize];
    othersSector.color = _othersColor;
    [_currentSectors addObject:othersSector];
    [othersSector release];
    
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

