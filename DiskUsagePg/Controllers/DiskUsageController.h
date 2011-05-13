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
#import "DUFolderInfoTopEntries.h"

@interface DiskUsageController : NSViewController <NSOutlineViewDataSource,  DURingChartDataSource> {
@private
    IBOutlet DURingChartView *_diskUsageChart;
    DUFolderInfo *_scannedFolderInfo;
    DUFolderInfoTopEntries *_topFolders;
    IBOutlet NSTextFieldCell *_pathTextField;
    IBOutlet NSOutlineView *_diskUsageTree;
    
    NSOperationQueue *_backgroundQueue;
    DUScanFolderOperation *_scanFolderOperation;
}

- (IBAction)scanFolder:(id)sender;
- (IBAction)updateGUI;


@end
