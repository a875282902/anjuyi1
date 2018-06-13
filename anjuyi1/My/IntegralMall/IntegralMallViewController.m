//
//  IntegralMallViewController.m
//  anjuyi1
//
//  Created by 李 on 2018/6/5.
//  Copyright © 2018年 lsy. All rights reserved.
//

#import "IntegralMallViewController.h"
#import "ScreeningBar.h"
#import "ScreeningView.h"
#import "IntegralMallTableViewCell.h"
#import "SuspensionButton.h"
#import "SearchView.h"
#import "ShopCartViewController.h"//购物车
#import "GoodsDetailsViewController.h"//商品详情

@interface IntegralMallViewController ()<ScreeningBarDelegate,UITableViewDelegate,UITableViewDataSource,SuspensionButtonDelegate>

@property (nonatomic,strong)ScreeningBar    * screeningBar;
@property (nonatomic,strong)ScreeningView   * screeningView;
@property (nonatomic,strong)UITableView     * tmpTableView;
@property (nonatomic,strong)SuspensionButton* shopView;

@end

@implementation IntegralMallViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self baseForDefaultLeftNavButton];
    
    SearchView *search = [[SearchView alloc] initWithFrame:CGRectMake(0, 0, MDXFrom6(355), 30) Title:@"大家都在搜设计师"];
    [search addTarget:self action:@selector(jumpSearch)];
    [self.navigationItem setTitleView:search];
    
    [self.view addSubview:self.screeningBar];
    
    [[UIApplication sharedApplication].keyWindow addSubview:self.screeningView];
    
    [self.view addSubview:self.tmpTableView];
    
    [self.view addSubview:[Tools setLineView:CGRectMake(0, 0, KScreenWidth, 1)]];
    
    [self.view addSubview:[Tools setLineView:CGRectMake(0, MDXFrom6(45), KScreenWidth, MDXFrom6(1))]];
    
    [self.view addSubview:self.shopView];
}

- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer{
    
    return NO;
}

#pragma mark -- screeningBar
- (ScreeningBar *)screeningBar{
    if (!_screeningBar) {
        _screeningBar = [[ScreeningBar alloc] initWithFrame:CGRectMake(0, 0, KScreenWidth, MDXFrom6(45))];
        [_screeningBar setDelegate:self];
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
        [_screeningView setTypeArr:[NSMutableArray arrayWithArray: @[@"商品分类",@"价格区间",@"品牌",@"活动"]]];
        [_screeningView setDataArr:[NSMutableArray arrayWithArray: @[@[@"全部",@"家装",@"工装",@"软装",@"全部",@"家装",@"工装",@"软装",@"全部",@"家装",@"工装",@"软装"],@[@"32-115\n31%的选择",@"32-115\n41%的选择",@"32-115\n21%的选择"],@[@"全部",@"普通",@"名家汇"],@[@"秒杀",@"一元购"]]]];
    }
    return _screeningView;
}

#pragma mark -- 购物车按钮
- (SuspensionButton *)shopView{
    
    if (!_shopView) {
        _shopView = [[SuspensionButton alloc] initWithFrame:CGRectMake(KScreenWidth - MDXFrom6(80), KScreenHeight -KTopHeight - MDXFrom6(80) , MDXFrom6(50), MDXFrom6(50))];
        [_shopView setDelegate:self];
    }
    return _shopView;
    
}

- (void)showProcess{
    
    ShopCartViewController *controller = [[ShopCartViewController alloc] init];
    [self.navigationController pushViewController:controller animated:YES];
}


#pragma mark -- tableView
- (UITableView *)tmpTableView{
    
    if (!_tmpTableView) {
        _tmpTableView = [[UITableView alloc] initWithFrame:CGRectMake(0,MDXFrom6(45), KScreenWidth, KScreenHeight-KTopHeight-MDXFrom6(45)) style:(UITableViewStylePlain)];
        [_tmpTableView setSeparatorStyle:(UITableViewCellSeparatorStyleNone)];
        if (@available(iOS 11.0, *)) {
            [_tmpTableView setContentInsetAdjustmentBehavior:(UIScrollViewContentInsetAdjustmentNever)];
        }
        [_tmpTableView setEstimatedRowHeight:100];
        [_tmpTableView setRowHeight:UITableViewAutomaticDimension];
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
    
    IntegralMallTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"IntegralMallTableViewCell"];
    if (!cell) {
        cell = [[IntegralMallTableViewCell alloc] initWithStyle:(UITableViewCellStyleDefault) reuseIdentifier:@"IntegralMallTableViewCell"];
    }
    
    [cell setSelectionStyle:(UITableViewCellSelectionStyleNone)];
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 120;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    GoodsDetailsViewController *controller = [[GoodsDetailsViewController alloc] init];
    [self.navigationController pushViewController:controller animated:YES];
    
}

#pragma mark -- 点击事件
- (void)jumpSearch{
    
    
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
