//
//  FRNetworkRecord.m
//  FreshRelic
//
//  Created by tag_mac_05 on 5/28/14.
//  Copyright (c) 2014 Lijinfeng. All rights reserved.
//

#import "FRNetworkRecord.h"
@interface Conn:NSURLConnection
- (id)newInitWithRequest:(NSURLRequest *)request delegate:(id)delegate;
@end
@implementation Conn




- (id)newInitWithRequest:(NSURLRequest *)request delegate:(id)delegate
{
    //    self = [self initWithRequest:request delegate:delegate];
    FRNetworkRecord *center = [FRNetworkRecord sharedFRNetworkRecord];
    
    NSURLConnection *conn  = [[NSURLConnection alloc] initWithRequest:request delegate:center startImmediately:NO];
    
    [center.connArray addObject:conn];
    
    [center.delegateArray addObject:delegate];
    
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
        
        

    }
    return self;
}
@end
