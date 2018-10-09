//
//  UIButton+Caregory.m
//  anjuyi1
//
//  Created by apple on 2018/9/28.
//  Copyright © 2018年 lsy. All rights reserved.
//

#import "UIButton+Caregory.h"


@implementation UIButton (Caregory)

- (void)setNumb:(NSString *)numb{
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(self.frame.size.width - 15, 5, 15, 15)];
    [label setText:[NSString stringWithFormat:@"%@",numb]];
    [label setBackgroundColor:[UIColor redColor]];
    [label setTextColor:[UIColor whiteColor]];
    [label setTextAlignment:(NSTextAlignmentCenter)];
    [label setFont:[UIFont boldSystemFontOfSize:10]];
    [label.layer setCornerRadius:7.5];
    [label setClipsToBounds:YES];
    [self addSubview:label];
    
}

@end
