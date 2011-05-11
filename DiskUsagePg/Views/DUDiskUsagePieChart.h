//
//  DUDiskUsageView.h
//  DiskUsagePg
//
//  Created by Roman Masek on 5/8/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CorePlot/CorePlot.h>
#import "DUFolderInfo.h"

@interface DUDiskUsagePieChart : CPLayerHostingView <CPPlotDataSource> {
@private
    CPXYGraph *_graph;
    CPPieChart *_piePlot;
    
    DUFolderInfo *_dataSource;
}

-(id)initWithFrame:(NSRect)frame;

@property (nonatomic, assign) DUFolderInfo *dataSource;

// TODO: private methods
- (void)_setupGraph;
- (void)_setupPieChart;


@end
