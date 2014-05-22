//
//  FRAppAgent.h
//  FreshRelic
//
//  Created by Li Jinfeng on 14-5-22.
//  Copyright (c) 2014年 Lijinfeng. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FRAppAgent : NSObject

// 初始化
+(void)startWithAppID:(NSString*)appId;

@end
