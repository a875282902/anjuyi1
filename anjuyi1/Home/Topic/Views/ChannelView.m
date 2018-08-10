//
//  ChannelView.m
//  anjuyi1
//
//  Created by apple on 2018/8/10.
//  Copyright © 2018年 lsy. All rights reserved.
//

#import "ChannelView.h"

static NSInteger const viewHeight = 50;

@interface ChannelView ()<UIScrollViewDelegate>

@property (nonatomic,strong)UIScrollView   * tmpScrollView;
@property (nonatomic,strong)NSMutableArray * buttonArr;
@property (nonatomic,strong)UIView         * lineView;

@end

@implementation ChannelView
- (instancetype)initWithFrame:(CGRect)frame{
    
    if (self == [super initWithFrame:frame]) {
        [self addSubview:self.tmpScrollView];
    }
    return self;
}

#pragma mark -- scrollview
-(UIScrollView *)tmpScrollView{
    
    if (!_tmpScrollView) {
        _tmpScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, KScreenWidth, viewHeight)];
        [_tmpScrollView setShowsVerticalScrollIndicator:NO];
        [_tmpScrollView setShowsHorizontalScrollIndicator:NO];
        if (@available(iOS 11.0, *)) {
            [_tmpScrollView setContentInsetAdjustmentBehavior:(UIScrollViewContentInsetAdjustmentNever)];
        }
        [_tmpScrollView setDelegate:self];
    }
    return _tmpScrollView;
}

- (NSMutableArray *)buttonArr{
    if (!_buttonArr) {
        _buttonArr  = [NSMutableArray array];
    }
    return _buttonArr;
}

- (UIView *)lineView{
    if (!_lineView) {
        _lineView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 0, 0)];
        [_lineView setBackgroundColor:GCOLOR];
    }
    return _lineView;
}

- (void)setCateArr:(NSArray *)cateArr{
    
    CGFloat x = 15;
    
    for (NSInteger i = 0 ; i < cateArr.count ; i ++) {

        NSString *name = cateArr[i][@"name"];
        
        CGFloat w = KHeight(name, 1000, 35, 15).size.width + 10;
        
        UIButton *btn = [Tools creatButton:CGRectMake(x, 15, w, 35) font:[UIFont systemFontOfSize:15] color:TCOLOR title:name image:@""];
        [btn setTag:i];
        [btn setTitleColor:GCOLOR forState:(UIControlStateNormal)];
        [btn addTarget:self action:@selector(buttonDidPress:) forControlEvents:(UIControlEventTouchUpInside)];
        [self.tmpScrollView addSubview:btn];
        
        [self.buttonArr addObject:btn];
        if (i==0) {
            [btn setSelected:YES];
            [self.lineView setFrame:CGRectMake(x+5, 48, w-10, 2)];
        }
    }
    
}

- (void)buttonDidPress:(UIButton *)sender{
    
    if (!sender.selected) {
        for (UIButton *button in self.buttonArr) {
            [button setSelected:NO];
        }
        
        [sender setSelected:YES];
        
        [self.delegate clickBtnIndex:sender.tag];
    }
    
    
    
}


@end
