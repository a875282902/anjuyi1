//
//  StandardView.m
//  anjuyi1
//
//  Created by 李 on 2018/5/31.
//  Copyright © 2018年 lsy. All rights reserved.
//

#import "StandardView.h"
#import "ChannelButton.h"

@interface StandardView()

@property (nonatomic,strong)UIView         * backView;

@property (nonatomic,strong)UIScrollView   * tmpScrollView;

@property (nonatomic,strong)NSMutableArray * btnArr;

@property (nonatomic,strong)NSMutableArray * textArr;

@property (nonatomic,strong)NSMutableArray * fieldArr;

@end

@implementation StandardView

- (instancetype)initWithFrame:(CGRect)frame{
    
    if (self == [super initWithFrame:frame]) {
        
        [self setHidden:YES];
        
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
    
    [self.backView addSubview:[Tools creatLabel:CGRectMake(20, 20,self.backView.frame.size.width - 40 , 20) font:[UIFont systemFontOfSize:15] color:[UIColor blackColor] alignment:(NSTextAlignmentLeft) title:@"全程监理服务"]];
    
    [self.backView addSubview:[Tools creatLabel:CGRectMake(20, 55,self.backView.frame.size.width - 40 , 20) font:[UIFont systemFontOfSize:15] color:[UIColor redColor] alignment:(NSTextAlignmentLeft) title:@"￥20元/平米"]];
    
    [self.backView addSubview:[Tools setLineView:CGRectMake(0, 79, self.backView.frame.size.width, 1)]];
    
    self.tmpScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 80, self.backView.frame.size.width, self.backView.frame.size.height - 130 )];
    [self.tmpScrollView setShowsVerticalScrollIndicator:NO];
    [self.tmpScrollView setShowsHorizontalScrollIndicator:NO];
    [self.backView addSubview:self.tmpScrollView];
    
    UIButton *sureBtn = [Tools creatButton:CGRectMake(0, self.backView.frame.size.height - 50 , self.backView.frame.size.width, 50) font:[UIFont systemFontOfSize:14] color:[UIColor whiteColor] title:@"立即购买" image:@""];
    [sureBtn addTarget:self action:@selector(sure) forControlEvents:(UIControlEventTouchUpInside)];
    [sureBtn setBackgroundColor:[UIColor colorWithHexString:@"#ffb538"]];
    [self.backView addSubview:sureBtn];
    
    [self.backView addSubview:[Tools setLineView:CGRectMake(0, self.backView.frame.size.height - 50 ,self.backView.frame.size.width , 1)]];
}

- (void)setUpContentView{
    
    CGFloat height = MDXFrom6(30);
    
    for (NSInteger i = 0 ; i < self.typeArr.count ; i++) {
        UILabel *typeLabel = [Tools creatLabel:CGRectMake(MDXFrom6(20), height, self.backView.frame.size.width - MDXFrom6(40), MDXFrom6(20)) font:[UIFont systemFontOfSize:17] color:[UIColor blackColor] alignment:(NSTextAlignmentLeft) title:self.typeArr[i]];
        [self.tmpScrollView addSubview:typeLabel];
        
        height += MDXFrom6(20+20);
        
        
        NSMutableArray *tmpBtn = [NSMutableArray array];
        
        CGFloat X = 20;
        CGFloat W = 0;
        
        for (NSInteger j = 0 ; j < [self.dataArr[i] count]; j++) {
            
            CGRect rext = [self.dataArr[i][j] boundingRectWithSize:CGSizeMake(100000, MDXFrom6(35)) options:NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:14]} context:nil];
            
            W = rext.size.width + 20;
            
            if (X + W > self.tmpScrollView.frame.size.width - 20) {
                height += MDXFrom6(45);
                X = 20;
            }

    
            ChannelButton *stautsBtn = [self creatButton:CGRectMake(X, height, W, MDXFrom6(35)) font:[UIFont systemFontOfSize:14] color:[UIColor colorWithHexString:@"#3b3b3b"] title:self.dataArr[i][j]];
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
            
            X += W +10;
            
        }
        
        [self.btnArr addObject:tmpBtn];
        
        height += MDXFrom6(80);
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
    
    [self.textArr replaceObjectAtIndex:sender.tag withObject:sender.text];
}

//确定选择
- (void)sure{
    
    [self hidden];
    
    [self.delegate sureBuyWithDictionary:nil];
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
