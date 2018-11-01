//
//  HouseDesignViewController.m
//  anjuyi1
//
//  Created by apple on 2018/7/15.
//  Copyright © 2018年 lsy. All rights reserved.
//
//  雇佣设计师

#import "HouseDesignViewController.h"
#import "HouseInfoViewController.h"

@interface HouseDesignViewController ()<UITableViewDelegate ,UITableViewDataSource>

@property (nonatomic,strong) UITableView      * tmpTableView;
@property (nonatomic,strong) UIView           * headerView;

@end

@implementation HouseDesignViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self baseForDefaultLeftNavButton];
    
    [self.view addSubview:self.tmpTableView];
    
}


#pragma mark -- tableView
- (UIView *)headerView{
    
    if (!_headerView) {
        _headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, KScreenWidth - 70, KViewHeight - 200)];
        [_headerView setBackgroundColor:[UIColor whiteColor]];
        [_headerView addSubview:[Tools creatLabel:CGRectMake(0, 25, KScreenWidth- 70, 80) font:[UIFont systemFontOfSize:21] color:[UIColor blackColor] alignment:(NSTextAlignmentCenter) title:@"本次装修是否雇佣了设计师？"]];

        
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
    return 2;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"PushHouseViewControllerCell"];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:(UITableViewCellStyleDefault) reuseIdentifier:@"PushHouseViewControllerCell"];
    }
    [cell setSelectionStyle:(UITableViewCellSelectionStyleNone)];
    [cell.textLabel setText:indexPath.row==0?@"否":@"是"];
    [cell.textLabel setFont:[UIFont systemFontOfSize:15]];
    [cell.textLabel setTextColor:[UIColor colorWithHexString:@"#3b3b3b"]];
    
    [cell setAccessoryType:(UITableViewCellAccessoryDisclosureIndicator)];
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 60;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    [self.houseDic setValue:[NSString stringWithFormat:@"%ld",indexPath.row] forKey:@"designer"];
    
    [self pushHouseInfo];
}

- (void)pushHouseInfo{
    
    
    NSString *path = [NSString stringWithFormat:@"%@/whole_house/add_house_info",KURL];
    
    NSDictionary *header = @{@"token":UTOKEN};
    
    
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    __weak typeof(self) weakSelf = self;
    
    [HttpRequest POSTWithHeader:header url:path parameters:self.houseDic success:^(id  _Nullable responseObject) {
        
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        
        if ([responseObject[@"code"] integerValue] == 200) {
            
            if ([responseObject[@"datas"] isKindOfClass:[NSDictionary class]]) {
                HouseInfoViewController *vc = [[HouseInfoViewController alloc] init];
                vc.house_id = responseObject[@"datas"][@"id"];
                [weakSelf.navigationController pushViewController:vc animated:YES];
            }
            else{
                
                [ViewHelps showHUDWithText:responseObject[@"message"]];
            }
            
        }
        else{
            
            [ViewHelps showHUDWithText:responseObject[@"message"]];
        }
        
        
    } failure:^(NSError * _Nullable error) {
        
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        [RequestSever showMsgWithError:error];
    }];

}

- (void)leftButtonTouchUpInside:(id)sender{
    [self.navigationController popViewControllerAnimated:YES];
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
