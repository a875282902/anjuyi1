//
//  DataView.m
//  anjuyi1
//
//  Created by 李 on 2018/6/8.
//  Copyright © 2018年 lsy. All rights reserved.
//

#import "DateView.h"

static CGFloat vHeight = 250;

static CGFloat sHeight = 50;

@interface DateView()
{
    NSString *time;
}

@property (nonatomic,strong)UIDatePicker *tmpDataPicker;

@property (nonatomic,strong)UIView *backView;

@end

@implementation DateView


- (instancetype)initWithFrame:(CGRect)frame{
    
    if (self == [super initWithFrame:frame]) {
    
        [self setBackgroundColor:MDRGBA(0, 0, 0, 0.8)];
        [self setUpUI];
        [self setHidden:YES];
    }
    
    return self;
}

- (void)setUpUI{
    
    self.backView = [[UIView alloc] initWithFrame:CGRectMake(0, KScreenHeight , KScreenWidth, vHeight)];
    [self.backView setBackgroundColor:[UIColor whiteColor]];
    [self addSubview:self.backView];
    
    [self.backView addSubview:self.tmpDataPicker];
    
    UIButton *cancel = [UIButton buttonWithType:(UIButtonTypeCustom)];
    [cancel setFrame:CGRectMake(0, 0 , 60, sHeight)];
    [cancel addTarget:self action:@selector(cancelDidPress) forControlEvents:(UIControlEventTouchUpInside)];
    [cancel setTitleColor:[UIColor blackColor] forState:(UIControlStateNormal)];
    [cancel setTitle:@"取消" forState:(UIControlStateNormal)];
    [self.backView addSubview:cancel];
    
    UIButton *sure = [UIButton buttonWithType:(UIButtonTypeCustom)];
    [sure setFrame:CGRectMake(KScreenWidth - 60, 0 , 60, sHeight)];
    [sure addTarget:self action:@selector(sureDidPress) forControlEvents:(UIControlEventTouchUpInside)];
    [sure setTitleColor:[UIColor blackColor] forState:(UIControlStateNormal)];
    [sure setTitle:@"确定" forState:(UIControlStateNormal)];
    [self.backView addSubview:sure];
    
    
    [self.backView addSubview:[Tools setLineView:CGRectMake(0, sHeight, KScreenWidth, 1)]];
}

- (UIDatePicker *)tmpDataPicker{
    
    if (!_tmpDataPicker) {
        _tmpDataPicker = [[UIDatePicker alloc] initWithFrame:CGRectMake(0, sHeight, KScreenWidth, vHeight-sHeight)];
        [_tmpDataPicker setLocale:[[NSLocale alloc] initWithLocaleIdentifier:@"zh_CN"]];
        // 设置时区
        [_tmpDataPicker setTimeZone:[NSTimeZone localTimeZone]];
        // 设置当前显示时间
        [_tmpDataPicker setDate:[NSDate dateWithTimeIntervalSince1970:0]     animated:YES];
        // 设置UIDatePicker的显示模式
        [_tmpDataPicker setMaximumDate:[NSDate dateWithTimeIntervalSinceNow:0]];
        [_tmpDataPicker setDatePickerMode:UIDatePickerModeDate];
        // 当值发生改变的时候调用的方法
        [_tmpDataPicker addTarget:self action:@selector(datePickerValueChanged:) forControlEvents:UIControlEventValueChanged];
    }
    return _tmpDataPicker;
}

- (void)cancelDidPress{
    
    [self hidden];
}

- (void)sureDidPress{
    
    if (!time) {
        NSDateFormatter *dateFormatter=[[NSDateFormatter alloc]init];
        dateFormatter.dateFormat=@"yyyy-MM-dd";
        time = [dateFormatter stringFromDate:self.tmpDataPicker.date];
    }
    
    [self.delegate selectCurrentTime:time];
    [self hidden];
}

- (void)datePickerValueChanged:(UIDatePicker *)sender{
    
    NSDateFormatter *dateFormatter=[[NSDateFormatter alloc]init];//创建一个日期格式化器
    
    dateFormatter.dateFormat=@"yyyy-MM-dd";//指定转date得日期格式化形式
    
    time = [dateFormatter stringFromDate:sender.date];
}

- (void)show{
    
    [self setHidden:NO];
    
    [UIView animateWithDuration:.3 animations:^{
        [self.backView setFrame:CGRectMake(0, KScreenHeight - vHeight, KScreenWidth, vHeight)];
    }];
}

- (void)hidden{
    
    [UIView animateWithDuration:.3 animations:^{
        [self.backView setFrame:CGRectMake(0, KScreenHeight , KScreenWidth, vHeight)];
    } completion:^(BOOL finished) {
       
        if (finished) {
            [self setHidden:YES];
        }
    }];
    
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    
    UITouch *touc = [touches anyObject];
    
    CGPoint p =  [touc locationInView:self];
    
    if (p.y < KScreenHeight - vHeight) {
        [self hidden];
    }
    
}

@end
