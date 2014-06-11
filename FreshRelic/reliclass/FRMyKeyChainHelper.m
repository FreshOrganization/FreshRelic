//
//  MyKeyChainHelper.m
//  KeyChainDemo
//
//  Created by Li on 12-7-8.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "FRMyKeyChainHelper.h"

@implementation FRMyKeyChainHelper

+ (NSMutableDictionary *)getKeyChainQuery:(NSString *)service {  
    return [NSMutableDictionary dictionaryWithObjectsAndKeys:  
            (id)kSecClassGenericPassword,(id)kSecClass,  
            service, (id)kSecAttrService,  
            service, (id)kSecAttrAccount,  
            (id)kSecAttrAccessibleAfterFirstUnlock,(id)kSecAttrAccessible,  
            nil];  
}  

+ (void) saveUserName:(NSString*)userName 
      userNameService:(NSString*)userNameService 
             psaaword:(NSString*)pwd 
      psaawordService:(NSString*)pwdService
{
    NSMutableDictionary *keychainQuery = [self getKeyChainQuery:userNameService];  
    SecItemDelete((CFDictionaryRef)keychainQuery);  
    [keychainQuery setObject:[NSKeyedArchiver archivedDataWithRootObject:userName] forKey:(id)kSecValueData];  
    SecItemAdd((CFDictionaryRef)keychainQuery, NULL); 
    
    keychainQuery = [self getKeyChainQuery:pwdService];  
    SecItemDelete((CFDictionaryRef)keychainQuery);  
    [keychainQuery setObject:[NSKeyedArchiver archivedDataWithRootObject:pwd] forKey:(id)kSecValueData];  
    SecItemAdd((CFDictionaryRef)keychainQuery, NULL); 
}

+ (void) saveUserEmail:(NSString*)userEmail
      userEmailService:(NSString*)emailService
{
    NSMutableDictionary *keychainQuery = [self getKeyChainQuery:emailService];
    SecItemDelete((CFDictionaryRef)keychainQuery);
    [keychainQuery setObject:[NSKeyedArchiver archivedDataWithRootObject:userEmail] forKey:(id)kSecValueData];
    SecItemAdd((CFDictionaryRef)keychainQuery, NULL);
}

+ (void) saveToken:(NSString*)token tokenService:(NSString*)tokenService;
{
    NSMutableDictionary *keychainQuery = [self getKeyChainQuery:tokenService];
    SecItemDelete((CFDictionaryRef)keychainQuery);
    [keychainQuery setObject:[NSKeyedArchiver archivedDataWithRootObject:token] forKey:(id)kSecValueData];
    SecItemAdd((CFDictionaryRef)keychainQuery, NULL);
}

+ (void) saveUid:(NSString*)uid
      uidService:(NSString*)useridService
           uname:(NSString*)uname
    unameService:(NSString*)unameService
            toke:(NSString *)token
    tokenService:(NSString *)tokenService
{
    NSMutableDictionary *keychainQuery = [self getKeyChainQuery:useridService];
    SecItemDelete((CFDictionaryRef)keychainQuery);
    [keychainQuery setObject:[NSKeyedArchiver archivedDataWithRootObject:uid] forKey:(id)kSecValueData];
    SecItemAdd((CFDictionaryRef)keychainQuery, NULL);
    
    keychainQuery = [self getKeyChainQuery:unameService];
    SecItemDelete((CFDictionaryRef)keychainQuery);
    [keychainQuery setObject:[NSKeyedArchiver archivedDataWithRootObject:uname] forKey:(id)kSecValueData];
    SecItemAdd((CFDictionaryRef)keychainQuery, NULL);
    
    keychainQuery = [self getKeyChainQuery:tokenService];
    SecItemDelete((CFDictionaryRef)keychainQuery);
    [keychainQuery setObject:[NSKeyedArchiver archivedDataWithRootObject:token] forKey:(id)kSecValueData];
    SecItemAdd((CFDictionaryRef)keychainQuery, NULL);
}

+ (void) deleteWithUserNameService:(NSString*)userNameService 
                   psaawordService:(NSString*)pwdService
{
    NSMutableDictionary *keychainQuery = [self getKeyChainQuery:userNameService];  
    SecItemDelete((CFDictionaryRef)keychainQuery); 
    
    keychainQuery = [self getKeyChainQuery:pwdService];  
    SecItemDelete((CFDictionaryRef)keychainQuery); 
}

+ (void) deleteWithUidService:(NSString *)uidService
                 unameService:(NSString *)unameService
                 tokenService:(NSString *)tokenService
{
    NSMutableDictionary *keychainQuery = [self getKeyChainQuery:uidService];
    SecItemDelete((CFDictionaryRef)keychainQuery);
    
    keychainQuery = [self getKeyChainQuery:unameService];
    SecItemDelete((CFDictionaryRef)keychainQuery);
    
    keychainQuery = [self getKeyChainQuery:tokenService];
    SecItemDelete((CFDictionaryRef)keychainQuery);
}

+ (void) deleteWithEmailService:(NSString *)emailService
{
    NSMutableDictionary *keychainQuery = [self getKeyChainQuery:emailService];
    SecItemDelete((CFDictionaryRef)keychainQuery);
}

+ (NSString*) getUserNameWithService:(NSString*)userNameService
{
    NSString* ret = nil;  
    NSMutableDictionary *keychainQuery = [self getKeyChainQuery:userNameService];  
    [keychainQuery setObject:(id)kCFBooleanTrue forKey:(id)kSecReturnData];  
    [keychainQuery setObject:(id)kSecMatchLimitOne forKey:(id)kSecMatchLimit];  
    CFDataRef keyData = NULL;  
    if (SecItemCopyMatching((CFDictionaryRef)keychainQuery, (CFTypeRef *)&keyData) == noErr) 
    {  
        @try 
        {  
            ret = [NSKeyedUnarchiver unarchiveObjectWithData:(NSData *)keyData];  
        } 
        @catch (NSException *e) 
        {  
            NSLog(@"Unarchive of %@ failed: %@", userNameService, e);  
        }
        @finally 
        {  
        }  
    }  
    if (keyData)   
        CFRelease(keyData);  
    return ret; 
}

+ (NSString*) getPasswordWithService:(NSString*)pwdService
{
    NSString* ret = nil;  
    NSMutableDictionary *keychainQuery = [self getKeyChainQuery:pwdService];  
    [keychainQuery setObject:(id)kCFBooleanTrue forKey:(id)kSecReturnData];  
    [keychainQuery setObject:(id)kSecMatchLimitOne forKey:(id)kSecMatchLimit];  
    CFDataRef keyData = NULL;  
    if (SecItemCopyMatching((CFDictionaryRef)keychainQuery, (CFTypeRef *)&keyData) == noErr) 
    {  
        @try 
        {  
            ret = [NSKeyedUnarchiver unarchiveObjectWithData:(NSData *)keyData];  
        } 
        @catch (NSException *e) 
        {  
            NSLog(@"Unarchive of %@ failed: %@", pwdService, e);  
        }
        @finally 
        {  
        }  
    }  
    if (keyData)   
        CFRelease(keyData);  
    return ret;
}

+ (NSString*) getUidWithService:(NSString*)uidService
{
    NSString* ret = nil;
    NSMutableDictionary *keychainQuery = [self getKeyChainQuery:uidService];
    [keychainQuery setObject:(id)kCFBooleanTrue forKey:(id)kSecReturnData];
    [keychainQuery setObject:(id)kSecMatchLimitOne forKey:(id)kSecMatchLimit];
    CFDataRef keyData = NULL;
    if (SecItemCopyMatching((CFDictionaryRef)keychainQuery, (CFTypeRef *)&keyData) == noErr)
    {
        @try
        {
            ret = [NSKeyedUnarchiver unarchiveObjectWithData:(NSData *)keyData];
        }
        @catch (NSException *e)
        {
            NSLog(@"Unarchive of %@ failed: %@", uidService, e);
        }
        @finally
        {
        }
    }
    if (keyData)
        CFRelease(keyData);
    return ret;
}

+ (NSString*) getUnameWithService:(NSString*)unameService
{
    NSString* ret = nil;
    NSMutableDictionary *keychainQuery = [self getKeyChainQuery:unameService];
    [keychainQuery setObject:(id)kCFBooleanTrue forKey:(id)kSecReturnData];
    [keychainQuery setObject:(id)kSecMatchLimitOne forKey:(id)kSecMatchLimit];
    CFDataRef keyData = NULL;
    if (SecItemCopyMatching((CFDictionaryRef)keychainQuery, (CFTypeRef *)&keyData) == noErr)
    {
        @try
        {
            ret = [NSKeyedUnarchiver unarchiveObjectWithData:(NSData *)keyData];
        }
        @catch (NSException *e)
        {
            NSLog(@"Unarchive of %@ failed: %@", unameService, e);
        }
        @finally
        {
        }
    }
    if (keyData)
        CFRelease(keyData);
    return ret;
}

+ (NSString*) getTokenWithService:(NSString*)tokenService
{
    NSString* ret = nil;
    NSMutableDictionary *keychainQuery = [self getKeyChainQuery:tokenService];
    [keychainQuery setObject:(id)kCFBooleanTrue forKey:(id)kSecReturnData];
    [keychainQuery setObject:(id)kSecMatchLimitOne forKey:(id)kSecMatchLimit];
    CFDataRef keyData = NULL;
    if (SecItemCopyMatching((CFDictionaryRef)keychainQuery, (CFTypeRef *)&keyData) == noErr)
    {
        @try
        {
            ret = [NSKeyedUnarchiver unarchiveObjectWithData:(NSData *)keyData];
        }
        @catch (NSException *e)
        {
            NSLog(@"Unarchive of %@ failed: %@", tokenService, e);
        }
        @finally
        {
        }
    }
    if (keyData)
        CFRelease(keyData);
    return ret;
}

+ (NSString*) getEmailWithService:(NSString*)emailService
{
    NSString* ret = nil;
    NSMutableDictionary *keychainQuery = [self getKeyChainQuery:emailService];
    [keychainQuery setObject:(id)kCFBooleanTrue forKey:(id)kSecReturnData];
    [keychainQuery setObject:(id)kSecMatchLimitOne forKey:(id)kSecMatchLimit];
    CFDataRef keyData = NULL;
    if (SecItemCopyMatching((CFDictionaryRef)keychainQuery, (CFTypeRef *)&keyData) == noErr)
    {
        @try
        {
            ret = [NSKeyedUnarchiver unarchiveObjectWithData:(NSData *)keyData];
        }
        @catch (NSException *e)
        {
            NSLog(@"Unarchive of %@ failed: %@", emailService, e);
        }
        @finally
        {
        }
    }
    if (keyData)
        CFRelease(keyData);
    return ret;
}

@end
