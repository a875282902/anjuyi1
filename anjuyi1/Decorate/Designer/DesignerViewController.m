//
//  DecorateViewController.m
//  anjuyi
//
//  Created by 李 on 2018/5/29.
//  Copyright © 2018年 lsy. All rights reserved.
//
//  设计师

#import "DesignerViewController.h"
#import "SearchView.h"
#import "DesignerTableViewCell.h"
#import "IanScrollView.h"
#import "DesignerDetailsVC.h"

#import "MasterModel.h"
#import "ShowWebViewController.h"

#import "StrategyCaseListViewController.h"
#import "HouseCaseListViewController.h"//整屋列表
#import "DesignerListViewController.h"


#define hederHeight MDXFrom6(55)

@interface DesignerViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic,strong)UITableView         *   tmpTableView;
@property (nonatomic,strong)NSMutableArray      *   dataArr;
@property (nonatomic,strong)UIView              *   headerView;
@property (nonatomic,strong)IanScrollView       *   bannerScroll;

@property (nonatomic,assign)NSInteger               page;
@property (nonatomic,strong)NSMutableArray      *   bannerArr;//广告数据

@end

@implementation DesignerViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
//    [self.view setBackgroundColor:[UIColor colorWithHexString:@"#f6f6f6"]];
    
    //搜索框
    SearchView *search = [[SearchView alloc] initWithFrame:CGRectMake(0, 0, MDXFrom6(355), 30) Title:@"大家都在搜设计师"];
    [search addTarget:self action:@selector(jumpSearch)];
//    [self.navigationItem setTitleView:search];
    
    [self baseForDefaultLeftNavButton];
    [self setTitle:@"找设计师"];
    
    self.page = 1;

    self.dataArr = [NSMutableArray array];
    self.bannerArr = [NSMutableArray array];
    
    [self.view addSubview:self.tmpTableView];
    
    [self load];
    
    [self pullDownRefresh];
    
    [self getBannerData];

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
    
    NSString *path = [NSString stringWithFormat:@"%@/designer/get_designer_list",KURL];

    NSDictionary *dic = @{@"page":[NSString stringWithFormat:@"%ld",self.page]};
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    __weak typeof(self) weakSelf = self;
    
    [HttpRequest POST:path parameters:dic success:^(id  _Nullable responseObject) {
        
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        
        if ([responseObject[@"code"] integerValue] == 200) {
            
            if ([responseObject[@"datas"] isKindOfClass:[NSArray class]]) {
                
                for (NSDictionary *dic in responseObject[@"datas"]) {
                    MasterModel *model = [[MasterModel alloc] initWithDictionary:dic];
                    model.type = @"设计师";
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
    
    NSString *path = [NSString stringWithFormat:@"%@/designer/get_designer_list",KURL];
    
    NSDictionary *dic = @{@"page":[NSString stringWithFormat:@"%ld",self.page]};
    
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    __weak typeof(self) weakSelf = self;
    
    [HttpRequest POST:path parameters:dic success:^(id  _Nullable responseObject) {
        
        [MBProgressHUD hideHUDForView:weakSelf.view animated:YES];
        
        if ([responseObject[@"code"] integerValue] == 200) {
            
            if ([responseObject[@"datas"] isKindOfClass:[NSArray class]]) {
                
                for (NSDictionary *dic in responseObject[@"datas"]) {
                    MasterModel *model = [[MasterModel alloc] initWithDictionary:dic];
                    model.type = @"设计师";
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
    
    NSString *path = [NSString stringWithFormat:@"%@/designer/index",KURL];
    
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

#pragma mark --  headerView
- (UIView *)headerView{
    
    if (!_headerView) {
        _headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, KScreenWidth, MDXFrom6(310))];
        [_headerView setBackgroundColor:[UIColor whiteColor]];
        
        NSArray *arr = @[@"designer_know",@"designer_family",@"designer_industry",@"designer_expert"];
        NSArray *tarr = @[@"设计知识",@"家庭装修",@"工业装修",@"名家汇"];
        for (NSInteger i = 0 ; i < 4; i ++) {
            UIView *back = [[UIView alloc] initWithFrame:CGRectMake(KScreenWidth*i/4, 0, KScreenWidth/4, MDXFrom6(90))];
            [back addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(selectService:)]];
            [back setTag:i];
            [_headerView addSubview:back];
            
            [back addSubview:[Tools creatImage:CGRectMake(MDXFrom6(29.375), MDXFrom6(20), MDXFrom6(35), MDXFrom6(30)) image:arr[i]]];
            [back addSubview:[Tools creatLabel:CGRectMake(0, MDXFrom6(55), KScreenWidth/4, MDXFrom6(25)) font:[UIFont systemFontOfSize:12] color:[UIColor colorWithHexString:@"#3b3b3b"] alignment:(NSTextAlignmentCenter) title:tarr[i]]];
            
        }
        
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
#pragma mark -- tableView
- (UITableView *)tmpTableView{
    
    if (!_tmpTableView) {
        _tmpTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, MDXFrom6(10), KScreenWidth,KViewHeight- MDXFrom6(10)) style:(UITableViewStylePlain)];
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



- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    
    return hederHeight;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    
    UIView *header = [[UIView alloc] initWithFrame:CGRectMake(0, 0, KScreenWidth, hederHeight)];
    [header setBackgroundColor:[UIColor whiteColor]];
    
    [header addSubview:[Tools setLineView:CGRectMake(0, 0, KScreenWidth , MDXFrom6(10))]];
    
    [header addSubview:[Tools creatImage:CGRectMake(MDXFrom6(10), MDXFrom6(30), MDXFrom6(18), MDXFrom6(18)) url:@"" image:@"zx_fdesign"]];
    
    [header addSubview:[Tools creatLabel:CGRectMake(MDXFrom6(40), MDXFrom6(15), MDXFrom6(300), MDXFrom6(45)) font:[UIFont boldSystemFontOfSize:16] color:[UIColor colorWithHexString:@"#3B3B3B"] alignment:(NSTextAlignmentLeft) title:@"优秀设计师"]];
    
    
    return header;
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (indexPath.row < self.dataArr.count) {
        
        MasterModel *model = self.dataArr[indexPath.row];
        
        DesignerDetailsVC *controller = [[DesignerDetailsVC alloc] init];
        controller.designerID = model.user_id;
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
            StrategyCaseListViewController *vc = [[StrategyCaseListViewController alloc] init];
            [self.navigationController pushViewController:vc animated:YES];
        }
            break;
        case 1:
        {
            HouseCaseListViewController *vc = [[HouseCaseListViewController alloc] init];
            [self.navigationController pushViewController:vc animated:YES];
        }
            break;
        case 2:
        {
            HouseCaseListViewController *vc = [[HouseCaseListViewController alloc] init];
            [self.navigationController pushViewController:vc animated:YES];
        }
            break;
        case 3:
        {
            DesignerListViewController *vc = [[DesignerListViewController alloc] init];
            [self.navigationController pushViewController:vc animated:YES];
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
