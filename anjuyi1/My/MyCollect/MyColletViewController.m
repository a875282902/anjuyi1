//
//  MyColletViewController.m
//  anjuyi1
//
//  Created by 李 on 2018/6/3.
//  Copyright © 2018年 lsy. All rights reserved.
//
//  我的收藏

#import "MyColletViewController.h"

@interface MyColletViewController ()

@end

@implementation MyColletViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self baseForDefaultLeftNavButton];
    [self.navigationItem setTitleView:[[NavTwoTitle alloc] initWithFrame:CGRectMake(0, 0, MDXFrom6(300), 44) WithTitle1:@"我的收藏" WithTitle2:@"3篇"]];
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
