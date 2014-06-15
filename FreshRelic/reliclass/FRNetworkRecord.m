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

@implementation FRNetworkRecord
static FRNetworkRecord* sharedInstance = nil;


+(void)addConn:(NSURLConnection*)conn andDelegate:(id<NSURLConnectionDelegate>)delegate
{
    if (conn) {
        NSNull *null = [NSNull null];
        FRNetworkRecord *record = [FRNetworkRecord sharedFRNetworkRecord];
        
        [record.connArray addObject:conn];
        if (delegate) {
            [record.delegateArray addObject:delegate];
        }else
        {
            [record.delegateArray addObject:null];
        }
    }
}
+(FRNetworkRecord*)sharedFRNetworkRecord
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[FRNetworkRecord alloc] init];
        

    });
    return sharedInstance;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.connArray = [[NSMutableArray alloc] init];
        self.delegateArray = [[NSMutableArray alloc] init];
        self.startTimeArray = [[NSMutableArray alloc] init];
        self.responseTimeArray = [[NSMutableArray alloc] init];
        self.endTimeArray = [[NSMutableArray alloc] init];
        self.dataArray = [[NSMutableArray alloc] init];
        self.responseArray = [[NSMutableArray alloc] init];
        self.threadCallStacks = [[NSMutableArray alloc] init];
        
        
        /*
        Method m1 = class_getInstanceMethod([NSURLConnection class], @selector(initWithRequest:delegate:));
        
        Method m2 = class_getInstanceMethod([Conn class], @selector(newInitWithRequest:delegate:));
        
        method_exchangeImplementations(m1, m2);
        
        
        m1 = class_getClassMethod([NSURLConnection class], @selector(sendSynchronousRequest:queue:completionHandler:));
        
        m2 = class_getClassMethod([Conn class], @selector(newSendSynchronousRequest:queue:completionHandler:));
        
        method_exchangeImplementations(m1, m2);
        */
        
        NSURLConnection *conn = [[NSURLConnection alloc] initWithRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:@"http://www.baidu.com"]] delegate:nil];
        [conn start];
//        [NSURLRequest requestWithURL:[NSURL URLWithString:@"http://www.baidu.com"]]
        
//        NSData *data = [NSURLConnection sendSynchronousRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:@"http://www.baidu.com"]] returningResponse:nil error:nil];
//        NSLog(@"%@",data);
        

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
    if (index == NSNotFound) {
        return nil;
    }
    NSObject *obj = _delegateArray[index];
    if ([obj isEqual:[NSNull null]]) {
        return nil;
    }
    return obj;
}




#pragma mark - NSURLConnectionDelegate

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
{
    [_threadCallStacks addObject:[NSThread callStackSymbols]];
    NSInteger errorCode = error.code;
    switch (errorCode) {
        case NSURLErrorTimedOut:
        {
//        超时
        }
            break;
            case NSURLErrorNetworkConnectionLost:
        {
//            链接超时
        }
            
        default:
            break;
    }
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


-(NSTimeInterval)currentTimeInterval
{
    NSDate *date = [NSDate date];
    NSTimeInterval interval = [date timeIntervalSince1970];
    return interval;
}
#pragma mark - NSURLConnectionDataDelegate

- (NSURLRequest *)connection:(NSURLConnection *)connection willSendRequest:(NSURLRequest *)request redirectResponse:(NSURLResponse *)response
{
    [_startTimeArray addObject:[NSDate date]];
    
    id<NSURLConnectionDataDelegate> obj = [self getDelegateFormConnection:connection];
    SEL sel = _cmd;
    NSURLRequest *req = request;
    
    if ([obj respondsToSelector:sel]) {
        req =[obj connection:connection willSendRequest:request redirectResponse:response];
        return req;
    }
    return req;
}


- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response
{
    [_responseTimeArray addObject:[NSDate date]];
    [_dataArray addObject:[NSMutableData data]];
//    NSInteger statusCode = [(NSHTTPURLResponse*)response statusCode];
//    NSLog(@"%@",[NSHTTPURLResponse localizedStringForStatusCode:statusCode]);
    [_responseTimeArray addObject:response];
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
    NSInteger index = [_connArray indexOfObject:connection];
    NSMutableData *totalData = _dataArray[index];
    [totalData appendData:data];
    
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
    [_endTimeArray addObject:[NSDate date]];
    NSObject *obj = [self getDelegateFormConnection:connection];
    SEL sel = _cmd;
    if ([obj respondsToSelector:sel]) {
        SuppressPerformSelectorLeakWarning(
                                           [obj performSelector:sel withObject:connection];
                                           );
        
    }
}


#pragma mark - NSURLConnectionDownloadDelegate
/*
- (void)connection:(NSURLConnection *)connection didWriteData:(long long)bytesWritten totalBytesWritten:(long long)totalBytesWritten expectedTotalBytes:(long long) expectedTotalBytes
{
    id<NSURLConnectionDownloadDelegate> obj = [self getDelegateFormConnection:connection];
    SEL sel = _cmd;
    //    NSURLRequest *req = nil;
    
    if ([obj respondsToSelector:sel]) {
        [obj connection:connection didWriteData:bytesWritten totalBytesWritten:totalBytesWritten expectedTotalBytes:expectedTotalBytes];
    }
}
- (void)connectionDidResumeDownloading:(NSURLConnection *)connection totalBytesWritten:(long long)totalBytesWritten expectedTotalBytes:(long long) expectedTotalBytes
{
    id<NSURLConnectionDownloadDelegate> obj = [self getDelegateFormConnection:connection];
    SEL sel = _cmd;
    //    NSURLRequest *req = nil;
    
    if ([obj respondsToSelector:sel]) {
        [obj connectionDidResumeDownloading:connection totalBytesWritten:totalBytesWritten expectedTotalBytes:expectedTotalBytes];
    }
}


- (void)connectionDidFinishDownloading:(NSURLConnection *)connection destinationURL:(NSURL *) destinationURL
{
    id<NSURLConnectionDownloadDelegate> obj = [self getDelegateFormConnection:connection];
    SEL sel = _cmd;
    //    NSURLRequest *req = nil;
    
    if ([obj respondsToSelector:sel]) {
        [obj connectionDidFinishDownloading:connection destinationURL:destinationURL];
    }
}
 */


@end
