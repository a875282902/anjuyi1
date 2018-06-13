//
//  MyWalletViewController.m
//  anjuyi1
//
//  Created by 李 on 2018/6/3.
//  Copyright © 2018年 lsy. All rights reserved.
//

#import "MyWalletViewController.h"
#import "RechargeViewController.h"
#import "TransactionRecordsVC.h"

@interface MyWalletViewController ()

@end

@implementation MyWalletViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self setTitle:@"我的钱包"];
    
    [self baseForDefaultLeftNavButton];
    
    [self.view addSubview:[Tools setLineView:CGRectMake(0, 0, KScreenWidth, 1.5)]];
    
    [self.view addSubview:[Tools creatImage:CGRectMake(MDXFrom6(160), MDXFrom6(40), MDXFrom6(55), MDXFrom6(55)) image:@"my_wallet_ye"]];
    
    [self.view addSubview:[Tools creatLabel:CGRectMake(0, MDXFrom6(115), KScreenWidth, MDXFrom6(20)) font:[UIFont systemFontOfSize:18] color:[UIColor blackColor] alignment:(NSTextAlignmentCenter) title:@"余额：300元"]];
    
    UIButton *recharge = [Tools creatButton:CGRectMake(MDXFrom6(15), MDXFrom6(195), KScreenWidth - MDXFrom6(30), MDXFrom6(50)) font:[UIFont systemFontOfSize:18] color:[UIColor whiteColor] title:@"充值" image:@""];
    [recharge setBackgroundColor:[UIColor colorWithHexString:@"#ffb638"]];
    [recharge.layer setCornerRadius:3];
    [recharge setClipsToBounds:YES];
    [recharge addTarget:self action:@selector(rechargeDidPress) forControlEvents:(UIControlEventTouchUpInside)];
    [self.view addSubview:recharge];
    
    UIButton *record = [Tools creatButton:CGRectMake(MDXFrom6(15), MDXFrom6(265), KScreenWidth - MDXFrom6(30), MDXFrom6(40)) font:[UIFont systemFontOfSize:16] color:[UIColor colorWithHexString:@"#999999"] title:@"交易记录" image:@""];
    [record addTarget:self action:@selector(recordDidPress) forControlEvents:(UIControlEventTouchUpInside)];
    [self.view addSubview:record];
}

- (void)rechargeDidPress{

    RechargeViewController *con = [[RechargeViewController alloc] init];
    [self.navigationController pushViewController:con animated:YES];

}

- (void)recordDidPress{
    
    TransactionRecordsVC *con = [[TransactionRecordsVC alloc] init];
    [self.navigationController pushViewController:con animated:YES];
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
