//
//  NSURLConnection+Swizzling.m
//  FreshRelic
//
//  Created by song on 14-6-15.
//  Copyright (c) 2014年 Lijinfeng. All rights reserved.
//

#import "NSURLConnection+Swizzling.h"
#import "JRSwizzle.h"
#import "FRDeviceInfo.h"

@implementation NSURLConnection (Swizzling)

+ (void)load
{
    [super load];
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        
//        [self jr_swizzleClassMethod:@selector(connectionWithRequest:delegate:) withClassMethod:@selector(xxx_connectionWithRequest: delegate:) error:nil];
        
        
        
        [self jr_swizzleMethod:@selector(initWithRequest:delegate:) withMethod:@selector(xxx_initWithRequest:delegate:) error:nil];
        
        [self jr_swizzleMethod:@selector(initWithRequest:delegate:startImmediately:) withMethod:@selector(xxx_initWithRequest:delegate:startImmediately:) error:nil];
        
        [self jr_swizzleClassMethod:@selector(start) withClassMethod:@selector(xxx_start) error:nil];
        
        [self jr_swizzleClassMethod:@selector(sendSynchronousRequest:returningResponse:error:) withClassMethod:@selector(xxx_sendSynchronousRequest:returningResponse:error:) error:nil];
        
        
        [self jr_swizzleClassMethod:@selector(sendAsynchronousRequest:queue:completionHandler:) withClassMethod:@selector(xxx_sendAsynchronousRequest:queue:completionHandler:) error:nil];
        
        
        [self jr_swizzleClassMethod:@selector(connectionWithRequest:delegate:) withClassMethod:@selector(xxx_connectionWithRequest:delegate:) error:nil];
        

    });
}





#pragma  mark - 需要重写的方法
-(void)xxx_start
{
    [self xxx_start];
    FRNetworkRecord *record = [FRNetworkRecord sharedFRNetworkRecord];
    [record.startTimeArray addObject:[NSDate date]];
    NSString *urlStr = [NSString stringWithFormat:@"%@",self.originalRequest.URL];
    NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithDictionary:record.carrierDic];
    [dict setValue:urlStr forKey:@"url"];
    
    
    NSMutableDictionary *pas = [NSMutableDictionary dictionary];
    [pas setValuesForKeysWithDictionary:[self.originalRequest allHTTPHeaderFields]];
    [dict setValue:pas forKey:@"pas"];
    [record.requestInfo addObject:dict];
}

- (id)xxx_initWithRequest:(NSURLRequest *)request delegate:(id < NSURLConnectionDelegate >)delegate
{
    
    FRNetworkRecord *record = [FRNetworkRecord sharedFRNetworkRecord];
    
    
    [self xxx_initWithRequest:request delegate:record];
    
    [FRNetworkRecord addConn:self andDelegate:delegate];
    return self;
}

- (id)xxx_initWithRequest:(NSURLRequest *)request delegate:(id < NSURLConnectionDelegate >)delegate startImmediately:(BOOL)startImmediately
{
    
    FRNetworkRecord *record = [FRNetworkRecord sharedFRNetworkRecord];
    [self xxx_initWithRequest:request delegate:record startImmediately:startImmediately];
    [FRNetworkRecord addConn:self andDelegate:delegate];
    [record.startTimeArray addObject:[NSDate date]];
    NSString *urlStr = [NSString stringWithFormat:@"%@",self.originalRequest.URL];
    if ([urlStr rangeOfString:locationHttp].location==NSNotFound) {
        NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithDictionary:record.carrierDic];
        [dict setValue:[NSString stringWithFormat:@"%@",self.originalRequest.URL] forKey:@"url"];
        NSMutableDictionary *pas = [NSMutableDictionary dictionary];
        [pas setValuesForKeysWithDictionary:[self.originalRequest allHTTPHeaderFields]];
        [dict setValue:pas forKey:@"pas"];
        [record.requestInfo addObject:dict];
    }
    return self;
}

+ (NSURLConnection *)xxx_connectionWithRequest:(NSURLRequest *)request delegate:(id < NSURLConnectionDelegate >)delegate
{
    FRNetworkRecord *record = [FRNetworkRecord sharedFRNetworkRecord];
    NSURLConnection *conn = [NSURLConnection xxx_connectionWithRequest:request delegate:record];
    [FRNetworkRecord addConn:conn andDelegate:delegate];
    return conn;
}

+ (NSData *)xxx_sendSynchronousRequest:(NSURLRequest *)request returningResponse:(NSURLResponse **)response error:(NSError **)error
{
    NSTimeInterval startTime = [self getCurrentTimeInterval];
    NSData *data = [self xxx_sendSynchronousRequest:request returningResponse:response error:error];
    
    NSTimeInterval endTime = [self getCurrentTimeInterval];
    
    FRNetworkRecord *record = [FRNetworkRecord sharedFRNetworkRecord];
    NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithDictionary:record.carrierDic];
    [dict setValue:[NSString stringWithFormat:@"%@",request.URL] forKey:@"url"];
    [dict setValue:[NSString stringWithFormat:@"%f",endTime] forKey:@"tm"];
    if ([*response isKindOfClass:[NSHTTPURLResponse class]]) {
        NSInteger statusCode = [(NSHTTPURLResponse*)*response statusCode];
        // String，HTTP状态码，如400
        [dict setValue:[NSString stringWithFormat:@"%d",statusCode] forKey:@"htp"];
    }
    if (error==nil) {//正常http
        [dict setValue:[NSNumber numberWithBool:NO] forKey:@"isError"];
        [dict setValue:[NSString stringWithFormat:@"%f",endTime-startTime] forKey:@"ret"];
        [dict setValue:[NSString stringWithFormat:@"%f",endTime-startTime] forKey:@"fpt"];
        [dict setValue:[NSString stringWithFormat:@"%d",[data length]] forKey:@"rd"];
        
    }else{//错误http
        [dict setValue:[NSNumber numberWithBool:YES] forKey:@"isError"];
//        NSInteger errorCode = error.code;
//        switch (errorCode) {
//            case NSURLErrorTimedOut:
//            {
//                //        超时
//                [dict setValue:@"3" forKey:@"nte"];
//            }
//                break;
//            case NSURLErrorNetworkConnectionLost:
//            {
//                //            链接超时
//                [dict setValue:@"2" forKey:@"nte"];
//            }
//                break;
//            case NSURLErrorDNSLookupFailed:
//            {
//                //        DNS无法解析
//                [dict setValue:@"1" forKey:@"nte"];
//            }break;
//            default:
//                break;
//        }
        
    }
    [record.finishInfo addObject:dict];
    
    
    return data;
}

+(NSTimeInterval)getCurrentTimeInterval
{
    NSDate *date = [NSDate date];
    return [date timeIntervalSince1970];
}
+ (void)xxx_sendAsynchronousRequest:(NSURLRequest *)request queue:(NSOperationQueue *)queue completionHandler:(void (^)(NSURLResponse*, NSData*, NSError*))handler
{
    NSTimeInterval startTime = [self getCurrentTimeInterval];
    [self xxx_sendAsynchronousRequest:request queue:queue completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
        handler(response,data,connectionError);
        
        NSString *urlStr = [NSString stringWithFormat:@"%@",request.URL];
        if ([urlStr rangeOfString:FreshRelicHttp].location!=NSNotFound) {
            return;
        }
        NSTimeInterval endTime = [self getCurrentTimeInterval];
        FRNetworkRecord *record = [FRNetworkRecord sharedFRNetworkRecord];
        NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithDictionary:record.carrierDic];
        [dict setValue:[NSString stringWithFormat:@"%@",request.URL] forKey:@"url"];
        [dict setValue:[NSString stringWithFormat:@"%f",endTime] forKey:@"tm"];
        if ([response isKindOfClass:[NSHTTPURLResponse class]]) {
            NSInteger statusCode = [(NSHTTPURLResponse*)response statusCode];
            // String，HTTP状态码，如400
            [dict setValue:[NSString stringWithFormat:@"%d",statusCode] forKey:@"htp"];
        }
        if (connectionError==nil) {//正常http
            [dict setValue:[NSNumber numberWithBool:NO] forKey:@"isError"];
            [dict setValue:[NSString stringWithFormat:@"%f",endTime-startTime] forKey:@"ret"];
            [dict setValue:[NSString stringWithFormat:@"%f",endTime-startTime] forKey:@"fpt"];
            [dict setValue:[NSString stringWithFormat:@"%d",[data length]] forKey:@"rd"];
            [record.finishInfo addObject:dict];
            
        }else{//错误http
            [dict setValue:[NSNumber numberWithBool:YES] forKey:@"isError"];
            NSInteger errorCode = connectionError.code;
            switch (errorCode) {
                case NSURLErrorTimedOut:
                {
                    //        超时
                    [dict setValue:@"3" forKey:@"nte"];
                }
                    break;
                case NSURLErrorNetworkConnectionLost:
                {
                    //            链接超时
                    [dict setValue:@"2" forKey:@"nte"];
                }
                    break;
                case NSURLErrorDNSLookupFailed:
                {
                    //        DNS无法解析
                    [dict setValue:@"1" forKey:@"nte"];
                }break;
                default:
                    break;
            }
            [record.errorInfo addObject:dict];
        }
    }];
}


@end
