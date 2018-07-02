//
//  ShareView.h
//  anjuyi1
//
//  Created by apple on 2018/6/26.
//  Copyright © 2018年 lsy. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ShareView;

@protocol ShareViewDelegate <NSObject>

// 微信 
- (void)shareToTypeWith:(NSInteger)index;

@end

@interface ShareView : UIView

@property (nonatomic,weak)id<ShareViewDelegate>delegate;

- (void)show;

- (void)hidden;

@end
