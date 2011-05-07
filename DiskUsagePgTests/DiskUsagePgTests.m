//
//  DiskUsagePgTests.m
//  DiskUsagePgTests
//
//  Created by Roman Masek on 5/6/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "DiskUsagePgTests.h"


void DULogFolderInfo(DUFolderInfo *folder);

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
    DUFolderInfo *folder = [scanner scanFolder:[NSURL URLWithString:@"/Users/romario/tmp/testdir"]];
    DULogFolderInfo(folder);
}

- (void)testTestHome
{
    DUFolderScanner *scanner = [[DUFolderScanner alloc] init];
    [scanner scanFolder:[NSURL URLWithString:@"/Users/romario"]];
}


void DULogFolderInfoInner(DUFolderInfo *folder, NSMutableString *indent)
{
    NSLog(@"%@%@ - %ld", indent, folder.url, folder.size);
    
    [indent appendString:@"  "];
    for (DUFolderInfo *subfolder in [folder subfolders])
    {
        DULogFolderInfoInner(subfolder, indent);
    }
    
    if (indent.length >= 2)
    {
        NSRange range;
        range.location = indent.length - 2;
        range.length = 2;
        [indent deleteCharactersInRange:range];
    }
}

void DULogFolderInfo(DUFolderInfo *folder)
{
    NSMutableString *indent = [[NSMutableString alloc] init];
    DULogFolderInfoInner(folder, indent);
    [indent release];
}


@end
