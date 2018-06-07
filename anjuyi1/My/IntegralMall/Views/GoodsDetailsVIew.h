//
//  DetailsVIew.h
//  anjuyi1
//
//  Created by 李 on 2018/6/6.
//  Copyright © 2018年 lsy. All rights reserved.
//

//  商品详情

#import <UIKit/UIKit.h>
#import <WebKit/WebKit.h>

@protocol GoodsDetailsVIewDelegate <NSObject>

- (void)changeGoodsDetailsViewHeight:(CGFloat)height; //声明协议方法

@end

@interface GoodsDetailsVIew : UIView <WKUIDelegate,WKNavigationDelegate>

@property (nonatomic,strong)WKWebView *tmpWeView;

@property (nonatomic,weak)id<GoodsDetailsVIewDelegate>delegate;

- (CGFloat)getGoodsDetailsHeight;
@end

