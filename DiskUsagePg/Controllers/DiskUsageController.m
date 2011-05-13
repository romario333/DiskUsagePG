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
    [_rootFolder release];
    [_chartFolder release];
    
    [super dealloc];
}

- (IBAction)scanFolder:(id)sender {
    // TODO: samozrejme kontrolovat, ze je zadana validni hodnota
    
    NSAssert(_scanFolderOperation == nil, @"Existing scan operation in progress?");
    
    [_pathTextField setEnabled:NO];
    // TODO:
    [_scanOrCancelButton setTitle:@"Cancel"];
    [_progress startAnimation:self];
    [_progress setHidden:NO];
    
    _scanFolderOperation = [[DUScanFolderOperation alloc]initWithFolder:[NSURL URLWithString:_pathTextField.title]];
    // TODO: prejmenovat _folder
    _rootFolder = [[DUFolderInfoView alloc] initWithFolder:_scanFolderOperation.folderInfo];
    _chartFolder = _rootFolder;
    [_scanFolderOperation addObserver:self forKeyPath:@"isFinished" options:NSKeyValueObservingOptionNew context:nil];
    [_backgroundQueue addOperation:_scanFolderOperation];
    
    // TODO:
    NSAssert(_updateGUITimer == nil, @"Existing timer!");
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
    [_rootFolder update];
    if (_chartFolder != _rootFolder)
    {
        [_chartFolder update];
    }
    [_diskUsageChart reloadData];
    [_diskUsageTree reloadData];
}



#pragma mark - NSOutlineView Notifications
- (void)outlineViewSelectionDidChange:(NSNotification *)notification
{
    // TODO: nemel bych releasovat ten starej?
    _chartFolder = [_diskUsageTree itemAtRow:[_diskUsageTree selectedRow]];
    [self updateGUI:nil];
}

#pragma mark - NSOutlineViewDataSource Members

- (id)outlineView:(NSOutlineView *)outlineView child:(NSInteger)index ofItem:(id)item
{
    DUFolderInfoView *folder = item == nil ? _rootFolder :(DUFolderInfoView *)item;
    // TODO: ach ten blbej mem management
    return [[folder subfolderAtIndex:index] retain];
}

- (BOOL)outlineView:(NSOutlineView *)outlineView isItemExpandable:(id)item
{
    DUFolderInfoView *folder = item == nil ? _rootFolder :(DUFolderInfoView *)item;
    return [folder subfolderCount] > 0;
}

- (NSInteger)outlineView:(NSOutlineView *)outlineView numberOfChildrenOfItem:(id)item 
{
    DUFolderInfoView *folder = item == nil ? _rootFolder :(DUFolderInfoView *)item;
    return [folder subfolderCount];
}

- (id)outlineView:(NSOutlineView *)outlineView objectValueForTableColumn:(NSTableColumn *)tableColumn byItem:(id)item
{
    DUFolderInfoView *folderView = item == nil ? _rootFolder :(DUFolderInfoView *)item;
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

// TODO: zamyslet se: nebylo by lepsi misto parent-child chtit od datasource level a index?

- (id)rootItemForRingChartView:(DURingChartView *)ringChartView
{
    DUFolderInfoTopEntries *topEntries = [[DUFolderInfoTopEntries alloc] initWithArray:[_chartFolder subfolders] shareThreshold:5.0];
    return topEntries;
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
    return [NSNumber numberWithLong:[folder size]];
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
    
    NSString *folderSize = unitStringFromBytes([folder size], kUnitStringOSNativeUnits | kUnitStringLocalizedFormat);
    
    return [NSString stringWithFormat:@"%@ (%@)", folderName, folderSize];
}

- (id)ringChartView:(DURingChartView *)ringChartView sectorColorForItem:(id)item 
{
//    DUFolderInfo *folder = (DUFolderInfo *)item;
    // TODO:
    return nil;
}

@end
