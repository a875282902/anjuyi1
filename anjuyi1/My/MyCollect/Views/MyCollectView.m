//
//  MyCollectView.m
//  anjuyi1
//
//  Created by apple on 2018/8/6.
//  Copyright © 2018年 lsy. All rights reserved.
//

#import "MyCollectView.h"
#import "DraftBoxTableViewCell.h"//整屋的cell
#import "HouseModel.h"
#import "StrategyModel.h"
#import "TopicListTableViewCell.h"//话题
#import "TopicModel.h"

#import "HouseDetailsViewController.h"
#import "StrategyDetailsViewController.h"
#import "TopicDetailsViewController.h"

@interface MyCollectView ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic,strong) UITableView    * tmpTableView;

@property (nonatomic,strong) NSMutableArray * dataArr;

@property (nonatomic,assign) NSInteger        page;

@end

@implementation MyCollectView

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self == [super initWithFrame:frame]) {
        [self addSubview:self.tmpTableView];
    }
    return self;
}

- (void)setIndex:(NSInteger)index{
    
    _index = index;
    [self.dataArr removeAllObjects];
    self.page = 1;
    [self load];
    [self.tmpTableView.mj_header beginRefreshing];
}

- (NSMutableArray *)dataArr{
    
    if (!_dataArr) {
        _dataArr = [NSMutableArray array];
    }
    return _dataArr;
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
    
    NSString *path = [NSString stringWithFormat:@"%@/member/my_collect",KURL];
    
    NSDictionary *header = @{@"token":UTOKEN};
    NSDictionary *dic = @{@"type":[NSString stringWithFormat:@"%ld",(long)(self.index+1)],
                          @"page":[NSString stringWithFormat:@"%ld",(long)self.page]};
    
    __weak typeof(self) weakSelf = self;
    
    [MBProgressHUD showHUDAddedTo:self animated:YES];
    
    [HttpRequest POSTWithHeader:header url:path parameters:dic success:^(id  _Nullable responseObject) {
        [MBProgressHUD hideHUDForView:self animated:YES];
        if ([responseObject[@"code"] integerValue] == 200) {
            if ([responseObject[@"datas"] isKindOfClass:[NSArray class]]) {
                for (NSDictionary *dic in responseObject[@"datas"]) {
                    [weakSelf.dataArr addObject:dic];
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
        [MBProgressHUD hideHUDForView:self animated:YES];
        [RequestSever showMsgWithError:error];
    }];
    
}
//上拉加载
- (void)pullUpLoadMore{
    
    NSString *path = [NSString stringWithFormat:@"%@/member/my_collect",KURL];
    
    NSDictionary *header = @{@"token":UTOKEN};
    NSDictionary *dic = @{@"type":[NSString stringWithFormat:@"%ld",(long)(self.index+1)]};
    
    __weak typeof(self) weakSelf = self;
    
    [MBProgressHUD showHUDAddedTo:self animated:YES];
    
    [HttpRequest POSTWithHeader:header url:path parameters:dic success:^(id  _Nullable responseObject) {
        [MBProgressHUD hideHUDForView:self animated:YES];
        if ([responseObject[@"code"] integerValue] == 200) {
            if ([responseObject[@"datas"] isKindOfClass:[NSArray class]]) {
                for (NSDictionary *dic in responseObject[@"datas"]) {
                    [weakSelf.dataArr addObject:dic];
                }
            }
            
        }
        else{
            [weakSelf.tmpTableView.mj_footer endRefreshing];
            weakSelf.page--;
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
        [weakSelf.tmpTableView.mj_footer endRefreshing];
        weakSelf.page--;
        [MBProgressHUD hideHUDForView:self animated:YES];
        [RequestSever showMsgWithError:error];
    }];
    
}

#pragma mark -- tableView
- (UITableView *)tmpTableView{
    
    if (!_tmpTableView) {
        _tmpTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, KScreenWidth, self.frame.size.height) style:(UITableViewStylePlain)];
        [_tmpTableView setSeparatorStyle:(UITableViewCellSeparatorStyleNone)];
        if (@available(iOS 11.0, *)) {
            [_tmpTableView setContentInsetAdjustmentBehavior:(UIScrollViewContentInsetAdjustmentNever)];
        }
        [_tmpTableView setShowsVerticalScrollIndicator:NO];
        [_tmpTableView setShowsHorizontalScrollIndicator:NO];
//        [_tmpTableView setTableHeaderView:self.headerView];
        [_tmpTableView setDataSource:self];
        [_tmpTableView setDelegate:self];
    }
    return _tmpTableView;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataArr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (self.index == 0) {
        DraftBoxTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"mycollectviewCell1"];
        if (!cell) {
            cell = [[DraftBoxTableViewCell alloc] initWithStyle:(UITableViewCellStyleDefault) reuseIdentifier:@"mycollectviewCell1"];
        }
        
        if (indexPath.row <self.dataArr.count) {
            
            NSDictionary *dic = self.dataArr[indexPath.row];
            HouseModel *model = [[HouseModel alloc] initWithDictionary:dic];
            [cell bandDataWithModel:model];
            
        }

        return cell;
    }
    if (self.index == 1) {
        DraftBoxTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"mycollectviewCell2"];
        if (!cell) {
            cell = [[DraftBoxTableViewCell alloc] initWithStyle:(UITableViewCellStyleDefault) reuseIdentifier:@"mycollectviewCell2"];
        }
        
        if (indexPath.row <self.dataArr.count) {
            
            NSDictionary *dic = self.dataArr[indexPath.row];
            StrategyModel *model = [[StrategyModel alloc] initWithDictionary:dic];
            [cell bandDataWithModel:model];
            
        }
        
        return cell;
    }
    
    if (self.index == 3) {
        TopicListTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"mycollectviewCell4"];
        if (!cell) {
            cell = [[TopicListTableViewCell alloc] initWithStyle:(UITableViewCellStyleDefault) reuseIdentifier:@"mycollectviewCell4"];
        }
        
        if (indexPath.row <self.dataArr.count) {
            
            NSDictionary *dic = self.dataArr[indexPath.row];
            TopicModel *model = [[TopicModel alloc] initWithDictionary:dic];
            [cell bandDataWithModel:model];
            
        }
        
        return cell;
    }
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MallTableViewCell"];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:(UITableViewCellStyleDefault) reuseIdentifier:@"MallTableViewCell"];
    }
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (self.index == 0 || self.index == 1) {
        return 265;
    }
    if (self.index == 3) {
        return UITableViewAutomaticDimension;
    }
    return 40;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
     if (self.index == 0) {
     
         HouseDetailsViewController *vc = [[HouseDetailsViewController alloc] init];
         HouseModel *model = [[HouseModel alloc] initWithDictionary:self.dataArr[indexPath.row]];
         vc.house_id =model.ID;
         self.push(vc);
         
     }
    
    if (self.index == 1) {
        
        StrategyDetailsViewController *vc = [[StrategyDetailsViewController alloc] init];
        StrategyModel *model = [[StrategyModel alloc] initWithDictionary:self.dataArr[indexPath.row]];
        vc.strategy_id =model.ID;
        self.push(vc);
        
    }
    
    if (self.index == 3) {
        
        TopicDetailsViewController *vc = [[TopicDetailsViewController alloc] init];
        TopicModel *model = [[TopicModel alloc] initWithDictionary:self.dataArr[indexPath.row]];
        vc.topic_id =model.ID;
        self.push(vc);
        
    }
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
