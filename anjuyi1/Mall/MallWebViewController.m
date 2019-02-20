//
//  MallWebViewController.m
//  anjuyi1
//
//  Created by apple on 2019/2/12.
//  Copyright © 2019 lsy. All rights reserved.
//

#import "MallWebViewController.h"
#import <WebKit/WebKit.h>
#import <JavaScriptCore/JavaScriptCore.h>

@interface MallWebViewController ()<WKNavigationDelegate,WKScriptMessageHandler>
{
    NSString * _curUrlStr;
    BOOL _isRefre;
}
@property (nonatomic,strong) WKWebView *tmpWeView;

@property (nonatomic,strong) UIWebView *tmpWeb;

@end

@implementation MallWebViewController

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"hiddenPushButton" object:nil];
    
    if (_isRefre && UTOKEN) {
        
        if ([_curUrlStr rangeOfString:@"?token="].location == NSNotFound) {
            [_tmpWeView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@?token=%@",_curUrlStr,UTOKEN]]]];
        }
        else{
            
            [_tmpWeView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@?token=%@",[[_curUrlStr componentsSeparatedByString:@"?token="] firstObject],UTOKEN]]]];
        }
        [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        _isRefre = NO;
    }
    
}



- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self.view setBackgroundColor:[UIColor whiteColor]];
    _isRefre = NO;
    [self.view addSubview:self.tmpWeView];
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
}

#pragma mark - tmpWeView
- (WKWebView *)tmpWeView{

    if (!_tmpWeView) {
        
        WKWebViewConfiguration *wkWebConfig = [[WKWebViewConfiguration alloc] init];
        _tmpWeView = [[WKWebView alloc] initWithFrame:CGRectMake(0, 0, KScreenWidth,KScreenHeight - KTabBarHeight) configuration:wkWebConfig];
        [_tmpWeView setNavigationDelegate:self];
        if (UTOKEN) {
             [_tmpWeView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"http://shopapp.anjuyi.com.cn/home/index/index?token=%@",UTOKEN]]]];
        }
        else{
            [_tmpWeView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:@"http://shopapp.anjuyi.com.cn/home/index/index"]]];
        }
        [[_tmpWeView configuration].userContentController addScriptMessageHandler:self name:@"app_login"];
        [[_tmpWeView configuration].userContentController addScriptMessageHandler:self name:@"AppModel"];
    }

    return _tmpWeView;
}


- (void)webView:(WKWebView *)webView decidePolicyForNavigationAction:(WKNavigationAction *)navigationAction decisionHandler:(void (^)(WKNavigationActionPolicy))decisionHandler{
    [MBProgressHUD hideHUDForView:self.view animated:YES];
    NSLog(@"当前网址%@",navigationAction.request.URL);
    _curUrlStr = [NSString stringWithFormat:@"%@",navigationAction.request.URL];
    decisionHandler(WKNavigationActionPolicyAllow);
    
}
//WKScriptMessageHandler协议方法
- (void)userContentController:(WKUserContentController *)userContentController didReceiveScriptMessage:(WKScriptMessage *)message {
    //code
    NSLog(@"name = %@, body = %@", message.name, message.body);
    _isRefre = YES;
    LOGIN
}


@end
