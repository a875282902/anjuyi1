//
//  DistributionViewController.m
//  anjuyi1
//
//  Created by 李 on 2018/6/2.
//  Copyright © 2018年 lsy. All rights reserved.
//
//  分销详情

#import "DistributionDetailsVC.h"

@interface DistributionDetailsVC ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic,strong)UITableView         * tmpTableView;
@property (nonatomic,strong)NSMutableArray      * dataArr;

@end

@implementation DistributionDetailsVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self.view addSubview:self.tmpTableView];
    
    [self setTitle:@"分销详情"];
    
    [self baseForDefaultLeftNavButton];
    
    [self.view addSubview:[Tools setLineView:CGRectMake(0, 0, KScreenWidth, 1.5)]];
}

#pragma mark -- tableView
- (UITableView *)tmpTableView{
    
    if (!_tmpTableView) {
        _tmpTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, KScreenWidth, KScreenHeight-KTopHeight) style:(UITableViewStylePlain)];
//        [_tmpTableView setSeparatorStyle:(UITableViewCellSeparatorStyleNone)];
        if (@available(iOS 11.0, *)) {
            [_tmpTableView setContentInsetAdjustmentBehavior:(UIScrollViewContentInsetAdjustmentNever)];
        }
        [_tmpTableView setShowsVerticalScrollIndicator:NO];
        [_tmpTableView setShowsHorizontalScrollIndicator:NO];
        [_tmpTableView setTableFooterView:[[UIView alloc] init]];
        [_tmpTableView setDataSource:self];
        [_tmpTableView setDelegate:self];
    }
    return _tmpTableView;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 6;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"DistributionDetailsVCCell"];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:(UITableViewCellStyleValue1) reuseIdentifier:@"DistributionDetailsVCCell"];
    }
    
    NSArray *tArr = @[@"用户",@"ID",@"购买订单号",@"金额",@"返佣比例",@"返佣金额"];
    
    [cell.textLabel setText:tArr[indexPath.row]];
    [cell.textLabel setTextColor:[UIColor colorWithHexString:@"#666666"]];
    [cell.textLabel setFont:[UIFont systemFontOfSize:16]];
    
    
    [cell.detailTextLabel setText:tArr[indexPath.row]];
    [cell.detailTextLabel setTextColor:[UIColor colorWithHexString:@"#000000"]];
    [cell.detailTextLabel setFont:[UIFont systemFontOfSize:16]];
    
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 50;
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
