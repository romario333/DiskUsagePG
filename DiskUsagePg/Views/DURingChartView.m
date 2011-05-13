//
//  DURingChartView.m
//  DiskUsagePg
//
//  Created by Roman Masek on 5/10/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "DURingChartView.h"


@implementation DURingChartView

static NSString *kSectorValue = @"sectorValue";
static NSString *kSectorDescription = @"sectorDescription";
static NSString *kSectorColor = @"sectorColor";


@synthesize dataSource = _dataSource;

- (void)dealloc
{
    [_graph release];
    [_piePlot release];
    [_dataSourceCache release];
    
    [super dealloc];
}

- (id)initWithFrame:(NSRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        _dataSourceCache = [[NSMutableArray alloc] init];
        
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

- (void)reloadData
{
    // TODO: mozna by byl dealloc rychlejsi?
    [_dataSourceCache removeAllObjects];
    
    id rootItem = [_dataSource rootItemForRingChartView:self];
    //_graph.title = [_dataSource ringChartView:self sectorDescriptionForItem:rootItem];
    
    NSInteger childrenCount = [_dataSource ringChartView:self numberOfChildrenOfItem:rootItem];
    for (NSInteger i = 0; i < childrenCount; i++)
    {
        id item = [_dataSource ringChartView:self child:i ofItem:rootItem];
        // TODO: co takhle setrit pameti a mit tu NSInteger?
        NSNumber *sectorValue = [_dataSource ringChartView:self sectorValueForItem:item];
        id sectorDescription = [_dataSource ringChartView:self sectorDescriptionForItem:item];
        NSColor *sectorColor = [_dataSource ringChartView:self sectorColorForItem:item];
        
        [_dataSourceCache addObject:[NSDictionary dictionaryWithObjectsAndKeys:
                                     sectorValue, kSectorValue,
                                     sectorDescription, kSectorDescription,
                                     sectorColor, kSectorColor,
                                     nil]];
    }
    
    [_graph reloadData];
}
                   

- (void)_setupGraph
{
    // Create graph and apply a dark theme
    _graph = [(CPXYGraph *)[CPXYGraph alloc] initWithFrame:NSRectToCGRect(self.bounds)];
	CPTheme *theme = [CPTheme themeNamed:kCPDarkGradientTheme];
    [_graph applyTheme:theme];
	self.hostedLayer = _graph;
    
    _graph.title = @"";
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

-(NSUInteger)numberOfRecordsForPlot:(CPPlot *)plot
{
    return [_dataSourceCache count];
}

-(NSNumber *)numberForPlot:(CPPlot *)plot field:(NSUInteger)fieldEnum recordIndex:(NSUInteger)index
{
    // TODO: k cemu je ten field?
    return [[_dataSourceCache objectAtIndex:index] objectForKey:kSectorValue];
}

-(CPLayer *)dataLabelForPlot:(CPPlot *)plot recordIndex:(NSUInteger)index
{
    static CPMutableTextStyle *whiteText = nil;
	
	CPTextLayer *newLayer = nil;
	
    //if ( [(NSString *)plot.identifier isEqualToString:outerChartName] ) {
    // TODO: barvy a cachovat barvy
    if ( !whiteText ) {
        whiteText = [[CPMutableTextStyle alloc] init];
        whiteText.color = [CPColor whiteColor];
    }
    
    id sectorDescription = [[_dataSourceCache objectAtIndex:index] objectForKey:kSectorDescription];
    
    newLayer = [[[CPTextLayer alloc] initWithText:[sectorDescription description] style:whiteText] autorelease];
    
    return newLayer;
}

#pragma mark - CPPieChartDataSource Members

- (CPFill *)sliceFillForPieChart:(CPPieChart *)pieChart recordIndex:(NSUInteger)index
{
    NSColor *color = [[_dataSourceCache objectAtIndex:index] objectForKey:kSectorColor];
    // TODO: zkusit gradient
    return [CPFill fillWithColor:[CPColor colorWithComponentRed:[color redComponent] 
                                                          green:[color greenComponent] 
                                                           blue:[color blueComponent] 
                                                          alpha:[color alphaComponent]]];
}

// TODO: prozkoumat
//- (CPTextLayer *)sliceLabelForPieChart:(CPPieChart *)pieChart recordIndex:(NSUInteger)index
//{
//    return [[CPTextLayer alloc] initWithText:@"chudaci"];
//    
//}

@end
