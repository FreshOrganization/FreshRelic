//
//  FRDeviceInfo.m
//  FreshRelic
//
//  Created by Jinfeng.Li on 14-5-28.
//  Copyright (c) 2014年 Lijinfeng. All rights reserved.
//

#import "FRDeviceInfo.h"

#import <CoreTelephony/CTTelephonyNetworkInfo.h>
#import <CoreTelephony/CTCarrier.h>


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

-(NSString *)getAPPVersion
{
    NSDictionary *infoDic = [[NSBundle mainBundle] infoDictionary];
    NSString *localVersion = [infoDic objectForKey:@"CFBundleShortVersionString"];
    return localVersion;
}

-(NSString *)getFRVersion
{
    return FRVersion;
}

-(NSString *)getDeviceType
{
    NSString *phoneModel = [[UIDevice currentDevice] model];
    return phoneModel;
}

-(NSDictionary*)getCarrierInfo{
    CTTelephonyNetworkInfo *networkInfo = [[CTTelephonyNetworkInfo alloc] init];
    NSLog(@"network %@",networkInfo.currentRadioAccessTechnology);//7.0
    NSLog(@"net %@",networkInfo.subscriberCellularProvider.carrierName);
    NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:networkInfo.currentRadioAccessTechnology,@"technology",networkInfo.subscriberCellularProvider.carrierName,@"carriername", nil];
    return dic;
}


@end


