//
//  FRDeviceInfo.m
//  FreshRelic
//
//  Created by Jinfeng.Li on 14-5-28.
//  Copyright (c) 2014年 Lijinfeng. All rights reserved.
//

#import "FRDeviceInfo.h"

@implementation FRDeviceInfo

-(NSString *)getDeviceUUID
{
    NSString *uuid = @"";
    if ([self getIOSVersion] < 6)
    {
        CFUUIDRef uuidRef = CFUUIDCreate(NULL);
        CFStringRef uuidStringRef = CFUUIDCreateString(NULL, uuidRef);
        CFRelease(uuidRef);
        uuid = [NSString stringWithString:(__bridge NSString *)uuidStringRef];
        CFRelease(uuidStringRef);
    }
    else
    {
        uuid = [[[UIDevice currentDevice] identifierForVendor] UUIDString];
    }
    return uuid;
}

-(float)getIOSVersion
{
    float version = [[[UIDevice currentDevice] systemVersion] floatValue];
    return version;
}

@end
