//
//  FRAppAgent.m
//  FreshRelic
//
//  Created by Li Jinfeng on 14-5-22.
//  Copyright (c) 2014年 Lijinfeng. All rights reserved.
//

#import "FRAppAgent.h"
#import "FRNetworkRecord.h"
static FRAppAgent *frAppAgent;

@interface FRAppAgent()<NSURLConnectionDataDelegate>

@end

@implementation FRAppAgent

+(instancetype)shareStance{
    if (frAppAgent==nil)
    {
        frAppAgent = [[self alloc] init];
    }
    return frAppAgent;
}

+(void)startWithAppID:(NSString*)appId
{
    // 去服务端进行appid的验证 并根据回复信息进行自定义的设置
    [[FRAppAgent shareStance] setConnect];
    
    [FRNetworkRecord sharedFRNetworkRecord];
    
}

// 运行时编程 进行nsurlconnect的监听
-(void)setConnect
{
    
}

@end
