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
    // TODO: rikaji guidelines neco o tom, jestli tu uvadet vsechny ivary?
    NSMutableArray *_subfolders;
}

// TODO: vyzkouset pak, o kolik to zrychli nonatomic


@property (retain) DUFolderInfo *parentFolder; // TODO: tohle by spravne taky melo byt readonly
@property (retain, readonly) NSURL *url;
@property long size;

- (id)initWithURL:(NSURL *)url parentFolder:(DUFolderInfo *)parentFolder;
+ (id)folderInfoWithURL:(NSURL *)url parentFolder:(DUFolderInfo *)parentFolder;

- (void)addSubfolder:(DUFolderInfo *)subfolder;
- (NSArray *)subfolders;
@end
