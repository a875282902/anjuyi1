//
//  BaseNaviViewController.m
//  AISpeedNew
//
//  Created by Medalands on 15/10/23.
//  Copyright (c) 2015年 Medalands. All rights reserved.
//

#import "BaseNaviViewController.h"




@interface BaseNaviViewController ()

@end

@implementation BaseNaviViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
//    
    // -- 新建一个图片来当背景
    UIImage *tmpImage = [UIImage imageWithColor:[UIColor whiteColor]];
//    UIImage *tmpImage = [UIImage imageNamed:@"1"];
    
    // --  导航栏背景颜色
    [self.navigationBar setBackgroundImage:tmpImage forBarMetrics:UIBarMetricsDefault];
    
    
    //隐藏导航栏下面的线条
    self.navigationBar.shadowImage = [[UIImage alloc] init];

    // -- 导航栏文字颜色和大小
    [self.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor blackColor],NSFontAttributeName:[UIFont boldSystemFontOfSize:19.0f]}];
    
    
    
    
    
}

- (UIStatusBarStyle)preferredStatusBarStyle{
    return UIStatusBarStyleDefault;
}

-(void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated{
    
    if (self.childViewControllers.count==1) {
        viewController.hidesBottomBarWhenPushed = YES; //viewController是将要被push的控制器
        
    }
    [super pushViewController:viewController animated:animated];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];

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
