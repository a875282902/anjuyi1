//
//  LaunchADView.m
//  anjuyi1
//
//  Created by apple on 2018/10/18.
//  Copyright © 2018年 lsy. All rights reserved.
//

#import "LaunchADView.h"

@interface LaunchADView ()

@property (nonatomic,strong) NSTimer *timer;
@property (nonatomic,strong) UIButton *timeButton;
@property (nonatomic,assign) NSInteger time;

@end

// 广告图 存在的时间
#define MDADViewShowDuration 4

@implementation LaunchADView

+(instancetype)createADViewWithADImageName:(NSString *)imageName
{
    UIWindow * window = [[[UIApplication sharedApplication] delegate] window];
    
    LaunchADView * view = [[LaunchADView alloc] initWithFrame:window.bounds  ADImageName:imageName];
    [view setBackgroundColor:[UIColor whiteColor]];
    [window addSubview:view];
    
    return view;
}


-(instancetype)initWithFrame:(CGRect)frame ADImageName:(NSString *)imageName
{
    self = [super initWithFrame:frame];
    
    if (self) {
        
        self.userInteractionEnabled = YES;
        
        // 创建和启动图 一样的背景图
        self.backgroundColor = [UIColor clearColor];
        self.time = MDADViewShowDuration;
        
        _adImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];
        [_adImageView setImage:[UIImage imageNamed:imageName]];
        _adImageView.contentMode = UIViewContentModeScaleAspectFill;
        [_adImageView setBackgroundColor:[UIColor whiteColor]];
        _adImageView.backgroundColor = [UIColor clearColor];
        
        [_adImageView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapAdViewAction:)]];
        
        _adImageView.userInteractionEnabled = YES;
        [self addSubview:_adImageView];
        
        _timeButton = [Tools creatButton:CGRectMake(KScreenWidth - 50, KStatusBarHeight  + 20, 40, 40) font:[UIFont systemFontOfSize:16] color:[UIColor blackColor] title:[NSString stringWithFormat:@"%d",MDADViewShowDuration] image:@""];
        [_timeButton setBackgroundColor:[UIColor grayColor]];
        [_timeButton.layer setCornerRadius:20];
        [_timeButton setClipsToBounds:YES];
        [_timeButton addTarget:self action:@selector(showAll) forControlEvents:(UIControlEventTouchUpInside)];
        [self addSubview:_timeButton];
        
        
        if (!self.timer) {
            self.timer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(timeChange) userInfo:nil repeats:YES];
        }
        
       
        
    }
    return self;
}

- (void)timeChange{
    
    self.time--;
    
    [self.timeButton  setTitle:[NSString stringWithFormat:@"%ld",(long)self.time] forState:(UIControlStateNormal)];
    
    if (self.time == 0) {
        [self cleaarView];
    }
}

- (void)showAll{
    
    [self cleaarView];
}

- (void)cleaarView{
    
    [self.timer invalidate];
    self.timer = nil;
    
    [self removeFromSuperview];
    
    if (self.endShowBlock)
    {
        self.endShowBlock();
    }
    
}

-(void)tapAdViewAction:(UITapGestureRecognizer *)ges
{
    if (self.tapAdViewBlock)
    {
        [self cleaarView];
        self.tapAdViewBlock();
    }
}


@end
