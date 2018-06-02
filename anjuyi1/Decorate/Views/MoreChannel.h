//
//  MoreChannel.h
//  anjuyi1
//
//  Created by 李 on 2018/5/31.
//  Copyright © 2018年 lsy. All rights reserved.
//

#import <UIKit/UIKit.h>

@class MoreChannel;

@protocol MoreChannelDelegate <NSObject>

- (void)selectButtonToSearch:(NSString *)sender;

@end

@interface MoreChannel : UIView

- (void)setUpButton:(NSArray *)arr width:(CGFloat)width spacing:(CGFloat)spacing;
- (CGFloat)getScrollViewHeight;

@property (nonatomic,weak)id<MoreChannelDelegate>delegate;

@end
