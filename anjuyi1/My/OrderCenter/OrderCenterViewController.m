//
//  MyOrderViewController.m
//  anjuyi1
//
//  Created by 李 on 2018/6/4.
//  Copyright © 2018年 lsy. All rights reserved.
//

#import "OrderCenterViewController.h"
#import "YZPullDownMenu.h"
#import "YZMenuButton.h"
#import "SortPullDown.h"
#import "DefaultPullDown.h"
#import "OrderCenterTableViewCell.h"
#import "OrderCenterDatailsVC.h"

#import "OrderCenterModel.h"

#define YZScreenW [UIScreen mainScreen].bounds.size.width
#define YZScreenH [UIScreen mainScreen].bounds.size.height

@interface OrderCenterViewController ()<YZPullDownMenuDataSource,YZPullDownMenuDelegate,UITableViewDelegate,UITableViewDataSource>
{
    NSDictionary * _typeDic;
    NSDictionary * _roomDic;
    NSDictionary * _moneyDic;//保存 筛选的信息
    YZPullDownMenu * _downMenu;
}

@property (nonatomic, strong) NSArray        * titles;
@property (nonatomic, strong) UITableView    * tmpTableView;
@property (nonatomic, strong) NSMutableArray * dataArr;
@property (nonatomic, assign) NSInteger        page;
@property (nonatomic, strong) NSArray        * typeArr;
@property (nonatomic, strong) NSArray        * roomArr;
@property (nonatomic, strong) NSArray        * moneyArr;

@end

@implementation OrderCenterViewController

- (void)viewWillDisappear:(BOOL)animated{
    
    [super viewWillDisappear:animated];
    [_downMenu cancel];
}


- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Do any additional setup after loading the view, typically from a nib.
    self.view.backgroundColor = [UIColor brownColor];
    
    [self setTitle:@"接单中心"];
    
    [self baseForDefaultLeftNavButton];
    
    self.dataArr = [NSMutableArray array];
    self.page = 1;
    
    [self.view addSubview:self.tmpTableView];
    
    [self.view addSubview:[Tools setLineView:CGRectMake(0, 0, KScreenWidth, 1.5)]];

    [self setupAllChildViewController];
    
    [self getTypeInfo];
    
    [self load];
    
    [self pullDownRefresh];
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
    
    NSString *path = [NSString stringWithFormat:@"%@/task/page_index",KURL];
    
    NSDictionary *header = @{@"token":UTOKEN};
    NSMutableDictionary *parameter = [NSMutableDictionary dictionary];
    
    [parameter setValue:[NSString stringWithFormat:@"%ld",(long)self.page] forKey:@"page"];
    if (_typeDic) {
        [parameter setValue:_typeDic[@"value"] forKey:@"type"];
    }
    if (_roomDic) {
        [parameter setValue:_roomDic[@"room"] forKey:@"room"];
        [parameter setValue:_roomDic[@"hall"] forKey:@"hall"];
    }
    if (_moneyDic) {
        [parameter setValue:_moneyDic[@"min"] forKey:@"min"];
        [parameter setValue:_moneyDic[@"max"] forKey:@"max"];
    }
    
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    __weak typeof(self) weakSelf = self;
    
    [HttpRequest POSTWithHeader:header url:path parameters:parameter success:^(id  _Nullable responseObject) {
        
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        
        if ([responseObject[@"code"] integerValue] == 200) {
            
            if ([responseObject[@"datas"] isKindOfClass:[NSArray class]]) {
                
                for (NSDictionary *dic in responseObject[@"datas"]) {
                    
                    OrderCenterModel *model = [[OrderCenterModel alloc] initWithDictionary:dic];
                    [weakSelf.dataArr addObject:model];
                }
            }
        }
        else{
            
            [ViewHelps showHUDWithText:responseObject[@"message"]];
        }
        
        [weakSelf.tmpTableView.mj_header endRefreshing];
        [weakSelf.tmpTableView reloadData];
        
        if (weakSelf.dataArr.count < weakSelf.page *10) {
            [weakSelf.tmpTableView.mj_footer endRefreshingWithNoMoreData];
        }
        
    } failure:^(NSError * _Nullable error) {
        
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        [RequestSever showMsgWithError:error];
        [weakSelf.tmpTableView.mj_header endRefreshing];
        
    }];

}
//上拉加载
- (void)pullUpLoadMore{
    
    NSString *path = [NSString stringWithFormat:@"%@/task/page_index",KURL];
    
    NSDictionary *header = @{@"token":UTOKEN};
    NSMutableDictionary *parameter = [NSMutableDictionary dictionary];
    
    [parameter setValue:[NSString stringWithFormat:@"%ld",self.page] forKey:@"page"];
    if (_typeDic) {
        [parameter setValue:_typeDic[@"value"] forKey:@"type"];
    }
    if (_roomDic) {
        [parameter setValue:_roomDic[@"room"] forKey:@"room"];
        [parameter setValue:_roomDic[@"hall"] forKey:@"hall"];
    }
    if (_moneyDic) {
        [parameter setValue:_moneyDic[@"min"] forKey:@"min"];
        [parameter setValue:_moneyDic[@"max"] forKey:@"max"];
    }
    
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    __weak typeof(self) weakSelf = self;
    
    [HttpRequest POSTWithHeader:header url:path parameters:parameter success:^(id  _Nullable responseObject) {
        
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        
        if ([responseObject[@"code"] integerValue] == 200) {
            
            if ([responseObject[@"datas"] isKindOfClass:[NSArray class]]) {
                
                for (NSDictionary *dic in responseObject[@"datas"]) {
                    
                    OrderCenterModel *model = [[OrderCenterModel alloc] initWithDictionary:dic];
                    [weakSelf.dataArr addObject:model];
                }
                
                 [weakSelf.tmpTableView.mj_footer endRefreshing];
                [weakSelf.tmpTableView reloadData];
            }
            else{
                weakSelf.page -- ;
                [weakSelf.tmpTableView.mj_footer endRefreshingWithNoMoreData];
            }
        }
        else{
            
            [ViewHelps showHUDWithText:responseObject[@"message"]];
            [weakSelf.tmpTableView.mj_footer endRefreshing];
        }
        
        if (weakSelf.dataArr.count < weakSelf.page *10) {
            [weakSelf.tmpTableView.mj_footer endRefreshingWithNoMoreData];
        }
        
        
    } failure:^(NSError * _Nullable error) {
        weakSelf.page -- ;
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        [RequestSever showMsgWithError:error];
        [weakSelf.tmpTableView.mj_footer endRefreshing];
        
    }];
}

//获取筛选类型
- (void)getTypeInfo{
    
    NSString *path = [NSString stringWithFormat:@"%@/task/get_list_info",KURL];
    
    NSDictionary *header = @{@"token":UTOKEN};
    
    
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    __weak typeof(self) weakSelf = self;
    
    [HttpRequest POSTWithHeader:header url:path parameters:nil success:^(id  _Nullable responseObject) {
        
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        
        if ([responseObject[@"code"] integerValue] == 200) {
            
            weakSelf.typeArr =responseObject[@"datas"][@"type"];
            weakSelf.roomArr =responseObject[@"datas"][@"room_hall"];
            weakSelf.moneyArr =responseObject[@"datas"][@"money"];
            
            NSArray *arr = weakSelf.childViewControllers;
            SortPullDown *sort1 = arr[0];
            [sort1 setTitleArray:weakSelf.typeArr];
            SortPullDown *sort2 = arr[1];
            [sort2 setTitleArray:weakSelf.roomArr];
            SortPullDown *sort3 = arr[2];
            [sort3 setTitleArray:weakSelf.moneyArr];
            
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
- (UITableView *)tmpTableView{
    
    if (!_tmpTableView) {
        _tmpTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 44, KScreenWidth, KScreenHeight-KTopHeight-44) style:(UITableViewStylePlain)];
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
    
    OrderCenterTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"OrderCenterTableViewCell"];
    if (!cell) {
        cell = [[OrderCenterTableViewCell alloc] initWithStyle:(UITableViewCellStyleDefault) reuseIdentifier:@"OrderCenterTableViewCell"];
    }
    
    [cell setSelectionStyle:(UITableViewCellSelectionStyleNone)];
    
    if (indexPath.row < self.dataArr.count) {
    
        [cell bandDataWithModel:self.dataArr[indexPath.row]];
    }
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 105;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    OrderCenterModel *model = self.dataArr[indexPath.row];
    
    OrderCenterDatailsVC *vc = [[OrderCenterDatailsVC alloc] init];
    vc.orderId = model.ID;
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark - 添加子控制器
- (void)setupAllChildViewController
{
    
    // 创建下拉菜单
    YZPullDownMenu *menu = [[YZPullDownMenu alloc] init];
    menu.frame = CGRectMake(0,0, YZScreenW, 44);
    [menu setDelegate:self];
    menu.coverColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:.8];
    [self.view addSubview:menu];
    
    _downMenu = menu;
    
    [self.view addSubview:[Tools setLineView:CGRectMake(0, 0, KScreenWidth, 1.5)]];
    
    [self.view addSubview:[Tools setLineView:CGRectMake(0, 42.5, KScreenWidth, 1.5)]];
    
    // 设置下拉菜单代理
    menu.dataSource = self;
    
    // 初始化标题
    _titles = @[@"全部类型",@"全部房型",@"预算范围"];
    
    SortPullDown *sort = [[SortPullDown alloc] init];
    SortPullDown *sort2 = [[SortPullDown alloc] init];
    SortPullDown *sort3 = [[SortPullDown alloc] init];
    [self addChildViewController:sort];
    [self addChildViewController:sort2];
    [self addChildViewController:sort3];
    
}

#pragma mark - YZPullDownMenuDataSource
// 返回下拉菜单多少列
- (NSInteger)numberOfColsInMenu:(YZPullDownMenu *)pullDownMenu
{
    return 3;
}

// 返回下拉菜单每列按钮
- (UIButton *)pullDownMenu:(YZPullDownMenu *)pullDownMenu buttonForColAtIndex:(NSInteger)index
{
    YZMenuButton *button = [YZMenuButton buttonWithType:UIButtonTypeCustom];
    [button setTitle:_titles[index] forState:UIControlStateNormal];
    [button.titleLabel setFont:[UIFont systemFontOfSize:15]];
    [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [button setTitleColor:[UIColor colorWithRed:25 /255.0 green:143/255.0 blue:238/255.0 alpha:1] forState:UIControlStateSelected];
    [button setImage:[UIImage imageNamed:@"标签-向下箭头"] forState:UIControlStateNormal];
    [button setImage:[UIImage imageNamed:@"标签-向上箭头"] forState:UIControlStateSelected];
    
    return button;
}

// 返回下拉菜单每列对应的控制器
- (UIViewController *)pullDownMenu:(YZPullDownMenu *)pullDownMenu viewControllerForColAtIndex:(NSInteger)index
{
    
    return self.childViewControllers[index];
}

// 返回下拉菜单每列对应的高度
- (CGFloat)pullDownMenu:(YZPullDownMenu *)pullDownMenu heightForColAtIndex:(NSInteger)index
{
    return 180;
}

- (void)pullDownMenu:(YZPullDownMenu *)pullDownMenu selectForColAtIndex:(NSIndexPath *)indexPath{
    
    if (indexPath.section == 0) {
        
        _typeDic = self.typeArr[indexPath.row];
    }
    else if (indexPath.section == 1){
        _roomDic = self.roomArr[indexPath.row];
    }
    else{
        _moneyDic = self.moneyArr[indexPath.row];
    }
 
    [self.tmpTableView.mj_header beginRefreshing];
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
