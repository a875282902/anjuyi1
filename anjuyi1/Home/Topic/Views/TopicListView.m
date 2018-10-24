//
//  ChannelListView.m
//  anjuyi1
//
//  Created by apple on 2018/8/10.
//  Copyright © 2018年 lsy. All rights reserved.
//

#import "TopicListView.h"
#import "TopicModel.h"
#import "TopicListTableViewCell.h"

#import "TopicDetailsViewController.h"

@interface TopicListView ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic,strong) UITableView       * tmpTableView;
@property (nonatomic,strong) NSMutableArray    * dataArr;
// 记录最后一次刷新的时间
@property (nonatomic,assign) CFAbsoluteTime      lastRefreshTime;
@property (nonatomic,assign) NSInteger           page;

@end

@implementation TopicListView

- (instancetype)initWithFrame:(CGRect)frame{
    
    self = [super initWithFrame:frame];
    
    if (self) {
        self.page = 1;
        [self addSubview:self.tmpTableView];
        
        [self load];
        
    }
    return self;
}

-(NSMutableArray *)dataArr{
    
    if (!_dataArr) {
        _dataArr = [NSMutableArray array];
    }
    return _dataArr;
}

#pragma mark -- refresh
- (void)load{
    __weak typeof(self) weakSelf = self;
    
    self.tmpTableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        self.page = 1;
        [weakSelf.dataArr removeAllObjects];
        [weakSelf.tmpTableView.mj_footer resetNoMoreData];
        [weakSelf pullDownRefresh];
    }];
    
    self.tmpTableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
         self.page ++;
        [weakSelf pullUpLoadMore];
    }];
    
}
//下拉刷新
- (void)pullDownRefresh{

    NSString *path = [NSString stringWithFormat:@"%@/topic_info/topic_list",KURL];
    
    NSDictionary *dci = @{@"cate_id":self.cate_id,@"page":[NSString stringWithFormat:@"%ld",self.page]};
    __weak typeof(self) weakSelf = self;
    
    [HttpRequest POST:path parameters:dci success:^(id  _Nullable responseObject) {
        weakSelf.lastRefreshTime = CFAbsoluteTimeGetCurrent();
        if ([responseObject[@"code"] integerValue] == 200) {
            
            if ([responseObject[@"datas"] isKindOfClass:[NSArray class]]) {
                
                for (NSDictionary *dic in responseObject[@"datas"]) {
                    TopicModel *model = [[TopicModel alloc] initWithDictionary:dic];
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
        [weakSelf.tmpTableView.mj_header endRefreshing];
        [RequestSever showMsgWithError:error];
    }];

}
//上拉加载
- (void)pullUpLoadMore{
    NSString *path = [NSString stringWithFormat:@"%@/topic_info/topic_list",KURL];
    
    NSDictionary *dci = @{@"cate_id":self.cate_id,@"page":[NSString stringWithFormat:@"%ld",self.page]};
    __weak typeof(self) weakSelf = self;
    
    [HttpRequest POST:path parameters:dci success:^(id  _Nullable responseObject) {
        weakSelf.lastRefreshTime = CFAbsoluteTimeGetCurrent();
        if ([responseObject[@"code"] integerValue] == 200) {
            
            if ([responseObject[@"datas"] isKindOfClass:[NSArray class]]) {
                
                for (NSDictionary *dic in responseObject[@"datas"]) {
                    TopicModel *model = [[TopicModel alloc] initWithDictionary:dic];
                    [weakSelf.dataArr addObject:model];
                }
                
                [weakSelf.tmpTableView reloadData];
                [weakSelf.tmpTableView.mj_footer endRefreshing];
            }
            else{
                [weakSelf.tmpTableView.mj_footer endRefreshingWithNoMoreData];
                weakSelf.page -- ;
            }
        }
        else{
            [weakSelf.tmpTableView.mj_footer endRefreshing];
            weakSelf.page -- ;
            [ViewHelps showHUDWithText:responseObject[@"message"]];
        }
        
        if (weakSelf.dataArr.count < weakSelf.page *10) {
            [weakSelf.tmpTableView.mj_footer endRefreshingWithNoMoreData];
        }
    } failure:^(NSError * _Nullable error) {
        weakSelf.page -- ;
        [weakSelf.tmpTableView.mj_footer endRefreshing];
        [RequestSever showMsgWithError:error];
    }];
}

- (void) autoRefreshIfNeed{
    
    // 如果当前的时间 - 最后一次刷新的时间 大于 十分钟（600秒） 就需要刷新
    if (CFAbsoluteTimeGetCurrent() - self.lastRefreshTime > 10 * 60) {
        // 刷新
        [self.tmpTableView.mj_header beginRefreshing];
    }
}
#pragma mark -- tableView
- (UITableView *)tmpTableView{
    
    if (!_tmpTableView) {
        _tmpTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, KScreenWidth, self.frame.size.height) style:(UITableViewStylePlain)];
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
    
    TopicListTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"TopicListTableViewCell"];
    if (!cell) {
        cell = [[TopicListTableViewCell alloc] initWithStyle:(UITableViewCellStyleDefault) reuseIdentifier:@"TopicListTableViewCell"];
    }
    if (indexPath.row < self.dataArr.count) {

        [cell bandDataWithModel:self.dataArr[indexPath.row]];
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    TopicModel *model =self.dataArr[indexPath.row];
    
    TopicDetailsViewController *vc = [[TopicDetailsViewController alloc] init];
    vc.topic_id = model.ID;
    vc.backColor = model.backColor;
    [self.delegate jumpToTopicDetails:vc];
}

@end
