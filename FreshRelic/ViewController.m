//
//  ViewController.m
//  FreshRelic
//
//  Created by Jinfeng.Li on 14-5-22.
//  Copyright (c) 2014年 Lijinfeng. All rights reserved.
//

#import "ViewController.h"
#import "FRDeviceInfo.h"
#import "NSData+Swizzling.h"

@interface ViewController ()

@property(nonatomic,strong)FRDeviceInfo *testINfo;

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
//    NSUserDefaults *userd = [NSUserDefaults standardUserDefaults];
//    
////    NSLog(@"测试一下");
//    //3A3D324D-6060-447B-BE46-525AE2FF36A2
//    //6A80CDB0-1226-4DDF-841E-4FDDD3DF264E
//    NSString *u = [userd objectForKey:@"myuuid"];
//    if (u)
//    {
//        NSLog(@"the u is:%@",u);
//    }
//    else
//    {
//        FRDeviceInfo *deviceinfo = [[FRDeviceInfo alloc] init];
//        NSString *uuid = [deviceinfo getDeviceUUID];
//        NSLog(@"uuid:%@",uuid);
//        
//        [userd setObject:uuid forKey:@"myuuid"];
//        [userd synchronize];
//    }
    
    FRDeviceInfo *deviceinfo = [[FRDeviceInfo alloc] init];
    NSString *appversion = [deviceinfo getAPPVersion];
    NSString *devicetype = [deviceinfo getDeviceType];
    double appMemory = [deviceinfo getCurrentMemory];
    NSString *fruuid = [deviceinfo getDeviceUUID];
    NSString *appName = [deviceinfo getDisplayName];
    NSString *appBoundle = [deviceinfo getBoundleID];
    NSString *rect = [deviceinfo getScreenSize];
    NSLog(@"the device screen is:%@",rect);
    

//    NSURLConnection *conn = [[NSURLConnection alloc] initWithRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:@"http://www.baidu.com"]] delegate:self ];
//    [conn start];
//    NSMutableURLRequest *req = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:@"http://www.baidu.com"]];
//    [req setTimeoutInterval:10];
//    NSURLConnection *conn = [NSURLConnection connectionWithRequest:req delegate:self];
//    [conn start];
//    NSLog(@"%@",[NSThread callStackReturnAddresses]);
    
//    [deviceinfo getAddressDictonarytest];
    
//    self.testINfo = [[FRDeviceInfo alloc] init];
//    [self.testINfo getAddressDictonarytest];
    
    
    UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 320, 100)];
    [btn setTitle:@"崩溃按钮" forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(btnTouch) forControlEvents:UIControlEventTouchUpInside];
    btn.center = self.view.center;
    btn.backgroundColor = [UIColor blueColor];
    [self.view addSubview:btn];
    
    // 测试 url
    
    NSMutableURLRequest *req = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:@"http://www.baidu.com"]];
    NSURLConnection *conn = [[NSURLConnection alloc] initWithRequest:req delegate:self];
        [conn start];
     
//    NSURL *url = [NSURL URLWithString:@"http://pica.nipic.com/2007-12-12/20071212235955316_2.jpg"];
//    NSData *resultData = [NSData dataWithContentsOfURL:url];
//    NSString *urlString = [NSString stringWithFormat:@"http://itunes.apple.com/lookup?id=%@", @"728266494"];
//    
//    urlString = [urlString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
//    NSLog(@"==utf8=%@", urlString);
//    NSURL *url1 = [NSURL URLWithString:urlString];
//    
//    NSMutableURLRequest *request = [[NSMutableURLRequest alloc]initWithURL:url1 cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:10];
//    
//    [request setHTTPMethod:@"POST"];//设置请求方式为POST，默认为GET
//    
//    
//    NSData *received = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:nil];

}
-(void)btnTouch
{
    NSLog(@"---------");
    NSArray *arry=[NSArray arrayWithObject:@"sss"];
    NSLog(@"%@",[arry objectAtIndex:1]);
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - NSURLConnectionDelegate
#pragma mark - NSURLConnectionDataDelegate
- (void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    NSLog(@"%@",connection);
}
@end
