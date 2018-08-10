//
//  MyColletViewController.m
//  anjuyi1
//
//  Created by 李 on 2018/6/3.
//  Copyright © 2018年 lsy. All rights reserved.
//
//  我的收藏

#import "MyColletViewController.h"
#import "MyCollectView.h"

@interface MyColletViewController ()<UIScrollViewDelegate>

@property (nonatomic,strong) NSMutableArray * channelArr;
@property (nonatomic,strong) NavTwoTitle    * navView;
@property (nonatomic,strong) UIView         * lineView;
@property (nonatomic,strong) UIScrollView   * tmpScrollView;

@end

@implementation MyColletViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self baseForDefaultLeftNavButton];
    [self.navigationItem setTitleView:self.navView];
    
    self.channelArr = [NSMutableArray array];
    
    [self setUpChannelView];

    [self.view addSubview:self.tmpScrollView];
    
    [self setUpScrollView];
}

#pragma mark -- UI
- (NavTwoTitle *)navView {
    
    if (!_navView) {
        _navView = [[NavTwoTitle alloc] initWithFrame:CGRectMake(0, 0, MDXFrom6(200), 44) WithTitle1:@"我的收藏" WithTitle2:@"0篇"];
    }
    return _navView;
}

- (void)setUpChannelView{
    
    UIView *backView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, KScreenWidth, 55)];
    [self.view addSubview:backView];
    
    [self.view addSubview:[Tools setLineView:CGRectMake(0, 0, KScreenWidth, 1.5)]];
    
    NSArray *tArr = @[@"整屋",@"文章",@"图片",@"活动精选"];
    CGFloat x = 0;
    for (NSInteger i = 0 ; i < [tArr count] ; i ++) {
        
        
        CGFloat w = KHeight(tArr[i], 1000, 25, 16).size.width + 20;
        
        UIButton *btn = [Tools creatButton:CGRectMake(x, 20, w ,25) font:[UIFont systemFontOfSize:16] color:[UIColor blackColor] title:tArr[i] image:@""];
        [btn setTitleColor:[UIColor colorWithHexString:@"#5cc6c6"] forState:(UIControlStateSelected)];
        [btn setTag:i];
        [btn addTarget:self action:@selector(selectChannel:) forControlEvents:(UIControlEventTouchUpInside)];
        [backView addSubview:btn];
        
        [self.channelArr addObject:btn];
        
        x += w;
        
        if (i==0) {
            [btn setSelected:YES];
            
            self.lineView = [[UIView alloc] initWithFrame:CGRectMake(10, 50, w-20, 2)];
            [self.lineView setBackgroundColor:[UIColor colorWithHexString:@"#5cc6c6"]];
            [backView addSubview:self.lineView];
        }
    }

    if (x<KScreenWidth) {
        [backView setFrame:CGRectMake((KScreenWidth-x)/2.0, 0, x, 55)];
    }

}

#pragma mark -- scrollview
-(UIScrollView *)tmpScrollView{
    
    if (!_tmpScrollView) {
        _tmpScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 55, KScreenWidth, KViewHeight-55)];
        [_tmpScrollView setShowsVerticalScrollIndicator:NO];
        [_tmpScrollView setShowsHorizontalScrollIndicator:NO];
        [_tmpScrollView setPagingEnabled:YES];
        if (@available(iOS 11.0, *)) {
            [_tmpScrollView setContentInsetAdjustmentBehavior:(UIScrollViewContentInsetAdjustmentNever)];
        }
        [_tmpScrollView setContentSize:CGSizeMake(KScreenWidth *4, KViewHeight - 55)];
        [_tmpScrollView setDelegate:self];
    }
    return _tmpScrollView;
}

- (void)setUpScrollView{
    
    for (NSInteger i = 0 ; i < 4 ; i ++) {
        MyCollectView *collectV = [[MyCollectView alloc] initWithFrame:CGRectMake(KScreenWidth *i, 0, KScreenWidth, self.tmpScrollView.frame.size.height)];
        [collectV setIndex:i];
        [self.tmpScrollView addSubview:collectV];
    }
}


#pragma mark -- 事件
- (void)selectChannel:(UIButton *)sender{
    
    if (!sender.selected) {
        
        for (UIButton *btn in self.channelArr) {
            [btn setSelected:NO];
        }
        
        sender.selected = YES;
        
        [UIView animateWithDuration:.2 animations:^{
            [self.lineView setFrame:CGRectMake(10+sender.frame.origin.x, 50, sender.frame.size.width-20, 2)];
            [self.tmpScrollView setContentOffset:CGPointMake(KScreenWidth *sender.tag, 0) animated:YES];
        }];
    }
}

#pragma mark -- scrollVIew 协议 、、 数据刷新
- (void) scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate{
    if (scrollView == self.tmpScrollView) {
        
        // 如果在拖动结束的时候，没有减速的过程
        if (!decelerate){
            
            NSInteger page = scrollView.contentOffset.x/KScreenWidth;
            
            [self selectChannel:self.channelArr[page]];
        }
    }
    
}
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    if (scrollView == self.tmpScrollView) {
        NSInteger page = scrollView.contentOffset.x/KScreenWidth;
        
        [self selectChannel:self.channelArr[page]];
    }
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
