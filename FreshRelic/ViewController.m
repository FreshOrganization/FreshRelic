//
//  ViewController.m
//  FreshRelic
//
//  Created by Jinfeng.Li on 14-5-22.
//  Copyright (c) 2014年 Lijinfeng. All rights reserved.
//

#import "ViewController.h"
#import "FRDeviceInfo.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    NSUserDefaults *userd = [NSUserDefaults standardUserDefaults];
    
//    NSLog(@"测试一下");
    //3A3D324D-6060-447B-BE46-525AE2FF36A2
    //6A80CDB0-1226-4DDF-841E-4FDDD3DF264E
    NSString *u = [userd objectForKey:@"myuuid"];
    if (u)
    {
        NSLog(@"the u is:%@",u);
    }
    else
    {
        FRDeviceInfo *deviceinfo = [[FRDeviceInfo alloc] init];
        NSString *uuid = [deviceinfo getDeviceUUID];
        NSLog(@"uuid:%@",uuid);
        
        [userd setObject:uuid forKey:@"myuuid"];
        [userd synchronize];
    }
    
    FRDeviceInfo *deviceinfo = [[FRDeviceInfo alloc] init];
    float ver = [deviceinfo getIOSVersion];
    NSLog(@"the ver is:%f",ver);
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
