//
//  PushViewController.m
//  anjuyi
//
//  Created by 李 on 2018/5/29.
//  Copyright © 2018年 lsy. All rights reserved.
//

#import "PushViewController.h"
#import "BaseNaviViewController.h"

#import "PushPhotoViewController.h"//发布图片
#import "PushProjectViewController.h"//发布项目

@interface PushViewController ()

@end

@implementation PushViewController

- (void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:animated];
    [self.navigationController.navigationBar setHidden:YES];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.\
    
    [self.view setBackgroundColor:[UIColor colorWithHexString:@"#7dd3d3"]];
    
    [self setUpUserUI];

    [self pushBtn];
}

- (void)setUpUserUI{
    
    UIImageView *headerImage = [[UIImageView alloc] initWithFrame:CGRectMake(MDXFrom6(40), MDXFrom6(70)+KStatusBarHeight, MDXFrom6(60), MDXFrom6(60))];
    [headerImage setImage:[UIImage imageNamed:@"fb_tx_img"]];
    [headerImage.layer setCornerRadius:MDXFrom6(30)];
    [headerImage setClipsToBounds:YES];
    [self.view addSubview:headerImage];
    
    [self.view addSubview:[Tools creatLabel:CGRectMake(MDXFrom6(120), MDXFrom6(70)+KStatusBarHeight, MDXFrom6(250), MDXFrom6(60)) font:[UIFont systemFontOfSize:18] color:[UIColor colorWithHexString:@"#ffffff"] alignment:(NSTextAlignmentLeft) title:@"九溪设计"]];
}

- (void)pushBtn{
    
    NSArray *iArr = @[@"fb_strategy",@"fb_dyn",@"assist",@"fb_task",@"fb_img_n",@"fb_w_house"];
    NSArray *tArr = @[@"发布攻略",@"工地动态",@"辅助下单",@"发布任务",@"发布图片",@"发布整屋"];
    
    for (NSInteger i = 0 ; i < 6 ; i++) {
        
        NSInteger n = i/3;
        
        UIView *backView = [[UIView alloc] initWithFrame:CGRectMake(MDXFrom6(95/2+100*(i%3)), KStatusBarHeight + MDXFrom6(235+n*150), MDXFrom6(80), MDXFrom6(110))];
        [backView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(pushType:)]];
        [backView setTag:i];
        [self.view addSubview:backView];
        
        [backView addSubview:[Tools creatImage:CGRectMake(0, 0, MDXFrom6(80), MDXFrom6(80)) image:iArr[i]]];
        [backView addSubview:[Tools creatLabel:CGRectMake(0, MDXFrom6(95), MDXFrom6(80), MDXFrom6(15)) font:[UIFont systemFontOfSize:14] color:[UIColor colorWithHexString:@"#ffffff"] alignment:(NSTextAlignmentCenter) title:tArr[i]]];
        
    }
    
    [self.view addSubview:[Tools creatImage:CGRectMake(0, KScreenHeight - MDXFrom6(119), KScreenWidth, MDXFrom6(119)) image:@"fb_backgroud"]];
    
    UIButton *cancel = [Tools creatButton:CGRectMake(0, 0, MDXFrom6(39), MDXFrom6(39)) font:[UIFont systemFontOfSize:12] color:[UIColor whiteColor] title:@"" image:@"fb_close"];
    [cancel setCenter:CGPointMake(KScreenWidth/2, KScreenHeight - MDXFrom6(95))];
    [cancel addTarget:self action:@selector(back) forControlEvents:(UIControlEventTouchUpInside)];
    [self.view addSubview:cancel];
    
}

- (void)pushType:(UITapGestureRecognizer *)sender{
    
    NSLog(@"%ld",sender.view.tag);
    
    switch (sender.view.tag) {
        case 1:
        {
            PushProjectViewController *controller = [[PushProjectViewController alloc] init];
            BaseNaviViewController *nav = [[BaseNaviViewController alloc] initWithRootViewController:controller];
            [self presentViewController:nav animated:YES completion:nil];
        }
            break;
        case 4:
        {
            PushPhotoViewController *controller = [[PushPhotoViewController alloc] init];
            BaseNaviViewController *nav = [[BaseNaviViewController alloc] initWithRootViewController:controller];
            [self presentViewController:nav animated:YES completion:nil];
        }
            break;
            
        default:
            break;
    }
    
    

}

- (void)back{
    [self.navigationController dismissViewControllerAnimated:YES completion:nil];
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
