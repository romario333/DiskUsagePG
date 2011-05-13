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
#import "DUFolderInfoView.h"

@interface DiskUsageController : NSViewController <NSOutlineViewDataSource,  DURingChartDataSource> {
@private
    IBOutlet DURingChartView *_diskUsageChart;
    DUFolderInfoView *_rootFolder;
    DUFolderInfoView *_chartFolder;
    IBOutlet NSTextFieldCell *_pathTextField;
    IBOutlet NSOutlineView *_diskUsageTree;
    
    NSOperationQueue *_backgroundQueue;
    DUScanFolderOperation *_scanFolderOperation;
    NSTimer *_updateGUITimer;
}

- (IBAction)scanFolder:(id)sender;
- (void)updateGUI:(NSTimer*)theTimer;


@end
