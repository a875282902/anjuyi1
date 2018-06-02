//
//  MoreChannel.m
//  anjuyi1
//
//  Created by 李 on 2018/5/31.
//  Copyright © 2018年 lsy. All rights reserved.
//

#import "MoreChannel.h"
#import "ChannelButton.h"

@interface MoreChannel ()<UIScrollViewDelegate>

@property (nonatomic,strong)UIScrollView *scrollView;

@end

@implementation MoreChannel

- (instancetype)initWithFrame:(CGRect)frame{
    
    if (self = [super initWithFrame:frame]) {
        self.scrollView = [[UIScrollView alloc] initWithFrame:frame];
        [self.scrollView setDelegate:self];
        [self.scrollView setShowsVerticalScrollIndicator:NO];
        [self.scrollView setShowsHorizontalScrollIndicator:NO];
        [self addSubview:self.scrollView];
    }
    return self;
}
- (void)setUpButton:(NSArray *)arr width:(CGFloat)width{
    
    CGFloat X = 0;
    CGFloat Y = 0;
    CGFloat W = 0;
    CGFloat H = 15;
    
    for (NSInteger i = 0; i < arr.count; i++) {
        
//        NSAttributedString *str = [[NSAttributedString alloc] initWithString:arr[i][@"name"]];
        
        CGRect rext = [arr[i][@"name"] boundingRectWithSize:CGSizeMake(100000, 10000) options:NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:14]} context:nil];
        NSLog(@"%.1f",rext.size.width);
        W = rext.size.width;
        
        
        NSLog(@"W ====%.1f   %ld ➖之前X====%.1f",W,i,X);
        
        if (X+W > width) {
            X = 20.0f;
            Y += H+10;
        }
        NSLog(@"X====%.1f",X);
        NSLog(@"Y====%.1f",Y);
        ChannelButton *btn = [ChannelButton buttonWithType:(UIButtonTypeCustom)];
        [btn setTitle:arr[i][@"name"] forState:(UIControlStateNormal)];
        [btn setTitleColor:[UIColor yellowColor] forState:(UIControlStateNormal)];
        [btn setFrame:CGRectMake(X, Y, W+20, H)];
        [btn.titleLabel setFont:[UIFont systemFontOfSize:15]];
        [btn setBackgroundColor:[UIColor redColor]];
        [btn addTarget:self action:@selector(btnDidPress:) forControlEvents:(UIControlEventTouchUpInside)];
        [btn setSelected:NO];
        [self.scrollView addSubview:btn];
        
        X += W+30;
    }
    
    [self.scrollView setContentSize:CGSizeMake(375, Y+H+10)];
}

- (void)btnDidPress:(UIButton *)sender{
    
    [self.delegate selectButtonToSearch:sender.titleLabel.text];
}

- (CGFloat)getScrollViewHeight{
    
    return self.scrollView.contentSize.height;
}


/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
