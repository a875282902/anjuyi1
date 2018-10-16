//
//  TestinDataBugoutDelegate.h
//  
//
//  Copyright (c) 2018年 wubo. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol TestinDataBugoutDelegate <NSObject>

@optional

- (void)receivedCrashNotification:(NSString*)stackTrace;
//- (void)userClosedShakeReport;

@end
