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
#import "HouseDetailsViewController.h"
#import "DesignerDetailsVC.h"//设计师详情
#import "MasterDetailsVC.h"//工长详情
#import "PersonalViewController.h"
#import "StrategyDetailsViewController.h"//攻略详情
#import "TopicDetailsViewController.h"//话题详情

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
    
    if (_index == 4) {
        [self.tmpTableView setSeparatorStyle:(UITableViewCellSeparatorStyleSingleLine)];
        [self.tmpTableView setTableFooterView:[UIView new]];
    }
    
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
    
    if (_index == 2 || _index == 3) {
        HouseTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"HouseTableViewCell"];
        if (!cell) {
            cell = [[HouseTableViewCell alloc] initWithStyle:(UITableViewCellStyleDefault) reuseIdentifier:@"HouseTableViewCell"];
        }
        if (indexPath.row < self.dataArr.count) {
            
            [cell bandDataWithModel:self.dataArr[indexPath.row]];
        }
        return cell;
    }
    if (_index == 4) {
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"TopicTableViewCell"];
        if (!cell) {
            cell = [[UITableViewCell alloc] initWithStyle:(UITableViewCellStyleSubtitle) reuseIdentifier:@"TopicTableViewCell"];
        }
        if (indexPath.row < self.dataArr.count) {
            
            NSDictionary *dic = self.dataArr[indexPath.row];
            [cell.textLabel setText:dic[@"title"]];
            [cell.detailTextLabel setText:[NSString stringWithFormat:@"%@回答",dic[@"answer"]]];
            [cell.detailTextLabel setTextColor:GRAYCOLOR];
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
    if (_index == 2 || _index == 3) {
        return 100;
    }
    return 65;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (_index == 2) {//整屋
        HouseDetailsViewController *vc = [[HouseDetailsViewController alloc] init];
        vc.house_id = self.dataArr[indexPath.row][@"house_id"];
        self.selectHouseToShowDetalis(vc);
    }
    if (_index == 3) {//攻略详情
        StrategyDetailsViewController *vc = [[StrategyDetailsViewController alloc] init];
        vc.strategy_id = self.dataArr[indexPath.row][@"strategy_id"];
        self.selectHouseToShowDetalis(vc);
    }
    if (_index == 4) {//话题详情
        TopicDetailsViewController *vc = [[TopicDetailsViewController alloc] init];
        vc.topic_id = self.dataArr[indexPath.row][@"topic_id"];
        NSArray *arr = @[[UIColor colorWithHexString:@"#62afd3"],
                         [UIColor colorWithHexString:@"#8f8e94"],
                         [UIColor colorWithHexString:@"#d3a25d"],
                         [UIColor colorWithHexString:@"#ad544b"],
                         [UIColor colorWithHexString:@"#57aa63"]];
        
        vc.backColor = arr[arc4random()%5];
        self.selectHouseToShowDetalis(vc);
    }
    if (_index == 5 || _index == 6 || _index == 7) {//工长
        PersonalViewController *vc = [[PersonalViewController alloc] init];
        vc.user_id = self.dataArr[indexPath.row][@"user_id"];
        self.selectHouseToShowDetalis(vc);
    }
//    if (_index == 6) {//工长
//        MasterDetailsVC *vc = [[MasterDetailsVC alloc] init];
//        vc.masterID = self.dataArr[indexPath.row][@"user_id"];
//        self.selectHouseToShowDetalis(vc);
//    }
//    if (_index == 7) {//设计师
//        DesignerDetailsVC *vc = [[DesignerDetailsVC alloc] init];
//        vc.designerID = self.dataArr[indexPath.row][@"user_id"];
//        self.selectHouseToShowDetalis(vc);
//    }
}


/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
