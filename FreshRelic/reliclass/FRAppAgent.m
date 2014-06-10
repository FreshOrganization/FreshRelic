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

+(void)startWithAppID:(NSString*)appId
{
    // 去服务端进行appid的验证 并根据回复信息进行自定义的设置
    [[FRAppAgent shareStance] setConnect];
    
    [FRNetworkRecord sharedFRNetworkRecord];
    
    [[FRAppAgent shareStance] getAddressInfo];
    
    // 异常捕获注册
    InstallUncaughtExceptionHandler();
}

-(void)getAddressInfo{

//    if ([CLLocationManager locationServicesEnabled] && [CLLocationManager authorizationStatus]==kCLAuthorizationStatusAuthorized) {
        self.locationManager = [[CLLocationManager alloc] init];
        self.locationManager.delegate = self;
        [self.locationManager startUpdatingLocation];
//    }
}

// 运行时编程 进行nsurlconnect的监听
-(void)setConnect
{
    
}

-(void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations{
    
    CLLocation *location = [locations objectAtIndex:0];
    NSLog(@"array %@ %f",[locations objectAtIndex:0],location.coordinate.latitude);
    [manager stopUpdatingLocation];
    CLGeocoder *geocoder = [[CLGeocoder alloc] init];
    CLLocation *ll = [[CLLocation alloc] initWithLatitude:100 longitude:100];
    [geocoder reverseGeocodeLocation:ll   completionHandler:^(NSArray *placemarks, NSError *error) {
        CLPlacemark *placemark = [placemarks objectAtIndex:0];
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
