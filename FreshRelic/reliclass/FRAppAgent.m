//
//  FRAppAgent.m
//  FreshRelic
//
//  Created by Li Jinfeng on 14-5-22.
//  Copyright (c) 2014年 Lijinfeng. All rights reserved.
//

#import "FRAppAgent.h"
#import "FRNetworkRecord.h"
#import "FRUncaughtExceptionHandler.h"

#import <CoreLocation/CoreLocation.h>


@interface FRAppAgent()<NSURLConnectionDataDelegate,CLLocationManagerDelegate>

@property(nonatomic,strong)NSString *appKey;
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
    NSURL *url = [NSURL URLWithString:@""];
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:url];
    [request setHTTPMethod:@"POST"];
    
    NSString *timeStr = [NSString stringWithFormat:@"%ld",(long)[[NSDate date] timeIntervalSince1970]];
    [request setAllHTTPHeaderFields:[NSDictionary dictionaryWithObjectsAndKeys:appId,@"ak",timeStr,@"tm",nil]];
    
    NSMutableDictionary *dataDic = [NSMutableDictionary dictionaryWithCapacity:10];
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
    self.locationManager = [[CLLocationManager alloc] init];
    self.locationManager.delegate = self;
    [self.locationManager startUpdatingLocation];
    
    [FRNetworkRecord sharedFRNetworkRecord];
    
    // 异常捕获注册
    InstallUncaughtExceptionHandler();
    
    NSTimer *timer = [NSTimer scheduledTimerWithTimeInterval:60 target:self selector:@selector(reportDataToServer) userInfo:nil repeats:YES];
    [timer fire];
}

//上报数据
-(void)reportDataToServer{
    
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
