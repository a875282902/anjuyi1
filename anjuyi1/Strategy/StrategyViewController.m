//
//  ChargingHomeViewController.m
//  anjuyi1
//
//  Created by apple on 2018/7/18.
//  Copyright © 2018年 lsy. All rights reserved.
//

#import "StrategyViewController.h"
#import "BannerModel.h"
#import "IanScrollView.h"

#import "DraftBoxTableViewCell.h"

#import "ShowWebViewController.h"

#import "StrategyCaseListViewController.h"

#import "StrategyModel.h"

@interface StrategyViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic,strong)UITableView     *  tmpTableView;
@property (nonatomic,strong)NSMutableArray  *  dataArr;
@property (nonatomic,strong)UIView          *  headerView;

@property (nonatomic,strong)IanScrollView   *  bannerScroll;
@property (nonatomic,strong)NSMutableArray  *  bannerArr;
@property (nonatomic,assign)NSInteger          page;

@end

@implementation StrategyViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self baseForDefaultLeftNavButton];
    [self setTitle:@"装修攻略"];
    
    self.dataArr = [NSMutableArray array];
    self.bannerArr = [NSMutableArray array];
    
    [self.view addSubview:self.tmpTableView];
    
    [self.view addSubview:[Tools setLineView:CGRectMake(0, 0, KScreenWidth, 1)]];
    
    [self getBannerData];
    
    [self load];
    
    [self.tmpTableView.mj_header beginRefreshing];
}

#pragma mark -- refresh
- (void)load{
    __weak typeof(self) weakSelf = self;
    
    self.tmpTableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        weakSelf.page = 1;
        [weakSelf.dataArr removeAllObjects];
        [weakSelf.tmpTableView.mj_footer resetNoMoreData];
        [weakSelf pullDownRefresh];
    }];
    
    self.tmpTableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        weakSelf.page ++;
        [weakSelf pullUpLoadMore];
    }];
    
}
//下拉刷新
- (void)pullDownRefresh{
    NSString *path = [NSString stringWithFormat:@"%@/Strategy_info/ajax_strategy_tui",KURL];
    
    NSDictionary *dic = @{@"page":[NSString stringWithFormat:@"%ld",(long)self.page]};
    
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    __weak typeof(self) weakSelf = self;
    
    [HttpRequest POST:path parameters:dic success:^(id  _Nullable responseObject) {
        
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        
        if ([responseObject[@"code"] integerValue] == 200) {
            
            if ([responseObject[@"datas"] isKindOfClass:[NSArray class]] ) {
                for (NSDictionary *dict in responseObject[@"datas"]) {
                    StrategyModel *model = [[StrategyModel alloc] initWithDictionary:dict];
                    [weakSelf.dataArr addObject:model];
                }
            }
        }
        else{
            
            [ViewHelps showHUDWithText:responseObject[@"message"]];
        }
        
        if (weakSelf.dataArr.count < weakSelf.page * 10) {
            [weakSelf.tmpTableView.mj_footer endRefreshingWithNoMoreData];
        }
        
        
        [weakSelf.tmpTableView.mj_header endRefreshing];
        [weakSelf.tmpTableView reloadData];

    } failure:^(NSError * _Nullable error) {
        [weakSelf.tmpTableView.mj_header endRefreshing];
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        [RequestSever showMsgWithError:error];
    }];
}
//上拉加载
- (void)pullUpLoadMore{
    NSString *path = [NSString stringWithFormat:@"%@/Strategy_info/ajax_strategy_tui",KURL];
    
    NSDictionary *dic = @{@"page":[NSString stringWithFormat:@"%ld",(long)self.page]};
    
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    __weak typeof(self) weakSelf = self;
    
    [HttpRequest POST:path parameters:dic success:^(id  _Nullable responseObject) {
        
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        
        if ([responseObject[@"code"] integerValue] == 200) {
            
            if ([responseObject[@"datas"] isKindOfClass:[NSArray class]] ) {
                for (NSDictionary *dict in responseObject[@"datas"]) {
                    StrategyModel *model = [[StrategyModel alloc] initWithDictionary:dict];
                    [weakSelf.dataArr addObject:model];
                }
            }
        }
        else{
            weakSelf.page --;
            [ViewHelps showHUDWithText:responseObject[@"message"]];
        }
        
        if (weakSelf.dataArr.count < weakSelf.page * 10) {
            [weakSelf.tmpTableView.mj_footer endRefreshingWithNoMoreData];
        }
        else{
            [weakSelf.tmpTableView.mj_footer endRefreshing];
        }
        [weakSelf.tmpTableView reloadData];
        
    } failure:^(NSError * _Nullable error) {
        weakSelf.page --;
        [weakSelf.tmpTableView.mj_footer endRefreshing];
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        [RequestSever showMsgWithError:error];
    }];
}


- (void)getBannerData{
    
    NSString *path = [NSString stringWithFormat:@"%@/strategy_info/index",KURL];
    
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    __weak typeof(self) weakSelf = self;
    
    [HttpRequest POST:path parameters:nil success:^(id  _Nullable responseObject) {
        
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        
        if ([responseObject[@"code"] integerValue] == 200) {
            
            [weakSelf.bannerArr removeAllObjects];
            
            if ([responseObject[@"datas"][@"slide_img"] isKindOfClass:[NSArray class]] ) {
                for (NSDictionary *dict in responseObject[@"datas"][@"slide_img"]) {
                    BannerModel *model = [[BannerModel alloc] initWithDictionary:dict];
                    [weakSelf.bannerArr addObject:model];
                }
            }
            
            [weakSelf setUpHeaderView];
            
            [weakSelf.tmpTableView reloadData];
        }
        else{
            
            [ViewHelps showHUDWithText:responseObject[@"message"]];
        }
        
        
    } failure:^(NSError * _Nullable error) {
        
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        [RequestSever showMsgWithError:error];
    }];
}

#pragma mark -- headerView
- (UIView *)headerView{
    
    if (!_headerView) {
        _headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, KScreenWidth, 10)];
        [_headerView setBackgroundColor:[UIColor whiteColor]];
    }
    return _headerView;
}

- (void)setUpHeaderView{
    
    CGFloat height = 0;
    
    [self.bannerScroll setFrame:CGRectMake(0, height, KScreenWidth, MDXFrom6(225))];
    
    NSMutableArray *barr = [NSMutableArray array];
    
    for (BannerModel *model in self.bannerArr) {
        [barr addObject:@{@"images":model.picture}];
    }
    if (barr.count != 0) {
        [self.bannerScroll setSlideImagesArray:barr];
        [_headerView addSubview:self.bannerScroll];
        
        __weak typeof(self) weakSelf = self;
        
        [self.bannerScroll setIanEcrollViewSelectAction:^(NSInteger index) {
            BannerModel *model = weakSelf.bannerArr[index];
            ShowWebViewController *vc = [[ShowWebViewController alloc] init];
            vc.url = model.url;
            [weakSelf.navigationController pushViewController:vc animated:YES];
        }];
        
        [self.bannerScroll startLoading];
    }
    
    height += MDXFrom6(225);
    
    NSArray *tArr = @[@"功能分类",@"房屋评测",@"吉日选择",@"装修图库"];
    //cdz_ico4
    for (NSInteger i = 0 ; i < 4; i ++) {
        UIView *back = [[UIView alloc] initWithFrame:CGRectMake(KScreenWidth*i/4, height, KScreenWidth/4, 85)];
        [back addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(selectService:)]];
        [back setTag:i];
        [_headerView addSubview:back];
        
        [back addSubview:[Tools creatImage:CGRectMake((KScreenWidth/4 - 25)/2, 23, 25, 25) image:[NSString stringWithFormat:@"zxgl_ico%ld",(long)(i+1)]]];
        
        [back addSubview:[Tools creatLabel:CGRectMake(0, 50, KScreenWidth/4, 12) font:[UIFont systemFontOfSize:12] color:[UIColor colorWithHexString:@"#3b3b3b"] alignment:(NSTextAlignmentCenter) title:tArr[i]]];
        
    }
    
    height += 85;
    
    [self.headerView addSubview:[Tools creatLabel:CGRectMake(10, height, KScreenWidth, 18) font:[UIFont boldSystemFontOfSize:18] color:[UIColor blackColor] alignment:(NSTextAlignmentLeft) title:@"热门攻略"]];
    
    height += 25;
    
    [self.headerView setFrame:CGRectMake(0, 0, KScreenWidth, height)];
}

- (IanScrollView *)bannerScroll{
    
    if (!_bannerScroll) {
        _bannerScroll = [[IanScrollView alloc] initWithFrame:CGRectMake(MDXFrom6(10), MDXFrom6(90), KScreenWidth - MDXFrom6(20), MDXFrom6(225))];
        [_bannerScroll setPageControlPageIndicatorTintColor:[UIColor whiteColor]];
        [_bannerScroll setPageControlCurrentPageIndicatorTintColor:[UIColor colorWithHexString:@"#3b3b3b"]];
    }
    return _bannerScroll;
    
}

#pragma mark -- tableView
- (UITableView *)tmpTableView{
    
    if (!_tmpTableView) {
        _tmpTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, KScreenWidth, KViewHeight) style:(UITableViewStylePlain)];
        if (@available(iOS 11.0, *)) {
            [_tmpTableView setContentInsetAdjustmentBehavior:(UIScrollViewContentInsetAdjustmentNever)];
        }
        [_tmpTableView setShowsVerticalScrollIndicator:NO];
        [_tmpTableView setShowsHorizontalScrollIndicator:NO];
        [_tmpTableView setTableHeaderView:self.headerView];
        [_tmpTableView setTableFooterView:[UIView new]];
        [_tmpTableView setDataSource:self];
        [_tmpTableView setDelegate:self];
    }
    return _tmpTableView;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataArr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    DraftBoxTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"StrategyViewController"];
    if (!cell) {
        cell = [[DraftBoxTableViewCell alloc] initWithStyle:(UITableViewCellStyleSubtitle) reuseIdentifier:@"StrategyViewController"];
    }
    if (indexPath.row < self.dataArr.count) {
        
        [cell bandDataWithModel:self.dataArr[indexPath.row]];
        
    }
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 265;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
}

#pragma mark -- 点击事件
- (void)selectService:(UITapGestureRecognizer *)sender{
    
    switch (sender.view.tag) {
        case 0:
        {
            StrategyCaseListViewController *vc = [[StrategyCaseListViewController alloc] init];
            [self.navigationController pushViewController:vc animated:YES];
        }
            break;
        case 1:
        {
            
        }
            break;
        case 2:
        {
           
        }
            break;
        case 3:
        {
           
        }
            break;
            
            
        default:
            break;
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
