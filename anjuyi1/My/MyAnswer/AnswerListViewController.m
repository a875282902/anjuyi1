//
//  MyAnswerViewController.m
//  anjuyi1
//
//  Created by 李 on 2018/6/3.
//  Copyright © 2018年 lsy. All rights reserved.
//
#import "AnswerListViewController.h"
#import "MyAnswerTableViewCell.h"
#import "AnswerModel.h"
#import "TopicDetailsViewController.h"

@interface AnswerListViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic,strong)UITableView     * tmpTableView;
@property (nonatomic,strong)NSMutableArray  * dataArr;
@property (nonatomic,assign)NSInteger         page;

@end

@implementation AnswerListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self setTitle:@"回答"];
    
    [self baseForDefaultLeftNavButton];
    self.page = 1;
    self.dataArr = [NSMutableArray array];
    
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
    
    NSString *path = [NSString stringWithFormat:@"%@/topic_info/user_answer",KURL];
    
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    __weak typeof(self) weakSelf = self;
    
    [HttpRequest POST:path parameters:@{@"page":[NSString stringWithFormat:@"%ld",self.page],@"user_id":self.user_id} success:^(id  _Nullable responseObject) {
        
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        
        if ([responseObject[@"code"] integerValue] == 200) {
            
            if ([responseObject[@"datas"] isKindOfClass:[NSArray class]]) {
                for (NSDictionary *dic in responseObject[@"datas"]) {
                    AnswerModel *model = [[AnswerModel alloc] initWithDictionary:dic];
                    [weakSelf.dataArr addObject:model];
                }
            }
        }
        else{
            
            [ViewHelps showHUDWithText:responseObject[@"message"]];
        }
        if (weakSelf.dataArr.count < weakSelf.page *10) {
            [weakSelf.tmpTableView.mj_footer endRefreshingWithNoMoreData];
        }
        
        [weakSelf.tmpTableView.mj_header endRefreshing];
        [weakSelf.tmpTableView reloadData];
        
    } failure:^(NSError * _Nullable error) {
        [weakSelf.tmpTableView.mj_header endRefreshing];
        [MBProgressHUD hideHUDForView:weakSelf.view animated:YES];
        [RequestSever showMsgWithError:error];
    }];
    
}
//上拉加载
- (void)pullUpLoadMore{
    
    NSString *path = [NSString stringWithFormat:@"%@/topic_info/user_answer",KURL];

    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    __weak typeof(self) weakSelf = self;
    
    [HttpRequest POST:path parameters:@{@"page":[NSString stringWithFormat:@"%ld",self.page],@"user_id":self.user_id} success:^(id  _Nullable responseObject) {
        
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        
        if ([responseObject[@"code"] integerValue] == 200) {
            
            if ([responseObject[@"datas"] isKindOfClass:[NSArray class]]) {
                for (NSDictionary *dic in responseObject[@"datas"]) {
                    AnswerModel *model = [[AnswerModel alloc] initWithDictionary:dic];
                    [weakSelf.dataArr addObject:model];
                }
            }
        }
        else{
            weakSelf.page -- ;
            [ViewHelps showHUDWithText:responseObject[@"message"]];
        }
        if (weakSelf.dataArr.count < weakSelf.page *10) {
            [weakSelf.tmpTableView.mj_footer endRefreshingWithNoMoreData];
        }
        else{
            [weakSelf.tmpTableView.mj_footer endRefreshing];
        }
        [weakSelf.tmpTableView reloadData];
        
    } failure:^(NSError * _Nullable error) {
        weakSelf.page -- ;
        [weakSelf.tmpTableView.mj_footer endRefreshing];
        [MBProgressHUD hideHUDForView:weakSelf.view animated:YES];
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
    
    MyAnswerTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MyAnswerTableViewCell"];
    if (!cell) {
        cell = [[MyAnswerTableViewCell alloc] initWithStyle:(UITableViewCellStyleDefault) reuseIdentifier:@"MyAnswerTableViewCell"];
    }
    
    [cell setSelectionStyle:(UITableViewCellSelectionStyleNone)];
    
    if (indexPath.row < self.dataArr.count) {
        [cell bandDataWithModel:self.dataArr[indexPath.row]];
    }
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 155;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row < self.dataArr.count) {
        AnswerModel *model = self.dataArr[indexPath.row];
        TopicDetailsViewController *vc = [[TopicDetailsViewController alloc] init];
        vc.topic_id = model.topic_id;
        NSArray *arr = @[[UIColor colorWithHexString:@"#62afd3"],
                         [UIColor colorWithHexString:@"#8f8e94"],
                         [UIColor colorWithHexString:@"#d3a25d"],
                         [UIColor colorWithHexString:@"#ad544b"],
                         [UIColor colorWithHexString:@"#57aa63"]];
        
        vc.backColor = arr[arc4random()%5];
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
