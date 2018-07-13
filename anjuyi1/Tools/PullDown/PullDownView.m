//
//  PullDownView.m
//  anjuyi1
//
//  Created by apple on 2018/7/13.
//  Copyright © 2018年 lsy. All rights reserved.
//

#import "PullDownView.h"
#import "YZCover.h"

// 更新下拉菜单标题通知名称
NSString * const YZUpdateMenuTitle = @"YZUpdateMenuTitleNote";

@interface  PullDownView ()
{
    UIButton *_selectBtn;
}

@property (nonatomic,strong)YZCover * coverView;
@property (nonatomic,strong)UIView  * contentView;
@property (nonatomic, weak)   id      observer;

@end

@implementation PullDownView


- (UIView *)coverView
{
    if (_coverView == nil) {

        // 设置蒙版的frame
        CGFloat coverX = 0;
        CGFloat coverY = 0;
        CGFloat coverW = self.superview.frame.size.width;
        CGFloat coverH = self.superview.bounds.size.height;
        _coverView = [[YZCover alloc] initWithFrame:CGRectMake(coverX, coverY, coverW, coverH)];
//        _coverView.backgroundColor = MDRGBA(0, 0, 0, .7);
        [self.superview addSubview:_coverView];

        // Cover 的 Block
        __weak typeof(self) weakSelf = self;
        _coverView.clickCover = ^{ // 点击蒙版调用
            [weakSelf dismiss];
        };
    }
    return _coverView;
}

- (UIView *)contentView
{
    if (_contentView == nil) {
        _contentView = [[UIView alloc] init];
        _contentView.backgroundColor = [UIColor whiteColor];
        _contentView.frame = CGRectMake(0, 0, self.bounds.size.width, 0);
        _contentView.clipsToBounds = YES;
        [_coverView.layer setBorderColor:[UIColor colorWithHexString:@"#d1d1d1"].CGColor];
        [_coverView.layer setBorderWidth:1];
        [self.coverView addSubview:_contentView];
    }
    return _contentView;
}

- (instancetype)init{
    
    if (self == [super init]) {
        
      _observer = [[NSNotificationCenter defaultCenter] addObserverForName:YZUpdateMenuTitle object:nil queue:[NSOperationQueue mainQueue] usingBlock:^(NSNotification * _Nonnull note) {
         
            // 隐藏下拉菜单
            [self dismiss];
            
            // 获取所有值
            NSArray *allValues = note.userInfo.allValues;
            
            // 不需要设置标题,字典个数大于1，或者有数组
            if (allValues.count > 1 || [allValues.firstObject isKindOfClass:[NSArray class]]) return ;
            
            // 设置按钮标题
            [self->_selectBtn setTitle:allValues.firstObject forState:UIControlStateNormal];
            
        }];
    }
    return self;
}


- (void)showOrHidden:(BOOL)isShow withFrame:(CGRect)frame button:(UIButton *)btn view:(UIView *)showView{
    
    _selectBtn = btn;
    
    [self.coverView setHidden:isShow];
    [self.contentView setBackgroundColor:[UIColor blackColor]];
    
    [self.contentView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    
    CGRect fra = frame;
    fra.size.height = 0;
    [self.contentView setFrame:fra];
    
    showView.frame = self.contentView.bounds;
    [self.contentView addSubview:showView];
    
    [UIView animateWithDuration:.2 animations:^{
        
        [self.contentView setFrame:frame];
    }];
    
}

- (void)dismiss{
    
    // 移除蒙版
    self.coverView.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0];
    
    _selectBtn.selected = !_selectBtn.selected;
    
    [UIView animateWithDuration:0.25 animations:^{
        
        CGRect frame = self.contentView.frame;
        frame.size.height = 0;
        self.contentView.frame = frame;
        
    } completion:^(BOOL finished) {
        
        self.coverView.hidden = YES;
        
        self.coverView.backgroundColor = self->_coverColor;
        
    }];
}

#pragma mark - 界面销毁
- (void)dealloc
{
    
    [[NSNotificationCenter defaultCenter] removeObserver:_observer];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
