//
//  DURingChartView.h
//  DiskUsagePg
//
//  Created by Roman Masek on 5/10/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CorePlot/CorePlot.h>
#import "DURingChartDataSource.h"

@interface DURingChartView : CPLayerHostingView <CPPieChartDataSource> {
@private
    CPXYGraph *_graph;
    CPPieChart *_piePlot;
    
    id <DURingChartDataSource> _dataSource;
    NSMutableArray *_dataSourceCache;
}

-(id)initWithFrame:(NSRect)frame;

@property (nonatomic, assign) IBOutlet id <DURingChartDataSource> dataSource;
- (void)reloadData;

// TODO: private methods
- (void)_setupGraph;
- (void)_setupPieChart;

@property (nonatomic, retain) NSString *title;

@end
