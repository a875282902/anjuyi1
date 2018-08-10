//
//  MyCollectView.m
//  anjuyi1
//
//  Created by apple on 2018/8/6.
//  Copyright © 2018年 lsy. All rights reserved.
//

#import "MyCollectView.h"
#import "DraftBoxTableViewCell.h"
#import "HouseModel.h"


@interface MyCollectView ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic,strong) UITableView    * tmpTableView;

@property (nonatomic,strong) NSMutableArray * dataArr;

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
    [self getData];
}

- (NSMutableArray *)dataArr{
    
    if (!_dataArr) {
        _dataArr = [NSMutableArray array];
    }
    return _dataArr;
}

- (void)getData{
    
    NSString *path = [NSString stringWithFormat:@"%@/member/my_collect",KURL];
    
    NSDictionary *header = @{@"token":UTOKEN};
    NSDictionary *dic = @{@"type":[NSString stringWithFormat:@"%ld",self.index+1]};
    
    
    __weak typeof(self) weakSelf = self;
    
    [HttpRequest POSTWithHeader:header url:path parameters:dic success:^(id  _Nullable responseObject) {
        
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
        
        [weakSelf.tmpTableView reloadData];
    } failure:^(NSError * _Nullable error) {
        
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
    
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MallTableViewCell"];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:(UITableViewCellStyleDefault) reuseIdentifier:@"MallTableViewCell"];
    }
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (self.index == 0) {
        return 265;
    }
    return 40;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
