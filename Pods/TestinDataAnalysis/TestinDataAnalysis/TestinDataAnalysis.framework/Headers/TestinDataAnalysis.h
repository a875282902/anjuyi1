//
//  TestinDataAnalysis.h
//  TestinDataAnalysis SDK version 5.0.3
//  BugOut version 1.0.2
//  build:A
//  Created by Testin on 16/7/29.
//  Copyright © 2016年 Testin. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "TestinDataConfig.h"
FOUNDATION_EXPORT double TestinDataAnalysisVersionNumber;

FOUNDATION_EXPORT const unsigned char TestinDataAnalysisVersionString[];

@interface TestinDataAnalysis : NSObject

/**
 初始化方法

 @param pid
 @param launchOptions
 */
+(void)initWithProjectId:(NSString * _Nullable)pid launchOptions:(NSDictionary * _Nonnull)launchOptions;

/**
 初始化方法

 @param pid
 @param config 可以设置用户自己的配置 不采用默认配置 传入此值
 @param launchOptions
 */
+ (void)initWithProjectId:(NSString * _Nullable)pid WithConfig:(TestinDataConfig*_Nullable)config launchOptions:(NSDictionary * _Nullable)launchOptions;

/**
 用户自定义操作信息（会存储于系统操作步骤中）

 @param stepMessage 用户自定义操作信息
 */
+ (void)setCustomUserSteps:(NSString *_Nonnull)stepMessage;

/**
 设置用户自定义属性 bug采集

 @param data
 @param key
 */
+ (void)setUserData:(NSString*_Nonnull)data forKey:(NSString*_Nonnull)key;

/**
 移除所有自定义属性 bug采集
 */
+ (void)removeAllUserData;

/**
 关闭/开启摇一摇

 @param enabled 默认YES
 */
+ (void)enabledShakeFeedback:(BOOL)enabled;

/**
 上报自定义异常信息

 @param exception 自定义异常
 */
+ (void)reportCustomizedException:(NSException*_Nonnull)exception;

/**
 上报自定义异常

 @param type 1 @"cpp" 3 @"lua" 4 @"js" 5 @"c#"
 @param msg 非oc调用
 @param stackTrace 自定义的异常信息
 */
+ (void)reportCustomizedException:(NSNumber*_Nonnull)type message:(NSString*_Nonnull)msg
                       stackTrace:(NSString*_Nonnull)stackTrace;


/**
 上报自定义异常2
 
 @param type 1 @"cpp" 3 @"lua" 4 @"js" 5 @"c#"
 @param msg 非oc调用
 @param stackTrace 自定义的异常信息
 @param isExit  是否系统退出 默认 NO 
 */
+ (void)reportCustomizedException:(NSNumber*_Nonnull)type message:(NSString*_Nonnull)msg
                       stackTrace:(NSString*_Nonnull)stackTrace exit:(BOOL)isExit;





/**
 上报埋点
 @param event 埋点名称
 */
+ (void)tracker:(NSString * _Nonnull)event;

/**
 上报埋点 携带属性

 @param event 埋点名称
 @param attributes 属性
 */
+ (void)tracker:(NSString * _Nonnull)event attributes:(NSDictionary * _Nullable)attributes;

/**
 上报埋点 携带属性和自定义数值

 @param event 埋点名称
 @param attributes 自定义属性
 @param value 自定义数值 默认为1
 */
+ (void)tracker:(NSString * _Nonnull)event attributes:(NSDictionary * _Nullable)attributes withValue:(NSNumber*_Nullable)value;

/**
 指定的UIViewController增加viewPage 事件
 
 @param viewController 指定的viewController
 @param attributes 自定义属性
 */
+ (void)trackViewPage:(UIViewController * _Nonnull)viewController attributes:(NSDictionary * _Nullable)attributes;

/**
 设置事件公共的属性
 
 @param profileDict 公共事件属性
 */
+ (void)setCommonProfile:(NSDictionary * _Nonnull)profileDict;

/**
 删除某一个公有事件属性
 
 @param profileName 事件属性名称
 */
+ (void)unsetCommonProfile:(NSString * _Nonnull)profileName;

/**
 清除所有公有事件属性
 */
+ (void)clearAllCommonProfile;

/**
 设置用户profile
 
 @param profileDict 用户属性
 */
+ (void)setProfile:(NSDictionary * _Nonnull)profileDict;

/**
 设置用户单个profile
 
 @param profileName 属性名称
 @param content 属性值
 */
+ (void)setProfileName:(NSString * _Nonnull)profileName content:(id _Nonnull)content;

/**
 清除用户属性
 
 @param profileName 属性名称
 */
+ (void)deleteProfile:(NSString * _Nonnull)profileName;

/**
 清除用户所有属性
 */
+ (void)deleteAllProfile;

/**
 设置是否开始自动埋点viewClick事件
 
 @param isAuto isAuto
 */
+ (void)supportAutoViewClickTrack:(BOOL)isAuto;

/**
 设置是否开始自动埋点viewPage事件
 
 @param isAuto isAuto
 */
+ (void)supportAutoViewPageTrack:(BOOL)isAuto;

/**
 * 针对UIControl控件以及子类
 设置是否对已经可视化埋点的位置支持主动埋点 默认是不支持,限制的
 
 @param isSupport
 */
+ (void)supportUIControlAutoTrackForAlreadyVTrack:(BOOL)isSupport;
/**
 忽略的自动埋点的类型
 
 @param viewType
 */
+ (void)ignoreAutoTrackViewType:(Class _Nonnull)viewType;

/**
 忽略的自动埋点的Controller
 
 @param controllers 举例:NSArray * array =@[@"XxxxController",@"YyyyController"];
 */
+ (void)ignoreAutoTrackUIViewControllers:(NSArray * _Nonnull)controllers;

/**
 设置是否支持触摸开始时候track 此方法主要针对UIControl 实现了UITouchDown 事件的情况
 
 @param isSupport YES 是支持 默认是不支持
 */
+ (void)supportTouchBeginState:(BOOL)isSupport;

/**
 是否支持获取IDFA
 
 @param isIDFA
 */
+ (void)enableIDFA:(BOOL)isIDFA;


/**
 * 获取SDK版本号
 *
 @return 返回SDK 版本号
 */
+ (NSString * _Nonnull)libVersion;

/**
 * 获取BugOut版本号
 *
 @return 返回BugOut版本号
 */
+(NSString* _Nonnull)libBugOutVersion;

/**
 用于区别多个系统弹框(UIAlertController、UIActionSheet、UIAlertView)
 使用方法：在系统弹框初始化完成后，请调用此方法

 @param alertTag 为当前弹框的初始tag(每个弹框的差值尽量大些)
 */
+(void)beginExecuteAlertInnerTag:(NSInteger)alertTag;


/**
 用于给弹框里每个按钮赋值（tag值）
 UIAlertController使用方法：[self presentViewController:alertController animated:YES completion:^{
 [TestinDataAnalysis endExecuteAlertViewInnerTag];
 }];
 UIActionSheet和UIAlertView的使用方法：
 请在对应的代理方法-(void)didPresentActionSheet:(UIActionSheet *)actionSheet和-(void)didPresentAlertView:(UIAlertView *)alertView中调用此方法。
 */
+(void)endExecuteAlertViewInnerTag;

/**
 获取包的UUID

 @return 返回包的UUID
 */
+(NSString*_Nonnull)executableUUID;



/**
 设置主窗口的属性名称 不设置 默认值 读取window属性
 需要在窗口初始化完毕后调用  示例:[TestinDataAnalysis setMainWindowSelector:@selector(xxxx)];
 @param seletor 设置主窗口的属性方法
 */
+(void)setMainWindowSelector:(SEL _Nonnull )seletor;

@end

@interface UIView (TestinView)
/**
 * track 是在hook的方法之前调用,还是之后调用 默认为hook方法之前
 */
@property (nonatomic, assign) BOOL testinDataAllowTrackBehindHookMethod;

/**
 是否禁止埋点
 */
@property (nonatomic, assign) BOOL testinDataForbidTrack;

/**
 view 的额外信息 类型为字典 利用分析
 */
@property (nonatomic, assign) NSDictionary * _Nullable testinDataViewExtInfo;

/**
 * 针对SDCycleScrollView轮播图框架，所设置的唯一标识。
 * 如SDCycleScrollView是pod导入的，我们的SDK是手动导入的，则建议使用tag。
 * 使用方法：cell.tag = itemIndex + 1;
 * 如SDCycleScrollView和我们的SDK导入方式一致，则可以使用此唯一标识。
 * 使用方法：cell.testinDataViewIdentifier = [NSString stringWithFormat:@"%ld",itemIndex];
 */
@property(nonatomic,copy)NSString* _Nullable testinDataViewIdentifier;
/**
 *  UITableViewCell和UICollectionCell 是否复用
 *
 *  @param forbitReUseTag  YES(开启不复用) NO(原程序运行)
 *  如果cell的个数较多，且没有关闭复用的，建议使用不复用
 *  使用方法：tableView.forbitReUseTag = YES/NO;
 *          collectionView.forbitReUseTag = YES/NO;
 *  (tableView和collectionView为对象名称)
 *  如您没有设置则默认为NO，可能会导致修改cell的时候出现重复修改的现象。
 *  默认为NO
 */
@property(nonatomic,assign)BOOL forbitReUseTag;//是否禁止对象重用(针对UITableViewCell和UICollectionViewCell 复用机制)

@end


