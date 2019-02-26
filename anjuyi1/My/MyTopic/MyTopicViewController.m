//
//  MyTopicViewController.m
//  anjuyi1
//
//  Created by 李 on 2018/6/3.
//  Copyright © 2018年 lsy. All rights reserved.
//
// 关注的话题

#import "MyTopicViewController.h"
#import "TopicListTableViewCell.h"
#import "TopicModel.h"

@interface MyTopicViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic,strong) UITableView            * tmpTableView;
@property (nonatomic,strong) NSMutableArray         * dataArr;
@property (nonatomic,assign) NSInteger                page;
@end

@implementation MyTopicViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self setTitle:@"关注的话题"];
    
    [self baseForDefaultLeftNavButton];
    
    self.dataArr = [NSMutableArray array];
    self.page = 1;
    

    [self.view addSubview:self.tmpTableView];
    
    [self.view addSubview:[Tools setLineView:CGRectMake(0, 0, KScreenWidth, 1.5)]];
    
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
    
    
    NSString *path = [NSString stringWithFormat:@"%@/member/my_follow_topic",KURL];
    
    NSDictionary *header = @{@"token":UTOKEN};
    
    
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    __weak typeof(self) weakSelf = self;
    
    [HttpRequest POSTWithHeader:header url:path parameters:@{@"page":[NSString stringWithFormat:@"%ld",(long)self.page]} success:^(id  _Nullable responseObject) {
        
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        
        if ([responseObject[@"code"] integerValue] == 200) {
            if (responseObject[@"datas"]&& [responseObject[@"datas"]  isKindOfClass:[NSArray class]]&& [responseObject[@"datas"] count]!=0) {
                for (NSDictionary *dic in responseObject[@"datas"]) {
                    TopicModel *model = [[TopicModel alloc] initWithDictionary:dic];
                    [weakSelf.dataArr addObject:model];
                }
            }
            else{
                [self.tmpTableView.mj_footer endRefreshingWithNoMoreData];
            }
        }
        else{
            
            [ViewHelps showHUDWithText:responseObject[@"message"]];
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
    
    NSString *path = [NSString stringWithFormat:@"%@/member/my_follow_topic",KURL];
    
    NSDictionary *header = @{@"token":UTOKEN};
    
    
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    __weak typeof(self) weakSelf = self;
    
    [HttpRequest POSTWithHeader:header url:path parameters:@{@"page":[NSString stringWithFormat:@"%ld",(long)self.page]} success:^(id  _Nullable responseObject) {
        
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        
        if ([responseObject[@"code"] integerValue] == 200) {
            
            if (responseObject[@"datas"]&&[responseObject[@"datas"]  isKindOfClass:[NSArray class]] && [responseObject[@"datas"] count]!=0) {
                for (NSDictionary *dic in responseObject[@"datas"]) {
                    TopicModel *model = [[TopicModel alloc] initWithDictionary:dic];
                    [weakSelf.dataArr addObject:model];
                }
                
                 [weakSelf.tmpTableView.mj_footer endRefreshing];
            }
            else{
                
                 [weakSelf.tmpTableView.mj_footer endRefreshingWithNoMoreData];
            }
           
        }
        else{
            
            [ViewHelps showHUDWithText:responseObject[@"message"]];
        }
        
       
        [weakSelf.tmpTableView reloadData];
        
    } failure:^(NSError * _Nullable error) {
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
        [_tmpTableView setEstimatedRowHeight:500.0f];
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
    
    TopicListTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MyTopicListTableViewCell"];
    if (!cell) {
        cell = [[TopicListTableViewCell alloc] initWithStyle:(UITableViewCellStyleDefault) reuseIdentifier:@"MyTopicListTableViewCell"];
    }
    if (indexPath.row < self.dataArr.count) {

        [cell bandDataWithModel:self.dataArr[indexPath.row]];
    }
    return cell;
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
