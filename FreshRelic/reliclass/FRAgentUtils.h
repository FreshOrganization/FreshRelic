//
//  FRAgentUtils.h
//  FreshRelic
//
//  Created by Li Jinfeng on 14-5-22.
//  Copyright (c) 2014年 Lijinfeng. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FRAgentUtils : NSObject

/** 获得缓存目录*/
+ (NSString *) applicationCachesDirectory: (NSString *) filename;

/** 判断某个文件是否存在*/
+(BOOL)fileIsExists:(NSString *)filename;

/** 将文件写到沙盒中*/
+(void)writeAgentDataInfoDic:(NSMutableDictionary*)dic;

/** 读取沙盒中的文件*/
+(NSMutableDictionary*)readAgentDataInfoDic;

@end
