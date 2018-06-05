//
//  BaseViewController.h
//  AISpeedNew
//
//  Created by Medalands on 15/10/23.
//  Copyright (c) 2015年 Medalands. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BaseViewController : UIViewController

/*
 *设置导航栏左侧的按钮 和点击事件
 */
- (void) baseForDefaultLeftNavButton; // -- 默认为back的左侧按钮

- (void) setNavigationLeftBarButtonWithImageNamed:(NSString *)imageName;
- (void) leftButtonTouchUpInside:(id)sender;

/*
 *设置导航栏右侧的按钮 和点击事件
 */
- (void) setNavigationRightBarButtonWithImageNamed:(NSString *)imageName;
- (void) setNavigationDoubleRightBarButtonWithImageNamed:(NSString *)imageName1 imageNamed2:(NSString *)imageName2;

- (void) setNavigationRightBarButtonWithTitle:(NSString *)title color:(UIColor *)color;

- (void) rightButtonTouchUpInside:(id)sender;
- (void)doubleRightButtonTouchUpInside:(id)sender;


- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer;

/**
 *菊花的显示和隐藏
 */
- (void) showHUD;
- (void) hidenHUD;
@end
