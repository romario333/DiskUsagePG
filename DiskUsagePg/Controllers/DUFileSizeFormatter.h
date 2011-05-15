//
//  DUByteFormatter.h
//  DiskUsagePg
//
//  Created by Roman Masek on 5/15/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

// TODO: sebral jsem nekde na inetu, zrevidovat
enum {
    DUFileSizeFormatterBinaryUnits     = 1 << 0,
    DUFileSizeFormatterOSNativeUnits   = 1 << 1,
    DUFileSizeFormatterLocalizedFormat = 1 << 2
};

@interface DUFileSizeFormatter : NSObject {
@private
    uint8_t _style; // TODO: tohle jde urcite nejak hezceji
}

- (id)initWithStyle:(uint8_t)style;

// TODO: proc jako double?
- (NSString *)stringFromFileSize:(double)fileSize;

@end
