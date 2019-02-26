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
#import <AlipaySDK/AlipaySDK.h>
#import <WechatOpenSDK/WXApi.h>

@interface MallWebViewController ()<WKNavigationDelegate,WKScriptMessageHandler,WXApiDelegate>
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
    
    if (_isRefre) {
        if (UTOKEN) {
            if ([_curUrlStr rangeOfString:@"?token="].location == NSNotFound) {
                [_tmpWeView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@?token=%@",_curUrlStr,UTOKEN]]]];
            }
            else{
                
                [_tmpWeView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@?token=%@",[[_curUrlStr componentsSeparatedByString:@"?token="] firstObject],UTOKEN]]]];
            }
        }else{
            
            [_tmpWeView goBack];
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
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(ZFBPaySuceess:) name:@"ZFB_PaySuccess" object:nil];
}

#pragma mark - tmpWeView
- (WKWebView *)tmpWeView{

    if (!_tmpWeView) {
        
        WKWebViewConfiguration *wkWebConfig = [[WKWebViewConfiguration alloc] init];
        _tmpWeView = [[WKWebView alloc] initWithFrame:CGRectMake(0, KStatusBarHeight, KScreenWidth,KScreenHeight - KTabBarHeight-KStatusBarHeight) configuration:wkWebConfig];
        [_tmpWeView setNavigationDelegate:self];
        if (UTOKEN) {
             [_tmpWeView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"http://shopapp.anjuyi.com.cn/home/index/index?token=%@",UTOKEN]]]];
        }
        else{
            [_tmpWeView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:@"http://shopapp.anjuyi.com.cn/home/index/index"]]];
        }
        [[_tmpWeView configuration].userContentController addScriptMessageHandler:self name:@"app_login"];
        [[_tmpWeView configuration].userContentController addScriptMessageHandler:self name:@"AppModel"];
        [[_tmpWeView configuration].userContentController addScriptMessageHandler:self name:@"payOrder"];
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
    
    if ([message.name isEqualToString:@"AppModel"]) {
        _isRefre = YES;
        LOGIN
    }
    else if ([message.name isEqualToString:@"payOrder"]) {
        
        [self payOrder:message.body];
    }
}


- (void)payOrder:(NSDictionary *)order{
    
    NSString *path = @"http://shopapp.anjuyi.com.cn/home/pay/pay_order";
    
    NSDictionary *header = @{@"token":UTOKEN};
    
    
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    __weak typeof(self) weakSelf = self;
    
    [HttpRequest POSTWithHeader:header url:path parameters:order success:^(id  _Nullable responseObject) {
        
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        
        if ([responseObject[@"code"] integerValue] == 200) {
            if ([order[@"pay_type"] isEqualToString:@"ali"]) {
                [weakSelf payInfoWithZhifubao:responseObject];
            }else if ([order[@"pay_type"] isEqualToString:@"wx"]) {
                [weakSelf payInfoWithWinxin:responseObject];
            }
        }
        else{
            
            [ViewHelps showHUDWithText:responseObject[@"message"]];
        }
        
        
    } failure:^(NSError * _Nullable error) {
        
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        [RequestSever showMsgWithError:error];
    }];

}

#pragma mark -- 支付宝支付
- (void)payInfoWithZhifubao:(NSDictionary *)orderDic{
    
    [[AlipaySDK defaultService] payOrder:orderDic[@"datas"][@"code"] fromScheme:@"anjuyi" callback:^(NSDictionary *resultDic) {
        [self ZFBPaySuceess:[[NSNotification alloc] initWithName:@"ZFB_PaySuccess" object:nil userInfo:resultDic]];
    }];
}

- (void)ZFBPaySuceess:(NSNotification *)sender{
    
    NSDictionary *resultDic = sender.userInfo;
    
    if([resultDic[@"resultStatus"] intValue] == 9000){ //成功付款
        [ViewHelps showHUDWithText:@"支付成功"];
        
    }else if([resultDic[@"resultStatus"] intValue] == 6001){ //中途取消订单了
        
        [ViewHelps showHUDWithText:@"中途取消订单了"];
        
    }else if([resultDic[@"resultStatus"] intValue] == 4000){ //订单支付失败
        [ViewHelps showHUDWithText:@"订单支付失败"];
        
    }else if([resultDic[@"resultStatus"] intValue] == 5000){ //重复请求
        [ViewHelps showHUDWithText:@"重复请求"];
    }else if([resultDic[@"resultStatus"] intValue] == 6000){ //网络连接出错
        [ViewHelps showHUDWithText:@"网络连接出错"];
    }
    
}

#pragma mark -- 微信支付
- (void)payInfoWithWinxin:(NSDictionary *)orderDic{
    NSDictionary *dic = orderDic[@"datas"][@"prepay_order"];
    PayReq *request = [[PayReq alloc] init];
    request.openID = dic[@"appid"];
    request.partnerId = dic[@"partnerid"];
    request.prepayId= dic[@"prepayid"];
    request.package = @"Sign=WXPay";
    request.nonceStr= dic[@"noncestr"];
    
    UInt32 timeStamp = [dic[@"timestamp"] intValue];
    request.timeStamp = timeStamp ;
    request.sign=dic[@"sign"];
    // 调用微信
    [WXApi sendReq:request];
}


@end
