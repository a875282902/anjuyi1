//
//  MallWebViewController.m
//  anjuyi1
//
//  Created by apple on 2019/2/12.
//  Copyright © 2019 lsy. All rights reserved.
//

#import "MyOrderWebViewController.h"
#import <WebKit/WebKit.h>
#import <JavaScriptCore/JavaScriptCore.h>

@interface MyOrderWebViewController ()<WKNavigationDelegate,UIScrollViewDelegate>

@property (nonatomic,strong) WKWebView *tmpWeView;

@end

@implementation MyOrderWebViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self.view setBackgroundColor:[UIColor whiteColor]];
    [self setTitle:@"我的订单"];
    
    [self baseForDefaultLeftNavButton];
    [self.view addSubview:self.tmpWeView];
    
    [self.view addSubview:[Tools setLineView:CGRectMake(0, 0, KScreenWidth, 2)]];
    
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
}

#pragma mark - tmpWeView
- (WKWebView *)tmpWeView{
    
    if (!_tmpWeView) {
        
        WKWebViewConfiguration *wkWebConfig = [[WKWebViewConfiguration alloc] init];
        _tmpWeView = [[WKWebView alloc] initWithFrame:CGRectMake(0, 0, KScreenWidth,KScreenHeight - KTopHeight) configuration:wkWebConfig];
        [_tmpWeView setNavigationDelegate:self];
        [_tmpWeView.scrollView setBounces:NO];
        [_tmpWeView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"http://shopapp.anjuyi.com.cn/home/my_order/index/token/%@",UTOKEN]]]];
    }
    
    return _tmpWeView;
}


- (void)webView:(WKWebView *)webView decidePolicyForNavigationAction:(WKNavigationAction *)navigationAction decisionHandler:(void (^)(WKNavigationActionPolicy))decisionHandler{
    [MBProgressHUD hideHUDForView:self.view animated:YES];
    decisionHandler(WKNavigationActionPolicyAllow);
    
}
- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer
{
    return NO;
}

@end
