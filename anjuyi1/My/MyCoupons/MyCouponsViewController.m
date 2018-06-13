//
//  MyAnswerViewController.m
//  anjuyi1
//
//  Created by 李 on 2018/6/3.
//  Copyright © 2018年 lsy. All rights reserved.
//
//  我的优惠券
#import "MyCouponsViewController.h"
#import "MyCouponsTableViewCell.h"
#import "CouponsDetails.h"

@interface MyCouponsViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic,strong)UITableView    * tmpTableView;

@property (nonatomic,strong)CouponsDetails * descView;

@end

@implementation MyCouponsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self setTitle:@"我的优惠券"];
    
    [self baseForDefaultLeftNavButton];
    
    [self.view addSubview:self.tmpTableView];
    
    [self.view addSubview:[Tools setLineView:CGRectMake(0, 0, KScreenWidth, 1.5)]];
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
    return 3;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    MyCouponsTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MyCouponsTableViewCell"];
    if (!cell) {
        cell = [[MyCouponsTableViewCell alloc] initWithStyle:(UITableViewCellStyleDefault) reuseIdentifier:@"MyCouponsTableViewCell"];
    }
    
    [cell setSelectionStyle:(UITableViewCellSelectionStyleNone)];
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return MDXFrom6(153);
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    [self.navigationController.view addSubview:self.descView];
    [self.descView show];
}

- (CouponsDetails *)descView{
    
    if (!_descView) {
        _descView = [[CouponsDetails alloc] initWithFrame:CGRectMake(0, 0, KScreenWidth, KScreenHeight)];
    }
    return _descView;
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
