//
//  MyOrderViewController.m
//  anjuyi1
//
//  Created by 李 on 2018/6/4.
//  Copyright © 2018年 lsy. All rights reserved.
//

#import "MyArticleViewController.h"
#import "YZPullDownMenu.h"
#import "YZMenuButton.h"
#import "SortPullDown.h"
#import "DraftBoxTableViewCell.h"

#define YZScreenW [UIScreen mainScreen].bounds.size.width
#define YZScreenH [UIScreen mainScreen].bounds.size.height

@interface MyArticleViewController ()<YZPullDownMenuDataSource,UITableViewDelegate,UITableViewDataSource>
@property (nonatomic, strong) NSArray     * titles;

@property (nonatomic, strong) UITableView * tmpTableView;


@end

@implementation MyArticleViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Do any additional setup after loading the view, typically from a nib.
    self.view.backgroundColor = [UIColor brownColor];
    
    [self.navigationItem setTitleView:[[NavTwoTitle alloc] initWithFrame:CGRectMake(0, 0, MDXFrom6(200), 44) WithTitle1:@"我的文章" WithTitle2:@"3篇"]];
    
    [self baseForDefaultLeftNavButton];
    
    
    [self.view addSubview:self.tmpTableView];
    
    [self.view addSubview:[Tools setLineView:CGRectMake(0, 0, KScreenWidth, 1.5)]];
    
    // 创建下拉菜单
    YZPullDownMenu *menu = [[YZPullDownMenu alloc] init];
    menu.frame = CGRectMake(0,0, YZScreenW, 44);
    menu.coverColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0];
    [self.view addSubview:menu];
    
    [self.view addSubview:[Tools setLineView:CGRectMake(0, 0, KScreenWidth, 1.5)]];
    
    [self.view addSubview:[Tools setLineView:CGRectMake(0, 42.5, KScreenWidth, 1.5)]];
    
    // 设置下拉菜单代理
    menu.dataSource = self;
    
    // 初始化标题
    _titles = @[@"全部类型",@"全部房型",@"发布来源"];
    
    // 添加子控制器
    [self setupAllChildViewController];
}

-(void)leftButtonTouchUpInside:(id)sender{
    
    [self.navigationController popViewControllerAnimated:YES];
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
    return 3;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    DraftBoxTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MyArticleViewController"];
    if (!cell) {
        cell = [[DraftBoxTableViewCell alloc] initWithStyle:(UITableViewCellStyleDefault) reuseIdentifier:@"MyArticleViewController"];
    }
    
    [cell setSelectionStyle:(UITableViewCellSelectionStyleNone)];
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 265;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
}

#pragma mark - 添加子控制器
- (void)setupAllChildViewController
{
    
    SortPullDown *sort = [[SortPullDown alloc] init];
    sort.titleArray = @[@"全部",@"电商",@"租赁",@"安装"];
    SortPullDown *sort2 = [[SortPullDown alloc] init];
    sort2.titleArray = @[@"全部",@"待支付",@"待发货",@"待收货",@"待评价",@"订单完成"];
    SortPullDown *sort3 = [[SortPullDown alloc] init];
    sort3.titleArray = @[@"全部",@"电商",@"租赁",@"安装"];
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
