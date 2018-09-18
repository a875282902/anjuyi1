//
//  DecorateViewController.m
//  anjuyi
//
//  Created by 李 on 2018/5/29.
//  Copyright © 2018年 lsy. All rights reserved.
//
//  工长

#import "MasterViewController.h"
#import "SearchView.h"
#import "DesignerTableViewCell.h"
#import "IanScrollView.h"
#import "ScreeningBar.h"
#import "ScreeningView.h"
#import "MasterDetailsVC.h"

#import "MasterModel.h"
#import "ShowWebViewController.h"

#define hederHeight MDXFrom6(55)

@interface MasterViewController ()<UITableViewDelegate,UITableViewDataSource,ScreeningBarDelegate,ScreeningViewDelegate>
{
    BOOL _isSearch;
    NSString * _service_type;
    NSString * _level;
    NSString * _min;
    NSString * _max;
}

@property (nonatomic,strong)UITableView         *   tmpTableView;
@property (nonatomic,strong)NSMutableArray      *   dataArr;//工长列表数据
@property (nonatomic,strong)UIView              *   headerView;
@property (nonatomic,strong)IanScrollView       *   bannerScroll;
@property (nonatomic,strong)ScreeningBar        *   screeningBar;
@property (nonatomic,strong)ScreeningView       *   screeningView;

@property (nonatomic,assign)NSInteger               page;
@property (nonatomic,strong)NSMutableArray      *   bannerArr;//广告数据

@property (nonatomic,strong)NSMutableArray      *   screenArr;//筛选数据

@end

@implementation MasterViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self.view setBackgroundColor:[UIColor colorWithHexString:@"#f6f6f6"]];
    
    
    //搜索框
    SearchView *search = [[SearchView alloc] initWithFrame:CGRectMake(0, 0, MDXFrom6(355), 30) Title:@"大家都在搜工长"];
    [search addTarget:self action:@selector(jumpSearch)];
//    [self.navigationItem setTitleView:search];
    
    [self baseForDefaultLeftNavButton];
    [self setTitle:@"找工长"];
    
    self.page = 1;
    _isSearch = NO;
    self.dataArr = [NSMutableArray array];
    self.bannerArr = [NSMutableArray array];
    self.screenArr = [NSMutableArray array];
    _service_type = @"";
    _min = @"";
    _max = @"";
    _level = @"";
    
    [self.view addSubview:self.tmpTableView];
    
    [self.view addSubview:self.screeningBar];
    
    [self.navigationController.view addSubview:self.screeningView];
    
    [self load];
    
    [self pullDownRefresh];
    
    [self getBannerData];
    
    [self getSearchType];
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
    
    
    NSString *path = [NSString stringWithFormat:@"%@/work/get_work_list",KURL];
    
    NSDictionary *header = @{@"token":UTOKEN};
    NSDictionary *dic = @{@"page":[NSString stringWithFormat:@"%ld",self.page]};
    
    if (_isSearch) {
        path = [NSString stringWithFormat:@"%@/work/search_list",KURL];
        dic = @{@"service_type":_service_type,
                @"level":_level,
                @"min":_min,
                @"max":_max,
                @"page":[NSString stringWithFormat:@"%ld",self.page]};
    }
    
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    __weak typeof(self) weakSelf = self;
    
    [HttpRequest POSTWithHeader:header url:path parameters:dic success:^(id  _Nullable responseObject) {
        
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        
        if ([responseObject[@"code"] integerValue] == 200) {
            
            if ([responseObject[@"datas"] isKindOfClass:[NSArray class]]) {
                
                for (NSDictionary *dic in responseObject[@"datas"]) {
                    MasterModel *model = [[MasterModel alloc] initWithDictionary:dic];
                    model.type = @"工长";
                    [weakSelf.dataArr addObject:model];
                }
            }
            
        }
        else{
            
            [ViewHelps showHUDWithText:responseObject[@"message"]];
        }
        
        [weakSelf.tmpTableView reloadData];
        [weakSelf.tmpTableView.mj_header endRefreshing];
        
        if (weakSelf.dataArr.count < weakSelf.page *10) {
            [weakSelf.tmpTableView.mj_footer endRefreshingWithNoMoreData];
        }
        
        
    } failure:^(NSError * _Nullable error) {
        
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        [RequestSever showMsgWithError:error];
    }];

    
}
//上拉加载
- (void)pullUpLoadMore{
    
    NSString *path = [NSString stringWithFormat:@"%@/work/get_work_list",KURL];
    
    NSDictionary *header = @{@"token":UTOKEN};
    NSDictionary *dic = @{@"page":[NSString stringWithFormat:@"%ld",self.page]};
    
    if (_isSearch) {
        path = [NSString stringWithFormat:@"%@/work/search_list",KURL];
        dic = @{@"service_type":_service_type,
                @"level":_level,
                @"min":_min,
                @"max":_max,
                @"page":[NSString stringWithFormat:@"%ld",self.page]};
    }
    
    
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    __weak typeof(self) weakSelf = self;
    
    [HttpRequest POSTWithHeader:header url:path parameters:dic success:^(id  _Nullable responseObject) {
        
        [MBProgressHUD hideHUDForView:weakSelf.view animated:YES];
        
        if ([responseObject[@"code"] integerValue] == 200) {
            
            if ([responseObject[@"datas"] isKindOfClass:[NSArray class]]) {
                
                for (NSDictionary *dic in responseObject[@"datas"]) {
                    MasterModel *model = [[MasterModel alloc] initWithDictionary:dic];
                    model.type = @"工长";
                    [weakSelf.dataArr addObject:model];
                }
            }
        }
        else{
            
            [ViewHelps showHUDWithText:responseObject[@"message"]];
        }
        
        [weakSelf.tmpTableView reloadData];
        [weakSelf.tmpTableView.mj_footer endRefreshing];
        
        if (weakSelf.dataArr.count < weakSelf.page *10) {
            [weakSelf.tmpTableView.mj_footer endRefreshingWithNoMoreData];
        }
        
    } failure:^(NSError * _Nullable error) {
        weakSelf.page --;
        [MBProgressHUD hideHUDForView:weakSelf.view animated:YES];
        [RequestSever showMsgWithError:error];
    }];
    
}

//获取banner
- (void)getBannerData{
    
    
    NSString *path = [NSString stringWithFormat:@"%@/Work/index",KURL];
    
    __weak typeof(self) weakSelf = self;
    
    [HttpRequest POST:path parameters:nil success:^(id  _Nullable responseObject) {
        
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        
        if ([responseObject[@"code"] integerValue] == 200) {
            
            NSMutableArray * arr = [NSMutableArray array];
            for (NSDictionary *dic in responseObject[@"datas"][@"slide_img"]) {
                [weakSelf.bannerArr addObject:dic];
                [arr addObject:@{@"images":dic[@"picture"]}];
            }
            [weakSelf.bannerScroll setSlideImagesArray:arr];
            [weakSelf.bannerScroll setIanEcrollViewSelectAction:^(NSInteger index) {
               
                ShowWebViewController *vc = [[ShowWebViewController alloc] init];
                vc.url = self.bannerArr[index][@"url"];
                [self.navigationController pushViewController:vc animated:YES];
            }];
            [weakSelf.bannerScroll startLoading];
        }
        else{
            
            [ViewHelps showHUDWithText:responseObject[@"message"]];
        }
        
        
    } failure:^(NSError * _Nullable error) {
        
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        [RequestSever showMsgWithError:error];
    }];

}

- (void)getSearchType{
    
    
    NSString *path = [NSString stringWithFormat:@"%@/work/get_search_type",KURL];

    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    __weak typeof(self) weakSelf = self;
    
    [HttpRequest POST:path parameters:nil success:^(id  _Nullable responseObject) {
        
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        
        if ([responseObject[@"code"] integerValue] == 200) {
            
            [weakSelf.screenArr addObject:responseObject[@"datas"][@"service_type"]];
            [weakSelf.screenArr addObject:responseObject[@"datas"][@"price_range"]];
            [weakSelf.screenArr addObject:responseObject[@"datas"][@"level"]];
            
            NSMutableArray *service_type = [NSMutableArray array];
            for (NSDictionary *dic  in weakSelf.screenArr[0]) {
                [service_type addObject:dic[@"value"]];
            }
            NSMutableArray *price_range = [NSMutableArray array];
            for (NSDictionary *dic  in weakSelf.screenArr[1]) {
                [price_range addObject:[NSString stringWithFormat:@"%@-%@\n%@的选择",dic[@"min"],dic[@"max"],dic[@"Percentage"]]];
            }
            
            NSMutableArray *level = [NSMutableArray array];
            for (NSDictionary *dic  in weakSelf.screenArr[2]) {
                [level addObject:dic[@"value"]];
            }
            
             [weakSelf.screeningView setDataArr:[NSMutableArray arrayWithArray: @[service_type,weakSelf.screenArr[1],level]]];
        }
        else{
            
            [ViewHelps showHUDWithText:responseObject[@"message"]];
        }
        
        
    } failure:^(NSError * _Nullable error) {
        
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        [RequestSever showMsgWithError:error];
    }];

}

#pragma mark --  headerView
- (UIView *)headerView{
    
    if (!_headerView) {
        _headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, KScreenWidth, MDXFrom6(310))];
        [_headerView setBackgroundColor:[UIColor whiteColor]];
        
        NSInteger num = 3;
        
        NSArray *arr = @[@"leader_zx",@"leader_dynamic",@"leader_gold"];
        NSArray *tarr = @[@"整屋装修",@"工地动态",@"金牌工长"];
        for (NSInteger i = 0 ; i < num; i ++) {
            UIView *back = [[UIView alloc] initWithFrame:CGRectMake(KScreenWidth*i/num, 0, KScreenWidth/num, MDXFrom6(90))];
            [back addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(selectService:)]];
            [back setTag:i];
            [_headerView addSubview:back];
            
            [back addSubview:[Tools creatImage:CGRectMake(MDXFrom6(45), MDXFrom6(20), MDXFrom6(35), MDXFrom6(30)) image:arr[i]]];
            [back addSubview:[Tools creatLabel:CGRectMake(0, MDXFrom6(55), KScreenWidth/num, MDXFrom6(25)) font:[UIFont systemFontOfSize:12] color:[UIColor colorWithHexString:@"#3b3b3b"] alignment:(NSTextAlignmentCenter) title:tarr[i]]];
            
        }
        
        
        //        [_headerView addSubview:[Tools creatImage:CGRectMake(MDXFrom6(10), MDXFrom6(90), KScreenWidth - MDXFrom6(20), MDXFrom6(210)) image:@"zx_banner"]];
        [_headerView addSubview:self.bannerScroll];
        
    }
    return _headerView;
}

- (IanScrollView *)bannerScroll{
    
    if (!_bannerScroll) {
        _bannerScroll = [[IanScrollView alloc] initWithFrame:CGRectMake(MDXFrom6(10), MDXFrom6(90), KScreenWidth - MDXFrom6(20), MDXFrom6(210))];
       
        [_bannerScroll setPageControlPageIndicatorTintColor:[UIColor whiteColor]];
        [_bannerScroll setPageControlCurrentPageIndicatorTintColor:[UIColor colorWithHexString:@"#3b3b3b"]];
    }
    return _bannerScroll;
    
}

#pragma mark -- screeningBar
- (ScreeningBar *)screeningBar{
    if (!_screeningBar) {
        _screeningBar = [[ScreeningBar alloc] initWithFrame:CGRectMake(0, MDXFrom6(10), KScreenWidth, MDXFrom6(45))];
        [_screeningBar setDelegate:self];
        [_screeningBar setHidden:YES];
    }
    return _screeningBar;
}

- (void)selectIndex:(NSInteger)index{
    
    NSLog(@"%ld",index);
    
    if (index == 3) {
        
        [self.screeningView show];
    }
}

- (ScreeningView *)screeningView{
    
    if (!_screeningView) {
        _screeningView = [[ScreeningView alloc] initWithFrame:CGRectMake(0, 0, KScreenWidth, KScreenHeight)];
        [_screeningView setDelegate:self];
        [_screeningView setTypeArr:[NSMutableArray arrayWithArray: @[@"工长种类",@"工长报价",@"工长等级"]]];
        
    }
    return _screeningView;
}

- (void)sureScreenData:(NSMutableArray *)sureArr{
    if ([sureArr[0] integerValue]>=0) {
        _service_type = self.screenArr[0][[sureArr[0] integerValue]][@"key"];
    }
    if ([sureArr[1] isKindOfClass:[NSDictionary class]]) {
        
        NSDictionary *dic =sureArr[1];
        _min = dic[@"min"];
        _max = dic[@"max"];
    }
    else{
        if ([sureArr[1] integerValue]>=0) {
            _min = self.screenArr[1][[sureArr[1] integerValue]][@"min"];
            _max = self.screenArr[1][[sureArr[1] integerValue]][@"max"];
        }
    }
    if ([sureArr[2] integerValue]>=0) {
       _level = self.screenArr[2][[sureArr[2] integerValue]][@"key"];
    }
    _isSearch = YES;
    [self.tmpTableView.mj_header beginRefreshing];
}

#pragma mark -- tableView
- (UITableView *)tmpTableView{
    
    if (!_tmpTableView) {
        _tmpTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, MDXFrom6(10), KScreenWidth, KScreenHeight-KTopHeight - MDXFrom6(10)) style:(UITableViewStylePlain)];
        [_tmpTableView setSeparatorStyle:(UITableViewCellSeparatorStyleNone)];
        if (@available(iOS 11.0, *)) {
            [_tmpTableView setContentInsetAdjustmentBehavior:(UIScrollViewContentInsetAdjustmentNever)];
        }
        [_tmpTableView setRowHeight:190.0f];
        [_tmpTableView setShowsVerticalScrollIndicator:NO];
        [_tmpTableView setShowsHorizontalScrollIndicator:NO];
        [_tmpTableView setTableHeaderView:self.headerView];
        [_tmpTableView setDataSource:self];
        [_tmpTableView setDelegate:self];
    }
    return _tmpTableView;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataArr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    DesignerTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"DesignerTableViewCell"];
    if (!cell) {
        cell = [[DesignerTableViewCell alloc] initWithStyle:(UITableViewCellStyleDefault) reuseIdentifier:@"DesignerTableViewCell"];
    }
    
    if (indexPath.row <self.dataArr.count) {
    
        [cell bandDataWithModel:self.dataArr[indexPath.row]];
    }
    
    
    return cell;
}

//- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
//
//    return 305;
//}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    
    return hederHeight;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    
    UIView *header = [[UIView alloc] initWithFrame:CGRectMake(0, 0, KScreenWidth, hederHeight)];
    [header setBackgroundColor:[UIColor whiteColor]];
    
    [header addSubview:[Tools setLineView:CGRectMake(0, 0, KScreenWidth , MDXFrom6(10))]];
    
    [header addSubview:[Tools creatImage:CGRectMake(MDXFrom6(10), MDXFrom6(30), MDXFrom6(18), MDXFrom6(20)) url:@"" image:@"leader_excellent"]];
    
    [header addSubview:[Tools creatLabel:CGRectMake(MDXFrom6(40), MDXFrom6(17), MDXFrom6(300), MDXFrom6(45)) font:[UIFont boldSystemFontOfSize:16] color:[UIColor colorWithHexString:@"#3B3B3B"] alignment:(NSTextAlignmentLeft) title:@"优秀工长"]];
    
    
    return header;
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (indexPath.row < self.dataArr.count) {
        
        MasterModel *model = self.dataArr[indexPath.row];
        
        MasterDetailsVC *controller = [[MasterDetailsVC alloc] init];
        controller.masterID = model.user_id;
        [self.navigationController pushViewController:controller animated:YES];
    }

}


#pragma mark -- click 事件
//
- (void)jumpSearch{
    
    
}

- (void)selectService:(UITapGestureRecognizer *)sender{
    
    switch (sender.view.tag) {
        case 0:
        {
            
        }
            break;
            
        default:
            break;
    }
}

#pragma mark -- delegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    CGFloat sectionHeaderHeight = hederHeight;
    if (scrollView.contentOffset.y<=sectionHeaderHeight&&scrollView.contentOffset.y>=0) {
        scrollView.contentInset = UIEdgeInsetsMake(-scrollView.contentOffset.y, 0, 0, 0);
    } else if (scrollView.contentOffset.y>=sectionHeaderHeight) {
        scrollView.contentInset = UIEdgeInsetsMake(-sectionHeaderHeight, 0, 0, 0);
    }
    
    if (scrollView.contentOffset.y>MDXFrom6(310)) {
        [self.screeningBar setHidden:NO];
    }
    else{
        [self.screeningBar setHidden:YES];
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
