//
//  PushView.h
//  anjuyi1
//
//  Created by apple on 2018/7/25.
//  Copyright © 2018年 lsy. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseNaviViewController.h"

@protocol PushViewDelegate <NSObject>

- (void)jumpToViewControllerForPush:(BaseNaviViewController *)nav;

@end

@interface PushView : UIView

@property (nonatomic,weak)id<PushViewDelegate>delegate;

@end
