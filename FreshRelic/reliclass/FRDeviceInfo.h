//
//  FRDeviceInfo.h
//  FreshRelic
//
//  Created by Jinfeng.Li on 14-5-28.
//  Copyright (c) 2014年 Lijinfeng. All rights reserved.
//

#import <Foundation/Foundation.h>

#define FRVersion @"1.0"

@interface FRDeviceInfo : NSObject

-(NSString *)getDeviceUUID;

-(float)getIOSVersion;

-(NSString *)getAPPVersion;

-(NSString *)getFRVersion;

-(NSString *)getDeviceType;

@end
