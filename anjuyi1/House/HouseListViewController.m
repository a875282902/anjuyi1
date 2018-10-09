//
//  MyPushHouseViewController.m
//  anjuyi1
//
//  Created by 李 on 2018/6/4.
//  Copyright © 2018年 lsy. All rights reserved.
//

#import "HouseListViewController.h"
#import "DraftBoxTableViewCell.h"
#import "HouseModel.h"
#import "HouseDetailsViewController.h"

@interface HouseListViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, strong) UITableView    * tmpTableView;
@property (nonatomic, strong) NSMutableArray * dataArr;
@property (nonatomic, strong) NavTwoTitle    * navView;

@end

@implementation HouseListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Do any additional setup after loading the view, typically from a nib.
    self.view.backgroundColor = [UIColor brownColor];
    
    self.navView = [[NavTwoTitle alloc] initWithFrame:CGRectMake(0, 0, MDXFrom6(200), 44) WithTitle1:@"整屋" WithTitle2:@"0篇"];
    
    [self.navigationItem setTitleView:self.navView];
    
    
    self.dataArr = [NSMutableArray array];
    
    [self baseForDefaultLeftNavButton];
    
    [self.view addSubview:self.tmpTableView];
    
    [self.view addSubview:[Tools setLineView:CGRectMake(0, 0, KScreenWidth, 1.5)]];
    
    [self getHouseList];
}

-(void)leftButtonTouchUpInside:(id)sender{
    
    if (self.isPresent) {
        [self dismissViewControllerAnimated:YES completion:nil];
    }
    else{
        [self.navigationController popViewControllerAnimated:YES];
    }
}

- (void)getHouseList{
    
    NSString *path = [NSString stringWithFormat:@"%@/whole_house_info/person_whole_list",KURL];
    
    NSDictionary *header = @{@"token":UTOKEN};
    NSDictionary *dic = @{@"user_id":self.user_id};
    
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    __weak typeof(self) weakSelf = self;
    
    [HttpRequest POSTWithHeader:header url:path parameters:dic success:^(id  _Nullable responseObject) {
        
        [MBProgressHUD hideHUDForView:weakSelf.view animated:YES];
        [weakSelf.dataArr removeAllObjects];
        if ([responseObject[@"code"] integerValue] == 200) {
            
            if ([responseObject[@"datas"] isKindOfClass:[NSArray class]]) {
                
                for (NSDictionary *dic in responseObject[@"datas"]) {
                    HouseModel *model = [[HouseModel alloc] initWithDictionary:dic];
                    [weakSelf.dataArr addObject:model];
                }
                
                [weakSelf.navView refreNum:[NSString stringWithFormat:@"%ld篇",weakSelf.dataArr.count]];
            }
        }
        else{
            
            [ViewHelps showHUDWithText:responseObject[@"message"]];
        }
        
        [weakSelf.tmpTableView reloadData];
        
        
    } failure:^(NSError * _Nullable error) {
        
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        [RequestSever showMsgWithError:error];
    }];
    
}

#pragma mark -- tableView
- (UITableView *)tmpTableView{
    
    if (!_tmpTableView) {
        _tmpTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, KScreenWidth,KViewHeight) style:(UITableViewStylePlain)];
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
    
    DraftBoxTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"HouseListViewController"];
    if (!cell) {
        cell = [[DraftBoxTableViewCell alloc] initWithStyle:(UITableViewCellStyleDefault) reuseIdentifier:@"HouseListViewController"];
    }
    
    [cell setSelectionStyle:(UITableViewCellSelectionStyleNone)];
    
    if (indexPath.row < self.dataArr.count) {
        
        [cell bandDataWithModel:self.dataArr[indexPath.row]];
    }
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 265;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    HouseModel *model  = self.dataArr[indexPath.row];
    HouseDetailsViewController *vc = [[HouseDetailsViewController alloc] init];
    [vc setHouse_id:model.ID];
    [self.navigationController pushViewController:vc animated:YES];
    
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
