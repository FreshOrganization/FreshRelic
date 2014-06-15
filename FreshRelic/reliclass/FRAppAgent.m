//
//  FRAppAgent.m
//  FreshRelic
//
//  Created by Li Jinfeng on 14-5-22.
//  Copyright (c) 2014年 Lijinfeng. All rights reserved.
//

#import "FRAppAgent.h"
#import "FRNetworkRecord.h"
#import "FRDeviceInfo.h"
#import "FRUncaughtExceptionHandler.h"

#import <CoreLocation/CoreLocation.h>


@interface FRAppAgent()<NSURLConnectionDataDelegate,CLLocationManagerDelegate>


@property(nonatomic,strong)FRDeviceInfo *deviceInfo;
@property(nonatomic,strong)NSString *appKey;
@property(nonatomic)BOOL isAllowUseLocation; //是否允许使用当前位置
@property(nonatomic,strong)NSMutableArray *cpuArray; //cpu使用率
@property(nonatomic,strong)NSMutableArray *memoryArray; //内存使用率

@property(nonatomic,strong)NSDictionary *locationDic;
@property(nonatomic,strong)CLLocationManager *locationManager;

@end

@implementation FRAppAgent

+(FRAppAgent*)shareStance{
    static FRAppAgent *appAgent;
    @synchronized(self) {
        if (!appAgent)
            appAgent = [[self alloc] init];
    }
    return appAgent;

}

+(void)startWithAppID:(NSString*)appId isUseLocation:(BOOL)allow
{
    //初始化接口
    [FRAppAgent shareStance].appKey = appId;
    [FRAppAgent shareStance].isAllowUseLocation = allow;
//    NSURL *url = [NSURL URLWithString:@"http://apm-collector.testin.cn/mobile/v1/data/npi/register"];
    NSURL *url = [NSURL URLWithString:@""];
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:url];
    [request setHTTPMethod:@"POST"];
    
    NSString *timeStr = [NSString stringWithFormat:@"%ld",(long)[[NSDate date] timeIntervalSince1970]];
    [request setAllHTTPHeaderFields:[NSDictionary dictionaryWithObjectsAndKeys:appId,@"ak",timeStr,@"tm",nil]];
    
    NSMutableDictionary *dataDic = [NSMutableDictionary dictionaryWithCapacity:10];
    [dataDic setValue:[[FRAppAgent shareStance].deviceInfo getDeviceUUID] forKey:@"und"];
    [dataDic setValue:[[FRAppAgent shareStance].deviceInfo getAPPVersion] forKey:@"av"];
    [dataDic setValue:[NSNumber numberWithInt:2] forKey:@"on"];
    [dataDic setValue:[[FRAppAgent shareStance].deviceInfo getIOSVersion] forKey:@"ov"];
    [dataDic setValue:[[FRAppAgent shareStance].deviceInfo getDeviceType] forKey:@"mt"];
    [dataDic setValue:FR_Protocal_Ver forKey:@"pro"];
    [dataDic setValue:FRVersion forKey:@"sv"];
    
    NSData *postData = [NSJSONSerialization dataWithJSONObject:dataDic options:NSJSONWritingPrettyPrinted error:nil];
    [request setHTTPBody:postData];
    
    [NSURLConnection sendAsynchronousRequest:request queue:[[NSOperationQueue alloc] init] completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
        if (connectionError==nil) {
            NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
            if ([[dic objectForKey:@"en"] intValue]==0 ) {
                //初始化成功,开始监听
                [[FRAppAgent shareStance] startMonitor];
            }
        }
    }];
    //临时执行
    [[FRAppAgent shareStance] startMonitor];
}

-(void)startMonitor{
    if (self.isAllowUseLocation) {
        self.locationManager = [[CLLocationManager alloc] init];
        self.locationManager.delegate = self;
        [self.locationManager startUpdatingLocation];
    }

    [FRNetworkRecord sharedFRNetworkRecord];
    [[FRNetworkRecord sharedFRNetworkRecord] initRecord];
    
    // 异常捕获注册
    InstallUncaughtExceptionHandler();
    
    NSTimer *timer = [NSTimer scheduledTimerWithTimeInterval:60 target:self selector:@selector(reportDataToServer) userInfo:nil repeats:YES];
    [timer fire];
    
    //采集cpu和内存使用率
    NSTimer *cpuTimer = [NSTimer scheduledTimerWithTimeInterval:5 target:self selector:@selector(getCpuMemoryUseInfo) userInfo:nil repeats:YES];
    [cpuTimer fire];
}

//上报数据
-(void)reportDataToServer{
    NSLog(@"reportDataToServer");
//    NSURL *url = [NSURL URLWithString:@"http://apm-collector.testin.cn/mobile/v1/data/npi/submit"];
    NSURL *url = [NSURL URLWithString:@""];
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:url];
    [request setHTTPMethod:@"POST"];
    
    NSString *timeStr = [NSString stringWithFormat:@"%ld",(long)[[NSDate date] timeIntervalSince1970]];
    [request setAllHTTPHeaderFields:[NSDictionary dictionaryWithObjectsAndKeys:[FRAppAgent shareStance].appKey,@"ak",timeStr,@"tm",nil]];
    
    NSMutableDictionary *dataDic = [NSMutableDictionary dictionaryWithCapacity:10];
    
    [dataDic setValue:FR_Protocal_Ver forKey:@"pro"];
    //设备信息
    NSDictionary *deviceDic = [NSDictionary dictionaryWithObjectsAndKeys:[[FRAppAgent shareStance].deviceInfo getDeviceUUID],@"und",[[FRAppAgent shareStance].deviceInfo getAPPVersion],@"av",[NSNumber numberWithInt:2],@"on",[[FRAppAgent shareStance].deviceInfo getIOSVersion],@"ov",[[FRAppAgent shareStance].deviceInfo getDeviceType],@"mt",FRVersion,@"sv",nil];
    [dataDic setValue:deviceDic forKey:@"dei"];
    //cpu and memory
    NSDictionary *cpuMemoryDic = [NSDictionary dictionaryWithObjectsAndKeys:self.cpuArray,@"cpu",self.memoryArray,@"mem",nil];
    [dataDic setValue:cpuMemoryDic forKey:@"Mach"];
    //位置信息
    [dataDic setValue:self.locationDic forKey:@"loc"];
    //http 请求信息
    
    //错误的 http 请求信息
    
    //exception 崩溃时的信息
    
    
    NSData *postData = [NSJSONSerialization dataWithJSONObject:dataDic options:NSJSONWritingPrettyPrinted error:nil];
    [request setHTTPBody:postData];
    
    [NSURLConnection sendAsynchronousRequest:request queue:[[NSOperationQueue alloc] init] completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
        if (connectionError==nil) {
            NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
            if ([[dic objectForKey:@"en"] intValue]==0 ) {
                //上报数据成功，删除已上报数据
                //cpu and memory
                [self.cpuArray removeAllObjects];
                [self.memoryArray removeAllObjects];
                //删除采集的http信息
                
                
            }
        }
    }];
}

-(void)getCpuMemoryUseInfo{
    NSString *cpu = [NSString stringWithFormat:@"%@%@",[[[FRAppAgent shareStance].deviceInfo cpuUsage] objectAtIndex:0],@"%"];
    
    [self.cpuArray addObject:cpu];
    [self.memoryArray addObject:[NSNumber numberWithDouble:[[FRAppAgent shareStance].deviceInfo getCurrentMemory]]];
}

-(FRDeviceInfo*)deviceInfo{
    if (_deviceInfo) {
        _deviceInfo = [[FRDeviceInfo alloc] init];
    }
    return _deviceInfo;
}

-(void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations{
    
    CLLocation *location = [locations objectAtIndex:0];
    NSLog(@"array %@ %f",[locations objectAtIndex:0],location.coordinate.latitude);
    [manager stopUpdatingLocation];
    CLGeocoder *geocoder = [[CLGeocoder alloc] init];
    [geocoder reverseGeocodeLocation:location   completionHandler:^(NSArray *placemarks, NSError *error) {
        CLPlacemark *placemark = [placemarks objectAtIndex:0];
        self.locationDic = [NSDictionary dictionaryWithObjectsAndKeys:placemark.country,@"cu",placemark.locality,@"prv",placemark.administrativeArea,@"ct",nil];
//        NSLog(@"1:%@2:%@3:%@4:%@5:%@",placeMark.locality,placeMark.subLocality,placeMark.location,placeMark.country,placeMark.administrativeArea);
        NSLog(@"name:%@\n country:%@\n postalCode:%@\n ISOcountryCode:%@\n ocean:%@\n inlandWater:%@\n locality:%@\n subLocality:%@ \n administrativeArea:%@\n subAdministrativeArea:%@\n thoroughfare:%@\n subThoroughfare:%@\n",
              placemark.name,
              placemark.country,
              placemark.postalCode,
              placemark.ISOcountryCode,
              placemark.ocean,
              placemark.inlandWater,
              placemark.locality,
              placemark.subLocality,
              placemark.administrativeArea,
              placemark.subAdministrativeArea,
              placemark.thoroughfare,
              placemark.subThoroughfare);
    }];
    
}

-(void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error{
    
    NSLog(@"error %@",error.description);
}


@end
