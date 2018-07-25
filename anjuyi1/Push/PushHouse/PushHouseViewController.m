//
//  PushHouseViewController.m
//  anjuyi1
//
//  Created by apple on 2018/7/15.
//  Copyright © 2018年 lsy. All rights reserved.
//
//  发布整屋

#import "PushHouseViewController.h"
#import "HouseAreaViewController.h"
#import "HouseInfoViewController.h"

@interface PushHouseViewController ()<UITableViewDelegate ,UITableViewDataSource>

@property (nonatomic,strong) UITableView      * tmpTableView;
@property (nonatomic,strong) UIView           * headerView;
@property (nonatomic,strong) NSMutableArray   * dataArr;

@end

@implementation PushHouseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
 
    if (self.house_id) {
        [self baseForDefaultLeftNavButton];
    }else{
        [self setNavigationLeftBarButtonWithImageNamed:@"yhq_close"];
    }
    
    
    
    self.dataArr = [NSMutableArray array];
    
    [self.view addSubview:self.tmpTableView];
    
    [self getData];
}

#pragma mark -- data
- (void)getData{
    
    NSString *path = [NSString stringWithFormat:@"%@/WholeHouse/house_type_info",KURL];
    
    NSDictionary *header = @{@"token":UTOKEN};
    
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    __weak typeof(self) weakSelf = self;
    
    [HttpRequest POSTWithHeader:header url:path parameters:nil success:^(id  _Nullable responseObject) {
        
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        
        if ([responseObject[@"code"] integerValue] == 200) {
            
            [weakSelf.dataArr removeAllObjects];
            for (NSDictionary * dic in responseObject[@"datas"]) {
                [weakSelf.dataArr addObject:dic];
            }
            [weakSelf.tmpTableView reloadData];
        }
        else{
            
            [ViewHelps showHUDWithText:responseObject[@"message"]];
        }
        
        
    } failure:^(NSError * _Nullable error) {
        
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        [RequestSever showMsgWithError:error];
    }];

    
}

#pragma mark -- tableView
- (UIView *)headerView{
    
    if (!_headerView) {
        _headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, KScreenWidth - 70, 200)];
        [_headerView setBackgroundColor:[UIColor whiteColor]];
        [_headerView addSubview:[Tools creatLabel:CGRectMake(0, 25, KScreenWidth- 70, 21) font:[UIFont systemFontOfSize:21] color:[UIColor blackColor] alignment:(NSTextAlignmentCenter) title:@"房子的户型是？"]];
        
        [_headerView addSubview:[Tools creatLabel:CGRectMake(0, 76, KScreenWidth- 70, 14) font:[UIFont systemFontOfSize:14] color:[UIColor colorWithHexString:@"#999999"] alignment:(NSTextAlignmentCenter) title:@"不包括客厅、餐厅、厨房和卫生间"]];
        
    }
    return _headerView;
}


- (UITableView *)tmpTableView{
    
    if (!_tmpTableView) {
        _tmpTableView = [[UITableView alloc] initWithFrame:CGRectMake(35, 0, KScreenWidth - 70, KViewHeight) style:(UITableViewStylePlain)];
        if (@available(iOS 11.0, *)) {
            [_tmpTableView setContentInsetAdjustmentBehavior:(UIScrollViewContentInsetAdjustmentNever)];
        }
        [_tmpTableView setShowsVerticalScrollIndicator:NO];
        [_tmpTableView setShowsHorizontalScrollIndicator:NO];
        [_tmpTableView setTableHeaderView:self.headerView];
        [_tmpTableView setTableFooterView:[UIView new]];
        [_tmpTableView setBounces:NO];
        [_tmpTableView setDataSource:self];
        [_tmpTableView setDelegate:self];
    }
    return _tmpTableView;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataArr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"PushHouseViewControllerCell"];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:(UITableViewCellStyleDefault) reuseIdentifier:@"PushHouseViewControllerCell"];
    }
    [cell setSelectionStyle:(UITableViewCellSelectionStyleNone)];
    [cell.textLabel setText:self.dataArr[indexPath.row][@"name"]];
    [cell.textLabel setFont:[UIFont systemFontOfSize:15]];
    [cell.textLabel setTextColor:[UIColor colorWithHexString:@"#3b3b3b"]];
    
    [cell setAccessoryType:(UITableViewCellAccessoryDisclosureIndicator)];
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 60;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
//    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
//    NSDictionary *dic = self.dataArr[indexPath.row];
//    [dict setValue:dic[@"id"] forKey:@"door"];
//
//    if (self.house_id) {
//        [self editHouseInfo:dic[@"id"]];
//    }
//    else{
//        HouseAreaViewController *vc = [[HouseAreaViewController alloc] init];
//        vc.houseDic = dict;
//        [self.navigationController pushViewController:vc animated:YES];
//    }
    
    HouseInfoViewController *vc = [[HouseInfoViewController alloc] init];
    vc.house_id = @"32";
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)leftButtonTouchUpInside:(id)sender{
    if (self.house_id) {
        [self.navigationController popViewControllerAnimated:YES];
    }
    else{
        [self dismissViewControllerAnimated:YES completion:nil];
    }
}

#pragma mark -- 修改房屋信息
- (void)editHouseInfo:(NSString *)door{
    
    
    NSString *path = [NSString stringWithFormat:@"%@/WholeHouse/update_house_info",KURL];
    
    NSDictionary *header = @{@"token":UTOKEN};
    
    NSDictionary *parame = @{@"id":self.house_id,
                             @"door":door};
    
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    __weak typeof(self) weakSelf = self;
    
    [HttpRequest POSTWithHeader:header url:path parameters:parame success:^(id  _Nullable responseObject) {
        
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        
        if ([responseObject[@"code"] integerValue] == 200) {
            
            [weakSelf.navigationController popViewControllerAnimated:YES];
        }
        else{
            
            [ViewHelps showHUDWithText:responseObject[@"message"]];
        }
        
        
    } failure:^(NSError * _Nullable error) {
        
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        [RequestSever showMsgWithError:error];
    }];

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
