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

//- (void)testTestDir
//{
//    DUScanFolderOperation *scanner = [[DUScanFolderOperation alloc] init];
//    DUFolderInfo *folder = [scanner scanFolder:[NSURL URLWithString:@"/Users/romario/tmp/testdir"]];
//    DULogFolderInfo(folder);
//}
//
//- (void)testFolderInfoSorting
//{
//    NSArray *folders = [NSArray arrayWithObjects:
//                        [DUFolderInfo folderInfoWithURL:[NSURL URLWithString:@"test2"]],
//                        [DUFolderInfo folderInfoWithURL:[NSURL URLWithString:@"test1"]],
//                        nil];
//    
//    NSSortDescriptor *sort = [NSSortDescriptor sortDescriptorWithKey:@"url.lastPathComponent" ascending:YES];
//    NSArray *sortedFolders = [folders sortedArrayUsingDescriptors:[NSArray arrayWithObject:sort]];
//    
//    for (DUFolderInfo *folder in sortedFolders)
//    {
//        NSLog(@"%@", [folder.url lastPathComponent]);
//    }
//
//                        
//}

- (void)testColorList
{
    // Apple
    // System
    // Crayons
    NSLog(@"And they are: %@", [[NSColorList colorListNamed:@"Crayons"] allKeys]);
}

//- (void)testTestHome
//{
//    DUFolderScanner *scanner = [[DUFolderScanner alloc] init];
//    [scanner scanFolder:[NSURL URLWithString:@"/Users/romario"]];
//}


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
