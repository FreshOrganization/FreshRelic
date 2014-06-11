//
//  MyKeyChainHelper.h
//  KeyChainDemo
//
//  Created by Li on 12-7-8.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FRMyKeyChainHelper : NSObject

+ (void) saveUserName:(NSString*)userName 
      userNameService:(NSString*)userNameService 
             psaaword:(NSString*)pwd 
      psaawordService:(NSString*)pwdService;

+ (void) deleteWithUserNameService:(NSString*)userNameService 
                   psaawordService:(NSString*)pwdService;

+ (NSString*) getUserNameWithService:(NSString*)userNameService;

+ (NSString*) getPasswordWithService:(NSString*)pwdService;

+ (void) saveUid:(NSString*)uid
      uidService:(NSString*)useridService
           uname:(NSString*)uname
    unameService:(NSString*)unameService
            toke:(NSString *)token
    tokenService:(NSString *)tokenService;

+ (void) saveUserEmail:(NSString*)userEmail
         userEmailService:(NSString*)emailService;

+ (void) deleteWithUidService:(NSString *)uidService
                 unameService:(NSString *)unameService
                 tokenService:(NSString *)tokenService;

+ (void) deleteWithEmailService:(NSString *)emailService;

+ (void) saveToken:(NSString*)token tokenService:(NSString*)tokenService;

+ (NSString*) getUidWithService:(NSString*)uidService;
+ (NSString*) getUnameWithService:(NSString*)unameService;
+ (NSString*) getTokenWithService:(NSString*)tokenService;
+ (NSString*) getEmailWithService:(NSString*)emailService;

@end
