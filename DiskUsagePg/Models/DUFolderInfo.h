//
//  DUFolderInfo.h
//  DiskUsagePg
//
//  Created by Roman Masek on 5/6/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface DUFolderInfo : NSObject {
@private
    DUFolderInfo *_parentFolder;
    NSURL *_url;
    NSMutableArray *_subfolders;
}

// TODO: vyzkouset pak, o kolik to zrychli nonatomic


@property (assign) DUFolderInfo *parentFolder;
@property (retain, readonly) NSURL *url;
@property long size;

- (id)initWithURL:(NSURL *)url;
+ (id)folderInfoWithURL:(NSURL *)url;

- (void)addSubfolder:(DUFolderInfo *)subfolder;
- (NSArray *)subfolders;

- (long)sizeWithSubfolders;

- (void)addToSize:(long) increment;

@end
