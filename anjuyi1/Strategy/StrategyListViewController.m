//
//  StrategyListViewController.m
//  anjuyi1
//
//  Created by apple on 2018/9/29.
//  Copyright © 2018年 lsy. All rights reserved.
//

#import "StrategyListViewController.h"

#import "DraftBoxTableViewCell.h"
#import "StrategyModel.h"
#import "StrategyDetailsViewController.h"

@interface StrategyListViewController ()<UITableViewDelegate,UITableViewDataSource>

//列表
@property (nonatomic,strong) UITableView     * tmpTableView;
@property (nonatomic,strong) NSMutableArray  * dataArr;
@property (nonatomic,assign) NSInteger         page;

@end

@implementation StrategyListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self baseForDefaultLeftNavButton];
    
    [self setTitle:@"装修攻略"];

    self.dataArr = [NSMutableArray array];
    
    [self.view addSubview:self.tmpTableView];
    
    [self.view addSubview:[Tools setLineView:CGRectMake(0, 0, KScreenWidth, 1)]];

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
    
    NSString *path = [NSString stringWithFormat:@"%@/strategy_info/strategy_list_by_id",KURL];
    
    NSDictionary *parameter = @{@"page":[NSString stringWithFormat:@"%ld",self.page],
                                @"user_id":self.user_id};
    
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    __weak typeof(self) weakSelf = self;
    
    [HttpRequest POST:path parameters:parameter success:^(id  _Nullable responseObject) {
        
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        
        if ([responseObject[@"code"] integerValue] == 200) {
            [weakSelf.dataArr removeAllObjects];
            if ([responseObject[@"datas"] isKindOfClass:[NSArray class]] ) {
                for (NSDictionary *dict in responseObject[@"datas"]) {
                    StrategyModel *model = [[StrategyModel alloc] initWithDictionary:dict];
                    model.member_info = @{@"nick_name":dict[@"nickname"],@"head":dict[@"head"]};
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
    NSString *path = [NSString stringWithFormat:@"%@/strategy_info/strategy_list_by_id",KURL];
    
    NSDictionary *parameter = @{@"page":[NSString stringWithFormat:@"%ld",self.page],
                                @"user_id":self.user_id};
    
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    __weak typeof(self) weakSelf = self;
    
    [HttpRequest POST:path parameters:parameter success:^(id  _Nullable responseObject) {
        
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        
        if ([responseObject[@"code"] integerValue] == 200) {
            
            if ([responseObject[@"datas"] isKindOfClass:[NSArray class]] ) {
                for (NSDictionary *dict in responseObject[@"datas"]) {
                    StrategyModel *model = [[StrategyModel alloc] initWithDictionary:dict];
                    model.member_info = @{@"nick_name":dict[@"nickname"],@"head":dict[@"head"]};
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
