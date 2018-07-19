//
//  ChargingHomeViewController.m
//  anjuyi1
//
//  Created by apple on 2018/7/18.
//  Copyright © 2018年 lsy. All rights reserved.
//

#import "ChargingHomeViewController.h"
#import "BannerModel.h"
#import "IanScrollView.h"

@interface ChargingHomeViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic,strong)UITableView     *    tmpTableView;
@property (nonatomic,strong)NSMutableArray  *    dataArr;
@property (nonatomic,strong)UIView          *    headerView;

@property (nonatomic,strong)IanScrollView   *    bannerScroll;
@property (nonatomic,strong)NSMutableArray  *    bannerArr;

@end

@implementation ChargingHomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self baseForDefaultLeftNavButton];
    [self setTitle:@"充电桩安装"];
    
    self.dataArr = [NSMutableArray array];
    self.bannerArr = [NSMutableArray array];
    
    [self.view addSubview:self.tmpTableView];
    
    [self.view addSubview:[Tools setLineView:CGRectMake(0, 0, KScreenWidth, 1)]];
    
    [self getBannerData];
    
    [self getNewsData];
}

- (void)getBannerData{
    
    NSString *path = [NSString stringWithFormat:@"%@/charging/index",KURL];
    
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    __weak typeof(self) weakSelf = self;
    
    [HttpRequest POST:path parameters:nil success:^(id  _Nullable responseObject) {
        
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        
        if ([responseObject[@"code"] integerValue] == 200) {
            
            [weakSelf.bannerArr removeAllObjects];
            
            if ([responseObject[@"datas"][@"slide_img"] isKindOfClass:[NSArray class]] ) {
                for (NSDictionary *dict in responseObject[@"datas"][@"slide_img"]) {
                    BannerModel *model = [[BannerModel alloc] initWithDictionary:dict];
                    [weakSelf.bannerArr addObject:model];
                }
            }
            
            [weakSelf setUpHeaderView];
            
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

- (void)getNewsData{
    
    NSString *path = [NSString stringWithFormat:@"%@/charging/article_list",KURL];
    
    NSDictionary *dic = @{@"page":@"1"};
    
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    __weak typeof(self) weakSelf = self;
    
    [HttpRequest POST:path parameters:dic success:^(id  _Nullable responseObject) {
        
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        
        if ([responseObject[@"code"] integerValue] == 200) {
            
            [weakSelf.bannerArr removeAllObjects];
            
            if ([responseObject[@"datas"] isKindOfClass:[NSArray class]] ) {
                for (NSDictionary *dict in responseObject[@"datas"]) {
                    [weakSelf.dataArr addObject:dict];
                }
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

#pragma mark -- headerView
- (UIView *)headerView{
    
    if (!_headerView) {
        _headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, KScreenWidth, 10)];
        [_headerView setBackgroundColor:[UIColor whiteColor]];
    }
    return _headerView;
}

- (void)setUpHeaderView{
    
    CGFloat height = 0;
    
    [self.bannerScroll setFrame:CGRectMake(0, height, KScreenWidth, MDXFrom6(225))];
    
    NSMutableArray *barr = [NSMutableArray array];
    
    for (BannerModel *model in self.bannerArr) {
        [barr addObject:@{@"images":model.picture}];
    }
    if (barr.count != 0) {
        [self.bannerScroll setSlideImagesArray:barr];
        [_headerView addSubview:self.bannerScroll];
        [self.bannerScroll startLoading];
    }
    
    height += MDXFrom6(225);
    
    NSArray *tArr = @[@"快速下单",@"安装须知",@"安装案例",@"附近电站"];
    //cdz_ico4
    for (NSInteger i = 0 ; i < 4; i ++) {
        UIView *back = [[UIView alloc] initWithFrame:CGRectMake(KScreenWidth*i/4, height, KScreenWidth/4, 85)];
        [back addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(selectService:)]];
        [back setTag:i];
        [_headerView addSubview:back];
        
        [back addSubview:[Tools creatImage:CGRectMake((KScreenWidth/4 - 25)/2, 23, 25, 25) image:[NSString stringWithFormat:@"cdz_ico%ld",i+1]]];
        
        [back addSubview:[Tools creatLabel:CGRectMake(0, 50, KScreenWidth/4, 12) font:[UIFont systemFontOfSize:12] color:[UIColor colorWithHexString:@"#3b3b3b"] alignment:(NSTextAlignmentCenter) title:tArr[i]]];
        
    }
    
    height += 85;
    
    [self.headerView addSubview:[Tools creatImage:CGRectMake(MDXFrom6(7.5), height, KScreenWidth - MDXFrom6(15) , MDXFrom6(125)) image:@"cgx_img"]];
    
    height += MDXFrom6(125) + 25;
    
    [self.headerView addSubview:[Tools creatLabel:CGRectMake(10, height, KScreenWidth, 18) font:[UIFont boldSystemFontOfSize:18] color:[UIColor blackColor] alignment:(NSTextAlignmentLeft) title:@"新闻时事"]];
    
    height += 25;
    
    [self.headerView setFrame:CGRectMake(0, 0, KScreenWidth, height)];
}

- (IanScrollView *)bannerScroll{
    
    if (!_bannerScroll) {
        _bannerScroll = [[IanScrollView alloc] initWithFrame:CGRectMake(MDXFrom6(10), MDXFrom6(90), KScreenWidth - MDXFrom6(20), MDXFrom6(225))];
        [_bannerScroll setPageControlPageIndicatorTintColor:[UIColor whiteColor]];
        [_bannerScroll setPageControlCurrentPageIndicatorTintColor:[UIColor colorWithHexString:@"#3b3b3b"]];
    }
    return _bannerScroll;
    
}

#pragma mark -- tableView
- (UITableView *)tmpTableView{
    
    if (!_tmpTableView) {
        _tmpTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, KScreenWidth, KViewHeight) style:(UITableViewStylePlain)];
        if (@available(iOS 11.0, *)) {
            [_tmpTableView setContentInsetAdjustmentBehavior:(UIScrollViewContentInsetAdjustmentNever)];
        }
        [_tmpTableView setShowsVerticalScrollIndicator:NO];
        [_tmpTableView setShowsHorizontalScrollIndicator:NO];
        [_tmpTableView setTableHeaderView:self.headerView];
        [_tmpTableView setTableFooterView:[UIView new]];
        [_tmpTableView setDataSource:self];
        [_tmpTableView setDelegate:self];
    }
    return _tmpTableView;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataArr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ChargingHomeViewControllerCell"];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:(UITableViewCellStyleSubtitle) reuseIdentifier:@"ChargingHomeViewControllerCell"];
    }
    if (indexPath.row < self.dataArr.count) {
        
        NSDictionary *dic = self.dataArr[indexPath.row];
        
        [cell.textLabel setText:dic[@"title"]];
        [cell.textLabel setFont:[UIFont systemFontOfSize:15]];
        [cell.textLabel setNumberOfLines:2];
        [cell.textLabel setTextColor:[UIColor blackColor]];
        
        [cell.detailTextLabel setText:dic[@"create_time"]];
        [cell.detailTextLabel setFont:[UIFont systemFontOfSize:12]];
        [cell.detailTextLabel setTextColor:[UIColor colorWithHexString:@"#999999"]];
        
        [cell setSelectionStyle:(UITableViewCellSelectionStyleNone)];
        [cell setAccessoryType:(UITableViewCellAccessoryDisclosureIndicator)];
        
    }
   
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 70;
}

#pragma mark -- 点击事件
- (void)selectService:(UITapGestureRecognizer *)sender{
    
    
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
