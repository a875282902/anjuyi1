//
//  NavTwoTitle.m
//  anjuyi1
//
//  Created by 李 on 2018/6/3.
//  Copyright © 2018年 lsy. All rights reserved.
//

#import "NavTwoTitle.h"

@interface NavTwoTitle ()

@property (nonatomic,strong)UILabel *numLabel;

@end

@implementation NavTwoTitle

- (instancetype)initWithFrame:(CGRect)frame WithTitle1:(NSString *)title1 WithTitle2:(NSString *)title2{
    
    if (self == [super initWithFrame:frame]) {
        
        [self addSubview:[Tools creatLabel:CGRectMake(0, 0, MDXFrom6(300), 24) font:[UIFont systemFontOfSize:18] color:[UIColor blackColor] alignment:(NSTextAlignmentCenter) title:title1]];
        
        self.numLabel = [Tools creatLabel:CGRectMake(0,24, MDXFrom6(300), 20) font:[UIFont systemFontOfSize:11] color:[UIColor colorWithHexString:@"#999999"] alignment:(NSTextAlignmentCenter) title:title2];
        
        [self addSubview:self.numLabel];
    }
    return self;
}

- (void)refreNum:(NSString *)num{
    
    [self.numLabel setText:num];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
