//
//  Tools.m
//  anjuyi1
//
//  Created by 李 on 2018/5/29.
//  Copyright © 2018年 lsy. All rights reserved.
//

#import "Tools.h"

@implementation Tools

+(UILabel *)creatLabel:(CGRect)rect font:(UIFont *)font color:(UIColor *)color alignment:(NSTextAlignment)alignment title:(NSString *)title{

    UILabel *label = [[UILabel alloc] initWithFrame:rect];
    [label setText:title];
    [label setFont:font];
    [label setTextColor:color];
    [label setNumberOfLines:0];
    [label setTextAlignment:alignment];
    [label setClipsToBounds:YES];
    [label setUserInteractionEnabled:YES];
    return label;
}

+ (UIView *)setLineView:(CGRect)rect{
    
    UIView *line = [[UIView alloc] initWithFrame:rect];
    [line setBackgroundColor:[UIColor colorWithHexString:@"#f6f6f6"]];
    
    return line;
}

+ (UIButton *)creatButton:(CGRect)rect font:(UIFont *)font color:(UIColor *)color title:(NSString *)title image:(NSString *)imageName{
    
    UIButton *btn = [UIButton buttonWithType:(UIButtonTypeCustom)];
    [btn setFrame:rect];
    [btn setTitle:title forState:(UIControlStateNormal)];
    [btn.titleLabel setFont:font];
    [btn setTitleColor:color forState:(UIControlStateNormal)];
    [btn setImage:[UIImage imageNamed:imageName] forState:(UIControlStateNormal)];
    [btn setClipsToBounds:YES];
    return btn;
}

+ (UIImageView *)creatImage:(CGRect)rect image:(NSString *)imageName {
    
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:rect];
    [imageView setImage:[UIImage imageNamed:imageName]];
    [imageView setUserInteractionEnabled:YES];
    [imageView setClipsToBounds:YES];
    return imageView;
}

+ (UIImageView *)creatImage:(CGRect)rect url:(NSString *)imageUrl image:(NSString *)imageName{
    
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:rect];
    [imageView sd_setImageWithURL:[NSURL URLWithString:imageUrl] placeholderImage:[UIImage imageNamed:imageName]];
    [imageView setUserInteractionEnabled:YES];
    [imageView setClipsToBounds:YES];
    return imageView;
}

@end
