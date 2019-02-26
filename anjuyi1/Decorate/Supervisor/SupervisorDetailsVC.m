//
//  DesignerDetailsVC.m
//  anjuyi1
//
//  Created by 李 on 2018/5/31.
//  Copyright © 2018年 lsy. All rights reserved.
//
//  监理介绍

#import "SupervisorDetailsVC.h"
#import "IanScrollView.h"
#import "SDPhotoBrowserd.h"
#import "StandardView.h"
#import "SettlementViewController.h"//结算中心

@interface SupervisorDetailsVC ()<UIScrollViewDelegate,SDPhotoBrowserDelegate,StandardViewDelegate>
{
    UIButton *backBtn;
    UIButton *shareBtn;
}
@property (nonatomic , strong)UIView         *  navView;
@property (nonatomic , strong)UIScrollView   *  tmpScrollView;

/** banner */
@property (nonatomic , strong)IanScrollView  * bannerScroll;
/** foot */
@property (nonatomic , strong)UIView         * footView;
/** 筛选 */
@property (nonatomic , strong)StandardView  * screeningView;

@end

@implementation SupervisorDetailsVC

- (void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:animated];
    
    [self setNavigationLeftBarButtonWithImageNamed:@""];
    
    [self.navigationController setNavigationBarHidden:YES animated:YES];
}

- (void)viewWillDisappear:(BOOL)animated{
    
    [super viewWillDisappear:animated];
    
    [self.navigationController setNavigationBarHidden:NO animated:YES];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.view addSubview:self.tmpScrollView];
    
    [self setUpScrollView];
    
    [self.view addSubview:self.navView];
    
    [self.view addSubview:self.footView];
    
    [[UIApplication sharedApplication].keyWindow addSubview:self.screeningView];
}

#pragma mark -- 头部和脚部 筛选视图
- (UIView *)navView{
    
    if (!_navView) {
        _navView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, KScreenWidth, KTopHeight)];
        [_navView setBackgroundColor:MDRGBA(255, 255, 255, 0)];
        
        UIButton *back = [Tools creatButton:CGRectMake(MDXFrom6(10), KStatusBarHeight + 2, 40, 40) font:[UIFont systemFontOfSize:12] color:[UIColor whiteColor] title:@"" image:@"ss_back"];
        [back addTarget:self action:@selector(back) forControlEvents:(UIControlEventTouchUpInside)];
        [_navView addSubview:back];
        
        backBtn = back;
        
        UIButton *share = [Tools creatButton:CGRectMake(KScreenWidth - 50, KStatusBarHeight + 2, 40, 40) font:[UIFont systemFontOfSize:12] color:[UIColor whiteColor] title:@"" image:@"share"];
        [share addTarget:self action:@selector(share) forControlEvents:(UIControlEventTouchUpInside)];
        [_navView addSubview:share];
        
        shareBtn = share;
    }
    return _navView;
}

- (UIView *)footView{
    
    if (!_footView) {
        _footView = [[UIView alloc] initWithFrame:CGRectMake(0, KScreenHeight - 50, KScreenWidth, 50)];
        [_footView setBackgroundColor:[UIColor colorWithHexString:@"#56c5c4"]];
        
        UIButton *service = [Tools creatButton:CGRectMake((MDXFrom6(100) -50)/2, 0, 50, 50) font:[UIFont systemFontOfSize:12] color:[UIColor colorWithHexString:@"#ffffff"] title:@"客服" image:@"fond_jl_pq"];
        [service setTitleEdgeInsets:UIEdgeInsetsMake(20, -service.imageView.frame.size.width-5, 0, 0)];
        [service setImageEdgeInsets:UIEdgeInsetsMake(5, 15,25, (15))];
        [service addTarget:self action:@selector(pullUpCusetomerServise) forControlEvents:(UIControlEventTouchUpInside)];
        [_footView addSubview:service];
        
        UIButton *buy = [Tools creatButton:CGRectMake(MDXFrom6(100), 0, KScreenWidth - MDXFrom6(100), 50) font:[UIFont systemFontOfSize:14] color:[UIColor colorWithHexString:@"#ffffff"] title:@"立即购买" image:@""];
        [buy setBackgroundColor:[UIColor colorWithHexString:@"ea7c01"]];
        [buy addTarget:self action:@selector(buy) forControlEvents:(UIControlEventTouchUpInside)];
        [_footView addSubview:buy];
        
    }
    return _footView;
}

- (StandardView *)screeningView{
    
    if (!_screeningView) {
        _screeningView = [[StandardView alloc] initWithFrame:CGRectMake(0, 0, KScreenWidth, KScreenHeight)];
        [_screeningView setTypeArr:[NSMutableArray arrayWithArray: @[@"选择户型",@"选择服务类型",@"选择服务类型"]]];
        [_screeningView setDataArr:[NSMutableArray arrayWithArray: @[@[@"全部",@"LECR",@"服装、得加",@"别墅"],@[@"150平米依稀",@"150平米依稀",@"150平米依稀",@"150平米依稀"],@[@"报2万|升10万",@"报10万|升20万",@"报20万|升100.0万"]]]];
        [_screeningView setDelegate:self];
    }
    return _screeningView;
}

- (void)sureBuyWithDictionary:(NSDictionary *)dic{
    
    SettlementViewController *vc = [[SettlementViewController alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
}


#pragma mark -- scrollView
- (UIScrollView *)tmpScrollView{
    //designer_xq_banner
    if (!_tmpScrollView) {
        _tmpScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, KScreenWidth, KScreenHeight-50)];
        if (@available(iOS 11.0, *)) {
            [_tmpScrollView setContentInsetAdjustmentBehavior:(UIScrollViewContentInsetAdjustmentNever)];
        }
        [_tmpScrollView setDelegate:self];
        [_tmpScrollView setShowsVerticalScrollIndicator:NO];
        [_tmpScrollView setShowsHorizontalScrollIndicator:NO];
    }
    return _tmpScrollView;
}


- (void)setUpScrollView{
    
    CGFloat height = 0.0f;
    
    [self.tmpScrollView addSubview:self.bannerScroll];
    [self.bannerScroll startLoading];
    
    height += MDXFrom6(360) ;

    [self.tmpScrollView addSubview:[Tools creatLabel:CGRectMake(MDXFrom6(15), height, KScreenWidth - MDXFrom6(30), 20) font:[UIFont systemFontOfSize:15] color:[UIColor colorWithHexString:@"#3b3b3b"] alignment:(NSTextAlignmentLeft) title:@"全程监理服务"]];
    
    height += 35;
    
    [self.tmpScrollView addSubview:[Tools creatLabel:CGRectMake(MDXFrom6(15), height, KScreenWidth - MDXFrom6(30), 20) font:[UIFont systemFontOfSize:15] color:[UIColor colorWithHexString:@"#3b3b3b"] alignment:(NSTextAlignmentLeft) title:@"￥20-30元、平米"]];
    
    height += 35;
    
    [self.tmpScrollView addSubview:[Tools creatLabel:CGRectMake(MDXFrom6(15), height, KScreenWidth - MDXFrom6(30), 15) font:[UIFont systemFontOfSize:12] color:[UIColor colorWithHexString:@"#999999"] alignment:(NSTextAlignmentLeft) title:@"月销10302单"]];
    
    height += 30;
    
    UISegmentedControl *sc = [[UISegmentedControl alloc] initWithItems:@[@"服务流程",@"用户评价"]];
    [sc setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor blackColor]} forState:(UIControlStateNormal)];
    [sc setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor blackColor]} forState:(UIControlStateSelected)];
    [sc setFrame:CGRectMake(MDXFrom6(15), height, KScreenWidth - MDXFrom6(30), 44)];
    [sc setTintColor:[UIColor colorWithHexString:@"#efefef"]];
    [sc addTarget:self action:@selector(showService:) forControlEvents:(UIControlEventValueChanged)];
    [self.tmpScrollView addSubview:sc];
    
    height += 60;
    
    [self.tmpScrollView setContentSize:CGSizeMake(KScreenWidth, height)];
}

#pragma mark -- banner
- (IanScrollView *)bannerScroll{
    
    if (!_bannerScroll) {
        _bannerScroll = [[IanScrollView alloc] initWithFrame:CGRectMake(MDXFrom6(0), 0, KScreenWidth , MDXFrom6(340))];
        [_bannerScroll setSlideImagesArray:[NSMutableArray arrayWithArray:@[@{@"images":@""},@{@"images":@""},@{@"images":@""}]]];
        [_bannerScroll setWithoutPageControl:YES];
        [_bannerScroll setWithoutAutoScroll:YES];
        [_bannerScroll setPageControlPageIndicatorTintColor:[UIColor whiteColor]];
        [_bannerScroll setPageControlCurrentPageIndicatorTintColor:[UIColor colorWithHexString:@"#3b3b3b"]];
        __weak typeof(self) weakSelf = self;
        [_bannerScroll  setIanEcrollViewSelectAction:^(NSInteger index) {
            [weakSelf showBigPhoto];
        }];
    }
    return _bannerScroll;
}


#pragma mark -- 服务 整屋 图片


#pragma mark -- 点击事件
- (void)back{
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)share{
    
}

// 服务流程 和 评价
- (void)showService:(UISegmentedControl *)sender{
    
    NSLog(@"%ld",(long)sender.selectedSegmentIndex);
}

//客服
- (void)pullUpCusetomerServise{
    
    
}
//立即购买
- (void)buy{
    
    [self.screeningView show];
}

#pragma mark --  展示大图
- (void)showBigPhoto{
    
    SDPhotoBrowserd *browser = [[SDPhotoBrowserd alloc] init];
    browser.imageCount = 3; // 图片总数
    browser.currentImageIndex = 1;
    browser.sourceImagesContainerView = self.view.superview; // 原图的父控件
    browser.delegate = self;
    [browser show];
}


// 返回高质量图片的url
- (NSURL *)photoBrowser:(SDPhotoBrowserd *)browser highQualityImageURLForIndex:(NSInteger)index {
    
    
    return [NSURL URLWithString:@""];
    
}

- (UIImage *)photoBrowser:(SDPhotoBrowserd *)browser placeholderImageForIndex:(NSInteger)index{
    
    return [UIImage imageNamed:@"gdxq_img"];
}

#pragma mark -- delegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    
    if (scrollView == self.tmpScrollView) {
        [self.navView setBackgroundColor:MDRGBA(255, 255, 255, scrollView.contentOffset.y/286.5)];
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
