//
//  BaseViewController.m
//  AISpeedNew
//
//  Created by Medalands on 15/10/23.
//  Copyright (c) 2015年 Medalands. All rights reserved.
//

#import "BaseViewController.h"

@interface BaseViewController ()<UIGestureRecognizerDelegate>
{
//    MBProgressHUD *progressHUD;
}

@end

@implementation BaseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setAutomaticallyAdjustsScrollViewInsets:NO];
    
    [self.view setBackgroundColor:[UIColor whiteColor]];
    id target = self.navigationController.interactivePopGestureRecognizer.delegate;
    
    // handleNavigationTransition:为系统私有API,即系统自带侧滑手势的回调方法，我们在自己的手势上直接用它的回调方法
    UIPanGestureRecognizer *panGesture = [[UIPanGestureRecognizer alloc] initWithTarget:target action:@selector(handleNavigationTransition:)];
    panGesture.delegate = self; // 设置手势代理，拦截手势触发
    [self.view addGestureRecognizer:panGesture];
    
    // 一定要禁止系统自带的滑动手势
    self.navigationController.interactivePopGestureRecognizer.enabled = NO;
    
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor blackColor],NSFontAttributeName:[UIFont boldSystemFontOfSize:19.0f]}];
    
    
}

- (UIStatusBarStyle)preferredStatusBarStyle{
    return UIStatusBarStyleDefault;
}
// 什么时候调用，每次触发手势之前都会询问下代理方法，是否触发
// 作用：拦截手势触发
- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer
{
    // 当当前控制器是根控制器时，不可以侧滑返回，所以不能使其触发手势
    if(self.navigationController.childViewControllers.count == 1)
    {
        return NO;
    }
    
    return YES;
}

/*设置导航栏左侧的按钮 和点击事件*/
- (void) setNavigationLeftBarButtonWithImageNamed:(NSString *)imageName{
    UIImage *image = [UIImage imageNamed:imageName];
    UIButton *leftButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [leftButton setFrame:CGRectMake(0, 0, 25, 44)];
    [leftButton setImage:image forState:UIControlStateNormal];
    [leftButton addTarget:self action:@selector(leftButtonTouchUpInside:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *leftButtonItem = [[UIBarButtonItem alloc] initWithCustomView:leftButton];
    [self.navigationItem setLeftBarButtonItem:leftButtonItem];
}

- (void) setNavigationLeftBarButtonWithTitle:(NSString *)title color:(UIColor *)color{
    UIButton *leftButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [leftButton setFrame:CGRectMake(0, 0, title.length *16+10, 44)];
    [leftButton setTitle:title forState:UIControlStateNormal];
    [leftButton.titleLabel setFont:[UIFont systemFontOfSize:16]];
    [leftButton setTitleColor:color forState:UIControlStateNormal];
    [leftButton addTarget:self action:@selector(leftButtonTouchUpInside:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *leftButtonItem = [[UIBarButtonItem alloc] initWithCustomView:leftButton];
    [self.navigationItem setLeftBarButtonItem:leftButtonItem];
}


- (void) baseForDefaultLeftNavButton
{
    UIImage *image = [UIImage imageNamed:@"ss_back"];
    UIButton *leftButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [leftButton setFrame:CGRectMake(0, 0, 25, 44)];
    [leftButton setImage:image forState:UIControlStateNormal];
    [leftButton addTarget:self action:@selector(leftButtonTouchUpInside:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *leftButtonItem = [[UIBarButtonItem alloc] initWithCustomView:leftButton];
    [self.navigationItem setLeftBarButtonItem:leftButtonItem];
}

- (void) leftButtonTouchUpInside:(id)sender
{
    if (sender && [sender isKindOfClass:[UIButton class]]) {
        
        [self.navigationController popViewControllerAnimated:YES];
    }
}

/*设置导航栏右侧的按钮 和点击事件*/
- (void) setNavigationRightBarButtonWithImageNamed:(NSString *)imageName{
    UIImage *image = [UIImage imageNamed:imageName];
    UIButton *rightButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [rightButton setFrame:CGRectMake(0, 0, 25, 44)];
    [rightButton setImage:image forState:UIControlStateNormal];
    [rightButton addTarget:self action:@selector(rightButtonTouchUpInside:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *rightButtonItem = [[UIBarButtonItem alloc] initWithCustomView:rightButton];
    [self.navigationItem setRightBarButtonItem:rightButtonItem];
    
}

/*设置导航栏右侧的按钮 和点击事件*/
- (void) setNavigationRightBarButtonWithTitle:(NSString *)title color:(UIColor *)color{
    UIButton *rightButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [rightButton setFrame:CGRectMake(0, 0, title.length * 16+10, 44)];
    [rightButton setTitle:title forState:(UIControlStateNormal)];
    [rightButton setTitleColor:color forState:(UIControlStateNormal)];
    [rightButton.titleLabel setFont:[UIFont systemFontOfSize:16]];
    [rightButton addTarget:self action:@selector(rightButtonTouchUpInside:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *rightButtonItem = [[UIBarButtonItem alloc] initWithCustomView:rightButton];
    [self.navigationItem setRightBarButtonItem:rightButtonItem];
    
}


/*设置导航栏右侧的double按钮 和点击事件*/
- (void) setNavigationDoubleRightBarButtonWithImageNamed:(NSString *)imageName1 imageNamed2:(NSString *)imageName2{
    UIImage *image = [UIImage imageNamed:imageName1];
    UIButton *rightButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [rightButton setFrame:CGRectMake(0, 0, 25, 44)];
    [rightButton setImage:image forState:UIControlStateNormal];
    [rightButton setTag:1];
    [rightButton addTarget:self action:@selector(doubleRightButtonTouchUpInside:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *rightButtonItem = [[UIBarButtonItem alloc] initWithCustomView:rightButton];
    
    UIImage *image1 = [UIImage imageNamed:imageName2];
    UIButton *rightButton1 = [UIButton buttonWithType:UIButtonTypeCustom];
    [rightButton1 setFrame:CGRectMake(0, 0, 25, 44)];
    [rightButton1 setImage:image1 forState:UIControlStateNormal];
    [rightButton1 addTarget:self action:@selector(doubleRightButtonTouchUpInside:) forControlEvents:UIControlEventTouchUpInside];
    [rightButton1 setTag:2];
    UIBarButtonItem *rightButtonItem1 = [[UIBarButtonItem alloc] initWithCustomView:rightButton1];
    
    [self.navigationItem setRightBarButtonItems:@[rightButtonItem1,rightButtonItem] animated:YES];
}

- (void) rightButtonTouchUpInside:(id)sender{
    
}

- (void)doubleRightButtonTouchUpInside:(id)sender{
    
    
}


/*设置的菊花*/
- (void) showHUD
{
//    progressHUD = [[MBProgressHUD alloc] initWithView:self.view];
//    [progressHUD setDimBackground:YES];
//    [self.view addSubview:progressHUD];
//    [progressHUD show:YES];
}

- (void) hidenHUD
{
//    [progressHUD hide:YES];
}







- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
