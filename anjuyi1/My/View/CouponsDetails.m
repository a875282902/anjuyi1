//
//  ScreeningView.m
//  anjuyi1
//
//  Created by 李 on 2018/5/31.
//  Copyright © 2018年 lsy. All rights reserved.
//

#import "CouponsDetails.h"

#define Kwidth KScreenWidth - MDXFrom6(20)

@interface CouponsDetails()

@property (nonatomic,strong)UIView         * backView;
@property (nonatomic,strong)UILabel        * titleLabel;
@property (nonatomic,strong)UILabel        * descLabel;
@property (nonatomic,strong)UILabel        * useLabel;
@property (nonatomic,strong)UILabel        * timeLabel;

@end

@implementation CouponsDetails

- (instancetype)initWithFrame:(CGRect)frame{
    
    if (self == [super initWithFrame:frame]) {
        
        [self setBackgroundColor:MDRGBA(0, 0, 0, 0.8)];
        [self setUpView];
        
    }
    return self;
}
- (void)setDataArr:(NSMutableArray *)dataArr{
    
    _dataArr = dataArr;
//    [self setUpContentView];
    
}
- (void)setUpView{
    
    self.backView = [[UIView alloc] initWithFrame:CGRectMake(MDXFrom6(10), KScreenHeight,Kwidth ,  MDXFrom6(280))];
    [self.backView setBackgroundColor:[UIColor whiteColor]];
    [self.backView.layer setCornerRadius:10];
    [self.backView setClipsToBounds:YES];
    [self addSubview:self.backView];
    
    self.titleLabel = [Tools creatLabel:CGRectMake(0, 0, Kwidth, MDXFrom6(55)) font:[UIFont systemFontOfSize:18] color:[UIColor blackColor] alignment:(NSTextAlignmentCenter) title:@"8折商品优惠"];
    [self.backView addSubview:self.titleLabel];
    
    UIButton *back = [Tools creatButton:CGRectMake(Kwidth - MDXFrom6(40), 0, MDXFrom6(40), MDXFrom6(40)) font:[UIFont systemFontOfSize:1] color:[UIColor whiteColor] title:@"" image:@"yhq_close"];
    [back addTarget:self action:@selector(back) forControlEvents:(UIControlEventTouchUpInside)];
    [self.backView addSubview:back];
    
    [self.backView addSubview:[Tools setLineView:CGRectMake(0, MDXFrom6(55), KScreenWidth, 1.5)]];
    
    self.descLabel = [Tools creatLabel:CGRectMake(MDXFrom6(20), MDXFrom6(75), Kwidth - MDXFrom6(40), MDXFrom6(20)) font:[UIFont systemFontOfSize:15] color:[UIColor blackColor] alignment:(NSTextAlignmentLeft) title:@"优惠详情：本优惠券限购买装修建材类。"];
    [self.backView addSubview:self.descLabel];
    
    self.useLabel = [Tools creatLabel:CGRectMake(MDXFrom6(20), MDXFrom6(95), Kwidth - MDXFrom6(40), MDXFrom6(20)) font:[UIFont systemFontOfSize:15] color:[UIColor blackColor] alignment:(NSTextAlignmentLeft) title:@"适用范围：砂石、水泥分类。"];
    [self.backView addSubview:self.useLabel];
    
    self.timeLabel = [Tools creatLabel:CGRectMake(MDXFrom6(20), MDXFrom6(115), Kwidth - MDXFrom6(40), MDXFrom6(20)) font:[UIFont systemFontOfSize:15] color:[UIColor blackColor] alignment:(NSTextAlignmentLeft) title:@"有效时期：2018年6月30日截止。"];
    [self.backView addSubview:self.timeLabel];

}



//显示
- (void)show{
    
    [self setHidden:NO];
    
    [UIView animateWithDuration:.3 animations:^{
        [self.backView setFrame:CGRectMake(MDXFrom6(10), KScreenHeight - MDXFrom6(290), KScreenWidth - MDXFrom6(20) , MDXFrom6(280))];
        
    }];
}

- (void)hidden{
    
    [UIView animateWithDuration:.3 animations:^{
        
        [self.backView setFrame:CGRectMake(MDXFrom6(10), KScreenHeight, KScreenWidth - MDXFrom6(20) ,MDXFrom6(280))];
    } completion:^(BOOL finished) {
        [self setHidden:YES];
        
    }];
}

- (void)back{
    
    [self hidden];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    
    UITouch *touch = [touches anyObject];
    CGPoint touchPoint = [touch locationInView:self];
    
    if (touchPoint.y<(KScreenHeight - MDXFrom6(290))) {
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
