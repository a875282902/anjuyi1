//
//  ScreeningView.m
//  anjuyi1
//
//  Created by 李 on 2018/5/31.
//  Copyright © 2018年 lsy. All rights reserved.
//

#import "ScreeningView.h"
#import "ChannelButton.h"

@interface ScreeningView()

@property (nonatomic,strong)UIView         * backView;

@property (nonatomic,strong)UIScrollView   * tmpScrollView;

@property (nonatomic,strong)NSMutableArray * btnArr;

@property (nonatomic,strong)NSMutableArray * textArr;

@property (nonatomic,strong)NSMutableArray * fieldArr;

@end

@implementation ScreeningView

- (instancetype)initWithFrame:(CGRect)frame{
    
    if (self == [super initWithFrame:frame]) {

        [self setBackgroundColor:MDRGBA(0, 0, 0, 0.8)];
        [self setUpView];
        
        self.textArr = [NSMutableArray arrayWithObjects:@"",@"", NULL];
        self.fieldArr = [NSMutableArray array];
        
    }
    return self;
}
- (void)setDataArr:(NSMutableArray *)dataArr{
    
    _dataArr = dataArr;
    self.btnArr = [NSMutableArray array];
    [self setUpContentView];
    
}
- (void)setUpView{
    
    self.backView = [[UIView alloc] initWithFrame:CGRectMake(KScreenWidth, KStatusBarHeight, KScreenWidth - MDXFrom6(50) , KScreenHeight - KStatusBarHeight)];
    [self.backView setBackgroundColor:[UIColor whiteColor]];
    [self addSubview:self.backView];
    
    self.tmpScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, self.backView.frame.size.width, self.backView.frame.size.height - 50 )];
    [self.backView addSubview:self.tmpScrollView];
    
    UIButton *resetBtn = [Tools creatButton:CGRectMake(0, self.backView.frame.size.height - 50 , self.backView.frame.size.width/2, 50) font:[UIFont systemFontOfSize:14] color:[UIColor blackColor] title:@"重置" image:@""];
    [resetBtn addTarget:self action:@selector(reset) forControlEvents:(UIControlEventTouchUpInside)];
    [self.backView addSubview:resetBtn];
    
    
    UIButton *sureBtn = [Tools creatButton:CGRectMake(self.backView.frame.size.width/2, self.backView.frame.size.height - 50 , self.backView.frame.size.width/2, 50) font:[UIFont systemFontOfSize:14] color:[UIColor whiteColor] title:@"确定" image:@""];
    [sureBtn addTarget:self action:@selector(sure) forControlEvents:(UIControlEventTouchUpInside)];
    [sureBtn setBackgroundColor:[UIColor orangeColor]];
    [self.backView addSubview:sureBtn];
    
    [self.backView addSubview:[Tools setLineView:CGRectMake(0, self.backView.frame.size.height - 50 ,self.backView.frame.size.width , 1)]];
}

- (void)setUpContentView{
    
    CGFloat height = MDXFrom6(30);
    
    for (NSInteger i = 0 ; i < self.typeArr.count ; i++) {
        UILabel *typeLabel = [Tools creatLabel:CGRectMake(MDXFrom6(20), height, self.backView.frame.size.width - MDXFrom6(40), MDXFrom6(20)) font:[UIFont systemFontOfSize:17] color:[UIColor blackColor] alignment:(NSTextAlignmentLeft) title:self.typeArr[i]];
        [self.tmpScrollView addSubview:typeLabel];
        
        height += MDXFrom6(20+20);
        
        if (i==1) {
            for (NSInteger i = 0 ; i < 2 ; i ++) {
                UITextField *textFeild = [[UITextField alloc] initWithFrame:CGRectMake(MDXFrom6(20+140*i), height, MDXFrom6(135), MDXFrom6(35))];
                [textFeild setPlaceholder:i==0?@"最低价":@"最高价"];
                [textFeild setTag:i];
                [textFeild setKeyboardType:(UIKeyboardTypeNumberPad)];
                [textFeild addTarget:self action:@selector(textValueChange:) forControlEvents:(UIControlEventEditingChanged)];
                [textFeild setTextAlignment:(NSTextAlignmentCenter)];
                [textFeild setBorderStyle:(UITextBorderStyleRoundedRect)];
                [textFeild setBackgroundColor:[UIColor colorWithHexString:@"#efefef"]];
                [self.tmpScrollView addSubview:textFeild];
                
                [self.fieldArr addObject:textFeild];
            }
            
            height += MDXFrom6(45);
        }
        
        
        NSMutableArray *tmpBtn = [NSMutableArray array];
        
        for (NSInteger j = 0 ; j < [self.dataArr[i] count]; j++) {
            
            ChannelButton *stautsBtn = [self creatButton:CGRectMake(MDXFrom6(20+95*(j%3)), height+MDXFrom6(45*(j/3)), MDXFrom6(85), i==1?MDXFrom6(40):MDXFrom6(35)) font:[UIFont systemFontOfSize:i==1?12:14] color:[UIColor colorWithHexString:@"#3b3b3b"] title:self.dataArr[i][j]];
            [stautsBtn.layer setCornerRadius:5];
            [stautsBtn setClipsToBounds:YES];
            [stautsBtn setBackgroundColor:[UIColor colorWithHexString:@"#efefef"]];
            [stautsBtn setSelected:NO];
            [stautsBtn.titleLabel setNumberOfLines:0];
            [stautsBtn.titleLabel setTextAlignment:(NSTextAlignmentCenter)];
            [stautsBtn setTag:(i*100+j)];
            [stautsBtn addTarget:self action:@selector(buttonDidPress:) forControlEvents:(UIControlEventTouchUpInside)];
            [self.tmpScrollView addSubview:stautsBtn];
            
            [tmpBtn addObject:stautsBtn];
            
        }
        
        [self.btnArr addObject:tmpBtn];
        
        height += MDXFrom6(45)* ceil([self.dataArr[i] count]/3.0) +MDXFrom6(40);
        
        
    }
    
    
}
- (ChannelButton *)creatButton:(CGRect)rect font:(UIFont *)font color:(UIColor *)color title:(NSString *)title {
    
    ChannelButton *btn = [ChannelButton buttonWithType:(UIButtonTypeCustom)];
    [btn setFrame:rect];
    [btn setTitle:title forState:(UIControlStateNormal)];
    [btn.titleLabel setFont:font];
    [btn setTitleColor:color forState:(UIControlStateNormal)];
    return btn;
}
#pragma mark -- 事件

//价钱区间
- (void)textValueChange:(UITextField *)sender{
    
    [self.textArr replaceObjectAtIndex:sender.tag withObject:sender.text];
}

//确定选择
- (void)sure{
    
    [self hidden];
}
//重置
- (void)reset{
    
    for (NSArray *ar in self.btnArr) {
        for (ChannelButton *btn in ar) {
            [btn setSelected:NO];
        }
    }
    
    for (UITextField *text in self.fieldArr) {
        [text setText:@""];
    }
    
    self.textArr = [NSMutableArray arrayWithObjects:@"",@"", nil];
}

- (void)buttonDidPress:(ChannelButton *)sender{
    
    if (sender.selected) {
        [sender setSelected:NO];
    }
    else{
    
        NSInteger i = sender.tag/100;
    //    NSInteger j = sender.tag%100;
        
        for (ChannelButton *btn in self.btnArr[i]) {
            [btn setSelected:NO];
        }
        
        [sender setSelected:YES];
        
        
    }
}

//显示
- (void)show{
    
    [self setHidden:NO];
    
    [UIView animateWithDuration:.3 animations:^{
        [self.backView setFrame:CGRectMake(MDXFrom6(50), KStatusBarHeight, KScreenWidth - MDXFrom6(50) , KScreenHeight - KStatusBarHeight)];
        
    }];
}

- (void)hidden{
    
    [UIView animateWithDuration:.3 animations:^{
        
        [self.backView setFrame:CGRectMake(KScreenWidth, KStatusBarHeight, KScreenWidth - MDXFrom6(50) , KScreenHeight - KStatusBarHeight)];
    } completion:^(BOOL finished) {
        [self setHidden:YES];
      
    }];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    
    UITouch *touch = [touches anyObject];
    CGPoint touchPoint = [touch locationInView:self];
    
    if (touchPoint.x<MDXFrom6(50)) {
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
