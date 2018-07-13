//
//  PullDownView.h
//  anjuyi1
//
//  Created by apple on 2018/7/13.
//  Copyright © 2018年 lsy. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PullDownView : UIView

/**
 *  蒙版颜色
 */
@property (nonatomic, strong) UIColor *coverColor;

- (void)showOrHidden:(BOOL)isShow withFrame:(CGRect)frame button:(UIButton *)btn view:(UIView *)showView;

@end
