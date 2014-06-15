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
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        [self jr_swizzleClassMethod:@selector(dataWithContentsOfURL:) withClassMethod:@selector(dataWithContentsOfURL:) error:nil];
        
        
        [self jr_swizzleClassMethod:@selector(dataWithContentsOfURL:options:error:) withClassMethod:@selector(xxx_dataWithContentsOfURL:options:error:) error:nil];
    });
}


+ (id)xxx_dataWithContentsOfURL:(NSURL *)aURL
{
    NSData *data = [self xxx_dataWithContentsOfURL:aURL];
    return data;
}

+ (id)xxx_dataWithContentsOfURL:(NSURL *)aURL options:(NSDataReadingOptions)mask error:(NSError **)errorPtr
{
    NSData *data = [self xxx_dataWithContentsOfURL:aURL options:mask error:errorPtr];
    return data;
}
@end
