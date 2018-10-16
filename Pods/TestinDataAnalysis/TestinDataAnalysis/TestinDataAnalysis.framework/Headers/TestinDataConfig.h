//
//  TestinDataConfig.h
//  TestinDataAnalysis
//
//  Created by wubo on 2018/8/1.
//  Copyright © 2018年 testin. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TestinDataBugoutDelegate.h"
@interface TestinDataConfig : NSObject
/**
 ABTestappkey
 */
@property(nonatomic,copy)NSString* abAppKey;
/**
 下拉配置url
 */
@property(nonatomic,copy)NSString* configUrl;
/**
 上报数据url
 */
@property(nonatomic,copy)NSString* uploadUrl;

/**
 自定义DataSocketUrl
 */
@property(nonatomic,copy)NSString* dataSocketUrl;

/**
 自定义ABSocketUrl
 */
@property(nonatomic,copy)NSString* abSocketUrl;
//========以下bug收集相关========
/**
 *
 * 数据通知的代理
 */
@property(nonatomic, strong) id delegate;
/**
 *Exception monitor enabled, default YES.
 *启用异常监视器,默认：YES
 */
@property(nonatomic, assign) BOOL enabledMonitorException;

/**
 *Enabled feedback, default YES.
 *启用摇一摇反馈，默认:YES
 */
@property(nonatomic, assign) BOOL enabledShakeFeedback;
/**
 *
 *Response speed settings, the greater the value of the slower response speed, the smaller the faster the response, the value is too large may lose response, the default 3.0
 *响应速度设置值越大，响应速度越慢，响应越快，值越大，则可能丢失响应，默认为3.0。
 *
 *
 */
@property(nonatomic, assign) NSTimeInterval shakeSenseSpeed;
/**
 * only wifi report data, default NO.
 * 只有WiFi报告数据，默认:NO
 */
@property(nonatomic, assign) BOOL reportOnlyWIFI;

/**
 * use user location info, default NO.
 * 是否开启用户定位信息。默认：NO
 */
@property(nonatomic, assign) BOOL useLocationInfo;

/**
 * Whether or not to open the user's operation steps,default YES.
 * 是否开启用户操作步骤。默认：YES
 */
@property(nonatomic, assign) BOOL enableUserSteps;
/**
 *Open the system log. default NO
 *开启系统日志。默认：NO
 */
@property(nonatomic, assign) BOOL enableSysLog;

/**
 屏幕快照模式  0 为App模式 1为游戏类模式  默认为游戏类模式
 */
@property(nonatomic,assign)int snapshotMode;

+(TestinDataConfig*)shareConfig;
@end
