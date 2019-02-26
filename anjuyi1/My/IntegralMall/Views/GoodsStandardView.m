//
//  GoodsStandardView.m
//  anjuyi1
//
//  Created by 李 on 2018/5/31.
//  Copyright © 2018年 lsy. All rights reserved.
//
//  商品规格

#import "GoodsStandardView.h"
#import "ChannelButton.h"

@interface GoodsStandardView()

@property (nonatomic,strong)UIView         * backView;
@property (nonatomic,strong)UILabel        * allMoney;
@property (nonatomic,strong)UIScrollView   * tmpScrollView;

@property (nonatomic,strong)NSMutableArray * btnArr;

@property (nonatomic,strong)NSMutableArray * textArr;

@property (nonatomic,strong)NSMutableArray * fieldArr;
@property (nonatomic,strong)UITextField    * numTextField;


@end

@implementation GoodsStandardView

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
    
    self.backView = [[UIView alloc] initWithFrame:CGRectMake(0, KScreenHeight, KScreenWidth ,  MDXFrom6(400))];
    [self.backView setBackgroundColor:[UIColor whiteColor]];
    [self addSubview:self.backView];
    
    self.tmpScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, self.backView.frame.size.width, self.backView.frame.size.height - 50 )];
    [self.tmpScrollView setShowsVerticalScrollIndicator:NO];
    [self.tmpScrollView setShowsHorizontalScrollIndicator:NO];
    [self.backView addSubview:self.tmpScrollView];
    
    self.allMoney = [Tools creatLabel:CGRectMake(MDXFrom6(10), self.backView.frame.size.height - 50 , self.backView.frame.size.width/2 - MDXFrom6(20), 50) font:[UIFont systemFontOfSize:14] color:[UIColor blackColor] alignment:(NSTextAlignmentLeft) title:@"总计：231积分"];
    [self.backView addSubview:self.allMoney];
    
    UIButton *sureBtn = [Tools creatButton:CGRectMake(self.backView.frame.size.width/2, self.backView.frame.size.height - 50 , self.backView.frame.size.width/2, 50) font:[UIFont systemFontOfSize:14] color:[UIColor whiteColor] title:@"立即购买" image:@""];
    [sureBtn addTarget:self action:@selector(sure) forControlEvents:(UIControlEventTouchUpInside)];
    [sureBtn setBackgroundColor:[UIColor colorWithHexString:@"#ffb538"]];
    [self.backView addSubview:sureBtn];
    
    [self.backView addSubview:[Tools setLineView:CGRectMake(0, self.backView.frame.size.height - 50 ,self.backView.frame.size.width , 1)]];
}

- (void)setUpContentView{
    
    [self.tmpScrollView addSubview:[Tools creatImage:CGRectMake(MDXFrom6(10), MDXFrom6(25), MDXFrom6(70), MDXFrom6(70)) url:@"" image:@"designer_xq_img_case"]];
    
    [self.tmpScrollView addSubview:[Tools creatLabel:CGRectMake(MDXFrom6(90), MDXFrom6(25), MDXFrom6(270), MDXFrom6(70)) font:[UIFont systemFontOfSize:14] color:[UIColor blackColor] alignment:(NSTextAlignmentLeft) title:@"商品名字商品名字商品名字商品名字商品名字商品名字商品名字"]];
    
    
    CGFloat height = MDXFrom6(115);
    
    for (NSInteger i = 0 ; i < self.typeArr.count ; i++) {
        UILabel *typeLabel = [Tools creatLabel:CGRectMake(MDXFrom6(10), height, self.backView.frame.size.width - MDXFrom6(40), MDXFrom6(20)) font:[UIFont systemFontOfSize:16] color:[UIColor colorWithHexString:@"#999999"] alignment:(NSTextAlignmentLeft) title:self.typeArr[i]];
        [self.tmpScrollView addSubview:typeLabel];
        
        height += MDXFrom6(20+15);
        

        NSMutableArray *tmpBtn = [NSMutableArray array];
        
        NSInteger num = 4;
        
        for (NSInteger j = 0 ; j < [self.dataArr[i] count]; j++) {
            
            ChannelButton *stautsBtn = [self creatButton:CGRectMake(MDXFrom6(10+90*(j%num)), height+MDXFrom6(45*(j/num)), MDXFrom6(80),MDXFrom6(35)) font:[UIFont systemFontOfSize:14] color:[UIColor colorWithHexString:@"#000000"] title:self.dataArr[i][j]];
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
        
        height += MDXFrom6(45)* ceil([self.dataArr[i] count]/4.0) +MDXFrom6(25);
    }
    
    UILabel *numLabel = [Tools creatLabel:CGRectMake(MDXFrom6(10), height, self.backView.frame.size.width - MDXFrom6(40), MDXFrom6(20)) font:[UIFont systemFontOfSize:16] color:[UIColor colorWithHexString:@"#999999"] alignment:(NSTextAlignmentLeft) title:@"数量"];
    [self.tmpScrollView addSubview:numLabel];
    
    UIButton * addButton = [Tools creatButton:CGRectMake(KScreenWidth - MDXFrom6(35), height-MDXFrom6(10), MDXFrom6(35), MDXFrom6(40)) font:[UIFont systemFontOfSize:MDXFrom6(24)] color:[UIColor colorWithHexString:@"#333333"] title:@"+" image:@""];
    [addButton addTarget:self action:@selector(addButtonDidPress:) forControlEvents:(UIControlEventTouchUpInside)];
    [self.tmpScrollView addSubview:addButton];
    
    self.numTextField = [[UITextField alloc] initWithFrame:CGRectMake(KScreenWidth - MDXFrom6(85), height - MDXFrom6(10), MDXFrom6(50), MDXFrom6(40))];
    [self.numTextField setTextAlignment:(NSTextAlignmentCenter)];
    [self.numTextField setFont:[UIFont systemFontOfSize:MDXFrom6(18)]];
    [self.numTextField setTextColor:[UIColor colorWithHexString:@"#333333"]];
    [self.numTextField setKeyboardType:(UIKeyboardTypeNumberPad)];
    [self.tmpScrollView addSubview:self.numTextField];
    
    UIButton * subtractButton = [Tools creatButton:CGRectMake(KScreenWidth - MDXFrom6(120), height-MDXFrom6(10), MDXFrom6(35), MDXFrom6(40)) font:[UIFont systemFontOfSize:MDXFrom6(24)] color:[UIColor colorWithHexString:@"#999999"] title:@"-" image:@""];
    [subtractButton addTarget:self action:@selector(subtractButtonDidPress:) forControlEvents:(UIControlEventTouchUpInside)];
    [self.tmpScrollView addSubview:subtractButton];
    
    
    
    height += MDXFrom6(40);
    
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

- (void)addButtonDidPress:(UIButton *)sender{
    
    [self.numTextField setText:[NSString stringWithFormat:@"%ld",(long)([self.numTextField.text intValue]+1)]];
}

- (void)subtractButtonDidPress:(UIButton *)sender {
    
    if ([self.numTextField.text integerValue] > 1) {
        [self.numTextField setText:[NSString stringWithFormat:@"%ld",(long)([self.numTextField.text intValue]-1)]];
    }
    
    
    
}

//显示
- (void)show{
    
    [self setHidden:NO];
    
    [UIView animateWithDuration:.3 animations:^{
        [self.backView setFrame:CGRectMake(0,  KScreenHeight - MDXFrom6(400), KScreenWidth , MDXFrom6(400))];
        
    }];
}

- (void)hidden{
    
    [UIView animateWithDuration:.3 animations:^{
        
        [self.backView setFrame:CGRectMake(0, KScreenHeight, KScreenWidth  , MDXFrom6(400))];
    } completion:^(BOOL finished) {
        [self setHidden:YES];
        
    }];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    
    UITouch *touch = [touches anyObject];
    CGPoint touchPoint = [touch locationInView:self];
    
    if (touchPoint.y<KScreenHeight - MDXFrom6(400)) {
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
