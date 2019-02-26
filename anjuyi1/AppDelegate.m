//
//  AppDelegate.m
//  anjuyi1
//
//  Created by 李 on 2018/5/29.
//  Copyright © 2018年 lsy. All rights reserved.
//

#import "AppDelegate.h"
#import "RootViewController.h"
#import "HttpRequest.h"
#import "RegisterViewController.h"
#import "BaseNaviViewController.h"

#import <BaiduMapAPI_Base/BMKMapManager.h>

// 引入JPush功能所需头文件
#import "JPUSHService.h"
// iOS10注册APNs所需头文件
#ifdef NSFoundationVersionNumber_iOS_9_x_Max
#import <UserNotifications/UserNotifications.h>
#endif

#import <UMCommon/UMConfigure.h>

#import <TestinDataAnalysis/TestinDataAnalysis.h>

#import <UMShare/UMShare.h>

#import <MeiQiaSDK/MeiQiaSDK.h>

#import "LaunchADView.h"

#import "ShowWebViewController.h"

#define QQscheme @"tencent1104651968"

#import <AlipaySDK/AlipaySDK.h>

@interface AppDelegate ()<JPUSHRegisterDelegate>

@end

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    
    //百度
    BMKMapManager *man = [[BMKMapManager alloc]init];
    BOOL ret = [man start:MAPKEY generalDelegate:nil];
    if (!ret) {
        NSLog(@"manager start failed!");
    }
    else{
        NSLog(@"success");
    }
    //极光推送
    [self registJGPush:launchOptions];
    //u友盟分享
    [self umShare];
    //u友盟y统计
    [self umCommnont];
    //debug
    [self testinDataConfig:launchOptions];
    //美洽聊天
    [MQManager initWithAppkey:MQKEY completion:^(NSString *clientId, NSError *error) {
        if (!error) {
            NSLog(@"美洽 SDK：初始化成功");
        } else {
            NSLog(@"error:%@",error);
        }
    }];
    
    [[UIApplication sharedApplication] setApplicationIconBadgeNumber:0];
    
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];

    [self.window setBackgroundColor:[UIColor whiteColor]];
    
    [self.window setRootViewController:[[RootViewController alloc] init]];

    [self.window makeKeyAndVisible];
    [self loadLaunchADView];
    [HttpRequest checkReachabilityStatus:^(NSString *status) {
       
        NSLog(@"%@",status);
    }];
    
    return YES;
}

// 广告页
- (void) loadLaunchADView{
    LaunchADView *adView = [LaunchADView createADViewWithADImageName:@""];
    NSString *path = [NSString stringWithFormat:@"%@/currency/get_app_adv",KURL];
    
    [HttpRequest POST:path parameters:nil success:^(id  _Nullable responseObject) {
        
        [adView.adImageView sd_setImageWithURL:[NSURL URLWithString:responseObject[@"datas"][@"picture"]] placeholderImage:[UIImage imageNamed:@""]];

        [adView setTapAdViewBlock:^{
            ShowWebViewController * c = [[ShowWebViewController alloc] init];
            c.url = responseObject[@"datas"][@"url"];
            BaseNaviViewController *vc = [[BaseNaviViewController alloc] initWithRootViewController:c];
            [self.window.rootViewController presentViewController:vc animated:YES completion:nil];
        }];
        
    } failure:^(NSError * _Nullable error) {\
        [RequestSever showMsgWithError:error];
    }];

}

//注册JGPush
- (void)registJGPush:(NSDictionary *)launchOptions{
    
    JPUSHRegisterEntity * entity = [[JPUSHRegisterEntity alloc] init];
    entity.types = JPAuthorizationOptionAlert|JPAuthorizationOptionBadge|JPAuthorizationOptionSound;
    if ([[UIDevice currentDevice].systemVersion floatValue] >= 8.0) {
        // 可以添加自定义categories
        // NSSet<UNNotificationCategory *> *categories for iOS10 or later
        // NSSet<UIUserNotificationCategory *> *categories for iOS8 and iOS9
    }
    [JPUSHService registerForRemoteNotificationConfig:entity delegate:self];
    
    [JPUSHService setupWithOption:launchOptions appKey:JGAppKey
                          channel:@"App Store"
                 apsForProduction:NO];
}

- (void)application:(UIApplication *)application
didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken {
    
    /// Required - 注册 DeviceToken
    [JPUSHService registerDeviceToken:deviceToken];
    [JPUSHService setTags:[NSSet setWithObject:JPUSHService.registrationID] completion:^(NSInteger iResCode, NSSet *iTags, NSInteger seq) {
        
    } seq:100034];
    
    //美恰集成第四步: 上传设备deviceToken
    [MQManager registerDeviceToken:deviceToken];
}

#pragma mark- JPUSHRegisterDelegate

// iOS 10 Support
- (void)jpushNotificationCenter:(UNUserNotificationCenter *)center willPresentNotification:(UNNotification *)notification withCompletionHandler:(void (^)(NSInteger))completionHandler  API_AVAILABLE(ios(10.0)){
    // Required
    NSDictionary * userInfo = notification.request.content.userInfo;
    if([notification.request.trigger isKindOfClass:[UNPushNotificationTrigger class]]) {
        [JPUSHService handleRemoteNotification:userInfo];
    }
    completionHandler(UNNotificationPresentationOptionAlert); // 需要执行这个方法，选择是否提醒用户，有Badge、Sound、Alert三种类型可以选择设置
}

// iOS 10 Support
- (void)jpushNotificationCenter:(UNUserNotificationCenter *)center didReceiveNotificationResponse:(UNNotificationResponse *)response withCompletionHandler:(void (^)())completionHandler  API_AVAILABLE(ios(10.0)){
    // Required
    NSDictionary * userInfo = response.notification.request.content.userInfo;
    if([response.notification.request.trigger isKindOfClass:[UNPushNotificationTrigger class]]) {
        [JPUSHService handleRemoteNotification:userInfo];
    }
    completionHandler();  // 系统要求执行这个方法
}

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo fetchCompletionHandler:(void (^)(UIBackgroundFetchResult))completionHandler {
    
    // Required, iOS 7 Support
    [JPUSHService handleRemoteNotification:userInfo];
    completionHandler(UIBackgroundFetchResultNewData);
}

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo {
    
    // Required,For systems with less than or equal to iOS6
    [JPUSHService handleRemoteNotification:userInfo];
}


#pragma mark -- 友盟分享
- (void)umShare{
    
    [UMSocialGlobal shareInstance].isUsingHttpsWhenShareContent = NO;
    
    //微信聊天
    [[UMSocialManager defaultManager] setPlaform:UMSocialPlatformType_WechatSession appKey:WXID appSecret:WXSECRET redirectURL:@"http://mobile.umeng.com/social"];
    //微信朋友圈
     [[UMSocialManager defaultManager] setPlaform:UMSocialPlatformType_WechatTimeLine appKey:WXID appSecret:WXSECRET redirectURL:@"http://mobile.umeng.com/social"];
    //QQ
    [[UMSocialManager defaultManager] setPlaform:UMSocialPlatformType_QQ appKey:QQID  appSecret:nil redirectURL:@"http://mobile.umeng.com/social"];
    //新浪
//    [[UMSocialManager defaultManager] setPlaform:UMSocialPlatformType_Sina appKey:@"3921700954"  appSecret:@"04b48b094faeb16683c32669824ebdad" redirectURL:@"https://sns.whalecloud.com/sina2/callback"];
    
    /* 支付宝的appKey */
    [[UMSocialManager defaultManager] setPlaform: UMSocialPlatformType_AlipaySession appKey:ZFBKEY appSecret:nil redirectURL:@"http://mobile.umeng.com/social"];
}

- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation{
    
    BOOL result = [[UMSocialManager defaultManager] handleOpenURL:url sourceApplication:sourceApplication annotation:annotation];
    
    if (!result) {
        // 其他如支付等SDK的回调
        if ([url.host isEqualToString:@"safepay"]) {
            //跳转支付宝钱包进行支付，处理支付结果
            [[AlipaySDK defaultService] processOrderWithPaymentResult:url standbyCallback:^(NSDictionary *resultDic) {
                NSLog(@"result = %@",resultDic);
            }];
        }
    }
    
    return YES;
}

- (BOOL)application:(UIApplication *)app openURL:(NSURL *)url options:(NSDictionary<UIApplicationOpenURLOptionsKey,id> *)options{
    BOOL result = [[UMSocialManager defaultManager] handleOpenURL:url options:options];
    if (!result) {
        // 其他如支付等SDK的回调
        if ([url.host isEqualToString:@"safepay"]) {
            //跳转支付宝钱包进行支付，处理支付结果
            [[AlipaySDK defaultService] processOrderWithPaymentResult:url standbyCallback:^(NSDictionary *resultDic) {
                NSLog(@"result = %@",resultDic);
            }];
        }
    }
    
    return YES;
}

- (BOOL)application:(UIApplication *)application handleOpenURL:(NSURL *)url{
    BOOL result = [[UMSocialManager defaultManager] handleOpenURL:url];
    if (!result) {
        // 其他如支付等SDK的回调
    }
    
    return YES;
}
#pragma mark -- 友盟统计
- (void)umCommnont{
    
    [UMConfigure initWithAppkey:@"570f1af067e58eab75002315" channel:@"App Store"];
}

#pragma mark -- bug
- (void)testinDataConfig:(NSDictionary *)launchOptions{
    
    TestinDataConfig  *config = [TestinDataConfig shareConfig];
    config.enabledShakeFeedback = YES;
    config.enabledMonitorException = YES;
    
    [TestinDataAnalysis initWithProjectId:BUGKEY WithConfig:config launchOptions:launchOptions];

}

#pragma mark --- ***********
- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    //集成第三步: 进入后台 关闭美洽服务
    [MQManager closeMeiqiaService];
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    //集成第二步: 进入前台 打开meiqia服务
    [MQManager openMeiqiaService];
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}


- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    // Saves changes in the application's managed object context before the application terminates.
    [self saveContext];
}


#pragma mark - Core Data stack

@synthesize persistentContainer = _persistentContainer;

- (NSPersistentContainer *)persistentContainer  {
    // The persistent container for the application. This implementation creates and returns a container, having loaded the store for the application to it.
    @synchronized (self) {
        if (_persistentContainer == nil) {
            _persistentContainer = [[NSPersistentContainer alloc] initWithName:@"anjuyi1"];
            [_persistentContainer loadPersistentStoresWithCompletionHandler:^(NSPersistentStoreDescription *storeDescription, NSError *error) {
                if (error != nil) {
                    // Replace this implementation with code to handle the error appropriately.
                    // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                    
                    /*
                     Typical reasons for an error here include:
                     * The parent directory does not exist, cannot be created, or disallows writing.
                     * The persistent store is not accessible, due to permissions or data protection when the device is locked.
                     * The device is out of space.
                     * The store could not be migrated to the current model version.
                     Check the error message to determine what the actual problem was.
                    */
                    NSLog(@"Unresolved error %@, %@", error, error.userInfo);
                    abort();
                }
            }];
        }
    }
    
    return _persistentContainer;
}

#pragma mark - Core Data Saving support

- (void)saveContext {
    NSManagedObjectContext *context = self.persistentContainer.viewContext;
    NSError *error = nil;
    if ([context hasChanges] && ![context save:&error]) {
        // Replace this implementation with code to handle the error appropriately.
        // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
        NSLog(@"Unresolved error %@, %@", error, error.userInfo);
        abort();
    }
}

@end
