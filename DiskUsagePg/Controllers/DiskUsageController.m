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
    _backgroundQueue = [[NSOperationQueue alloc] init];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(outlineViewSelectionDidChange:) name:NSOutlineViewSelectionDidChangeNotification object:_diskUsageTree];
    
    _pathTextField.title = NSHomeDirectory();
}

- (void)dealloc
{
    [_backgroundQueue release];
    
    // TODO: co kdyz jsem ho neinicializoval
    [_scannedFolderInfo release];
    [_topFolders release];
    
    [super dealloc];
}

- (IBAction)scanFolder:(id)sender {
    // TODO: samozrejme kontrolovat, ze je zadana validni hodnota
    
    NSAssert(_scanFolderOperation == nil, @"Existing scan operation in progress?");
    
    _scanFolderOperation = [[DUScanFolderOperation alloc]initWithFolder:[NSURL URLWithString:_pathTextField.title]];
    // TODO: prejmenovat _folder
    _scannedFolderInfo = [_scanFolderOperation.folderInfo retain];
    [_scanFolderOperation addObserver:self forKeyPath:@"isFinished" options:NSKeyValueObservingOptionNew context:nil];
    [_backgroundQueue addOperation:_scanFolderOperation];

}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    [_scanFolderOperation release];
    _scanFolderOperation = nil;
    [self performSelectorOnMainThread:@selector(updateGUI) withObject:nil waitUntilDone:NO];
}

- (IBAction)updateGUI
{
    // TODO: razeni
    [_scannedFolderInfo sort];
    _topFolders = [[DUFolderInfoTopEntries alloc]initWithArray:_scannedFolderInfo.subfolders shareThreshold:10];

    
    // TODO: fakt musim poustet reloadData na main threadu? outlineView fungoval i bez toho, chart ale
    // mela zpozdeni pri zobrazeni
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
    DUFolderInfo *folder = item == nil ? _scannedFolderInfo :(DUFolderInfo *)item;
    return [folder.subfolders objectAtIndex:index];
}

- (BOOL)outlineView:(NSOutlineView *)outlineView isItemExpandable:(id)item
{
    DUFolderInfo *folder = item == nil ? _scannedFolderInfo :(DUFolderInfo *)item;
    return [folder.subfolders count] > 0;
}

- (NSInteger)outlineView:(NSOutlineView *)outlineView numberOfChildrenOfItem:(id)item 
{
    DUFolderInfo *folder = item == nil ? _scannedFolderInfo :(DUFolderInfo *)item;
    return [folder.subfolders count];
}

- (id)outlineView:(NSOutlineView *)outlineView objectValueForTableColumn:(NSTableColumn *)tableColumn byItem:(id)item
{
    DUFolderInfo *folder = item == nil ? _scannedFolderInfo :(DUFolderInfo *)item;
    
    if ([tableColumn.identifier isEqualTo:@"folderName"])
    {
        NSLog(@"outlineView - loading folder %@", [folder.url lastPathComponent]);
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
