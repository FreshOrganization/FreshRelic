//
//  NSData+Swizzling.m
//  FreshRelic
//
//  Created by song on 14-6-15.
//  Copyright (c) 2014年 Lijinfeng. All rights reserved.
//

#import "NSData+Swizzling.h"
#import "JRSwizzle.h"
@implementation NSData (Swizzling)

+ (void)load
{
    NSLog(@"nsdata swizzling is coming...");
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        [self jr_swizzleClassMethod:@selector(dataWithContentsOfURL:) withClassMethod:@selector(xxx_dataWithContentsOfURL:) error:nil];
        
        
        [self jr_swizzleClassMethod:@selector(dataWithContentsOfURL:options:error:) withClassMethod:@selector(xxx_dataWithContentsOfURL:options:error:) error:nil];
    });
}

+(NSTimeInterval)getCurrentTimeInterval
{
    NSDate *date = [NSDate date];
    return [date timeIntervalSince1970];
}

+ (id)xxx_dataWithContentsOfURL:(NSURL *)aURL
{
    NSTimeInterval startTime = [self getCurrentTimeInterval];
    
    NSData *data = [self xxx_dataWithContentsOfURL:aURL];
    
    NSString *urlStr = [NSString stringWithFormat:@"%@",aURL];
    if ([urlStr rangeOfString:fileHttp].location==NSNotFound) {
        NSTimeInterval endTime = [self getCurrentTimeInterval];
        
        FRNetworkRecord *record = [FRNetworkRecord sharedFRNetworkRecord];
        
        NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithDictionary:record.carrierDic];
        [dict setValue:[NSString stringWithFormat:@"%@",aURL] forKey:@"url"];
        [dict setValue:[NSString stringWithFormat:@"%f",endTime-startTime] forKey:@"ret"];
        [dict setValue:[NSString stringWithFormat:@"%f",endTime-startTime] forKey:@"fpt"];
        [dict setValue:[NSString stringWithFormat:@"%d",[data length]] forKey:@"rd"];
        [dict setValue:[NSString stringWithFormat:@"%f",endTime] forKey:@"tm"];
    
        [record.finishInfo addObject:dict];

    }
    
    return data;
}

+ (id)xxx_dataWithContentsOfURL:(NSURL *)aURL options:(NSDataReadingOptions)mask error:(NSError **)errorPtr
{
    NSTimeInterval startTime = [self getCurrentTimeInterval];
    NSData *data = [self xxx_dataWithContentsOfURL:aURL options:mask error:errorPtr];
    NSString *urlStr = [NSString stringWithFormat:@"%@",aURL];
    if ([urlStr rangeOfString:fileHttp].location==NSNotFound) {
        NSTimeInterval endTime = [self getCurrentTimeInterval];
        FRNetworkRecord *record = [FRNetworkRecord sharedFRNetworkRecord];
        NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithDictionary:record.carrierDic];
        [dict setValue:[NSString stringWithFormat:@"%@",aURL] forKey:@"url"];
        [dict setValue:[NSString stringWithFormat:@"%f",endTime-startTime] forKey:@"ret"];
        [dict setValue:[NSString stringWithFormat:@"%f",endTime-startTime] forKey:@"fpt"];
        [dict setValue:[NSString stringWithFormat:@"%d",[data length]] forKey:@"rd"];
        [dict setValue:[NSString stringWithFormat:@"%f",endTime] forKey:@"tm"];
        
        
        [record.finishInfo addObject:dict];
    }
    return data;
}
@end
