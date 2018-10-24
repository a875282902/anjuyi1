//
//  ServiceAgreementVC.m
//  anjuyi1
//
//  Created by apple on 2018/6/13.
//  Copyright © 2018年 lsy. All rights reserved.
//
//  服务协议

#import "AboutUsViewController.h"

@interface AboutUsViewController ()<UIWebViewDelegate,NSURLConnectionDelegate>
{
    NSURLConnection* _urlConnection;
    NSMutableURLRequest* _originRequest;
    BOOL _authenticated;
    
}

@property (nonatomic,strong)UIWebView *tmpWebView;
@property (nonatomic,strong)NSString *baseStr;

@end

@implementation AboutUsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self baseForDefaultLeftNavButton];
    [self setTitle:@"关于我们"];
    
    self.baseStr = [NSString stringWithFormat:@"%@/login/about",KURL];
    
    self.tmpWebView = [[UIWebView alloc] initWithFrame:CGRectMake(0, 0, KScreenWidth , KViewHeight)];
    [self.tmpWebView setBackgroundColor:[UIColor whiteColor]];
    [self.tmpWebView.scrollView setBackgroundColor:[UIColor whiteColor]];
    [self.tmpWebView.scrollView setShowsHorizontalScrollIndicator:NO];
    _originRequest= [[NSMutableURLRequest alloc]initWithURL:[NSURL URLWithString:self.baseStr]];
    
    [self.tmpWebView loadRequest:_originRequest];
    [self.tmpWebView setDelegate:self];
    [self.view addSubview:self.tmpWebView];
    
    
    [self.view addSubview:[Tools setLineView:CGRectMake(0, 0 , KScreenWidth , 1)]];
    
}

#pragma mark - UIWebViewDelegate

- (BOOL)webView:(UIWebView*)webView shouldStartLoadWithRequest:(NSURLRequest*)request navigationType:(UIWebViewNavigationType)navigationType

{
    
    NSLog(@"Did start loading: %@ auth:%d", [[request URL]absoluteString],_authenticated);
    
    if(!_authenticated) {
        
        _authenticated=NO;
        
        _urlConnection= [[NSURLConnection alloc] initWithRequest:_originRequest delegate:self];
        
        [_urlConnection start];
        
        return NO;
        
    }
    
    return YES;
    
}


-(void)webView:(UIWebView*)webView didFailLoadWithError:(NSError*)error

{
    
    // 102 == WebKitErrorFrameLoadInterruptedByPolicyChange
    
    NSLog(@"***********error:%@,errorcode=%ld,errormessage:%@",error.domain,(long)error.code,error.description);
    
    if(!([error.domain isEqualToString:@"WebKitErrorDomain"] && error.code==102)) {
        
        //当请求出错了会做什么事情
        
    }
    
}

- (void)webViewDidFinishLoad:(UIWebView *)webView{
    
    [MBProgressHUD hideHUDForView:self.view animated:YES];
}

#pragma mark-NURLConnectiondelegate

- (void)connection:(NSURLConnection *)connection didReceiveAuthenticationChallenge:(NSURLAuthenticationChallenge *)challenge
{
    
    NSLog(@"WebController Got auth challange via NSURLConnection");
    
    if([challenge previousFailureCount]==0)
        
    {
        
        _authenticated=YES;
        
        NSURLCredential*credential=[NSURLCredential credentialForTrust:challenge.protectionSpace.serverTrust];
        
        [challenge.sender useCredential:credential forAuthenticationChallenge:challenge];
        
    }else{
        
        [[challenge sender]cancelAuthenticationChallenge:challenge];
        
    }
    
}




-(void)connection:(NSURLConnection*)connection didReceiveResponse:(NSURLResponse*)response

{
    
    NSLog(@"WebController received response via NSURLConnection");
    
    // remake a webview call now that authentication has passed ok.
    
    _authenticated=YES;
    
    //    NSString *body = [NSString stringWithFormat:@"msg=%@",self.baseStr];
    
    [_originRequest setHTTPMethod:@"POST"];
    
    [_originRequest setHTTPBody:[self.baseStr dataUsingEncoding:NSUTF8StringEncoding]];
    
    [self.tmpWebView loadRequest:_originRequest];
    
    // Cancel the URL connection otherwise we double up (webview + url connection, same url = no good!)
    
    [_urlConnection cancel];
    
}

- (void)URLSession:(NSURLSession*)session didReceiveChallenge:(NSURLAuthenticationChallenge*)challenge completionHandler:(void(^)(NSURLSessionAuthChallengeDisposition disposition,NSURLCredential*__nullablecredential))completionHandler{
    
    NSLog(@"didReceiveChallenge");
    
    //    if([challenge.protectionSpace.host isEqualToString:@"api.lz517.me"] /*check if this is host you trust: */ ){
    
    completionHandler(NSURLSessionAuthChallengeUseCredential, [NSURLCredential credentialForTrust:challenge.protectionSpace.serverTrust]);
    
    //    }
    
}

// We use this method is to accept an untrusted site which unfortunately we need to do, as our PVM servers are self signed.

- (BOOL)connection:(NSURLConnection*)connection canAuthenticateAgainstProtectionSpace:(NSURLProtectionSpace*)protectionSpace

{
    
    return [protectionSpace.authenticationMethod isEqualToString:NSURLAuthenticationMethodServerTrust];
    
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
