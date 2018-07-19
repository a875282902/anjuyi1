//
//  ChargingCaseViewController.m
//  anjuyi1
//
//  Created by apple on 2018/7/19.
//  Copyright © 2018年 lsy. All rights reserved.
//

#import "ChargingCaseViewController.h"
#import "ChargingCaseTableViewCell.h"
#import "ShowDetailsViewController.h"

@interface ChargingCaseViewController ()<UITableViewDelegate,UITableViewDataSource>
{
    NSInteger _page;
}

@property (nonatomic,strong) UITableView     * tmpTableView;
@property (nonatomic,strong) NSMutableArray  * dataArr;

@end

@implementation ChargingCaseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self baseForDefaultLeftNavButton];
    [self setTitle:@"充电桩安装案例"];
    
    _page = 1;
    
    self.dataArr = [NSMutableArray array];
    
    [self.view addSubview:self.tmpTableView];
    [self.view addSubview:[Tools setLineView:CGRectMake(0, 0, KScreenWidth, 1)]];
    
    [self load];
    
    [self pullDownRefresh];
    
}

#pragma mark -- refresh
- (void)load{
    __weak typeof(self) weakSelf = self;
    
    self.tmpTableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        self->_page = 1;
        [weakSelf pullDownRefresh];
        [weakSelf.tmpTableView.mj_footer resetNoMoreData];
    }];
    
    self.tmpTableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        self->_page++;
        [weakSelf pullUpLoadMore];
    }];
    
}
//下拉刷新
- (void)pullDownRefresh{

    NSString *path = [NSString stringWithFormat:@"%@/charging/install_case",KURL];
    
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    NSDictionary *dic = @{@"page":@(_page)};
    
    __weak typeof(self) weakSelf = self;
    
    [HttpRequest POST:path parameters:dic success:^(id  _Nullable responseObject) {
        
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        
        if ([responseObject[@"code"] integerValue] == 200) {
            [weakSelf.dataArr removeAllObjects];
            if ([responseObject[@"datas"] isKindOfClass:[NSArray class]]) {
                
                for (NSDictionary *dic in responseObject[@"datas"]) {
                    [weakSelf.dataArr addObject:dic];
                }
                [weakSelf.tmpTableView reloadData];
                [weakSelf.tmpTableView.mj_header endRefreshing];
            }
            else{
                [weakSelf.tmpTableView.mj_header endRefreshing];
                [weakSelf.tmpTableView.mj_footer endRefreshingWithNoMoreData];
            }
        }
        else{
            
            [ViewHelps showHUDWithText:responseObject[@"message"]];
        }
        
        
    } failure:^(NSError * _Nullable error) {
        
        [weakSelf.tmpTableView.mj_header endRefreshing];
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        [RequestSever showMsgWithError:error];
    }];

}
//上拉加载
- (void)pullUpLoadMore{

    NSString *path = [NSString stringWithFormat:@"%@/charging/install_case",KURL];
    
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    NSDictionary *dic = @{@"page":@(_page)};
    
    __weak typeof(self) weakSelf = self;
    
    [HttpRequest POST:path parameters:dic success:^(id  _Nullable responseObject) {
        
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        
        if ([responseObject[@"code"] integerValue] == 200) {
            
            if ([responseObject[@"datas"] isKindOfClass:[NSArray class]]) {
                
                for (NSDictionary *dic in responseObject[@"datas"]) {
                    [weakSelf.dataArr addObject:dic];
                }
                [weakSelf.tmpTableView reloadData];
                [weakSelf.tmpTableView.mj_footer endRefreshing];
            }
            else{
                
                [weakSelf.tmpTableView.mj_footer endRefreshingWithNoMoreData];
            }
        }
        else{
            self->_page -- ;
            [ViewHelps showHUDWithText:responseObject[@"message"]];
        }
        
        
        
    } failure:^(NSError * _Nullable error) {
        
        self->_page -- ;
        [weakSelf.tmpTableView.mj_footer endRefreshing];
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        [RequestSever showMsgWithError:error];
    }];
}


#pragma mark -- tableView
- (UITableView *)tmpTableView{
    
    if (!_tmpTableView) {
        _tmpTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, KScreenWidth, KScreenHeight-KTopHeight) style:(UITableViewStylePlain)];
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
    
    ChargingCaseTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ChargingCaseTableViewCell"];
    if (!cell) {
        cell = [[ChargingCaseTableViewCell alloc] initWithStyle:(UITableViewCellStyleDefault) reuseIdentifier:@"ChargingCaseTableViewCell"];
    }
    
    [cell setSelectionStyle:(UITableViewCellSelectionStyleNone)];
    
    if (indexPath.row < self.dataArr.count) {
        [cell bandDataWithDictionary:self.dataArr[indexPath.row]];
    }
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 265;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    ShowDetailsViewController *vc = [[ShowDetailsViewController alloc] init];
    vc.url = [NSString stringWithFormat:@"https://api.ajyvip.com/charging/case_detail/id/%@",self.dataArr[indexPath.row][@"id"]];
    [vc.navigationItem setTitle:@"案例详情"];
    [self.navigationController pushViewController:vc animated:YES];
    
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
