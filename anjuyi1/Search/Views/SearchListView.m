//
//  SearchListView.m
//  anjuyi1
//
//  Created by apple on 2018/9/26.
//  Copyright © 2018年 lsy. All rights reserved.
//

#import "SearchListView.h"
#import "HouseTableViewCell.h"
#import "UserTableViewCell.h"

@interface SearchListView ()<UITableViewDelegate,UITableViewDataSource>
{
    NSInteger _index;
}

@property (nonatomic,strong) UITableView        * tmpTableView;
@property (nonatomic,strong) NSMutableArray     * dataArr;

@end

@implementation SearchListView


- (instancetype)initWithFrame:(CGRect)frame{
    
    if (self == [super initWithFrame:frame]) {
        self.dataArr = [NSMutableArray array];
        [self addSubview:self.tmpTableView];
    }
    return self;
}

- (void)setUpKeyWord:(NSString *)keyword type:(NSString *)type{
    
    _index = [type integerValue];
    
    NSString *path = [NSString stringWithFormat:@"%@/search/search",KURL];
    
    [MBProgressHUD showHUDAddedTo:self animated:YES];
    
    __weak typeof(self) weakSelf = self;
    
    [HttpRequest POST:path parameters:@{@"type":[NSString stringWithFormat:@"%@",type],@"keyword":keyword} success:^(id  _Nullable responseObject) {
        
        [MBProgressHUD hideHUDForView:weakSelf animated:YES];
        
        if ([responseObject[@"code"] integerValue] == 200) {
            if ([responseObject[@"datas"] isKindOfClass:[NSArray class]]) {
                for (NSDictionary *dic in responseObject[@"datas"]) {
                    
                    [weakSelf.dataArr addObject:dic];
                }
                
            }
            
            [weakSelf.tmpTableView reloadData];
        }
        else{
            
            [ViewHelps showHUDWithText:responseObject[@"message"]];
        }
        
        
    } failure:^(NSError * _Nullable error) {
        
        [MBProgressHUD hideHUDForView:weakSelf animated:YES];
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
        [_tmpTableView setDataSource:self];
        [_tmpTableView setDelegate:self];
    }
    return _tmpTableView;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataArr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (_index == 2) {
        HouseTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"HouseTableViewCell"];
        if (!cell) {
            cell = [[HouseTableViewCell alloc] initWithStyle:(UITableViewCellStyleDefault) reuseIdentifier:@"HouseTableViewCell"];
        }
        if (indexPath.row < self.dataArr.count) {
            
            [cell bandDataWithModel:self.dataArr[indexPath.row]];
        }
        return cell;
    }
    
    UserTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"UserTableViewCell"];
    if (!cell) {
        cell = [[UserTableViewCell alloc] initWithStyle:(UITableViewCellStyleDefault) reuseIdentifier:@"UserTableViewCell"];
    }
    if (indexPath.row < self.dataArr.count) {

        [cell bandDataWithDictionary:self.dataArr[indexPath.row]];
    }
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (_index == 2) {
        return 100;
    }
    return 65;
}


/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end