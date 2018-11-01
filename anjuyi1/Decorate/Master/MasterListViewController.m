//
//  DecorateViewController.m
//  anjuyi
//
//  Created by 李 on 2018/5/29.
//  Copyright © 2018年 lsy. All rights reserved.
//
//  工长

#import "MasterListViewController.h"
#import "DesignerTableViewCell.h"
#import "ScreeningBar.h"
#import "ScreeningView.h"
#import "MasterDetailsVC.h"

#import "MasterModel.h"

#define hederHeight MDXFrom6(55)

@interface MasterListViewController ()<UITableViewDelegate,UITableViewDataSource,ScreeningBarDelegate,ScreeningViewDelegate>
{
    NSString * _service_type;
    NSString * _level;
    NSString * _min;
    NSString * _max;
}

@property (nonatomic,strong)UITableView         *   tmpTableView;
@property (nonatomic,strong)NSMutableArray      *   dataArr;//工长列表数据
@property (nonatomic,strong)ScreeningBar        *   screeningBar;
@property (nonatomic,strong)ScreeningView       *   screeningView;

@property (nonatomic,assign)NSInteger               page;

@property (nonatomic,strong)NSMutableArray      *   screenArr;//筛选数据

@end

@implementation MasterListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    

    
    [self baseForDefaultLeftNavButton];
    [self setTitle:@"工长"];
    
    self.page = 1;
    self.dataArr = [NSMutableArray array];
    self.screenArr = [NSMutableArray array];
    _service_type = @"";
    _min = @"";
    _max = @"";
    _level = @"";
    
    [self.view addSubview:self.tmpTableView];
    
    [self.view addSubview:self.screeningBar];
    
    [self.navigationController.view addSubview:self.screeningView];
    
    [self.view addSubview:[Tools setLineView:CGRectMake(0, 0, KScreenWidth, 1)]];
    [self.view addSubview:[Tools setLineView:CGRectMake(0, MDXFrom6(44), KScreenWidth, 1)]];
    
    [self load];
    
    [self pullDownRefresh];
    
    [self getSearchType];
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
    
    
    NSString *path = [NSString stringWithFormat:@"%@/work/search_list",KURL];

    NSDictionary *dic = @{@"service_type":_service_type,
                          @"level":_level,
                          @"min":_min,
                          @"max":_max,
                          @"page":[NSString stringWithFormat:@"%ld",self.page]};
    
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    __weak typeof(self) weakSelf = self;
    
    [HttpRequest POST:path parameters:dic success:^(id  _Nullable responseObject) {
        
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        
        if ([responseObject[@"code"] integerValue] == 200) {
            
            if ([responseObject[@"datas"] isKindOfClass:[NSArray class]]) {
                
                for (NSDictionary *dic in responseObject[@"datas"]) {
                    MasterModel *model = [[MasterModel alloc] initWithDictionary:dic];
                    model.type = @"工长";
                    [weakSelf.dataArr addObject:model];
                }
            }
            
        }
        else{
            
            [ViewHelps showHUDWithText:responseObject[@"message"]];
        }
        
        [weakSelf.tmpTableView reloadData];
        [weakSelf.tmpTableView.mj_header endRefreshing];
        
        if (weakSelf.dataArr.count < weakSelf.page *10) {
            [weakSelf.tmpTableView.mj_footer endRefreshingWithNoMoreData];
        }
        
        
    } failure:^(NSError * _Nullable error) {
        
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        [RequestSever showMsgWithError:error];
    }];
    
    
}
//上拉加载
- (void)pullUpLoadMore{
    
    NSString *path = [NSString stringWithFormat:@"%@/work/search_list",KURL];
    
    NSDictionary *dic =  @{@"service_type":_service_type,
                           @"level":_level,
                           @"min":_min,
                           @"max":_max,
                           @"page":[NSString stringWithFormat:@"%ld",self.page]};

    
    
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    __weak typeof(self) weakSelf = self;
    
    [HttpRequest POST:path parameters:dic success:^(id  _Nullable responseObject) {
        
        [MBProgressHUD hideHUDForView:weakSelf.view animated:YES];
        
        if ([responseObject[@"code"] integerValue] == 200) {
            
            if ([responseObject[@"datas"] isKindOfClass:[NSArray class]]) {
                
                for (NSDictionary *dic in responseObject[@"datas"]) {
                    MasterModel *model = [[MasterModel alloc] initWithDictionary:dic];
                    model.type = @"工长";
                    [weakSelf.dataArr addObject:model];
                }
            }
        }
        else{
            
            [ViewHelps showHUDWithText:responseObject[@"message"]];
        }
        
        [weakSelf.tmpTableView reloadData];
        [weakSelf.tmpTableView.mj_footer endRefreshing];
        
        if (weakSelf.dataArr.count < weakSelf.page *10) {
            [weakSelf.tmpTableView.mj_footer endRefreshingWithNoMoreData];
        }
        
    } failure:^(NSError * _Nullable error) {
        weakSelf.page --;
        [MBProgressHUD hideHUDForView:weakSelf.view animated:YES];
        [RequestSever showMsgWithError:error];
    }];
    
}

- (void)getSearchType{
    
    
    NSString *path = [NSString stringWithFormat:@"%@/work/get_search_type",KURL];
    
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    __weak typeof(self) weakSelf = self;
    
    [HttpRequest POST:path parameters:nil success:^(id  _Nullable responseObject) {
        
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        
        if ([responseObject[@"code"] integerValue] == 200) {
            
            [weakSelf.screenArr addObject:responseObject[@"datas"][@"service_type"]];
            [weakSelf.screenArr addObject:responseObject[@"datas"][@"price_range"]];
            [weakSelf.screenArr addObject:responseObject[@"datas"][@"level"]];
            
            NSMutableArray *service_type = [NSMutableArray array];
            for (NSDictionary *dic  in weakSelf.screenArr[0]) {
                [service_type addObject:dic[@"value"]];
            }
            NSMutableArray *price_range = [NSMutableArray array];
            for (NSDictionary *dic  in weakSelf.screenArr[1]) {
                [price_range addObject:[NSString stringWithFormat:@"%@-%@\n%@的选择",dic[@"min"],dic[@"max"],dic[@"Percentage"]]];
            }
            
            NSMutableArray *level = [NSMutableArray array];
            for (NSDictionary *dic  in weakSelf.screenArr[2]) {
                [level addObject:dic[@"value"]];
            }
            
            [weakSelf.screeningView setDataArr:[NSMutableArray arrayWithArray: @[service_type,weakSelf.screenArr[1],level]]];
        }
        else{
            
            [ViewHelps showHUDWithText:responseObject[@"message"]];
        }
        
        
    } failure:^(NSError * _Nullable error) {
        
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        [RequestSever showMsgWithError:error];
    }];
    
}


#pragma mark -- screeningBar
- (ScreeningBar *)screeningBar{
    if (!_screeningBar) {
        _screeningBar = [[ScreeningBar alloc] initWithFrame:CGRectMake(0, 0, KScreenWidth, MDXFrom6(45))];
        [_screeningBar setDelegate:self];
        [_screeningBar setTitleArr:@[@"综合排序",@"关注最多",@"价格",@"筛选"]];
    }
    return _screeningBar;
}

- (void)selectIndex:(NSInteger)index{
    
    NSLog(@"%ld",index);
    
    if (index == 3) {
        
        [self.screeningView show];
    }
}

- (ScreeningView *)screeningView{
    
    if (!_screeningView) {
        _screeningView = [[ScreeningView alloc] initWithFrame:CGRectMake(0, 0, KScreenWidth, KScreenHeight)];
        [_screeningView setDelegate:self];
        [_screeningView setTypeArr:[NSMutableArray arrayWithArray: @[@"工长种类",@"工长报价",@"工长等级"]]];
        
    }
    return _screeningView;
}

- (void)sureScreenData:(NSMutableArray *)sureArr{
    if ([sureArr[0] integerValue]>=0) {
        _service_type = self.screenArr[0][[sureArr[0] integerValue]][@"key"];
    }
    if ([sureArr[1] isKindOfClass:[NSDictionary class]]) {
        
        NSDictionary *dic =sureArr[1];
        _min = dic[@"min"];
        _max = dic[@"max"];
    }
    else{
        if ([sureArr[1] integerValue]>=0) {
            _min = self.screenArr[1][[sureArr[1] integerValue]][@"min"];
            _max = self.screenArr[1][[sureArr[1] integerValue]][@"max"];
        }
    }
    if ([sureArr[2] integerValue]>=0) {
        _level = self.screenArr[2][[sureArr[2] integerValue]][@"key"];
    }
    [self.tmpTableView.mj_header beginRefreshing];
}

#pragma mark -- tableView
- (UITableView *)tmpTableView{
    
    if (!_tmpTableView) {
        _tmpTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, MDXFrom6(45), KScreenWidth, KViewHeight-MDXFrom6(45)) style:(UITableViewStylePlain)];
        [_tmpTableView setSeparatorStyle:(UITableViewCellSeparatorStyleNone)];
        if (@available(iOS 11.0, *)) {
            [_tmpTableView setContentInsetAdjustmentBehavior:(UIScrollViewContentInsetAdjustmentNever)];
        }
        [_tmpTableView setRowHeight:190.0f];
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
    
    DesignerTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MasterListViewController"];
    if (!cell) {
        cell = [[DesignerTableViewCell alloc] initWithStyle:(UITableViewCellStyleDefault) reuseIdentifier:@"MasterListViewController"];
    }
    
    if (indexPath.row <self.dataArr.count) {
        
        [cell bandDataWithModel:self.dataArr[indexPath.row]];
    }
    
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (indexPath.row < self.dataArr.count) {
        
        MasterModel *model = self.dataArr[indexPath.row];
        
        MasterDetailsVC *controller = [[MasterDetailsVC alloc] init];
        controller.masterID = model.user_id;
        [self.navigationController pushViewController:controller animated:YES];
    }
    
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
