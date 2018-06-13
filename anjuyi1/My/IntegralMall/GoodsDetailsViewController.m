//
//  GoodsDetailsViewController.m
//  anjuyi1
//
//  Created by 李 on 2018/6/6.
//  Copyright © 2018年 lsy. All rights reserved.
//
//  商品详情

#import "GoodsDetailsViewController.h"
#import "SDPhotoBrowserd.h"
#import "GoodsDetailsVIew.h"
#import "GoodsStandardView.h"

@interface GoodsDetailsViewController ()<SDPhotoBrowserDelegate,UIScrollViewDelegate,GoodsDetailsVIewDelegate>

@property (nonatomic,strong) UIScrollView  * tmpScrollView;

@property (nonatomic,strong) GoodsStandardView  * goodsStandardView;

@end

@implementation GoodsDetailsViewController

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
    // Do any additional setup after loading the view.
    
    [self.view addSubview:self.tmpScrollView];
    
    [self setUpUI];
    
    [self.view addSubview:self.goodsStandardView];

}

-(UIScrollView *)tmpScrollView{
    
    if (!_tmpScrollView) {
        _tmpScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, KScreenWidth, KScreenHeight - MDXFrom6(50))];
        [_tmpScrollView setShowsVerticalScrollIndicator:NO];
        [_tmpScrollView setShowsHorizontalScrollIndicator:NO];
        [_tmpScrollView setDelegate:self];
    }
    return _tmpScrollView;
}

- (void)setUpUI{
    
    GoodsDetailsVIew *goodsView = [[GoodsDetailsVIew alloc] initWithFrame:CGRectMake(0, MDXFrom6(100), KScreenWidth, 100)];
    [goodsView setDelegate:self];
    [self.tmpScrollView addSubview:goodsView];
    
    
    // ----
    UIButton *addShopCart = [Tools creatButton:CGRectMake(0, KScreenHeight - MDXFrom6(50) , KScreenWidth/2, MDXFrom6(50)) font:[UIFont systemFontOfSize:14] color:[UIColor whiteColor] title:@"加入购物车" image:@""];
    [addShopCart addTarget:self action:@selector(addGoodsToShopCart) forControlEvents:(UIControlEventTouchUpInside)];
    [addShopCart setBackgroundColor:[UIColor colorWithHexString:@"#2cb7b5"]];
    [self.view addSubview:addShopCart];
    
    // ----
    UIButton *sureBtn = [Tools creatButton:CGRectMake(KScreenWidth/2, KScreenHeight - MDXFrom6(50) , KScreenWidth/2, MDXFrom6(50)) font:[UIFont systemFontOfSize:14] color:[UIColor whiteColor] title:@"立即购买" image:@""];
    [sureBtn addTarget:self action:@selector(nowBuyGoods) forControlEvents:(UIControlEventTouchUpInside)];
    [sureBtn setBackgroundColor:[UIColor colorWithHexString:@"#ffb538"]];
    [self.view addSubview:sureBtn];
    
}

- (void)changeGoodsDetailsViewHeight:(CGFloat)height{
    
    [self.tmpScrollView setContentSize:CGSizeMake(KScreenWidth, height + MDXFrom6(100))];
}

- (GoodsStandardView *)goodsStandardView{
    
    if (!_goodsStandardView) {
        _goodsStandardView = [[GoodsStandardView alloc] initWithFrame:CGRectMake(0, 0, KScreenWidth, KScreenHeight)];
        [_goodsStandardView setTypeArr:[NSMutableArray arrayWithArray: @[@"规格",@"五福"]]];
        [_goodsStandardView setDataArr:[NSMutableArray arrayWithArray: @[@[@"白色",@"黑色"],@[@"安装",@"拆旧"]]]];
    }
    return _goodsStandardView;
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

#pragma mark -- 点击事件
- (void)addGoodsToShopCart{

}

- (void)nowBuyGoods{
    [self.goodsStandardView show];
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
