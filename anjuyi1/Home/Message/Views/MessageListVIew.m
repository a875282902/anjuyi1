//
//  MessageListVIew.m
//  anjuyi1
//
//  Created by apple on 2018/10/10.
//  Copyright © 2018年 lsy. All rights reserved.
//

#import "MessageListVIew.h"
#import "MessageTableViewCell.h"

@interface MessageListVIew ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic,strong) UITableView    * tmpTableView;
@property (nonatomic,strong) NSMutableArray * dataArr;
@property (nonatomic,assign) NSInteger        page;

@end

@implementation MessageListVIew

- (instancetype)initWithFrame:(CGRect)frame{
    
    if (self == [super initWithFrame:frame]) {
        self.dataArr = [NSMutableArray array];
        [self addSubview:self.tmpTableView];
    }
    return self;
}

- (void)setType:(NSString *)type{
    
    _type = type;
    
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
    
    NSString *path = [NSString stringWithFormat:@"%@/message/index",KURL];
    
    NSDictionary *header = @{@"token":UTOKEN};
    NSDictionary *dic = @{@"page":[NSString stringWithFormat:@"%ld",(long)self.page],
                          @"type":self.type};
    __weak typeof(self) weakSelf = self;
    
    [HttpRequest POSTWithHeader:header url:path parameters:dic success:^(id  _Nullable responseObject) {
        
        if ([responseObject[@"code"] integerValue] == 200) {
            if ([responseObject[@"datas"] isKindOfClass:[NSArray class]]) {
                for (NSDictionary *dic in responseObject[@"datas"]) {
                    
                    [weakSelf.dataArr addObject:[weakSelf addAttributeToDic:dic]];
                }
            }
            
        }
        else{
            
            [ViewHelps showHUDWithText:responseObject[@"message"]];
        }
        if (weakSelf.dataArr.count<weakSelf.page*10) {
            [weakSelf.tmpTableView.mj_footer endRefreshingWithNoMoreData];
        }
        
        [weakSelf.tmpTableView.mj_header endRefreshing];
        [weakSelf.tmpTableView reloadData];
    } failure:^(NSError * _Nullable error) {
        
        [weakSelf.tmpTableView.mj_header endRefreshing];
        [RequestSever showMsgWithError:error];
    }];

}
//上拉加载
- (void)pullUpLoadMore{
    NSString *path = [NSString stringWithFormat:@"%@/message/index",KURL];
    
    NSDictionary *header = @{@"token":UTOKEN};
    NSDictionary *dic = @{@"page":[NSString stringWithFormat:@"%ld",(long)self.page],
                          @"type":self.type};
    __weak typeof(self) weakSelf = self;
    
    [HttpRequest POSTWithHeader:header url:path parameters:dic success:^(id  _Nullable responseObject) {
        
        if ([responseObject[@"code"] integerValue] == 200) {
            
            if ([responseObject[@"datas"] isKindOfClass:[NSArray class]]) {
                for (NSDictionary *dic in responseObject[@"datas"]) {
                    
                    [weakSelf.dataArr addObject:[weakSelf addAttributeToDic:dic]];
                }
            }
        }
        else{
            weakSelf.page--;
            [ViewHelps showHUDWithText:responseObject[@"message"]];
        }
        if (weakSelf.dataArr.count<weakSelf.page*10) {
            [weakSelf.tmpTableView.mj_footer endRefreshingWithNoMoreData];
        }
        else{
            [weakSelf.tmpTableView.mj_footer endRefreshing];
        }
        [weakSelf.tmpTableView reloadData];
    } failure:^(NSError * _Nullable error) {
        weakSelf.page--;
        [weakSelf.tmpTableView.mj_footer endRefreshing];
        [RequestSever showMsgWithError:error];
    }];
}

- (NSDictionary *)addAttributeToDic:(NSDictionary *)dic{
    
    NSMutableDictionary * dict = [NSMutableDictionary dictionaryWithDictionary:dic];
    
    NSString * str = dict[@"title"];
    NSString * detail = dict[@"detail"];
    
    CGFloat h = [str boundingRectWithSize:CGSizeMake(MDXFrom6(315), 1000) options:(NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading) attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:16]} context:nil].size.height;
    
    CGFloat w = [str boundingRectWithSize:CGSizeMake(1000000, 16) options:(NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading) attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:16]} context:nil].size.width+MDXFrom6(10);
    
    CGFloat detailh = [detail boundingRectWithSize:CGSizeMake(MDXFrom6(315), 1000) options:(NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading) attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:16]} context:nil].size.height;
    if (detail.length == 0) {
        detailh = 0;
    }
    
    
    [dict setValue:[NSString stringWithFormat:@"%.2f",h] forKey:@"titleHight"];
    [dict setValue:[NSString stringWithFormat:@"%.2f",w] forKey:@"titleWidth"];
    [dict setValue:str forKey:@"title"];
    
    [dict setValue:[NSString stringWithFormat:@"%.2f",detailh] forKey:@"detailHight"];
    
    return dict;
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
    return self.dataArr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    MessageTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MessageTableViewCell"];
    if (!cell) {
        cell = [[MessageTableViewCell alloc] initWithStyle:(UITableViewCellStyleDefault) reuseIdentifier:@"MessageTableViewCell"];
    }
    if (indexPath.row < self.dataArr.count) {

        [cell bandDataWith:self.dataArr[indexPath.row]];
    }
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    NSDictionary *dic = self.dataArr[indexPath.row];
    
    NSInteger h = [dic[@"titleWidth"] floatValue]/MDXFrom6(315);
    
    CGFloat wid = [dic[@"titleWidth"] floatValue] -  MDXFrom6(315) *h;
    
    h = [dic[@"titleHight"] floatValue] + [dic[@"detailHight"] floatValue];
    
    if (wid > MDXFrom6(240)) {
        
        return h+MDXFrom6(86)+31;
    }
    else{
        
        return h +MDXFrom6(85)+15;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithDictionary:self.dataArr[indexPath.row]];
    [dic setValue:@"2" forKey:@"status"];
    [self.dataArr replaceObjectAtIndex:indexPath.row withObject:dic];
    [self.tmpTableView reloadData];
    [self.delegate pushShowDetail:dic listView:self];
    
}


/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
