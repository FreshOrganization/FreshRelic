//
//  FRNetworkRecord.m
//  FreshRelic
//
//  Created by tag_mac_05 on 5/28/14.
//  Copyright (c) 2014 Lijinfeng. All rights reserved.
//
#define SuppressPerformSelectorLeakWarning(Stuff) \
do { \
_Pragma("clang diagnostic push") \
_Pragma("clang diagnostic ignored \"-Warc-performSelector-leaks\"") \
Stuff; \
_Pragma("clang diagnostic pop") \
} while (0)
#import "FRNetworkRecord.h"
@interface Conn:NSURLConnection
- (id)newInitWithRequest:(NSURLRequest *)request delegate:(id)delegate;
+ (NSURLConnection *)newConnectionWithRequest:(NSURLRequest *)request delegate:(id < NSURLConnectionDelegate >)delegate;
@end
@implementation Conn

+ (instancetype)newConnectionWithRequest:(NSURLRequest *)request delegate:(id < NSURLConnectionDelegate >)delegate
{
    FRNetworkRecord *center = [FRNetworkRecord sharedFRNetworkRecord];
    Conn *conn = [[Conn alloc] initWithRequest:request delegate:center];
    [center.connArray addObject:conn];
    if (delegate==nil) {
        [center.delegateArray addObject:[NSNull null]];
    }else
    {
    [center.delegateArray addObject:delegate];
    }
    return conn;
}


- (id)newInitWithRequest:(NSURLRequest *)request delegate:(id)delegate
{
    //    self = [self initWithRequest:request delegate:delegate];
    FRNetworkRecord *center = [FRNetworkRecord sharedFRNetworkRecord];
    
    NSURLConnection *conn  = [[NSURLConnection alloc] initWithRequest:request delegate:center startImmediately:NO];
    
    [center.connArray addObject:conn];
    
    if (delegate==nil) {
        [center.delegateArray addObject:[NSNull null]];
    }else
    {
        [center.delegateArray addObject:delegate];
    }
    
    //    NSLog(@"a111111");
    return conn;
}

@end
@implementation FRNetworkRecord
static FRNetworkRecord* sharedInstance = nil;
+(FRNetworkRecord*)sharedFRNetworkRecord
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[FRNetworkRecord alloc] init];
        
//        SEL sel = _cmd;
//        NSLog(@"%@",NSStringFromSelector(sel));
    });
    return sharedInstance;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.connArray = [[NSMutableArray alloc] init];
        self.delegateArray = [[NSMutableArray alloc] init];
        
        
        Method m1 =    class_getInstanceMethod([NSURLConnection class], @selector(initWithRequest:delegate:));
        
        Method m2 = class_getInstanceMethod([Conn class], @selector(newInitWithRequest:delegate:));
        
        method_exchangeImplementations(m1, m2);
        
        
        
        
//        NSLog(@"%@",obj);

    }
    return self;
}

-(void)returnNo
{
//    return NO;
}

-(id)getDelegateFormConnection:(NSURLConnection*)connection
{
    NSInteger index = [self.connArray indexOfObject:connection];
    NSObject *obj = _delegateArray[index];
    return obj;
}
#pragma mark - NSURLConnectionDelegate
- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
{
    NSObject *obj = [self getDelegateFormConnection:connection];
    SEL sel = _cmd;
    if ([obj respondsToSelector:sel]) {
        SuppressPerformSelectorLeakWarning(
            [obj performSelector:sel withObject:connection withObject:error];
                                           );
        
    }
}
- (BOOL)connectionShouldUseCredentialStorage:(NSURLConnection *)connection
{
    
//    SEL sel = NSSelectorFromString(NSStringFromSelector(_cmd));
    
    SEL sel = _cmd;
    NSObject *obj = [self getDelegateFormConnection:connection];
    if ([obj respondsToSelector:sel]) {
        BOOL flag;
        SuppressPerformSelectorLeakWarning(flag = (BOOL)[obj performSelector:sel withObject:connection]);
        return flag;
    }
    return YES;
}
- (void)connection:(NSURLConnection *)connection willSendRequestForAuthenticationChallenge:(NSURLAuthenticationChallenge *)challenge
{
    NSObject *obj = [self getDelegateFormConnection:connection];
    SEL sel = _cmd;
    if ([obj respondsToSelector:sel]) {
        SuppressPerformSelectorLeakWarning(
                                           [obj performSelector:sel withObject:connection withObject:challenge];
                                           );
        
    }
}

// Deprecated authentication delegates.
- (BOOL)connection:(NSURLConnection *)connection canAuthenticateAgainstProtectionSpace:(NSURLProtectionSpace *)protectionSpace
{
    SEL sel = _cmd;
    NSObject *obj = [self getDelegateFormConnection:connection];
    if ([obj respondsToSelector:sel]) {
        BOOL flag;
        SuppressPerformSelectorLeakWarning(flag = (BOOL)[obj performSelector:sel withObject:connection]);
        return flag;
    }
    return YES;
}
- (void)connection:(NSURLConnection *)connection didReceiveAuthenticationChallenge:(NSURLAuthenticationChallenge *)challenge
{
    NSObject *obj = [self getDelegateFormConnection:connection];
    SEL sel = _cmd;
    if ([obj respondsToSelector:sel]) {
        SuppressPerformSelectorLeakWarning(
                                           [obj performSelector:sel withObject:connection withObject:challenge];
                                           );
        
    }
}
- (void)connection:(NSURLConnection *)connection didCancelAuthenticationChallenge:(NSURLAuthenticationChallenge *)challenge
{
    NSObject *obj = [self getDelegateFormConnection:connection];
    SEL sel = _cmd;
    if ([obj respondsToSelector:sel]) {
        SuppressPerformSelectorLeakWarning(
                                           [obj performSelector:sel withObject:connection withObject:challenge];
                                           );
        
    }
}

#pragma mark - NSURLConnectionDataDelegate
- (NSURLRequest *)connection:(NSURLConnection *)connection willSendRequest:(NSURLRequest *)request redirectResponse:(NSURLResponse *)response
{
    id<NSURLConnectionDataDelegate> obj = [self getDelegateFormConnection:connection];
    SEL sel = _cmd;
    NSURLRequest *req = nil;
    
    if ([obj respondsToSelector:sel]) {
        req =[obj connection:connection willSendRequest:request redirectResponse:response];
        return req;
    }
    return req;
}
- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response
{
    NSObject *obj = [self getDelegateFormConnection:connection];
    SEL sel = _cmd;
    if ([obj respondsToSelector:sel]) {
        SuppressPerformSelectorLeakWarning(
                                           [obj performSelector:sel withObject:connection withObject:response];
                                           );
        
    }
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
    NSObject *obj = [self getDelegateFormConnection:connection];
    SEL sel = _cmd;
    if ([obj respondsToSelector:sel]) {
        SuppressPerformSelectorLeakWarning(
                                           [obj performSelector:sel withObject:connection withObject:data];
                                           );
        
    }
}

- (NSInputStream *)connection:(NSURLConnection *)connection needNewBodyStream:(NSURLRequest *)request
{
    NSObject *obj = [self getDelegateFormConnection:connection];
    SEL sel = _cmd;
    NSInputStream *stream = nil;
    if ([obj respondsToSelector:sel]) {
        SuppressPerformSelectorLeakWarning(
                                         stream =  [obj performSelector:sel withObject:connection withObject:request];
                                           );
        
    }
    return stream;
}
- (void)connection:(NSURLConnection *)connection
   didSendBodyData:(NSInteger)bytesWritten
 totalBytesWritten:(NSInteger)totalBytesWritten
totalBytesExpectedToWrite:(NSInteger)totalBytesExpectedToWrite
{
    id<NSURLConnectionDataDelegate> obj = [self getDelegateFormConnection:connection];
    SEL sel = _cmd;
//    NSURLRequest *req = nil;
    
    if ([obj respondsToSelector:sel]) {
        [obj connection:connection
        didSendBodyData:bytesWritten
      totalBytesWritten:totalBytesWritten
totalBytesExpectedToWrite:totalBytesExpectedToWrite];
//        return req;
    }
//    return req;
}

- (NSCachedURLResponse *)connection:(NSURLConnection *)connection willCacheResponse:(NSCachedURLResponse *)cachedResponse
{
    NSObject *obj = [self getDelegateFormConnection:connection];
    SEL sel = _cmd;
    NSCachedURLResponse *stream = nil;
    if ([obj respondsToSelector:sel]) {
        SuppressPerformSelectorLeakWarning(
                                           stream =  [obj performSelector:sel withObject:connection withObject:cachedResponse];
                                           );
        
    }
    return stream;
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    NSObject *obj = [self getDelegateFormConnection:connection];
    SEL sel = _cmd;
    if ([obj respondsToSelector:sel]) {
        SuppressPerformSelectorLeakWarning(
                                           [obj performSelector:sel withObject:connection];
                                           );
        
    }
}
@end
