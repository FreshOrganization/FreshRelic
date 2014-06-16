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
#define FRInitURL @"http://apm-collector.testin.cn/mobile/v1/data/npi/register"
#define FRUploadURL @"http://apm-collector.testin.cn/mobile/v1/data/npi/submit"

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
-(NSArray *)cpuUsage;

// 获取应用名称
-(NSString *)getDisplayName;

// 获取boundle id
-(NSString *)getBoundleID;

// 获取屏幕尺寸
-(NSString *)getScreenSize;

@end
