//
//  UncaughtExceptionHandler.h
//  FreshRelic
//
//  Created by Jinfeng.Li on 14-6-10.
//  Copyright (c) 2014年 Lijinfeng. All rights reserved.
//

@interface UncaughtExceptionHandler : NSObject{
    BOOL dismissed;
}

@end
void HandleException(NSException *exception);
void SignalHandler(int signal);


void InstallUncaughtExceptionHandler(void);
