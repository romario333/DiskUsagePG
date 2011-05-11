//
//  DUDiskUsageView.m
//  DiskUsagePg
//
//  Created by Roman Masek on 5/8/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "DUDiskUsagePieChart.h"


@implementation DUDiskUsagePieChart

- (void)dealloc
{
    [_graph release];
    [_piePlot release];
    
    [super dealloc];
}

- (id)initWithFrame:(NSRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        [self _setupGraph];
        [self _setupPieChart];
    }
    return self;
}

- (void)awakeFromNib
{
    [super awakeFromNib];

    [self _setupGraph];
    [self _setupPieChart];
}

- (void)_setupGraph
{
    // Create graph and apply a dark theme
    _graph = [(CPXYGraph *)[CPXYGraph alloc] initWithFrame:NSRectToCGRect(self.bounds)];
	CPTheme *theme = [CPTheme themeNamed:kCPDarkGradientTheme];
    [_graph applyTheme:theme];
	self.hostedLayer = _graph;
    
    // Graph title
    _graph.title = @"This is the Graph Title";
    CPMutableTextStyle *textStyle = [CPMutableTextStyle textStyle];
    textStyle.color = [CPColor grayColor];
    textStyle.fontName = @"Helvetica-Bold";
    textStyle.fontSize = 18.0;
    _graph.titleTextStyle = textStyle;
    _graph.titleDisplacement = CGPointMake(0.0, 20.0);
    _graph.titlePlotAreaFrameAnchor = CPRectAnchorTop;
	
    // Graph padding
    _graph.paddingLeft = 60.0;
    _graph.paddingTop = 60.0;
    _graph.paddingRight = 60.0;
    _graph.paddingBottom = 60.0;    
    
}

- (void)_setupPieChart
{
    _piePlot = [[CPPieChart alloc] init];
    _piePlot.pieRadius = MIN(0.7 * (self.frame.size.height - 2 * _graph.paddingLeft) / 2.0,
                            0.7 * (self.frame.size.width - 2 * _graph.paddingTop) / 2.0);
	CGFloat innerRadius = _piePlot.pieRadius / 2.0;
	_piePlot.pieInnerRadius = innerRadius + 5.0;
    _piePlot.identifier = @"TODOkcemu";
	//_piePlot.borderLineStyle = whiteLineStyle;
    _piePlot.startAngle = M_PI_4;
    _piePlot.sliceDirection = CPPieDirectionCounterClockwise;
    
    _piePlot.dataSource = self;
    // TODO: delegate
//    _piePlot.delegate = self;
    
    
    [_graph addPlot:_piePlot];
    
    //[piePlot release];
}

- (DUFolderInfo *)dataSource
{
    return _dataSource;
}

- (void)setDataSource:(DUFolderInfo *)dataSource
{
    _dataSource = dataSource;
    [_graph reloadData];
    // TODO: reloadDataIfNeeded?
}

-(NSUInteger)numberOfRecordsForPlot:(CPPlot *)plot
{
    return [[_dataSource subfolders] count];
}

-(NSNumber *)numberForPlot:(CPPlot *)plot field:(NSUInteger)fieldEnum recordIndex:(NSUInteger)index
{
    DUFolderInfo *subfolder = [[_dataSource subfolders] objectAtIndex:index];
    return [NSNumber numberWithLong:[subfolder sizeWithSubfolders]];
}

-(CPLayer *)dataLabelForPlot:(CPPlot *)plot recordIndex:(NSUInteger)index
{
    static CPMutableTextStyle *whiteText = nil;
	
	CPTextLayer *newLayer = nil;
	
    //if ( [(NSString *)plot.identifier isEqualToString:outerChartName] ) {
    if ( !whiteText ) {
        whiteText = [[CPMutableTextStyle alloc] init];
        whiteText.color = [CPColor whiteColor];
    }
    
    DUFolderInfo *folder = [[_dataSource subfolders]objectAtIndex:index];
    NSString *folderName = [folder.url lastPathComponent];
    
    newLayer = [[[CPTextLayer alloc] initWithText:[NSString stringWithFormat:@"%@ (2 MiB)", folderName] style:whiteText] autorelease];
//    }
    
    
    return newLayer;
}

@end
