//
//  MallViewController.m
//  anjuyi
//
//  Created by 李 on 2018/5/29.
//  Copyright © 2018年 lsy. All rights reserved.
//

#import "MallViewController.h"
#import "SearchView.h"
#import "MallTableViewCell.h"
#import "IanScrollView.h"

#define hederHeight MDXFrom6(55)

@interface MallViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic,strong)UITableView         *   tmpTableView;
@property (nonatomic,strong)NSMutableArray      *   dataArr;
@property (nonatomic,strong)UIView              *   headerView;
@property (nonatomic,strong)IanScrollView       *   bannerScroll;

@end

@implementation MallViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self.view setBackgroundColor:[UIColor colorWithHexString:@"#f6f6f6"]];
    
    //搜索框
    SearchView *search = [[SearchView alloc] initWithFrame:CGRectMake(0, 0, MDXFrom6(355), 30) Title:@"沙子  水泥"];
    [search addTarget:self action:@selector(jumpSearch)];
    [self.navigationItem setTitleView:search];
    
    [self.view addSubview:self.tmpTableView];
    
}

#pragma mark --  headerView
- (UIView *)headerView{
    
    if (!_headerView) {
        _headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, KScreenWidth, MDXFrom6(265))];
        [_headerView setBackgroundColor:[UIColor whiteColor]];
        
        NSArray *arr = @[@"sc_com_cal",@"sc_scekill",@"sc_shop",@"sc_sever"];
        NSArray *tarr = @[@"商品分类",@"秒杀专区",@"一元购",@"安装服务"];
        for (NSInteger i = 0 ; i < 4; i ++) {
            UIView *back = [[UIView alloc] initWithFrame:CGRectMake(KScreenWidth*i/4, MDXFrom6(170), KScreenWidth/4, MDXFrom6(80))];
            [back addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(selectService:)]];
            [back setTag:i];
            [_headerView addSubview:back];
            
            [back addSubview:[Tools creatImage:CGRectMake(MDXFrom6(28.375), MDXFrom6(10), MDXFrom6(37), MDXFrom6(37)) image:arr[i]]];
            [back addSubview:[Tools creatLabel:CGRectMake(0, MDXFrom6(62), KScreenWidth/4, MDXFrom6(20)) font:[UIFont systemFontOfSize:14] color:[UIColor colorWithHexString:@"#3b3b3b"] alignment:(NSTextAlignmentCenter) title:tarr[i]]];
            
        }
        
//        [_headerView addSubview:[Tools creatImage:CGRectMake(MDXFrom6(10), MDXFrom6(10), KScreenWidth - MDXFrom6(20), MDXFrom6(147)) image:@"zx_banner"]];
        
        [_headerView addSubview:self.bannerScroll];
        [self.bannerScroll startLoading];
        
    }
    return _headerView;
}
- (IanScrollView *)bannerScroll{
    
    if (!_bannerScroll) {
        _bannerScroll = [[IanScrollView alloc] initWithFrame:CGRectMake(MDXFrom6(10), MDXFrom6(10), KScreenWidth - MDXFrom6(20), MDXFrom6(147))];
        [_bannerScroll setSlideImagesArray:@[@{@"images":@""},@{@"images":@""},@{@"images":@""}]];
        [_bannerScroll setPageControlPageIndicatorTintColor:[UIColor whiteColor]];
        [_bannerScroll setPageControlCurrentPageIndicatorTintColor:[UIColor colorWithHexString:@"#3b3b3b"]];
    }
    return _bannerScroll;
    
}
#pragma mark -- tableView
- (UITableView *)tmpTableView{
    
    if (!_tmpTableView) {
        _tmpTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, MDXFrom6(10), KScreenWidth, KScreenHeight-KTopHeight - KTabBarHeight - MDXFrom6(10)) style:(UITableViewStylePlain)];
        [_tmpTableView setSeparatorStyle:(UITableViewCellSeparatorStyleNone)];
        if (@available(iOS 11.0, *)) {
            [_tmpTableView setContentInsetAdjustmentBehavior:(UIScrollViewContentInsetAdjustmentNever)];
        }
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
    
    MallTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MallTableViewCell"];
    if (!cell) {
        cell = [[MallTableViewCell alloc] initWithStyle:(UITableViewCellStyleDefault) reuseIdentifier:@"MallTableViewCell"];
    }
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 150;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    
    return hederHeight;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    
    UIView *header = [[UIView alloc] initWithFrame:CGRectMake(0, 0, KScreenWidth, hederHeight)];
    [header setBackgroundColor:[UIColor whiteColor]];
    
    [header addSubview:[Tools setLineView:CGRectMake(0, 0, KScreenWidth , MDXFrom6(10))]];
    
    [header addSubview:[Tools creatImage:CGRectMake(MDXFrom6(10), MDXFrom6(25), MDXFrom6(16), MDXFrom6(22)) url:@"" image:@"sc_hot"]];
    
    [header addSubview:[Tools creatLabel:CGRectMake(MDXFrom6(40), MDXFrom6(15), MDXFrom6(300), MDXFrom6(45)) font:[UIFont boldSystemFontOfSize:16] color:[UIColor colorWithHexString:@"#3B3B3B"] alignment:(NSTextAlignmentLeft) title:@"热销商品"]];
    
    
    return header;
    
}



#pragma mark -- click 事件
//
- (void)jumpSearch{
    
    
}

- (void)selectService:(UITapGestureRecognizer *)sender{
    
    NSLog(@"%ld",sender.view.tag);
}

#pragma mark -- delegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    CGFloat sectionHeaderHeight = hederHeight;
    if (scrollView.contentOffset.y<=sectionHeaderHeight&&scrollView.contentOffset.y>=0) {
        scrollView.contentInset = UIEdgeInsetsMake(-scrollView.contentOffset.y, 0, 0, 0);
    } else if (scrollView.contentOffset.y>=sectionHeaderHeight) {
        scrollView.contentInset = UIEdgeInsetsMake(-sectionHeaderHeight, 0, 0, 0);
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
