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
    [_treeData release];
    [_chartData release];
    
    [super dealloc];
}

- (IBAction)scanFolder:(id)sender {
    // TODO: samozrejme kontrolovat, ze je zadana validni hodnota
    
    NSAssert(_scanFolderOperation == nil, @"Existing scan operation in progress?");
    _scanFolderOperation = [[DUScanFolderOperation alloc]initWithFolder:[NSURL URLWithString:_pathTextField.title]];
    // TODO: prejmenovat _folder
    _treeData = [[DUFolderTreeData alloc] initWithFolder:_scanFolderOperation.folderInfo];
    _chartData = [[DUFolderChartData alloc] initWithFolder: _scanFolderOperation.folderInfo shareThreshold:5.0];
    [_scanFolderOperation addObserver:self forKeyPath:@"isFinished" options:NSKeyValueObservingOptionNew context:nil];
    [_backgroundQueue addOperation:_scanFolderOperation];

    [_scanOrCancelButton setTitle:@"Cancel"];
    [_pathTextField setEnabled:NO];
    [_progress startAnimation:self];
    [_progress setHidden:NO];

    // TODO:
    NSAssert(_updateGUITimer == nil, @"Timer already exists");
    _updateGUITimer = [NSTimer scheduledTimerWithTimeInterval:0.5 target:self selector:@selector(updateGUI:) userInfo:nil repeats:YES];
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    [self performSelectorOnMainThread:@selector(scanFolderCompleted) withObject:nil waitUntilDone:NO];
}

- (void)scanFolderCompleted
{
    [_scanFolderOperation release];
    _scanFolderOperation = nil;
    
    [_updateGUITimer invalidate];
    _updateGUITimer = nil;
    
    [self updateGUI:nil];
    
    [_pathTextField setEnabled:YES];
    // TODO:
    [_scanOrCancelButton setTitle:@"Scan Folder"];
    [_progress setHidden:YES];
    [_progress stopAnimation:self];

    
}

// TODO: volat z timeru pres notfication, abych tu nemusel mit ten parametr
- (void)updateGUI:(NSTimer*)theTimer
{
    // TODO: razeni
//    [_scannedFolderInfo sort];
//    _topFolders = [[DUFolderInfoTopEntries alloc]initWithArray:_scannedFolderInfo.subfolders shareThreshold:10];

    
    // TODO: fakt musim poustet reloadData na main threadu? outlineView fungoval i bez toho, chart ale
    // mela zpozdeni pri zobrazeni
    [_treeData update];
    [_chartData update];
    
    [_diskUsageTree reloadData];
    [_diskUsageChart reloadData];
}



#pragma mark - NSOutlineView Notifications
- (void)outlineViewSelectionDidChange:(NSNotification *)notification
{
    [_chartData release];
    DUFolderInfo *selectedFolder = [[_diskUsageTree itemAtRow:[_diskUsageTree selectedRow]] folder];
    // TODO: threshold na 2 mistech
    _chartData = [[DUFolderChartData alloc] initWithFolder:selectedFolder shareThreshold:5.0];
    
    [self updateGUI:nil];
}

#pragma mark - NSOutlineViewDataSource Members

- (id)outlineView:(NSOutlineView *)outlineView child:(NSInteger)index ofItem:(id)item
{
    DUFolderTreeData *folder = item == nil ? _treeData :(DUFolderTreeData *)item;
    // TODO: ach ten blbej mem management
    return [[folder subfolderAtIndex:index] retain];
}

- (BOOL)outlineView:(NSOutlineView *)outlineView isItemExpandable:(id)item
{
    DUFolderTreeData *folder = item == nil ? _treeData :(DUFolderTreeData *)item;
    return [folder subfolderCount] > 0;
}

- (NSInteger)outlineView:(NSOutlineView *)outlineView numberOfChildrenOfItem:(id)item 
{
    DUFolderTreeData *folder = item == nil ? _treeData :(DUFolderTreeData *)item;
    return [folder subfolderCount];
}

- (id)outlineView:(NSOutlineView *)outlineView objectValueForTableColumn:(NSTableColumn *)tableColumn byItem:(id)item
{
    DUFolderTreeData *folderView = item == nil ? _treeData :(DUFolderTreeData *)item;
    DUFolderInfo *folder = [folderView folder];
    
    if ([tableColumn.identifier isEqualTo:@"folderName"])
    {
        return [folder.url lastPathComponent];
    }
    else if ([tableColumn.identifier isEqualTo:@"folderSize"])
    {
        return unitStringFromBytes([folder size], kUnitStringOSNativeUnits | kUnitStringLocalizedFormat);
    }
    
    return nil;
}

#pragma mark - DURingChartDataSource Members

// TODO: tenhle delegat by sel urcite navrhnout lip

- (id)rootItemForRingChartView:(DURingChartView *)ringChartView
{
    return _chartData;
}

- (id)ringChartView:(DURingChartView *)ringChartView child:(NSInteger)index ofItem:(id)item
{
    DUFolderChartData *chartData = (DUFolderChartData *)item;
    return [chartData.sectors objectAtIndex:index];
}

- (NSInteger)ringChartView:(DURingChartView *)ringChartView numberOfChildrenOfItem:(id)item
{
    DUFolderChartData *chartData = (DUFolderChartData *)item;
    return [chartData.sectors count];
}

- (NSNumber *)ringChartView:(DURingChartView *)ringChartView sectorValueForItem:(id)item
{
    DUFolderChartSector *sector = (DUFolderChartSector *)item;
    return [NSNumber numberWithLong:sector.size];
}

- (id)ringChartView:(DURingChartView *)ringChartView sectorDescriptionForItem:(id)item
{
    DUFolderChartSector *sector = (DUFolderChartSector *)item;
    
    NSString *folderName;
    folderName = [sector.folder.url lastPathComponent];
    
    NSString *folderSize = unitStringFromBytes(sector.size, kUnitStringOSNativeUnits | kUnitStringLocalizedFormat);
    
    return [NSString stringWithFormat:@"%@ (%@)", folderName, folderSize];
}

- (id)ringChartView:(DURingChartView *)ringChartView sectorColorForItem:(id)item 
{
    DUFolderChartSector *sector = (DUFolderChartSector *)item;
    return sector.color;
}

@end
