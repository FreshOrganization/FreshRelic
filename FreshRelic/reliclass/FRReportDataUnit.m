//
//  FRReportDataUnit.m
//  FreshRelic
//
//  Created by xlhu on 14-6-15.
//  Copyright (c) 2014年 Lijinfeng. All rights reserved.
//

#import "FRReportDataUnit.h"

#import "FRNetworkRecord.h"
#import "FRDeviceInfo.h"
#import "FRUncaughtExceptionHandler.h"

#import <CoreLocation/CoreLocation.h>

@interface FRReportDataUnit()<CLLocationManagerDelegate>

@property(nonatomic,strong)FRDeviceInfo *deviceInfo;
@property(nonatomic,strong)NSException *exception;
@property(nonatomic,strong)NSString *appKey;
@property(nonatomic)BOOL isAllowUseLocation; //是否允许使用当前位置
@property(nonatomic,strong)NSMutableArray *cpuArray; //cpu使用率
@property(nonatomic,strong)NSMutableArray *memoryArray; //内存使用率

@property(nonatomic,strong)NSMutableDictionary *locationDic;
@property(nonatomic,strong)CLLocationManager *locationManager;


@end

@implementation FRReportDataUnit

+(FRReportDataUnit*)shareStance{
    static FRReportDataUnit *reportDataUnit;
    @synchronized(self) {
        if (!reportDataUnit)
            reportDataUnit = [[self alloc] init];
    }
    return reportDataUnit;
}


-(void)initReportInterface:(NSString*)appkey isUseLocation:(BOOL)allow{
    //初始化接口
    self.deviceInfo = [[FRDeviceInfo alloc] init];
    self.locationDic = [NSMutableDictionary dictionaryWithCapacity:3];
    self.cpuArray = [[NSMutableArray alloc] initWithCapacity:20];
    self.memoryArray = [[NSMutableArray alloc] initWithCapacity:20];
    self.appKey = appkey;
    self.isAllowUseLocation = allow;
    NSURL *url = [NSURL URLWithString:FRInitURL];
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:url];
    [request setHTTPMethod:@"POST"];
    
    NSString *timeStr = [NSString stringWithFormat:@"%ld",(long)[[NSDate date] timeIntervalSince1970]];
    [request setAllHTTPHeaderFields:[NSDictionary dictionaryWithObjectsAndKeys:appkey,@"ak",timeStr,@"tm",nil]];
    
    NSMutableDictionary *dataDic = [NSMutableDictionary dictionaryWithCapacity:10];
    [dataDic setValue:[self.deviceInfo getDeviceUUID] forKey:@"und"];
    [dataDic setValue:[self.deviceInfo getAPPVersion] forKey:@"av"];
    [dataDic setValue:[NSNumber numberWithInt:2] forKey:@"on"];
    [dataDic setValue:[self.deviceInfo getIOSVersion] forKey:@"ov"];
    [dataDic setValue:[self.deviceInfo getDeviceType] forKey:@"mt"];
    [dataDic setValue:FR_Protocal_Ver forKey:@"pro"];
    [dataDic setValue:FRVersion forKey:@"sv"];
    
    
    NSData *postData = [NSJSONSerialization dataWithJSONObject:dataDic options:NSJSONWritingPrettyPrinted error:nil];
    [request setHTTPBody:postData];
    
    [NSURLConnection sendAsynchronousRequest:request queue:[[NSOperationQueue alloc] init] completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
        if (connectionError==nil) {
            NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
            if ([[dic objectForKey:@"en"] intValue]==0 ) {
                //初始化成功,开始监听
                [self startMonitor];
            }
        }
    }];
    //临时执行
    [self startMonitor];
}

-(void)startMonitor{
    if (self.isAllowUseLocation) {
        self.locationManager = [[CLLocationManager alloc] init];
        self.locationManager.delegate = self;
        [self.locationManager startUpdatingLocation];
    }
    
    [FRNetworkRecord sharedFRNetworkRecord];
    
    // 异常捕获注册
    InstallUncaughtExceptionHandler();
    
    NSTimer *timer = [NSTimer scheduledTimerWithTimeInterval:60 target:self selector:@selector(reportDataTimer) userInfo:nil repeats:YES];
    [timer fire];
    
    //采集cpu和内存使用率
    NSTimer *cpuTimer = [NSTimer scheduledTimerWithTimeInterval:5 target:self selector:@selector(getCpuMemoryUseInfo) userInfo:nil repeats:YES];
    [cpuTimer fire];
}

-(void)reportDataTimer{
    [self reportDataToServer:NO];
}

//上报数据 是否crash
-(void)reportDataToServer:(BOOL)isCrash{
    NSLog(@"reportDataToServer");
    NSURL *url = [NSURL URLWithString:FRUploadURL];
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:url];
    [request setHTTPMethod:@"POST"];
    
    NSString *timeStr = [NSString stringWithFormat:@"%ld",(long)[[NSDate date] timeIntervalSince1970]];
    [request setAllHTTPHeaderFields:[NSDictionary dictionaryWithObjectsAndKeys:self.appKey,@"ak",timeStr,@"tm",nil]];
    
    NSMutableDictionary *dataDic = [NSMutableDictionary dictionaryWithCapacity:10];
    
    [dataDic setValue:FR_Protocal_Ver forKey:@"pro"];
    //设备信息
    NSDictionary *deviceDic = [NSDictionary dictionaryWithObjectsAndKeys:[self.deviceInfo getDeviceUUID],@"und",[self.deviceInfo getAPPVersion],@"av",[NSNumber numberWithInt:2],@"on",[self.deviceInfo getIOSVersion],@"ov",[self.deviceInfo getDeviceType],@"mt",FRVersion,@"sv",nil];
    [dataDic setValue:deviceDic forKey:@"dei"];
    //cpu and memory
    NSDictionary *cpuMemoryDic = [NSDictionary dictionaryWithObjectsAndKeys:self.cpuArray,@"cpu",self.memoryArray,@"mem",nil];
    [dataDic setValue:cpuMemoryDic forKey:@"Mach"];
    //位置信息
    [dataDic setValue:self.locationDic forKey:@"loc"];
    //http 请求信息
    [dataDic setValue:[FRNetworkRecord sharedFRNetworkRecord].requestInfo forKey:@"http"];
    //错误的 http 请求信息
    
    //exception 崩溃时的信息
    if (isCrash) {
        NSDictionary *dic = [self.deviceInfo getCarrierInfo];
        NSMutableDictionary *mutableDic = [NSMutableDictionary dictionaryWithDictionary:dic];
        [mutableDic setValue:self.exception.name forKey:@"name"];
        [mutableDic setValue:self.exception.reason forKey:@"reason"];
         NSString *timeStr = [NSString stringWithFormat:@"%ld",(long)[[NSDate date] timeIntervalSince1970]];
        [mutableDic setValue:timeStr forKey:@"tm"];
        [dataDic setValue:mutableDic forKey:@"ecp"];
    }
    NSLog(@"report %@",dataDic);
    
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
                [[FRNetworkRecord sharedFRNetworkRecord].requestInfo removeAllObjects];
            }
        }
    }];
}

-(void)reportException:(NSException *)exception{

    self.exception = exception;
    [self reportDataToServer:YES];
}

-(void)getCpuMemoryUseInfo{
    if (self.cpuArray.count>20) {//防止数据不能上传时，数组不停增加
        return;
    }
    
    NSString *cpu = [NSString stringWithFormat:@"%@%@",[[self.deviceInfo cpuUsage] objectAtIndex:0],@"%"];

    [self.cpuArray addObject:cpu];
    [self.memoryArray addObject:[NSNumber numberWithDouble:[self.deviceInfo getCurrentMemory]]];
}

-(void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations{
    
    CLLocation *location = [locations objectAtIndex:0];
    [manager stopUpdatingLocation];
    CLGeocoder *geocoder = [[CLGeocoder alloc] init];
    [geocoder reverseGeocodeLocation:location   completionHandler:^(NSArray *placemarks, NSError *error) {
        CLPlacemark *placemark = [placemarks objectAtIndex:0];
        [self.locationDic setValue:placemark.country forKey:@"cu"];
        [self.locationDic setValue:placemark.locality forKey:@"prv"];
        if (placemark.locality==NULL) {
            [self.locationDic setValue:placemark.administrativeArea forKey:@"prv"];
        }
        [self.locationDic setValue:placemark.subLocality forKey:@"ct"];
//        NSLog(@"name:%@\n country:%@\n postalCode:%@\n ISOcountryCode:%@\n ocean:%@\n inlandWater:%@\n locality:%@\n subLocality:%@ \n administrativeArea:%@\n subAdministrativeArea:%@\n thoroughfare:%@\n subThoroughfare:%@\n",
//              placemark.name,
//              placemark.country,
//              placemark.postalCode,
//              placemark.ISOcountryCode,
//              placemark.ocean,
//              placemark.inlandWater,
//              placemark.locality,
//              placemark.subLocality,
//              placemark.administrativeArea,
//              placemark.subAdministrativeArea,
//              placemark.thoroughfare,
//              placemark.subThoroughfare);
//        NSLog(@"local %@",self.locationDic);
    }];
    
}

-(void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error{
    
    NSLog(@"error %@",error.description);
}



@end
