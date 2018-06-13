//
//  RecordsTableView.m
//  anjuyi1
//
//  Created by 李 on 2018/6/5.
//  Copyright © 2018年 lsy. All rights reserved.
//

#import "RecordsTableView.h"
#import "DistributionTableViewCell.h"

@interface RecordsTableView ()<UITableViewDataSource,UITableViewDelegate>

@property (nonatomic,strong)   UITableView   *tmpTableView;

@property (nonatomic , assign) CFAbsoluteTime lastRefreshTime;

@end

@implementation RecordsTableView

- (instancetype)initWithFrame:(CGRect)frame{
    
    if (self == [super initWithFrame:frame]) {
        [self addSubview:self.tmpTableView];
        
        [self load];
    }
    return self;
}

- (void)load{
 
    self.tmpTableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        
        [self headerReload];
    }];
    
    self.tmpTableView.mj_footer = [MJRefreshAutoFooter footerWithRefreshingBlock:^{
       
        [self footReload];
    }];
    
}

- (void)headerReload{
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        self.lastRefreshTime = CFAbsoluteTimeGetCurrent();
        [self.tmpTableView.mj_header endRefreshing];
    });
    
}

- (void)footReload{
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        
        [self.tmpTableView.mj_footer endRefreshing];
    });
    
}

- (void)autoRefresh{
    
    if (CFAbsoluteTimeGetCurrent() - self.lastRefreshTime  > 5*60) {
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
        [_tmpTableView setShowsVerticalScrollIndicator:NO];
        [_tmpTableView setShowsHorizontalScrollIndicator:NO];
        [_tmpTableView setDataSource:self];
        [_tmpTableView setDelegate:self];
    }
    return _tmpTableView;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 3;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    DistributionTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"RecordsTableViewCell"];
    if (!cell) {
        cell = [[DistributionTableViewCell alloc] initWithStyle:(UITableViewCellStyleDefault) reuseIdentifier:@"RecordsTableViewCell"];
    }
    
    [cell setSelectionStyle:(UITableViewCellSelectionStyleNone)];
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 75;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
