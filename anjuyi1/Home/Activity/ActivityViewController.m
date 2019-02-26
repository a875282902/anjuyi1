//
//  ActivityViewController.m
//  anjuyi1
//
//  Created by apple on 2018/8/7.
//  Copyright © 2018年 lsy. All rights reserved.
//

#import "ActivityViewController.h"
#import "ActivityModel.h"
#import "ActivityTableViewCell.h"
#import "ActivityDetailsViewController.h"

#import "AddActivityPhotoViewController.h"

@interface ActivityViewController ()<UITableViewDelegate,UITableViewDataSource>
{
    NSInteger _page;
}

@property (nonatomic,strong)UITableView    * tmpTableView;
@property (nonatomic,strong)NSMutableArray * dataArr;

@end

@implementation ActivityViewController
- (void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:animated];
    
    [self.navigationController setNavigationBarHidden:NO animated:YES];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self setTitle:@"正在征集"];
    [self baseForDefaultLeftNavButton];
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
        [weakSelf.dataArr removeAllObjects];
        [weakSelf pullDownRefresh];
        
        [weakSelf.tmpTableView.mj_footer resetNoMoreData];
    }];
    
    self.tmpTableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        self->_page++;
        [weakSelf pullUpLoadMore];
    }];
    
}
//下拉刷新
- (void)pullDownRefresh{
    
    NSString *path = [NSString stringWithFormat:@"%@/activity/index",KURL];
    
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    NSDictionary *dic = @{@"page":[NSString stringWithFormat:@"%ld",(long)_page]};
    
    __weak typeof(self) weakSelf = self;
    
    [HttpRequest POST:path parameters:dic success:^(id  _Nullable responseObject) {
        
        [MBProgressHUD hideHUDForView:weakSelf.view animated:YES];
        
        if ([responseObject[@"code"] integerValue] == 200) {
            if ([responseObject[@"datas"] isKindOfClass:[NSArray class]]) {
                
                for (NSDictionary *dic in responseObject[@"datas"]) {
                    ActivityModel *model = [[ActivityModel alloc] initWithDictionary:dic];
                    [weakSelf.dataArr addObject:model];
                }
            }
            
            [weakSelf.tmpTableView.mj_header endRefreshing];
            [weakSelf.tmpTableView reloadData];
        }
        else{
            
            [ViewHelps showHUDWithText:responseObject[@"message"]];
        }
        if (weakSelf.dataArr.count<self->_page *10) {
            [weakSelf.tmpTableView.mj_footer endRefreshingWithNoMoreData];
        }
        
    } failure:^(NSError * _Nullable error) {
        
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        [RequestSever showMsgWithError:error];
    }];
}
//上拉加载
- (void)pullUpLoadMore{
    NSString *path = [NSString stringWithFormat:@"%@/activity/index",KURL];
    
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    NSDictionary *dic = @{@"page":[NSString stringWithFormat:@"%ld",(long)_page]};
    
    __weak typeof(self) weakSelf = self;
    
    [HttpRequest POST:path parameters:dic success:^(id  _Nullable responseObject) {
        
        [MBProgressHUD hideHUDForView:weakSelf.view animated:YES];
        
        if ([responseObject[@"code"] integerValue] == 200) {
            if ([responseObject[@"datas"] isKindOfClass:[NSArray class]]) {
                
                for (NSDictionary *dic in responseObject[@"datas"]) {
                    ActivityModel *model = [[ActivityModel alloc] initWithDictionary:dic];
                    [weakSelf.dataArr addObject:model];
                }
                
                [weakSelf.tmpTableView.mj_footer endRefreshing];
                
            }
            else{
                [weakSelf.tmpTableView.mj_footer endRefreshingWithNoMoreData];
                
            }
            

            [weakSelf.tmpTableView reloadData];
        }
        else{
            
            [ViewHelps showHUDWithText:responseObject[@"message"]];
        }
        
        
    } failure:^(NSError * _Nullable error) {
        self->_page --;
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
        [_tmpTableView setRowHeight:UITableViewAutomaticDimension];
        [_tmpTableView setEstimatedRowHeight:100.0f];
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
    
    ActivityTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ActivityTableViewCell"];
    if (!cell) {
        cell = [[ActivityTableViewCell alloc] initWithStyle:(UITableViewCellStyleDefault) reuseIdentifier:@"ActivityTableViewCell"];
    }
    if (indexPath.row < self.dataArr.count) {

        ActivityModel *model = self.dataArr[indexPath.row];
        
        [cell bandDataWithModel:model];
        
        [cell setSelectToParticipate:^{

            AddActivityPhotoViewController *VC = [[AddActivityPhotoViewController alloc] init];
            VC.activity_id = model.ID;
            [self.navigationController pushViewController:VC animated:YES];
        }];
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    ActivityModel *model = self.dataArr[indexPath.row];
    
    ActivityDetailsViewController *VC = [[ActivityDetailsViewController alloc] init];
    VC.activity_id = model.ID;
    [self.navigationController pushViewController:VC animated:YES];
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
