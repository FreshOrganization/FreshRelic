//
//  FRNetworkRecord.h
//  FreshRelic
//
//  Created by tag_mac_05 on 5/28/14.
//  Copyright (c) 2014 Lijinfeng. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <objc/runtime.h>
//网络记录
@interface FRNetworkRecord : NSObject <NSURLConnectionDelegate,NSURLConnectionDataDelegate>

+(FRNetworkRecord*)sharedFRNetworkRecord;
@property (nonatomic,retain) NSMutableArray *connArray;
@property (nonatomic,retain) NSMutableArray *delegateArray;
@end
