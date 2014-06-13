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
#import <sys/sysctl.h>
#import <mach/mach.h>
#import "FRMyKeyChainHelper.h"

@implementation FRDeviceInfo

-(NSString *)getDeviceUUID
{
    NSString *uuid = @"";
    uuid = [FRMyKeyChainHelper getTokenWithService:FRUUID];
    if (uuid == nil)
    {
        if ([[self getIOSVersion] floatValue]  < 6)
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
        [FRMyKeyChainHelper saveToken:uuid tokenService:FRUUID];
    }
    return uuid;
}

-(NSString *)getIOSVersion
{
    float version = [[[UIDevice currentDevice] systemVersion] floatValue];
    NSString *str = [NSString stringWithFormat:@"%f",version];
    return str;
}

-(NSString *)getAPPVersion
{
    NSDictionary *infoDic = [[NSBundle mainBundle] infoDictionary];
    NSString *localVersion = [infoDic objectForKey:@"CFBundleShortVersionString"];
    return localVersion;
}

-(NSString *)getDisplayName
{
    NSDictionary *infoDic = [[NSBundle mainBundle] infoDictionary];
    NSString *appName = [infoDic objectForKey:@"CFBundleDisplayName"];
    return appName;
}

-(NSString *)getBoundleID
{
    NSDictionary *infoDic = [[NSBundle mainBundle] infoDictionary];
    NSString *boundleid = [infoDic objectForKey:@"CFBundleIdentifier"];
    return boundleid;
}

-(NSString *)getScreenSize
{
    int width = [[UIScreen mainScreen] bounds].size.width;
    int height = [[UIScreen mainScreen] bounds].size.height;
    return [NSString stringWithFormat:@"%d*%d",width,height];
}

-(NSString *)getFRVersion
{
    return FRVersion;
}

-(NSString *)getDeviceType
{
    size_t size;
    int nR = sysctlbyname("hw.machine", NULL, &size, NULL, 0);
    char *machine = (char *)malloc(size);
    nR = sysctlbyname("hw.machine", machine, &size, NULL, 0);
    NSString *platform = [NSString stringWithCString:machine encoding:NSUTF8StringEncoding];
    free(machine);
    
    if ([platform isEqualToString:@"iPhone1,1"])
        platform = @"iPhone";
    else if ([platform isEqualToString:@"iPhone1,2"])
        platform = @"iPhone 3G";
    else if ([platform isEqualToString:@"iPhone2,1"])
        platform = @"iPhone 3GS";
    else if ([platform isEqualToString:@"iPhone3,1"]||[platform isEqualToString:@"iPhone3,2"]||[platform isEqualToString:@"iPhone3,3"])
        platform = @"iPhone 4";
    else if ([platform isEqualToString:@"iPhone4,1"])
        platform = @"iPhone 4S";
    else if ([platform isEqualToString:@"iPhone5,1"]||[platform isEqualToString:@"iPhone5,2"])
        platform = @"iPhone 5";
    else if ([platform isEqualToString:@"iPhone5,3"]||[platform isEqualToString:@"iPhone5,4"])
        platform = @"iPhone 5C";
    else if ([platform isEqualToString:@"iPhone6,2"]||[platform isEqualToString:@"iPhone6,1"])
        platform = @"iPhone 5S";
    else if ([platform isEqualToString:@"iPod4,1"])
        platform = @"iPod touch 4";
    else if ([platform isEqualToString:@"iPod5,1"])
        platform = @"iPod touch 5";
    else if ([platform isEqualToString:@"iPod3,1"])
        platform = @"iPod touch 3";
    else if ([platform isEqualToString:@"iPod2,1"])
        platform = @"iPod touch 2";
    else if ([platform isEqualToString:@"iPod1,1"])
        platform = @"iPod touch";
    else if ([platform isEqualToString:@"iPad3,2"]||[platform isEqualToString:@"iPad3,1"]||[platform isEqualToString:@"iPad3,3"])
        platform = @"iPad 3";
    else if ([platform isEqualToString:@"iPad2,2"]||[platform isEqualToString:@"iPad2,1"]||[platform isEqualToString:@"iPad2,3"]||[platform isEqualToString:@"iPad2,4"])
        platform = @"iPad 2";
    else if ([platform isEqualToString:@"iPad1,1"])
        platform = @"iPad 1";
    else if ([platform isEqualToString:@"iPad2,5"]||[platform isEqualToString:@"iPad2,6"]||[platform isEqualToString:@"iPad2,7"])
        platform = @"ipad mini";
    else if ([platform isEqualToString:@"iPad3,4"]||[platform isEqualToString:@"iPad3,5"]||[platform isEqualToString:@"iPad3,6"])
        platform = @"ipad 4";
    return platform;
}

-(NSDictionary*)getCarrierInfo{
    CTTelephonyNetworkInfo *networkInfo = [[CTTelephonyNetworkInfo alloc] init];
    NSLog(@"network %@",networkInfo.currentRadioAccessTechnology);//7.0
    NSLog(@"net %@",networkInfo.subscriberCellularProvider.carrierName);
    NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:networkInfo.currentRadioAccessTechnology,@"technology",networkInfo.subscriberCellularProvider.carrierName,@"carriername", nil];
    return dic;
}

-(double)getCurrentMemory
{
    task_basic_info_data_t taskInfo;
    mach_msg_type_number_t infoCount = TASK_BASIC_INFO_COUNT;
    kern_return_t kernReturn = task_info(mach_task_self(),
                                         TASK_BASIC_INFO,
                                         (task_info_t)&taskInfo,
                                         &infoCount);
    if (kernReturn != KERN_SUCCESS ) {
        return NSNotFound;
    }
    return taskInfo.resident_size;
}

- (NSArray *)cpuUsage
{
    NSMutableArray *usage = [NSMutableArray array];
    //    float usage = 0;
    processor_info_array_t _cpuInfo, _prevCPUInfo = nil;
    mach_msg_type_number_t _numCPUInfo, _numPrevCPUInfo = 0;
    unsigned _numCPUs;
    NSLock *_cpuUsageLock;
    
    int _mib[2U] = { CTL_HW, HW_NCPU };
    size_t _sizeOfNumCPUs = sizeof(_numCPUs);
    int _status = sysctl(_mib, 2U, &_numCPUs, &_sizeOfNumCPUs, NULL, 0U);
    if(_status)
        _numCPUs = 1;
    
    _cpuUsageLock = [[NSLock alloc] init];
    
    natural_t _numCPUsU = 0U;
    kern_return_t err = host_processor_info(mach_host_self(), PROCESSOR_CPU_LOAD_INFO, &_numCPUsU, &_cpuInfo, &_numCPUInfo);
    if(err == KERN_SUCCESS) {
        [_cpuUsageLock lock];
        
        for(unsigned i = 0U; i < _numCPUs; ++i) {
            Float32 _inUse, _total;
            if(_prevCPUInfo) {
                _inUse = (
                          (_cpuInfo[(CPU_STATE_MAX * i) + CPU_STATE_USER]   - _prevCPUInfo[(CPU_STATE_MAX * i) + CPU_STATE_USER])
                          + (_cpuInfo[(CPU_STATE_MAX * i) + CPU_STATE_SYSTEM] - _prevCPUInfo[(CPU_STATE_MAX * i) + CPU_STATE_SYSTEM])
                          + (_cpuInfo[(CPU_STATE_MAX * i) + CPU_STATE_NICE]   - _prevCPUInfo[(CPU_STATE_MAX * i) + CPU_STATE_NICE])
                          );
                _total = _inUse + (_cpuInfo[(CPU_STATE_MAX * i) + CPU_STATE_IDLE] - _prevCPUInfo[(CPU_STATE_MAX * i) + CPU_STATE_IDLE]);
            } else {
                _inUse = _cpuInfo[(CPU_STATE_MAX * i) + CPU_STATE_USER] + _cpuInfo[(CPU_STATE_MAX * i) + CPU_STATE_SYSTEM] + _cpuInfo[(CPU_STATE_MAX * i) + CPU_STATE_NICE];
                _total = _inUse + _cpuInfo[(CPU_STATE_MAX * i) + CPU_STATE_IDLE];
            }
            
            //            NSLog(@"Core : %u, Usage: %.2f%%", i, _inUse / _total * 100.f);
            float u = _inUse / _total * 100.f;
            [usage addObject:[NSNumber numberWithFloat:u]];
        }
        
        [_cpuUsageLock unlock];
        
        if(_prevCPUInfo) {
            size_t prevCpuInfoSize = sizeof(integer_t) * _numPrevCPUInfo;
            vm_deallocate(mach_task_self(), (vm_address_t)_prevCPUInfo, prevCpuInfoSize);
        }
        
        _prevCPUInfo = _cpuInfo;
        _numPrevCPUInfo = _numCPUInfo;
        
        _cpuInfo = nil;
        _numCPUInfo = 0U;
    } else {
        NSLog(@"Error!");
    }
    return usage;
}

@end


