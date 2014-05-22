//
//  FRAgentUtils.m
//  FreshRelic
//
//  Created by Li Jinfeng on 14-5-22.
//  Copyright (c) 2014年 Lijinfeng. All rights reserved.
//

#import "FRAgentUtils.h"

@implementation FRAgentUtils

+ (NSString *) applicationCachesDirectory: (NSString *) filename {
	
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSCachesDirectory,
														 NSUserDomainMask,
														 YES);
    
	
    NSString *basePath = ([paths count] > 0) ? [paths objectAtIndex:0] : nil;
	return [basePath stringByAppendingPathComponent: filename];
}

+(BOOL)fileIsExists:(NSString *)filename {
	
	if ([[NSFileManager defaultManager] fileExistsAtPath: filename]) {
        return YES;
	}else{
		return NO;
	}
}

+(void)writeAgentDataInfoDic:(NSMutableDictionary *)dict{
    NSString *fileName = @"FRAgentCoverInfo.json";
    NSString *filePath = [self applicationCachesDirectory:fileName];
    [dict writeToFile:filePath atomically:YES];
}

+(NSMutableDictionary*)readAgentDataInfoDic{
    NSString *fileName = @"FRAgentCoverInfo.json";
    NSString *filePath = [self applicationCachesDirectory:fileName];
    if([self fileIsExists:filePath]){
        NSMutableDictionary *result = [[NSMutableDictionary alloc] initWithContentsOfFile:filePath];
        return result;
    }else{
        return  NULL;
    }
}

@end
