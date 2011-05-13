//
//  DUFolderScanner.h
//  DiskUsagePg
//
//  Created by Roman Masek on 5/7/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DUFolderInfo.h"

@interface DUScanFolderOperation : NSOperation {
@private
    DUFolderInfo *_folderInfo;
}

- (id)initWithFolder:(NSURL *)folderURL;

- (void)_scanFolder;

@property (readonly) DUFolderInfo *folderInfo;

@end
