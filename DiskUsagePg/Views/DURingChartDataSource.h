//
//  DURingChartDataSource.h
//  DiskUsagePg
//
//  Created by Roman Masek on 5/10/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DURingChartView.h"

@class DURingChartView;

@protocol DURingChartDataSource <NSObject>

// TODO: tady jim ta jejich pojmenovavaci konvence skripe, kouknout jak to vypada v UIKitu
- (id)rootItemForRingChartView:(DURingChartView *)ringChartView;
- (id)ringChartView:(DURingChartView *)ringChartView child:(NSInteger)index ofItem:(id)item;
- (NSInteger)ringChartView:(DURingChartView *)ringChartView numberOfChildrenOfItem:(id)item;
- (NSNumber *)ringChartView:(DURingChartView *)ringChartView sectorValueForItem:(id)item;
- (id)ringChartView:(DURingChartView *)ringChartView sectorDescriptionForItem:(id)item;

@optional
- (id)ringChartView:(DURingChartView *)ringChartView sectorColorForItem:(id)item;

@end
