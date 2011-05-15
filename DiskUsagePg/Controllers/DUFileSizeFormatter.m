//
//  DUByteFormatter.m
//  DiskUsagePg
//
//  Created by Roman Masek on 5/15/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "DUFileSizeFormatter.h"


@implementation DUFileSizeFormatter

BOOL DULeopardOrGreater();

- (id)initWithStyle:(uint8_t)style
{
    self = [super init];
    if (self) {
        _style = style;
    }
    
    return self;
}

- (void)dealloc
{
    [super dealloc];
}

- (NSString *)stringFromFileSize:(double)fileSize
{
    static const char units[] = { '\0', 'k', 'M', 'G', 'T', 'P', 'E', 'Z', 'Y' };
    static int maxUnits = sizeof units - 1;
    
    int multiplier = (_style & DUFileSizeFormatterOSNativeUnits && !DULeopardOrGreater() || _style & DUFileSizeFormatterBinaryUnits) ? 1024 : 1000;
    int exponent = 0;
    
    while (fileSize >= multiplier && exponent < maxUnits) {
        fileSize /= multiplier;
        exponent++;
    }
    NSNumberFormatter* formatter = [[[NSNumberFormatter alloc] init] autorelease];
    [formatter setMaximumFractionDigits:2];
    if (_style & DUFileSizeFormatterLocalizedFormat) {
        [formatter setNumberStyle: NSNumberFormatterDecimalStyle];
    }
    // Beware of reusing this format string. -[NSString stringWithFormat] ignores \0, *printf does not.
    return [NSString stringWithFormat:@"%@ %cB", [formatter stringFromNumber: [NSNumber numberWithDouble: fileSize]], units[exponent]];
    
}


BOOL DULeopardOrGreater(){
    static BOOL alreadyComputedOS = NO;
    static BOOL leopardOrGreater = NO;
    if (!alreadyComputedOS) {
        SInt32 majorVersion, minorVersion;
        Gestalt(gestaltSystemVersionMajor, &majorVersion);
        Gestalt(gestaltSystemVersionMinor, &minorVersion);
        leopardOrGreater = ((majorVersion == 10 && minorVersion >= 5) || majorVersion > 10);
        alreadyComputedOS = YES;
    }
    return leopardOrGreater;
}


@end
