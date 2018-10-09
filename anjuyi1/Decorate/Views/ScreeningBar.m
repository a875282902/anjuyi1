//
//  ScreeningBar.m
//  anjuyi1
//
//  Created by 李 on 2018/5/31.
//  Copyright © 2018年 lsy. All rights reserved.
//

#import "ScreeningBar.h"

#define Knum 4

@interface ScreeningBar ()

@property (nonatomic,strong) NSMutableArray *btnArr;

@end


@implementation ScreeningBar

- (instancetype)initWithFrame:(CGRect)frame{
    
    if (self == [super initWithFrame:frame]) {
        self.btnArr = [NSMutableArray array];
        [self setBackgroundColor:[UIColor whiteColor]];

    }
    return self;
}

- (void)setTitleArr:(NSArray *)titleArr{
    
    _titleArr = titleArr;
    
    [self setUpUI];
}

- (void)setUpUI{
    
    NSArray *iarr = @[@"designer_list_px",@"",@"designer_list_jgb",@"designer_list_sx"];
    
    for (NSInteger i = 0 ; i < Knum; i ++) {
        UIButton *btn = [Tools creatButton:CGRectMake(KScreenWidth*i/Knum, 0, KScreenWidth/Knum, self.frame.size.height) font:[UIFont systemFontOfSize:14] color:[UIColor colorWithHexString:@"#3b3b3b"] title:self.titleArr[i] image:iarr[i]];
        [btn setTag:i];
        [btn addTarget:self action:@selector(buttonDidPress:) forControlEvents:(UIControlEventTouchUpInside)];
        [self addSubview:btn];
        
        [btn setTitleEdgeInsets:UIEdgeInsetsMake(0, 0, 0, btn.imageView.frame.size.width+btn.imageView.frame.origin.x/2)];
        [btn setImageEdgeInsets:UIEdgeInsetsMake(0, btn.titleLabel.frame.size.width+btn.imageView.frame.size.width+btn.imageView.frame.origin.x/2, 0, 0 )];
        
        if (i == 2) {
            [btn setImage:[UIImage imageNamed:@"designer_list_jgt"] forState:(UIControlStateSelected)];
        }
        
        [btn setSelected:NO];
        
        [self.btnArr addObject:btn];
    }
    
}

- (void)buttonDidPress:(UIButton *)sender{
    
    if (sender.selected) {
        [sender setSelected:NO];
    }
    else{
        [sender setSelected:YES];
    }
    
    [self.delegate selectIndex:(NSInteger)sender.tag];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
