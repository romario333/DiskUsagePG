//
//  NSString+DUDataFormatters.h
//  DiskUsagePg
//
//  Created by Roman Masek on 5/10/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

//TODO: takhle se delaji moduly?

enum {
    kUnitStringBinaryUnits     = 1 << 0,
    kUnitStringOSNativeUnits   = 1 << 1,
    kUnitStringLocalizedFormat = 1 << 2
};

BOOL leopardOrGreater(){
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

NSString* unitStringFromBytes(double bytes, uint8_t flags){
    
    static const char units[] = { '\0', 'k', 'M', 'G', 'T', 'P', 'E', 'Z', 'Y' };
    static int maxUnits = sizeof units - 1;
    
    int multiplier = (flags & kUnitStringOSNativeUnits && !leopardOrGreater() || flags & kUnitStringBinaryUnits) ? 1024 : 1000;
    int exponent = 0;
    
    while (bytes >= multiplier && exponent < maxUnits) {
        bytes /= multiplier;
        exponent++;
    }
    NSNumberFormatter* formatter = [[[NSNumberFormatter alloc] init] autorelease];
    [formatter setMaximumFractionDigits:2];
    if (flags & kUnitStringLocalizedFormat) {
        [formatter setNumberStyle: NSNumberFormatterDecimalStyle];
    }
    // Beware of reusing this format string. -[NSString stringWithFormat] ignores \0, *printf does not.
    return [NSString stringWithFormat:@"%@ %cB", [formatter stringFromNumber: [NSNumber numberWithDouble: bytes]], units[exponent]];
}
