//
//  DetailsVIew.m
//  anjuyi1
//
//  Created by 李 on 2018/6/6.
//  Copyright © 2018年 lsy. All rights reserved.
//

//  商品详情

#import "GoodsDetailsVIew.h"

@implementation GoodsDetailsVIew

- (instancetype)initWithFrame:(CGRect)frame{
    
    if (self == [super initWithFrame:frame]) {
    
        
        
        [self.tmpWeView.scrollView addObserver:self forKeyPath:@"contentSize" options:NSKeyValueObservingOptionInitial context:nil];
        
        [self addSubview:self.tmpWeView];
        
        [self.tmpWeView loadRequest:[NSURLRequest requestWithURL:[NSURL fileURLWithPath:[[NSBundle mainBundle] pathForResource:@"test" ofType:@"html"]]]];

    }
    return self;
}


#pragma mark - tmpWeView
- (WKWebView *)tmpWeView{
    
    if (!_tmpWeView) {
        WKWebViewConfiguration *wkWebConfig = [[WKWebViewConfiguration alloc] init];
        // 自适应屏幕宽度js
        NSString *jSString =@"var meta = document.createElement('meta'); meta.setAttribute('name', 'viewport'); meta.setAttribute('content', 'width=device-width'); document.getElementsByTagName('head')[0].appendChild(meta);";
        WKUserContentController *userContentController = [[WKUserContentController alloc] init];
        
        WKUserScript *wkUserScript = [[WKUserScript alloc] initWithSource:jSString injectionTime:WKUserScriptInjectionTimeAtDocumentEnd forMainFrameOnly:YES];
        
        // 添加自适应屏幕宽度js调用的方法
        [userContentController addUserScript:wkUserScript];
        wkWebConfig.userContentController = userContentController;
        _tmpWeView = [[WKWebView alloc] initWithFrame:CGRectMake(0, 0, KScreenWidth, self.frame.size.height) configuration:wkWebConfig];
        [_tmpWeView setUserInteractionEnabled:NO];
    }
    
    return _tmpWeView;
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
    if (object == self.tmpWeView.scrollView && [keyPath isEqual:@"contentSize"]) {
        // we are here because the contentSize of the WebView's scrollview changed.
        
        UIScrollView *scrollView = self.tmpWeView.scrollView;
        
        if (scrollView.contentSize.height != self.tmpWeView.frame.size.height) {
            [self.tmpWeView setFrame:CGRectMake(0, 0, KScreenWidth, scrollView.contentSize.height)];
        }
        else{
            
             [self.delegate changeGoodsDetailsViewHeight:self.tmpWeView.scrollView.contentSize.height];
        }
        
    }
}

- (CGFloat)getGoodsDetailsHeight{
    
    return self.tmpWeView.scrollView.contentSize.height;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
