//
//  DiskUsageController.h
//  DiskUsagePg
//
//  Created by Roman Masek on 5/7/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CorePlot/CorePlot.h>
#import "DUScanFolderOperation.h"
#import "DURingChartView.h"
#import "DURingChartDataSource.h"
#import "DUFolderChartData.h"
#import "DUFolderTreeDataItem.h"

@interface DiskUsageController : NSViewController <NSOutlineViewDataSource, NSOutlineViewDelegate,  DURingChartDataSource> {
@private
    DUFolderTreeDataItem *_treeDataRoot;
    DUFolderChartData *_chartData;
    
    IBOutlet NSButton *_scanOrCancelButton;
    IBOutlet NSTextFieldCell *_pathTextField;
    IBOutlet NSProgressIndicator *_progress;
    IBOutlet NSOutlineView *_diskUsageTree;
    IBOutlet DURingChartView *_diskUsageChart;
    
    NSOperationQueue *_backgroundQueue;
    DUScanFolderOperation *_scanFolderOperation;
    NSTimer *_updateGUITimer;
}

- (IBAction)scanFolder:(id)sender;
- (void)scanFolderCompleted;
- (void)updateGUI:(NSTimer*)theTimer;


@end
