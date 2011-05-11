//
//  DiskUsageController.m
//  DiskUsagePg
//
//  Created by Roman Masek on 5/7/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "DiskUsageController.h"
#import "DataFormatingUtils.h"


@implementation DiskUsageController

- (void)awakeFromNib
{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(outlineViewSelectionDidChange:) name:NSOutlineViewSelectionDidChangeNotification object:_diskUsageTree];
    
    _pathTextField.title = NSHomeDirectory();
}

- (void)dealloc
{
    // TODO: co kdyz jsem ho neinicializoval
    [_folder release];
    [_topFolders release];
    
    [super dealloc];
}

- (IBAction)scanFolder:(id)sender {
    // TODO: samozrejme kontrolovat, ze je zadana validni hodnota
    
    DUFolderScanner *folderScanner = [[DUFolderScanner alloc]init];
    _folder = [folderScanner scanFolder:[NSURL URLWithString:_pathTextField.title]];
    [_folder retain];
    [_folder sort];
    [folderScanner release];
    
    _topFolders = [[DUFolderInfoTopEntries alloc]initWithArray:_folder.subfolders shareThreshold:10];

    // TODO: nastavovat data-sources vsude stejne
    [_diskUsageChart reloadData];
    [_diskUsageTree reloadData];

}

#pragma mark - NSOutlineView Notifications
- (void)outlineViewSelectionDidChange:(NSNotification *)notification
{
    // TODO: leakuju tu pamet jak o zivot
    DUFolderInfo *folder = [_diskUsageTree itemAtRow:[_diskUsageTree selectedRow]];
    [_topFolders release];
    _topFolders = [[DUFolderInfoTopEntries alloc]initWithArray:folder.subfolders shareThreshold:10];
    [_diskUsageChart reloadData];
}

#pragma mark - NSOutlineViewDataSource Members

- (id)outlineView:(NSOutlineView *)outlineView child:(NSInteger)index ofItem:(id)item
{
    DUFolderInfo *folder = item == nil ? _folder :(DUFolderInfo *)item;
    return [folder.subfolders objectAtIndex:index];
}

- (BOOL)outlineView:(NSOutlineView *)outlineView isItemExpandable:(id)item
{
    DUFolderInfo *folder = item == nil ? _folder :(DUFolderInfo *)item;
    return [folder.subfolders count] > 0;
}

- (NSInteger)outlineView:(NSOutlineView *)outlineView numberOfChildrenOfItem:(id)item 
{
    DUFolderInfo *folder = item == nil ? _folder :(DUFolderInfo *)item;
    return [folder.subfolders count];
}

- (id)outlineView:(NSOutlineView *)outlineView objectValueForTableColumn:(NSTableColumn *)tableColumn byItem:(id)item
{
    DUFolderInfo *folder = item == nil ? _folder :(DUFolderInfo *)item;
    
    if ([tableColumn.identifier isEqualTo:@"folderName"])
    {
        return [folder.url lastPathComponent];
    }
    else if ([tableColumn.identifier isEqualTo:@"folderSize"])
    {
        return unitStringFromBytes([folder sizeWithSubfolders], kUnitStringOSNativeUnits | kUnitStringLocalizedFormat);
    }
    
    return nil;
}

#pragma mark - DURingChartDataSource Members

// TODO: zamyslet se: nebylo by lepsi misto parent-child chtit od datasource level a index?

- (id)rootItemForRingChartView:(DURingChartView *)ringChartView
{
    return _topFolders;
}

- (id)ringChartView:(DURingChartView *)ringChartView child:(NSInteger)index ofItem:(id)item
{
    DUFolderInfoTopEntries *topEntries = (DUFolderInfoTopEntries *)item;
    return [topEntries.topEntries objectAtIndex:index];
}

- (NSInteger)ringChartView:(DURingChartView *)ringChartView numberOfChildrenOfItem:(id)item
{
    DUFolderInfoTopEntries *topEntries = (DUFolderInfoTopEntries *)item;
    return [topEntries.topEntries count];
}

- (NSNumber *)ringChartView:(DURingChartView *)ringChartView sectorValueForItem:(id)item
{
    DUFolderInfo *folder = (DUFolderInfo *)item;
    return [NSNumber numberWithLong:[folder sizeWithSubfolders]];
}

- (id)ringChartView:(DURingChartView *)ringChartView sectorDescriptionForItem:(id)item
{
    DUFolderInfo *folder = (DUFolderInfo *)item;
    
    NSString *folderName;
    if ([folder respondsToSelector:@selector(url)])
    {
        folderName = [folder.url lastPathComponent];
    }
    else
    {
        // TODO:
        folderName = @"Others";
    }
    
    NSString *folderSize = unitStringFromBytes([folder sizeWithSubfolders], kUnitStringOSNativeUnits | kUnitStringLocalizedFormat);
    
    return [NSString stringWithFormat:@"%@ (%@)", folderName, folderSize];
}

- (id)ringChartView:(DURingChartView *)ringChartView sectorColorForItem:(id)item 
{
//    DUFolderInfo *folder = (DUFolderInfo *)item;
    // TODO:
    return nil;
}

@end
