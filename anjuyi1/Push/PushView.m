//
//  PushView.m
//  anjuyi1
//
//  Created by apple on 2018/7/25.
//  Copyright © 2018年 lsy. All rights reserved.
//

#import "PushView.h"
#import "PushPhotoViewController.h"//发布图片
#import "PushProjectViewController.h"//发布项目
#import "PushHouseViewController.h"//发布整屋
#import "PushTaskViewController.h"//发布任务

@implementation PushView

- (instancetype)initWithFrame:(CGRect)frame{
    
    if (self == [super initWithFrame:frame]) {
        [self setBackgroundColor:[UIColor colorWithHexString:@"#7dd3d3"]];
        
        [self setUpUserUI];
        
        [self pushBtn];
    }
    return self;
    
}

- (void)setUpUserUI{
    
    UIImageView *headerImage = [[UIImageView alloc] initWithFrame:CGRectMake(MDXFrom6(40), MDXFrom6(70)+KStatusBarHeight, MDXFrom6(60), MDXFrom6(60))];
    [headerImage setImage:[UIImage imageNamed:@"fb_tx_img"]];
    [headerImage.layer setCornerRadius:MDXFrom6(30)];
    [headerImage setClipsToBounds:YES];
    [self addSubview:headerImage];
    
    [self addSubview:[Tools creatLabel:CGRectMake(MDXFrom6(120), MDXFrom6(70)+KStatusBarHeight, MDXFrom6(250), MDXFrom6(60)) font:[UIFont systemFontOfSize:18] color:[UIColor colorWithHexString:@"#ffffff"] alignment:(NSTextAlignmentLeft) title:@"九溪设计"]];
}

- (void)pushBtn{
    
    NSArray *iArr = @[@"fb_strategy",@"fb_dyn",@"assist",@"fb_task",@"fb_img_n",@"fb_w_house"];
    NSArray *tArr = @[@"发布攻略",@"工地动态",@"辅助下单",@"发布任务",@"发布图片",@"发布整屋"];
    
    for (NSInteger i = 0 ; i < 6 ; i++) {
        
        NSInteger n = i/3;
        
        UIView *backView = [[UIView alloc] initWithFrame:CGRectMake(MDXFrom6(95/2+100*(i%3)), KStatusBarHeight + MDXFrom6(235+n*150), MDXFrom6(80), MDXFrom6(110))];
        [backView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(pushType:)]];
        [backView setTag:i];
        [self addSubview:backView];
        
        [backView addSubview:[Tools creatImage:CGRectMake(0, 0, MDXFrom6(80), MDXFrom6(80)) image:iArr[i]]];
        [backView addSubview:[Tools creatLabel:CGRectMake(0, MDXFrom6(95), MDXFrom6(80), MDXFrom6(15)) font:[UIFont systemFontOfSize:14] color:[UIColor colorWithHexString:@"#ffffff"] alignment:(NSTextAlignmentCenter) title:tArr[i]]];
        
    }
    
    [self  addSubview:[Tools creatImage:CGRectMake(0, KScreenHeight - MDXFrom6(119), KScreenWidth, MDXFrom6(119)) image:@"fb_backgroud"]];
    
    UIButton *cancel = [Tools creatButton:CGRectMake(0, 0, MDXFrom6(39), MDXFrom6(39)) font:[UIFont systemFontOfSize:12] color:[UIColor whiteColor] title:@"" image:@"fb_close"];
    [cancel setCenter:CGPointMake(KScreenWidth/2, KScreenHeight - MDXFrom6(95))];
    [cancel addTarget:self action:@selector(back) forControlEvents:(UIControlEventTouchUpInside)];
    [self  addSubview:cancel];
    
}

- (void)pushType:(UITapGestureRecognizer *)sender{
    
    [self setHidden:YES];
    
    switch (sender.view.tag) {
        case 1:
        {
            PushProjectViewController *controller = [[PushProjectViewController alloc] init];
            BaseNaviViewController *nav = [[BaseNaviViewController alloc] initWithRootViewController:controller];
            [self.delegate jumpToViewControllerForPush:nav];
        }
            break;
        case 3:
        {
            PushTaskViewController *controller = [[PushTaskViewController alloc] init];
            BaseNaviViewController *nav = [[BaseNaviViewController alloc] initWithRootViewController:controller];
            [self.delegate jumpToViewControllerForPush:nav];
        }
            break;
        case 4:
        {
            PushPhotoViewController *controller = [[PushPhotoViewController alloc] init];
            BaseNaviViewController *nav = [[BaseNaviViewController alloc] initWithRootViewController:controller];
            [self.delegate jumpToViewControllerForPush:nav];
        }
            break;
        case 5:
        {
            PushHouseViewController *controller = [[PushHouseViewController alloc] init];
            BaseNaviViewController *nav = [[BaseNaviViewController alloc] initWithRootViewController:controller];
            [self.delegate jumpToViewControllerForPush:nav];
        }
            break;
            
            
            
            
        default:
            break;
    }
    
    
    
}

- (void)back{
   [self setHidden:YES];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
