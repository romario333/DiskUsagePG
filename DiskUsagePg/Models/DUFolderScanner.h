//
//  DUFolderScanner.h
//  DiskUsagePg
//
//  Created by Roman Masek on 5/7/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DUFolderInfo.h"


@interface DUFolderScanner : NSObject {
@private
    
}

- (DUFolderInfo *)scanFolder:(NSURL *)folderUrl;

@end
