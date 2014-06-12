//
//  FRDeviceInfo.h
//  FreshRelic
//
//  Created by Jinfeng.Li on 14-5-28.
//  Copyright (c) 2014年 Lijinfeng. All rights reserved.
//

#import <Foundation/Foundation.h>

#define FR_Protocal_Ver @"1.0"
#define FRVersion @"1.0"
#define FRUUID @"FRUUID"

@interface FRDeviceInfo : NSObject

-(NSString *)getDeviceUUID;

-(NSString *)getIOSVersion;

-(NSString *)getAPPVersion;

-(NSString *)getFRVersion;

-(NSString *)getDeviceType;

-(NSDictionary*)getCarrierInfo;
    
// 获取当前应用所占内存 单位字节
-(double)getCurrentMemory;

// 获取CPU使用率 支持获取多核
- (NSArray *)cpuUsage;

@end
