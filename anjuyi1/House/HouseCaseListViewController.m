//
//  MyPushHouseViewController.m
//  anjuyi1
//
//  Created by 李 on 2018/6/4.
//  Copyright © 2018年 lsy. All rights reserved.
//

#import "HouseCaseListViewController.h"
#import "DraftBoxTableViewCell.h"
#import "HouseModel.h"
#import "HouseDetailsViewController.h"

#import "YZPullDownMenu.h"
#import "SortPullDown.h"
#import "YZMenuButton.h"


@interface HouseCaseListViewController ()<UITableViewDelegate,UITableViewDataSource,YZPullDownMenuDataSource,YZPullDownMenuDelegate>
{
    YZPullDownMenu *_downMenu;
    NSInteger _page;
    NSString * _type;
    NSString * _room;
    NSString * _source;
}

@property (nonatomic, strong) UITableView    * tmpTableView;
@property (nonatomic, strong) NSMutableArray * dataArr;
@property (nonatomic, strong) NavTwoTitle    * navView;
@property (nonatomic, strong) NSMutableArray * titles;

//筛选
@property (nonatomic, strong) NSMutableArray * typeArr;
@property (nonatomic, strong) NSMutableArray * roomArr;
@property (nonatomic, strong) NSMutableArray * sourceArr;


@end

@implementation HouseCaseListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Do any additional setup after loading the view, typically from a nib.
    self.view.backgroundColor = [UIColor brownColor];
    
    [self setTitle:@"整屋列表"];
    
    _page = 1;
    _type = @"0";
    _room = @"0";
    _source = @"0";
    
    self.titles = [NSMutableArray array];
    self.dataArr = [NSMutableArray array];
    self.typeArr = [NSMutableArray array];
    self.roomArr = [NSMutableArray array];
    self.sourceArr = [NSMutableArray array];
    
    [self baseForDefaultLeftNavButton];
    
    [self.view addSubview:self.tmpTableView];
    
    [self.view addSubview:[Tools setLineView:CGRectMake(0, 0, KScreenWidth, 1.5)]];
    
    [self setupAllChildViewController];

    [self getHousetCate];
    
    [self load];
    [self.tmpTableView.mj_header beginRefreshing];

}

- (void)getHousetCate{
    
    
    NSString *path = [NSString stringWithFormat:@"%@/whole_house_info/get_list_info",KURL];

    
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    __weak typeof(self) weakSelf = self;
    
    [HttpRequest POST:path parameters:nil success:^(id  _Nullable responseObject) {
        
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        
        if ([responseObject[@"code"] integerValue] == 200) {
            
            for (NSDictionary *dic in responseObject[@"datas"][@"type"]) {
                [weakSelf.typeArr addObject:@{@"name":dic[@"value"],@"key":dic[@"key"]}];
            }
            for (NSDictionary *dic in responseObject[@"datas"][@"room"]) {
                [weakSelf.roomArr addObject:@{@"name":dic[@"value"],@"key":dic[@"key"]}];
            }
            
            for (NSDictionary *dic in responseObject[@"datas"][@"source"]) {
                [weakSelf.sourceArr addObject:@{@"name":dic[@"value"],@"key":dic[@"key"]}];
            }
            
            
            [weakSelf reloadChildViewData];
        }
        else{
            
            [ViewHelps showHUDWithText:responseObject[@"message"]];
        }
        
        
    } failure:^(NSError * _Nullable error) {
        
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        [RequestSever showMsgWithError:error];
    }];

}

#pragma mark -- refresh
- (void)load{
    __weak typeof(self) weakSelf = self;
    
    self.tmpTableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        self->_page = 1;
        [weakSelf.dataArr removeAllObjects];
        [weakSelf.tmpTableView.mj_footer resetNoMoreData];
        [weakSelf pullDownRefresh];
    }];
    
    self.tmpTableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        self->_page ++;
        [weakSelf pullUpLoadMore];
    }];
    
}
//下拉刷新
- (void)pullDownRefresh{
    
    
    NSString *path = [NSString stringWithFormat:@"%@/whole_house_info/house_list",KURL];
    NSDictionary *dic = @{@"page":[NSString stringWithFormat:@"%ld",_page],
                          @"type":[NSString stringWithFormat:@"%@",_type],
                          @"room":[NSString stringWithFormat:@"%@",_room],
                          @"source":[NSString stringWithFormat:@"%@",_source]};
    
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    __weak typeof(self) weakSelf = self;
    
    [HttpRequest POST:path parameters:dic success:^(id  _Nullable responseObject) {
        
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        
        if ([responseObject[@"code"] integerValue] == 200) {
            if ([responseObject[@"datas"] isKindOfClass:[NSArray class]]) {
                for (NSDictionary *dic in responseObject[@"datas"]) {
                    HouseModel *model = [[HouseModel alloc] initWithDictionary:dic];
                    [weakSelf.dataArr addObject:model];
                }
            }
            
        }
        else{
            
            [ViewHelps showHUDWithText:responseObject[@"message"]];
        }
        
        if (weakSelf.dataArr.count < self->_page *10) {
            [weakSelf.tmpTableView.mj_footer endRefreshingWithNoMoreData];
        }
        
        [weakSelf.tmpTableView.mj_header endRefreshing];
        [weakSelf.tmpTableView reloadData];
        
        
    } failure:^(NSError * _Nullable error) {
        [weakSelf.tmpTableView.mj_header endRefreshing];

        [MBProgressHUD hideHUDForView:self.view animated:YES];
        [RequestSever showMsgWithError:error];
    }];

    
}
//上拉加载
- (void)pullUpLoadMore{
    NSString *path = [NSString stringWithFormat:@"%@/whole_house_info/house_list",KURL];

    NSDictionary *dic = @{@"page":[NSString stringWithFormat:@"%ld",_page],
                          @"type":[NSString stringWithFormat:@"%@",_type],
                          @"room":[NSString stringWithFormat:@"%@",_room],
                          @"source":[NSString stringWithFormat:@"%@",_source]};
    
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    __weak typeof(self) weakSelf = self;
    
    [HttpRequest POST:path parameters:dic success:^(id  _Nullable responseObject) {
        
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        
        if ([responseObject[@"code"] integerValue] == 200) {
            
            if ([responseObject[@"datas"] isKindOfClass:[NSArray class]]) {
                for (NSDictionary *dic in responseObject[@"datas"]) {
                    HouseModel *model = [[HouseModel alloc] initWithDictionary:dic];
                    [weakSelf.dataArr addObject:model];
                }
            }
        }
        else{
            self->_page -- ;
            [ViewHelps showHUDWithText:responseObject[@"message"]];
        }
        
        if (weakSelf.dataArr.count < self->_page *10) {
            [weakSelf.tmpTableView.mj_footer endRefreshingWithNoMoreData];
        }
        
        [weakSelf.tmpTableView.mj_footer endRefreshing];
        [weakSelf.tmpTableView reloadData];
        
        
    } failure:^(NSError * _Nullable error) {
        [weakSelf.tmpTableView.mj_footer endRefreshing];
        self->_page -- ;
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        [RequestSever showMsgWithError:error];
    }];
}

#pragma mark -- tableView
- (UITableView *)tmpTableView{
    
    if (!_tmpTableView) {
        _tmpTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 44, KScreenWidth,KViewHeight-44) style:(UITableViewStylePlain)];
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
    
    DraftBoxTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"HouseCaseListViewController"];
    if (!cell) {
        cell = [[DraftBoxTableViewCell alloc] initWithStyle:(UITableViewCellStyleDefault) reuseIdentifier:@"HouseCaseListViewController"];
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

#pragma mark - 添加子控制器
- (void)setupAllChildViewController
{
    
    // 创建下拉菜单
    YZPullDownMenu *menu = [[YZPullDownMenu alloc] init];
    menu.frame = CGRectMake(0,0, KScreenWidth, 44);
    [menu setDelegate:self];
    menu.coverColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:.8];
    [self.view addSubview:menu];
    
    _downMenu = menu;
    
    [self.view addSubview:[Tools setLineView:CGRectMake(0, 0, KScreenWidth, 1.5)]];
    
    [self.view addSubview:[Tools setLineView:CGRectMake(0, 42.5, KScreenWidth, 1.5)]];
    
    // 设置下拉菜单代理
    menu.dataSource = self;
    
    // 初始化标题
    _titles = [NSMutableArray arrayWithArray:@[@"类型",@"房型",@"来源"]];
    
    SortPullDown *sort = [[SortPullDown alloc] init];
    sort.titleArray = self.typeArr;
    SortPullDown *sort2 = [[SortPullDown alloc] init];
    sort2.titleArray = self.roomArr;
    SortPullDown *sort3 = [[SortPullDown alloc] init];
    sort3.titleArray = self.sourceArr;
    [self addChildViewController:sort];
    [self addChildViewController:sort2];
    [self addChildViewController:sort3];
    
}

- (void)reloadChildViewData{
    
    SortPullDown *sort = self.childViewControllers[0];
    sort.titleArray = self.typeArr;
    SortPullDown *sort2 = self.childViewControllers[1];
    sort2.titleArray = self.roomArr;
    SortPullDown *sort3 =self.childViewControllers[2];
    sort3.titleArray = self.sourceArr;
}

- (void)leftButtonTouchUpInside:(id)sender{
    
    [_downMenu cancel];
    [self.navigationController popViewControllerAnimated:YES];
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

        _type = self.typeArr[indexPath.row][@"key"];
    }
    else if (indexPath.section == 1){
        _room = self.roomArr[indexPath.row][@"key"];
    }
    else{
        _source = self.sourceArr[indexPath.row][@"key"];
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
