//
//  NSURLConnection+Swizzling.m
//  FreshRelic
//
//  Created by song on 14-6-15.
//  Copyright (c) 2014年 Lijinfeng. All rights reserved.
//

#import "NSURLConnection+Swizzling.h"
#import "JRSwizzle.h"

@implementation NSURLConnection (Swizzling)

+(void)exchangeSel:(SEL)sel1 with:(SEL)sel2
{
    Class class = [self class];
    
    // When swizzling a class method, use the following:
    // Class class = object_getClass((id)self);
    
    SEL originalSelector = sel1;
    SEL swizzledSelector = sel2;
    
    Method originalMethod = class_getInstanceMethod(class, originalSelector);
    Method swizzledMethod = class_getInstanceMethod(class, swizzledSelector);
    
    BOOL didAddMethod =
    class_addMethod(class,
                    originalSelector,
                    method_getImplementation(swizzledMethod),
                    method_getTypeEncoding(swizzledMethod));
    
    if (didAddMethod) {
        class_replaceMethod(class,
                            swizzledSelector,
                            method_getImplementation(originalMethod),
                            method_getTypeEncoding(originalMethod));
    } else {
        method_exchangeImplementations(originalMethod, swizzledMethod);
    }
}

+ (void)load
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        
//        [self jr_swizzleClassMethod:@selector(connectionWithRequest:delegate:) withClassMethod:@selector(xxx_connectionWithRequest: delegate:) error:nil];
        
        
        
        [self jr_swizzleMethod:@selector(initWithRequest:delegate:) withMethod:@selector(xxx_initWithRequest:delegate:) error:nil];
        
        [self jr_swizzleMethod:@selector(initWithRequest:delegate:startImmediately:) withMethod:@selector(xxx_initWithRequest:delegate:startImmediately:) error:nil];
        
        [self jr_swizzleClassMethod:@selector(sendSynchronousRequest:returningResponse:error:) withClassMethod:@selector(xxx_sendSynchronousRequest:returningResponse:error:) error:nil];
        
        
        [self jr_swizzleClassMethod:@selector(sendAsynchronousRequest:queue:completionHandler:) withClassMethod:@selector(xxx_sendAsynchronousRequest:queue:completionHandler:) error:nil];
        
        
        [self jr_swizzleClassMethod:@selector(connectionWithRequest:delegate:) withClassMethod:@selector(xxx_connectionWithRequest:delegate:) error:nil];
        

    });
}





#pragma  mark - 需要重写的方法


- (id)xxx_initWithRequest:(NSURLRequest *)request delegate:(id < NSURLConnectionDelegate >)delegate
{
    [self xxx_initWithRequest:request delegate:delegate];
    [FRNetworkRecord addConn:self andDelegate:delegate];
    return self;
}

- (id)xxx_initWithRequest:(NSURLRequest *)request delegate:(id < NSURLConnectionDelegate >)delegate startImmediately:(BOOL)startImmediately
{
    [FRNetworkRecord addConn:self andDelegate:delegate];
    [self xxx_initWithRequest:request delegate:delegate startImmediately:startImmediately];

    return self;
}

+ (NSURLConnection *)xxx_connectionWithRequest:(NSURLRequest *)request delegate:(id < NSURLConnectionDelegate >)delegate
{
    
    NSURLConnection *conn = [NSURLConnection xxx_connectionWithRequest:request delegate:delegate];
    [FRNetworkRecord addConn:conn andDelegate:delegate];
    return conn;
}

+ (NSData *)xxx_sendSynchronousRequest:(NSURLRequest *)request returningResponse:(NSURLResponse **)response error:(NSError **)error
{

    NSData *data = [self xxx_sendSynchronousRequest:request returningResponse:response error:error];
    
    return data;
}


+ (void)xxx_sendAsynchronousRequest:(NSURLRequest *)request queue:(NSOperationQueue *)queue completionHandler:(void (^)(NSURLResponse*, NSData*, NSError*))handler
{
    [self xxx_sendAsynchronousRequest:request queue:queue completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
        handler(response,data,connectionError);
    }];
}


@end
