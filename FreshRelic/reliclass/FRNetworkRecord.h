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
//链接数组
@property (nonatomic,retain) NSMutableArray *connArray;

//delegate数组
@property (nonatomic,retain) NSMutableArray *delegateArray;

//开始时间 Date
@property (nonatomic,retain) NSMutableArray *startTimeArray;

//响应时间  Date
@property (nonatomic,retain) NSMutableArray *responseTimeArray;

//结束时间  Date
@property (nonatomic,retain) NSMutableArray *endTimeArray;

//响应的数据  Data
@property (nonatomic,retain) NSMutableArray *dataArray;

//响应的数组  NSURLResponse 类型
@property (nonatomic,retain) NSMutableArray *responseArray;

//故障的时候线程的堆栈
@property (nonatomic,retain) NSMutableArray *threadCallStacks;

//采集http数据
@property(nonatomic,retain)NSMutableDictionary *httpReportDataDic;

@end
/*
 1.url  直接通过connection获得request，再获得url    搞定
 2.相应时间   记录开始时间和响应时间就可以了           搞定
 3.状态吗                  搞定
 4.网络故障码                搞定
 5.请求发送字节数      NSURLRequest 的 allHTTPHeaderFields      搞定
 6.响应接受字节数          搞定
 7.请求时间             搞定
 8.网络故障堆栈   【nsthread callstacks】  搞定
 9.会话时长        搞定
 10错误时返回的body内容 搞定
 
 
 */