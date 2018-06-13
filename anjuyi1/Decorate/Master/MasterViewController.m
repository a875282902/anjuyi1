//
//  DecorateViewController.m
//  anjuyi
//
//  Created by 李 on 2018/5/29.
//  Copyright © 2018年 lsy. All rights reserved.
//
//  工长

#import "MasterViewController.h"
#import "SearchView.h"
#import "DesignerTableViewCell.h"
#import "IanScrollView.h"
#import "ScreeningBar.h"
#import "ScreeningView.h"
#import "MasterDetailsVC.h"

#define hederHeight MDXFrom6(55)

@interface MasterViewController ()<UITableViewDelegate,UITableViewDataSource,ScreeningBarDelegate>

@property (nonatomic,strong)UITableView         *   tmpTableView;
@property (nonatomic,strong)NSMutableArray      *   dataArr;
@property (nonatomic,strong)UIView              *   headerView;
@property (nonatomic,strong)IanScrollView       *   bannerScroll;
@property (nonatomic,strong)ScreeningBar        *   screeningBar;
@property (nonatomic,strong)ScreeningView       *   screeningView;

@end

@implementation MasterViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self.view setBackgroundColor:[UIColor colorWithHexString:@"#f6f6f6"]];
    
    //搜索框
    SearchView *search = [[SearchView alloc] initWithFrame:CGRectMake(0, 0, MDXFrom6(355), 30) Title:@"大家都在搜工长"];
    [search addTarget:self action:@selector(jumpSearch)];
    [self.navigationItem setTitleView:search];
    
    [self.view addSubview:self.tmpTableView];
    
    [self.view addSubview:self.screeningBar];
    
    [self.navigationController.view addSubview:self.screeningView];
}

#pragma mark --  headerView
- (UIView *)headerView{
    
    if (!_headerView) {
        _headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, KScreenWidth, MDXFrom6(310))];
        [_headerView setBackgroundColor:[UIColor whiteColor]];
        
        NSInteger num = 3;
        
        NSArray *arr = @[@"leader_zx",@"leader_dynamic",@"leader_gold"];
        NSArray *tarr = @[@"整屋装修",@"工地动态",@"金牌工长"];
        for (NSInteger i = 0 ; i < num; i ++) {
            UIView *back = [[UIView alloc] initWithFrame:CGRectMake(KScreenWidth*i/num, 0, KScreenWidth/num, MDXFrom6(90))];
            [back addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(selectService:)]];
            [back setTag:i];
            [_headerView addSubview:back];
            
            [back addSubview:[Tools creatImage:CGRectMake(MDXFrom6(45), MDXFrom6(20), MDXFrom6(35), MDXFrom6(30)) image:arr[i]]];
            [back addSubview:[Tools creatLabel:CGRectMake(0, MDXFrom6(55), KScreenWidth/num, MDXFrom6(25)) font:[UIFont systemFontOfSize:12] color:[UIColor colorWithHexString:@"#3b3b3b"] alignment:(NSTextAlignmentCenter) title:tarr[i]]];
            
        }
        
        
        //        [_headerView addSubview:[Tools creatImage:CGRectMake(MDXFrom6(10), MDXFrom6(90), KScreenWidth - MDXFrom6(20), MDXFrom6(210)) image:@"zx_banner"]];
        [_headerView addSubview:self.bannerScroll];
        [self.bannerScroll startLoading];
        
    }
    return _headerView;
}

- (IanScrollView *)bannerScroll{
    
    if (!_bannerScroll) {
        _bannerScroll = [[IanScrollView alloc] initWithFrame:CGRectMake(MDXFrom6(10), MDXFrom6(90), KScreenWidth - MDXFrom6(20), MDXFrom6(210))];
        [_bannerScroll setSlideImagesArray:@[@{@"images":@""},@{@"images":@""},@{@"images":@""}]];
        [_bannerScroll setPageControlPageIndicatorTintColor:[UIColor whiteColor]];
        [_bannerScroll setPageControlCurrentPageIndicatorTintColor:[UIColor colorWithHexString:@"#3b3b3b"]];
    }
    return _bannerScroll;
    
}

#pragma mark -- screeningBar
- (ScreeningBar *)screeningBar{
    if (!_screeningBar) {
        _screeningBar = [[ScreeningBar alloc] initWithFrame:CGRectMake(0, MDXFrom6(10), KScreenWidth, MDXFrom6(45))];
        [_screeningBar setDelegate:self];
        [_screeningBar setHidden:YES];
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
        [_screeningView setTypeArr:[NSMutableArray arrayWithArray: @[@"工长分类",@"价格区间",@"工长等级"]]];
        [_screeningView setDataArr:[NSMutableArray arrayWithArray: @[@[@"全部",@"家装",@"工装",@"软装"],@[@"32-115\n31%的选择",@"32-115\n41%的选择",@"32-115\n21%的选择"],@[@"全部",@"普通",@"名家汇"]]]];
        
        
    }
    return _screeningView;
}

#pragma mark -- tableView
- (UITableView *)tmpTableView{
    
    if (!_tmpTableView) {
        _tmpTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, MDXFrom6(10), KScreenWidth, KScreenHeight-KTopHeight - MDXFrom6(10)) style:(UITableViewStylePlain)];
        [_tmpTableView setSeparatorStyle:(UITableViewCellSeparatorStyleNone)];
        if (@available(iOS 11.0, *)) {
            [_tmpTableView setContentInsetAdjustmentBehavior:(UIScrollViewContentInsetAdjustmentNever)];
        }
        [_tmpTableView setRowHeight:190.0f];
        [_tmpTableView setShowsVerticalScrollIndicator:NO];
        [_tmpTableView setShowsHorizontalScrollIndicator:NO];
        [_tmpTableView setTableHeaderView:self.headerView];
        [_tmpTableView setDataSource:self];
        [_tmpTableView setDelegate:self];
    }
    return _tmpTableView;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 10;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    DesignerTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"DesignerTableViewCell"];
    if (!cell) {
        cell = [[DesignerTableViewCell alloc] initWithStyle:(UITableViewCellStyleDefault) reuseIdentifier:@"DesignerTableViewCell"];
    }
    
    return cell;
}

//- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
//
//    return 305;
//}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    
    return hederHeight;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    
    UIView *header = [[UIView alloc] initWithFrame:CGRectMake(0, 0, KScreenWidth, hederHeight)];
    [header setBackgroundColor:[UIColor whiteColor]];
    
    [header addSubview:[Tools setLineView:CGRectMake(0, 0, KScreenWidth , MDXFrom6(10))]];
    
    [header addSubview:[Tools creatImage:CGRectMake(MDXFrom6(10), MDXFrom6(30), MDXFrom6(18), MDXFrom6(20)) url:@"" image:@"leader_excellent"]];
    
    [header addSubview:[Tools creatLabel:CGRectMake(MDXFrom6(40), MDXFrom6(17), MDXFrom6(300), MDXFrom6(45)) font:[UIFont boldSystemFontOfSize:16] color:[UIColor colorWithHexString:@"#3B3B3B"] alignment:(NSTextAlignmentLeft) title:@"优秀工长"]];
    
    
    return header;
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    MasterDetailsVC *controller = [[MasterDetailsVC alloc] init];
    [self.navigationController pushViewController:controller animated:YES];
    
}


#pragma mark -- click 事件
//
- (void)jumpSearch{
    
    
}

- (void)selectService:(UITapGestureRecognizer *)sender{
    
    switch (sender.view.tag) {
        case 0:
        {
            
        }
            break;
            
        default:
            break;
    }
}

#pragma mark -- delegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    CGFloat sectionHeaderHeight = hederHeight;
    if (scrollView.contentOffset.y<=sectionHeaderHeight&&scrollView.contentOffset.y>=0) {
        scrollView.contentInset = UIEdgeInsetsMake(-scrollView.contentOffset.y, 0, 0, 0);
    } else if (scrollView.contentOffset.y>=sectionHeaderHeight) {
        scrollView.contentInset = UIEdgeInsetsMake(-sectionHeaderHeight, 0, 0, 0);
    }
    
    if (scrollView.contentOffset.y>MDXFrom6(310)) {
        [self.screeningBar setHidden:NO];
    }
    else{
        [self.screeningBar setHidden:YES];
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
