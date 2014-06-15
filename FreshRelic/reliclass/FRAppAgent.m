//
//  FRAppAgent.m
//  FreshRelic
//
//  Created by Li Jinfeng on 14-5-22.
//  Copyright (c) 2014年 Lijinfeng. All rights reserved.
//

#import "FRAppAgent.h"
#import "FRReportDataUnit.h"


@implementation FRAppAgent

+(void)startWithAppID:(NSString*)appId isUseLocation:(BOOL)allow
{
   [[FRReportDataUnit shareStance] initReportInterface:appId isUseLocation:allow];
}

@end
