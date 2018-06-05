//
//  SelectTime.m
//  anjuyi1
//
//  Created by 李 on 2018/6/5.
//  Copyright © 2018年 lsy. All rights reserved.
//

#import "SelectTime.h"

@interface SelectTime ()

@property (nonatomic,strong)UIView *backView;

@end

@implementation SelectTime

- (instancetype)initWithFrame:(CGRect)frame{
    
    if (self == [super initWithFrame:frame]) {
        [self setHidden:YES];
        [self setUpBackView];
    }
    return self;
}

- (void)setUpBackView{
    
    self.backView = [[UIView alloc] initWithFrame:CGRectMake(KScreenWidth - 180, 0, 180, 180)];
    [self.backView setBackgroundColor:[UIColor colorWithHexString:@"#f7f7f7"]];
    [self addSubview:self.backView];
    
    
    NSArray *tArr = @[@"请选择开始时间",@"请选择结束时间"];
    
    for (NSInteger i = 0 ; i < 2 ; i++) {
        
        UIView *back = [[UIView alloc] initWithFrame:CGRectMake(0, 50*i, 180, 50)];
        [back setTag:i];
        [back addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(selectTime:)]];
        [self.backView addSubview:back];
        
        [back addSubview:[Tools creatLabel:CGRectMake(10, 0, 140, 50) font:[UIFont systemFontOfSize:15] color:[UIColor colorWithHexString:@"#999999"] alignment:(NSTextAlignmentLeft) title:tArr[i]]];
        
        [back addSubview:[Tools creatImage:CGRectMake(155, 20, 6, 10) image:@"jilu_rili_arrow"]];
        
        UIView *line = [[UIView alloc] initWithFrame:CGRectMake(10, 49, 160, 1)];
        [line setBackgroundColor:[UIColor colorWithHexString:@"#dddddd"]];
        [back addSubview:line];
        
    }
    
    UIButton *sureBtn = [Tools creatButton:CGRectMake(10, 120, 160, 40) font:[UIFont systemFontOfSize:15] color:[UIColor whiteColor] title:@"确定" image:@""];
    [sureBtn setBackgroundColor:[UIColor colorWithHexString:@"#FFB638"]];
    [sureBtn.layer setCornerRadius:4];
    [sureBtn setClipsToBounds:YES];
    [sureBtn addTarget:self action:@selector(sureBtnDidPress) forControlEvents:(UIControlEventTouchUpInside)];
    [self.backView addSubview:sureBtn];
    
    
    
}

- (void)selectTime:(UITapGestureRecognizer *)sender{
    
    
}

- (void)sureBtnDidPress{
    
    [self setHidden:YES];
}

- (void)show{
    [self setHidden:NO];
}

- (void)hidden{
    [self setHidden:YES];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    
    UITouch *touch = [touches anyObject];
    CGPoint touchPoint = [touch locationInView:self];
    
    if (touchPoint.x>(KScreenWidth - 180) && touchPoint.y<180) {
        
    }
    else{
        [self hidden];
    }
}


/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
