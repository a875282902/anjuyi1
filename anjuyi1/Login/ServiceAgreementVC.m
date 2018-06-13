//
//  ServiceAgreementVC.m
//  anjuyi1
//
//  Created by apple on 2018/6/13.
//  Copyright © 2018年 lsy. All rights reserved.
//
//  服务协议

#import "ServiceAgreementVC.h"

@interface ServiceAgreementVC ()<UIWebViewDelegate>

@property (nonatomic,strong)NSURLSession *session;


@property (nonatomic,strong)UIWebView *tmpWebView;

@end

@implementation ServiceAgreementVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.tmpWebView = [[UIWebView alloc] initWithFrame:CGRectMake(0, KStatusBarHeight, KScreenWidth , KScreenHeight - KStatusBarHeight - 60)];
    [self.tmpWebView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:@"https://api.ajyvip.com/login/register_agreement"]]];
    [self.tmpWebView setDelegate:self];
    [self.view addSubview:self.tmpWebView];
    
    [_session dataTask]
    
}


- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer{
    return NO;
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
