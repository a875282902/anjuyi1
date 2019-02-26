//
//  StrategyListViewController.m
//  anjuyi1
//
//  Created by apple on 2018/9/29.
//  Copyright © 2018年 lsy. All rights reserved.
//

#import "MyStrategyListViewController.h"

#import "ScreeningBar.h"
#import "ScreeningView.h"

#import "DraftBoxTableViewCell.h"
#import "StrategyModel.h"
#import "StrategyDetailsViewController.h"

@interface MyStrategyListViewController ()<ScreeningBarDelegate,ScreeningViewDelegate,UITableViewDelegate,UITableViewDataSource>
{
    NSString *_cate;
    NSString *_door;
    NSString *_keyword;
    NSString *_order;
    NSString *_asc;
}

//筛选框
@property (nonatomic,strong) ScreeningBar    * screeningBar;
@property (nonatomic,strong) ScreeningView   * screeningView;
@property (nonatomic,strong) NSMutableArray  * screenArr;

//列表
@property (nonatomic,strong) UITableView     * tmpTableView;
@property (nonatomic,strong) NSMutableArray  * dataArr;
@property (nonatomic,assign) NSInteger         page;

@end

@implementation MyStrategyListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self baseForDefaultLeftNavButton];
    
    [self setTitle:@"我的装修攻略"];
    
    self.screenArr = [NSMutableArray array];
    self.dataArr = [NSMutableArray array];
    
    [self.view addSubview:self.screeningBar];
    
    [self.view addSubview:self.tmpTableView];
    
    [self.view addSubview:[Tools setLineView:CGRectMake(0, 0, KScreenWidth, 1)]];
//    [self.view addSubview:[Tools setLineView:CGRectMake(0, MDXFrom6(44), KScreenWidth, 1)]];
    
    _cate = @"";
    _door = @"";
    _keyword= @"";
    _order= @"1";
    _asc= @"1";
    
//    [self.navigationController.view addSubview:self.screeningView];
    
//    [self getStrategyInfo];
    
    [self load];
    
    [self.tmpTableView.mj_header beginRefreshing];
}

#pragma mark -- screeningBar
- (void)getStrategyInfo{
    
    NSString *path = [NSString stringWithFormat:@"%@/Strategy_info/get_shai_info",KURL];
    
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    __weak typeof(self) weakSelf = self;
    
    [HttpRequest POST:path parameters:nil success:^(id  _Nullable responseObject) {
        
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        
        if ([responseObject[@"code"] integerValue] == 200) {
            
            [weakSelf.screenArr addObject:responseObject[@"datas"][@"cate"]];
            [weakSelf.screenArr addObject:responseObject[@"datas"][@"door"]];
            
            NSMutableArray *cate = [NSMutableArray array];
            for (NSDictionary *dic  in weakSelf.screenArr[0]) {
                [cate addObject:dic[@"name"]];
            }
            NSMutableArray *door = [NSMutableArray array];
            for (NSDictionary *dic  in weakSelf.screenArr[1]) {
                [door addObject:dic[@"name"]];
            }
            
            [weakSelf.screeningView setDataArr:[NSMutableArray arrayWithArray:@[cate,door]]];
        }
        else{
            
            [ViewHelps showHUDWithText:responseObject[@"message"]];
        }
        
        
    } failure:^(NSError * _Nullable error) {
        
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        [RequestSever showMsgWithError:error];
    }];
    
}

- (ScreeningBar *)screeningBar{
    if (!_screeningBar) {
        _screeningBar = [[ScreeningBar alloc] initWithFrame:CGRectMake(0, 0, KScreenWidth, MDXFrom6(45))];
        _screeningBar.titleArr = @[@"综合排序",@"点赞最多",@"上传时间",@"筛选"];
        [_screeningBar setDelegate:self];
    }
    return _screeningBar;
}

- (void)selectIndex:(NSInteger)index{
    
    if (index == 3) {
        
        [self.screeningView show];
    }
    else{
        
        _order = [NSString stringWithFormat:@"%ld",(long)(index +1)];
        if ([_asc isEqualToString:@"1"]) {
            _asc = @"0";
        }
        else{
            _asc = @"1";
        }
        
        [self.tmpTableView.mj_header beginRefreshing];
    }
}

- (ScreeningView *)screeningView{
    
    if (!_screeningView) {
        _screeningView = [[ScreeningView alloc] initWithFrame:CGRectMake(0, 0, KScreenWidth, KScreenHeight)];
        [_screeningView setDelegate:self];
        [_screeningView setTypeArr:[NSMutableArray arrayWithArray: @[@"分类信息",@"户型信息"]]];
        
    }
    return _screeningView;
}

- (void)sureScreenData:(NSMutableArray *)sureArr{
    
    if ([sureArr[0] integerValue]<0) {
        _cate =@"";
    }
    else{
        NSInteger index = [sureArr[0] integerValue];
        _cate = self.screenArr[0][index][@"id"];
    }
    
    if ([sureArr[1] integerValue]<0) {
        _door =@"";
    }
    else{
        NSInteger index = [sureArr[1] integerValue];
        _door = self.screenArr[1][index][@"id"];
    }
    
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
    
    NSString *path = [NSString stringWithFormat:@"%@/member/my_strategy",KURL];
    NSDictionary *header = @{@"token":UTOKEN};
//    NSDictionary *parameter = @{@"page":[NSString stringWithFormat:@"%ld",self.page],
//                                @"keyword":_keyword,
//                                @"door":[NSString stringWithFormat:@"%@",_door],
//                                @"cate_id":[NSString stringWithFormat:@"%@",_cate],
//                                @"order":_order,
//                                @"asc":_asc};
    
    NSDictionary *parameter = @{@"page":[NSString stringWithFormat:@"%ld",(long)self.page]};
    
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    __weak typeof(self) weakSelf = self;
    
    [HttpRequest POSTWithHeader:header  url:path parameters:parameter success:^(id  _Nullable responseObject) {
        
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        
        if ([responseObject[@"code"] integerValue] == 200) {
            [weakSelf.dataArr removeAllObjects];
            if ([responseObject[@"datas"] isKindOfClass:[NSArray class]] ) {
                for (NSDictionary *dict in responseObject[@"datas"]) {
                    StrategyModel *model = [[StrategyModel alloc] initWithDictionary:dict];
                    model.member_info = @{@"head":dict[@"head"],@"nick_name":dict[@"nick_name"]};
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
        
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        [RequestSever showMsgWithError:error];
    }];
    
}
//上拉加载
- (void)pullUpLoadMore{
    NSString *path = [NSString stringWithFormat:@"%@/Strategy_info/ajax_strategy_tui",KURL];
    NSDictionary *header = @{@"token":UTOKEN};
//    NSDictionary *parameter = @{@"page":[NSString stringWithFormat:@"%ld",self.page],
//                                @"keyword":_keyword,
//                                @"door":[NSString stringWithFormat:@"%@",_door],
//                                @"cate_id":[NSString stringWithFormat:@"%@",_cate],
//                                @"order":_order,
//                                @"asc":_asc};

    NSDictionary *parameter = @{@"page":[NSString stringWithFormat:@"%ld",(long)self.page]};
    
    
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    __weak typeof(self) weakSelf = self;
    
    [HttpRequest POSTWithHeader:header  url:path parameters:parameter success:^(id  _Nullable responseObject) {
        
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        
        if ([responseObject[@"code"] integerValue] == 200) {
            
            if ([responseObject[@"datas"] isKindOfClass:[NSArray class]] ) {
                for (NSDictionary *dict in responseObject[@"datas"]) {
                    StrategyModel *model = [[StrategyModel alloc] initWithDictionary:dict];
                    model.member_info = @{@"head":dict[@"head"],@"nick_name":dict[@"nick_name"]};
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

#pragma mark -- tableView
- (UITableView *)tmpTableView{
    
    if (!_tmpTableView) {
        _tmpTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, KScreenWidth, KViewHeight) style:(UITableViewStylePlain)];
        [_tmpTableView setSeparatorStyle:(UITableViewCellSeparatorStyleNone)];
        if (@available(iOS 11.0, *)) {
            [_tmpTableView setContentInsetAdjustmentBehavior:(UIScrollViewContentInsetAdjustmentNever)];
        }
        [_tmpTableView setShowsVerticalScrollIndicator:NO];
        [_tmpTableView setShowsHorizontalScrollIndicator:NO];
        [_tmpTableView setDataSource:self];
        [_tmpTableView setDelegate:self];
    }
    return _tmpTableView;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataArr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    DraftBoxTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"StrategyListViewController"];
    if (!cell) {
        cell = [[DraftBoxTableViewCell alloc] initWithStyle:(UITableViewCellStyleDefault) reuseIdentifier:@"StrategyListViewController"];
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
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if (indexPath.row < self.dataArr.count) {
        
        StrategyModel *model = self.dataArr[indexPath.row];
        
        StrategyDetailsViewController *vc = [[StrategyDetailsViewController alloc] init];
        vc.strategy_id = model.ID;
        [self.navigationController pushViewController:vc animated:YES];
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
