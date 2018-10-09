//
//  RootViewController.m
//  anjuyi
//
//  Created by 李 on 2018/5/29.
//  Copyright © 2018年 lsy. All rights reserved.
//

#import "RootViewController.h"
#import "HomeViewController.h"
#import "DecorateViewController.h"
#import "MallViewController.h"
#import "MyViewController.h"
#import "KBTabbar.h"
#import "BaseNaviViewController.h"
#import "PushViewController.h"
#import "UIColor+Category.h"
#import "PushView.h"

@interface RootViewController ()<PushViewDelegate>

@property (nonatomic,strong)  PushView *pushView ;
@property (nonatomic,strong)  UIButton *pushButton ;

@end

@implementation RootViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(hiddenPushButton) name:@"hiddenPushButton" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(noHiddenPushButton) name:@"noHiddenPushButton" object:nil];
    
    HomeViewController *hvc = [[HomeViewController alloc] init];
    [self addChildController:hvc title:@"首页" imageName:@"nav_sy" selectedImageName:@"nav_sy_xz" navVc:[UINavigationController class]];
    
    DecorateViewController *dvc = [[DecorateViewController alloc] init];
    [self addChildController:dvc title:@"装修" imageName:@"nav_decorate" selectedImageName:@"nav_decorate_xz" navVc:[UINavigationController class]];
    
    
    MallViewController *mvc = [[MallViewController alloc] init];
    [self addChildController:mvc title:@"商城" imageName:@"nav_shop_xz" selectedImageName:@"nav_shop" navVc:[UINavigationController class]];
    
    MyViewController *myvc = [[MyViewController alloc] init];
    [self addChildController:myvc title:@"我的" imageName:@"nav_my" selectedImageName:@"nav_my_xz" navVc:[UINavigationController class]];
    
    [[UITabBar appearance] setBackgroundImage:[UIImage imageWithColor:MDRGBA(254, 255, 255, 1)]];
    //  设置tabbar
    //    [[UITabBar appearance] setShadowImage:[[UIImage alloc] init]];
    // 设置自定义的tabbar
//    [self setCustomtabbar];
    
    [self setUpPushButton];
    
}

- (void)setCustomtabbar{
    
    KBTabbar *tabbar = [[KBTabbar alloc]init];
    
    [self setValue:tabbar forKeyPath:@"tabBar"];
    
    [tabbar.centerBtn addTarget:self action:@selector(centerBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    
}

- (void)hiddenPushButton{
    [self.pushButton setHidden:YES];
}
- (void)noHiddenPushButton{
    [self.pushButton setHidden:NO];
}

- (void)setUpPushButton{
    
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    [btn setImage:[UIImage imageNamed:@"nav_fb"] forState:UIControlStateNormal];
    btn.frame = CGRectMake(KScreenWidth - 80, KScreenHeight - KTabBarHeight - 80, 64, 64);
    [btn addTarget:self action:@selector(centerBtnClick:) forControlEvents:(UIControlEventTouchUpInside)];
    [self.view addSubview:btn];
    self.pushButton = btn;
}

- (void)centerBtnClick:(UIButton *)btn{
    
//    PushViewController *controller = [[PushViewController alloc] init];
//    BaseNaviViewController *navCon = [[BaseNaviViewController alloc] initWithRootViewController:controller];
//    [self presentViewController:navCon animated:YES completion:nil];
    
    
    
    [self.pushView setHidden:NO];
    [[UIApplication sharedApplication].keyWindow addSubview:self.pushView];

}

- (PushView *)pushView{
    
    if (!_pushView) {
        _pushView = [[PushView alloc] initWithFrame:[UIScreen mainScreen].bounds];
        [_pushView setDelegate:self];
    }
    return  _pushView;
}


- (void)jumpToViewControllerForPush:(BaseNaviViewController *)nav{
    [self presentViewController:nav animated:YES completion:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void)addChildController:(UIViewController*)childController title:(NSString*)title imageName:(NSString*)imageName selectedImageName:(NSString*)selectedImageName navVc:(Class)navVc
{
    
    
    childController.tabBarItem.title = title;
    childController.tabBarItem.image = [[UIImage imageNamed:imageName] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    childController.tabBarItem.selectedImage = [[UIImage imageNamed:selectedImageName] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    // 设置一下选中tabbar文字颜色
    [childController.tabBarItem setTitleTextAttributes:@{NSForegroundColorAttributeName : [UIColor colorWithHexString:@"#666666"] }forState:UIControlStateNormal];
    [childController.tabBarItem setTitleTextAttributes:@{NSForegroundColorAttributeName : [UIColor colorWithHexString:@"#47BABA"] }forState:UIControlStateSelected];
    
    BaseNaviViewController* nav = [[BaseNaviViewController alloc] initWithRootViewController:childController];
    
    [self addChildViewController:nav];
}


@end
