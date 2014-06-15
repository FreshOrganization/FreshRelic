//
//  FRReportDataUnit.h
//  FreshRelic
//
//  Created by xlhu on 14-6-15.
//  Copyright (c) 2014年 Lijinfeng. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FRDeviceInfo.h"

@interface FRReportDataUnit : NSObject

+(FRReportDataUnit*)shareStance;

-(void)initReportInterface:(NSString*)appkey isUseLocation:(BOOL)allow;

-(void)reportException:(NSException *)exception;

@end
