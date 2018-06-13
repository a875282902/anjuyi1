//
//  ContractDetailsVC.m
//  anjuyi1
//
//  Created by 李 on 2018/6/2.
//  Copyright © 2018年 lsy. All rights reserved.
//
//  合同详情

#import "ContractDetailsVC.h"


@interface ContractDetailsVC ()<UIWebViewDelegate>

@end

@implementation ContractDetailsVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    [self setTitle:@"合同详情"];
    
    [self baseForDefaultLeftNavButton];
    
    [self setNavigationRightBarButtonWithImageNamed:@"download"];
    
    UIWebView *web = [[UIWebView alloc] initWithFrame:CGRectMake(0, 0, KScreenWidth, KScreenHeight - KTopHeight)];
    
    NSString *documentLocation = [[NSBundle mainBundle]
                                  pathForResource:@"pdf.pdf" ofType:nil];
    
    [web loadRequest:[NSURLRequest requestWithURL:[NSURL fileURLWithPath:documentLocation]]];
    
    web.delegate = self;
    
    web.scalesPageToFit = YES;
    
    [self.view addSubview:web];
    
    [self.view addSubview:[Tools setLineView:CGRectMake(0, 0, KScreenWidth, 1.5)]];
    
    [MBProgressHUD showHUDAddedTo:self.view animated:YES].label.text = @"正在加载中···";
}

- (void)webViewDidFinishLoad:(UIWebView *)webView{
    
    [MBProgressHUD hideHUDForView:self.view animated:YES];
}

- (void)rightButtonTouchUpInside:(id)sender{
    
    NSLog(@"下载");
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
