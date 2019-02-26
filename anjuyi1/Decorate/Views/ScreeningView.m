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

@property (nonatomic,strong)NSMutableArray * sureArr;

@property (nonatomic,strong)NSMutableArray * priceArr;

@end

@implementation ScreeningView

- (instancetype)initWithFrame:(CGRect)frame{
    
    if (self == [super initWithFrame:frame]) {

        [self setHidden:YES];
        
        [self setBackgroundColor:MDRGBA(0, 0, 0, 0.8)];
        [self setUpView];
        
        self.textArr = [NSMutableArray arrayWithObjects:@"",@"", NULL];
        self.fieldArr = [NSMutableArray array];
        self.sureArr = [NSMutableArray array];
        self.priceArr = [NSMutableArray array];
        
    }
    return self;
}
- (void)setDataArr:(NSMutableArray *)dataArr{
    
    _dataArr = dataArr;
    self.btnArr = [NSMutableArray array];
    [self setUpContentView];
    
}
- (void)setUpView{
    
    self.backView = [[UIView alloc] initWithFrame:CGRectMake(KScreenWidth, 0, KScreenWidth - MDXFrom6(50) , KScreenHeight)];
    [self.backView setBackgroundColor:[UIColor whiteColor]];
    [self addSubview:self.backView];
    
    self.tmpScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, self.backView.frame.size.width, self.backView.frame.size.height - 50 )];
    [self.tmpScrollView setShowsVerticalScrollIndicator:NO];
    [self.tmpScrollView setShowsHorizontalScrollIndicator:NO];
    [self.backView addSubview:self.tmpScrollView];
    
    UIButton *resetBtn = [Tools creatButton:CGRectMake(0, self.backView.frame.size.height - 50 - KPlaceHeight , self.backView.frame.size.width/2, 50) font:[UIFont systemFontOfSize:14] color:[UIColor blackColor] title:@"重置" image:@""];
    [resetBtn addTarget:self action:@selector(reset) forControlEvents:(UIControlEventTouchUpInside)];
    [self.backView addSubview:resetBtn];
    
    
    UIButton *sureBtn = [Tools creatButton:CGRectMake(self.backView.frame.size.width/2, self.backView.frame.size.height - 50 - KPlaceHeight, self.backView.frame.size.width/2, 50) font:[UIFont systemFontOfSize:14] color:[UIColor whiteColor] title:@"确定" image:@""];
    [sureBtn addTarget:self action:@selector(sure) forControlEvents:(UIControlEventTouchUpInside)];
    [sureBtn setBackgroundColor:[UIColor colorWithHexString:@"#ffb538"]];
    [self.backView addSubview:sureBtn];
    
    [self.backView addSubview:[Tools setLineView:CGRectMake(0, self.backView.frame.size.height - 50 -KPlaceHeight ,self.backView.frame.size.width , 1)]];
}

- (void)setUpContentView{
    
    CGFloat height = MDXFrom6(30)+KStatusBarHeight;
    
    [self.sureArr removeAllObjects];
    
    for (NSInteger i = 0 ; i < self.typeArr.count ; i++) {
        UILabel *typeLabel = [Tools creatLabel:CGRectMake(MDXFrom6(20), height, self.backView.frame.size.width - MDXFrom6(40), MDXFrom6(20)) font:[UIFont systemFontOfSize:17] color:[UIColor blackColor] alignment:(NSTextAlignmentLeft) title:self.typeArr[i]];
        [self.tmpScrollView addSubview:typeLabel];
        
        height += MDXFrom6(20+20);
        
        NSArray * arr = self.dataArr[i];
        
        if (arr.count >0 && [arr[0] isKindOfClass:[NSDictionary class]]) {
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
            
            NSString *title = @"";
            
            if ([self.dataArr[i][j] isKindOfClass:[NSDictionary class]]) {
                NSDictionary *dic = self.dataArr[i][j];
                title = [NSString stringWithFormat:@"%@-%@\n%@的选择",dic[@"min"],dic[@"max"],dic[@"Percentage"]];
                [self.priceArr addObject:self.dataArr[i][j]];
            }
            else{
                title = self.dataArr[i][j];
            }

            ChannelButton *stautsBtn = [self creatButton:CGRectMake(MDXFrom6(20+95*(j%3)), height+MDXFrom6(45*(j/3)), MDXFrom6(85), i==1?MDXFrom6(40):MDXFrom6(35)) font:[UIFont systemFontOfSize:i==1?12:14] color:[UIColor colorWithHexString:@"#3b3b3b"] title:title];
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
        
        [self.sureArr addObject:@"-1"];
        
        height += MDXFrom6(45)* ceil([self.dataArr[i] count]/3.0) +MDXFrom6(40);
    }
    
    [self.tmpScrollView setContentSize:CGSizeMake(self.tmpScrollView.frame.size.width, height)];
    
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
    
    if (![self.sureArr[1] isKindOfClass:[NSDictionary class]]) {
        if ([self.sureArr[1] integerValue]>=0) {
            for (ChannelButton *btn in self.btnArr[1]) {
                [btn setSelected:NO];
            }
            
            [self.sureArr replaceObjectAtIndex:1 withObject:@"-1"];
        }
        
    }

    [self.textArr replaceObjectAtIndex:sender.tag withObject:sender.text];
    
    NSDictionary *dic = @{@"min":self.textArr[0],
                          @"max":self.textArr[1]};
    [self.sureArr replaceObjectAtIndex:1 withObject:dic];
}

//确定选择
- (void)sure{
    [self.delegate sureScreenData:self.sureArr];
    [self hidden];
}
//重置
- (void)reset{
    
    for (NSArray *ar in self.btnArr) {
        for (ChannelButton *btn in ar) {
            [btn setSelected:NO];
        }
    }
    
    for (NSInteger i = 0 ; i < self.sureArr.count; i++) {
        [self.sureArr replaceObjectAtIndex:i withObject:@"-1"];
    }
    
    for (UITextField *text in self.fieldArr) {
        [text setText:@""];
    }
    
    self.textArr = [NSMutableArray arrayWithObjects:@"",@"", nil];
}

- (void)buttonDidPress:(ChannelButton *)sender{
    
    if (sender.selected) {
        [sender setSelected:NO];
        
        NSInteger i = sender.tag/100;
        [self.sureArr replaceObjectAtIndex:i withObject:@"-1"];
    }
    else{
    
        NSInteger i = sender.tag/100;
        NSInteger j = sender.tag%100;
        
        for (ChannelButton *btn in self.btnArr[i]) {
            [btn setSelected:NO];
        }
        
        [sender setSelected:YES];
        
        [self.sureArr replaceObjectAtIndex:i withObject:[NSString stringWithFormat:@"%ld",(long)j]];
        
        NSArray *arr = self.dataArr[i];
        
        if (arr.count >0 && [arr[0] isKindOfClass:[NSDictionary class]]) {
            NSDictionary *dic = self.priceArr[j];
            [((UITextField *)self.fieldArr[0]) setText:[NSString stringWithFormat:@"%@",dic[@"min"]]];
            [((UITextField *)self.fieldArr[1]) setText:[NSString stringWithFormat:@"%@",dic[@"max"]]];
            
            self.textArr = [NSMutableArray arrayWithObjects:[NSString stringWithFormat:@"%@",dic[@"min"]],[NSString stringWithFormat:@"%@",dic[@"max"]], nil];
            
        }
    }
}

//显示
- (void)show{
    
    [self setHidden:NO];
    
    [UIView animateWithDuration:.3 animations:^{
        [self.backView setFrame:CGRectMake(MDXFrom6(50), 0, KScreenWidth - MDXFrom6(50) , KScreenHeight )];
        
    }];
}

- (void)hidden{
    
    [UIView animateWithDuration:.3 animations:^{
        
        [self.backView setFrame:CGRectMake(KScreenWidth, 0, KScreenWidth - MDXFrom6(50) , KScreenHeight )];
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
