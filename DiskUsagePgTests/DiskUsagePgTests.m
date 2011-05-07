//
//  DiskUsagePgTests.m
//  DiskUsagePgTests
//
//  Created by Roman Masek on 5/6/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "DiskUsagePgTests.h"


@implementation DiskUsagePgTests

- (void)setUp
{
    [super setUp];
    
    // Set-up code here.
}

- (void)tearDown
{
    // Tear-down code here.
    
    [super tearDown];
}

- (void)testTestDir
{
    DUFolderScanner *scanner = [[DUFolderScanner alloc] init];
    [scanner scanFolder:[NSURL URLWithString:@"/Users/romario/tmp/testdir"]];
}

- (void)testTestHome
{
    DUFolderScanner *scanner = [[DUFolderScanner alloc] init];
    [scanner scanFolder:[NSURL URLWithString:@"/Users/romario"]];
}


@end
