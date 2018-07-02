//
//  ShareView.m
//  anjuyi1
//
//  Created by apple on 2018/6/26.
//  Copyright © 2018年 lsy. All rights reserved.
//

#import "ShareView.h"

#define KDOWNHEIGHT ([[UIApplication sharedApplication] statusBarFrame].size.height>20?34:0)

@interface ShareView ()

@property (nonatomic,strong)UIView *backView;

@end

@implementation ShareView

- (instancetype)initWithFrame:(CGRect)frame{
    
    if (self == [super initWithFrame:frame]) {
        [self setBackgroundColor:MDRGBA(0, 0, 0, .8)];
        [self setUpUI];
    }
    return self;
}

- (void)setUpUI{
    
    self.backView = [[UIView alloc] initWithFrame:CGRectMake(0, KScreenHeight , KScreenWidth , 175)];
    [self addSubview:self.backView];
    
    UIView * typeView = [[UIView alloc] initWithFrame:CGRectMake(10, 0, KScreenWidth - 20, 90)];
    [typeView setBackgroundColor:[UIColor whiteColor]];
    [typeView.layer setCornerRadius:5];
    [self.backView addSubview:typeView];
    
    CGFloat w = (KScreenWidth - 20)/5;
    
    NSArray *iArr = @[@"share-wx",@"share-friend",@"share-sina",@"share-qq",@"share-more"];
    
    NSArray *tArr = @[@"微信",@"朋友圈",@"微博",@"QQ",@"更多"];
    
    for (NSInteger i = 0; i < 5 ; i++) {
        UIView *tapView = [[UIView alloc] initWithFrame:CGRectMake(w * i, 0, w, 90)];
        [tapView setUserInteractionEnabled:YES];
        [tapView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tap:)]];
        [tapView setTag:i];
        [typeView addSubview:tapView];
        
        [tapView addSubview:[Tools creatImage:CGRectMake((w-30)/2, 20, 30, 30) image:iArr[i]]];
        
        [tapView addSubview:[Tools creatLabel:CGRectMake(0, 55, w, 20) font:[UIFont systemFontOfSize:12] color:[UIColor colorWithHexString:@"#666666"] alignment:(NSTextAlignmentCenter) title:tArr[i]]];
    }

}

- (void)tap:(UITapGestureRecognizer *)sender{
    
    [self.delegate shareToTypeWith:sender.view.tag];
    [self hidden];
}


#pragma mark -- 显示和隐藏
//显示
- (void)show{
    
    [self setHidden:NO];
    
    [UIView animateWithDuration:.3 animations:^{
        [self.backView setFrame:CGRectMake(0, KScreenHeight - 175 - KDOWNHEIGHT, KScreenWidth  , 175)];
        
    }];
}

- (void)hidden{
    
    [UIView animateWithDuration:.3 animations:^{
        
        [self.backView setFrame:CGRectMake(0, KScreenHeight, KScreenWidth, 175)];
    } completion:^(BOOL finished) {
        [self setHidden:YES];
        
    }];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    
    UITouch *touch = [touches anyObject];
    CGPoint touchPoint = [touch locationInView:self];
    
    if (touchPoint.y<(KScreenHeight - 175 - KDOWNHEIGHT)) {
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
