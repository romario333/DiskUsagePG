//
//  DiskUsageController.h
//  DiskUsagePg
//
//  Created by Roman Masek on 5/7/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CorePlot/CorePlot.h>
#import "DUFolderScanner.h"
#import "DURingChartView.h"
#import "DURingChartDataSource.h"
#import "DUFolderInfoTopEntries.h"

@interface DiskUsageController : NSViewController <NSOutlineViewDataSource,  DURingChartDataSource> {
@private
    IBOutlet DURingChartView *_diskUsageChart;
    DUFolderInfo *_folder;
    DUFolderInfoTopEntries *_topFolders;
    IBOutlet NSTextFieldCell *_pathTextField;
    IBOutlet NSOutlineView *_diskUsageTree;
}

- (IBAction)scanFolder:(id)sender;


@end
