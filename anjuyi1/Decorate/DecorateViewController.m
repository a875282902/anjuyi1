//
//  DecorateViewController.m
//  anjuyi
//
//  Created by 李 on 2018/5/29.
//  Copyright © 2018年 lsy. All rights reserved.
//
//  装修

#import "DecorateViewController.h"
#import "SearchView.h"
#import "DecorateTableViewCell.h"
#import "IanScrollView.h"
#import "BannerModel.h"
#import "DecorateModel.h"

#import "DesignerViewController.h"//设计师
#import "MasterViewController.h"//工长
#import "PlaceSupervisorViewController.h"//监理
#import "HouseInspectViewController.h"//免费验房
#import "FreeOfferViewController.h"//免费报价

#import "HouseDetailsViewController.h"//整屋详情

#import "ShowWebViewController.h"

#import "SearchViewController.h"

#define hederHeight MDXFrom6(55)

@interface DecorateViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic,strong)UITableView         *   tmpTableView;
@property (nonatomic,strong)NSMutableArray      *   dataArr;
@property (nonatomic,strong)UIView              *   headerView;
@property (nonatomic,strong)IanScrollView       *   bannerScroll;
@property (nonatomic,strong)NSMutableArray      *   bannerArr;

@end

@implementation DecorateViewController

- (void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:animated];
    
    [self getDecorateData];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self.view setBackgroundColor:[UIColor colorWithHexString:@"#f6f6f6"]];
    self.bannerArr = [NSMutableArray array];
    self.dataArr = [NSMutableArray array];
    //搜索框
    SearchView *search = [[SearchView alloc] initWithFrame:CGRectMake(0, 0, MDXFrom6(355), 30) Title:@"大家都在搜设计师"];
    [search addTarget:self action:@selector(jumpSearch)];
    [self.navigationItem setTitleView:search];
    
    
    [self.view addSubview:self.tmpTableView];
    
    [self getBannerData];
    
    [self getDecorateData];
}

#pragma mark -- 数据
- (void)getBannerData{
  
    NSString *path = [NSString stringWithFormat:@"%@/Decorate/index",KURL];
    
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    __weak typeof(self) weakSelf = self;
    
    [HttpRequest POST:path parameters:nil success:^(id  _Nullable responseObject) {
        
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        
        if ([responseObject[@"code"] integerValue] == 200) {
            
            [weakSelf.bannerArr removeAllObjects];
            
            if ([responseObject[@"datas"][@"slide_img"] isKindOfClass:[NSArray class]] ) {
                for (NSDictionary *dict in responseObject[@"datas"][@"slide_img"]) {
                    BannerModel *model = [[BannerModel alloc] initWithDictionary:dict];
                    
                    [weakSelf.bannerArr addObject:@{@"images":model.picture}];
                }
            }
            
        
            if (weakSelf.bannerArr.count != 0) {
                [weakSelf.bannerScroll setSlideImagesArray:weakSelf.bannerArr];
                [weakSelf.bannerScroll setIanEcrollViewSelectAction:^(NSInteger index) {
                    
                    ShowWebViewController *vc = [[ShowWebViewController alloc] init];
                    vc.url = responseObject[@"datas"][@"slide_img"][index][@"url"];
                    [weakSelf.navigationController pushViewController:vc animated:YES];
                }];
                [weakSelf.bannerScroll startLoading];
            }
            
            
        }
        else{
            
            [ViewHelps showHUDWithText:responseObject[@"message"]];
        }
        
        
    } failure:^(NSError * _Nullable error) {
        
        [MBProgressHUD hideHUDForView:weakSelf.view animated:YES];
        [RequestSever showMsgWithError:error];
    }];

}

- (void)getDecorateData{
    
    NSString *path = [NSString stringWithFormat:@"%@/Decorate/getRandModel",KURL];
    
    NSDictionary *header = nil;
    NSDictionary *dic = nil;
    if (UTOKEN) {
       header  = @{@"token":UTOKEN};
    }else{
        dic = @{@"equipment_number":deviceUUID};
    }
    
    
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    __weak typeof(self) weakSelf = self;
    
    [HttpRequest POSTWithHeader:header url:path parameters:dic success:^(id  _Nullable responseObject) {
        
        [MBProgressHUD hideHUDForView:weakSelf.view animated:YES];
        
        if ([responseObject[@"code"] integerValue] == 200) {
            if ([responseObject[@"datas"] isKindOfClass:[NSArray class]]) {
                for (NSDictionary *dic in responseObject[@"datas"]) {
                    DecorateModel *model = [[DecorateModel alloc] initWithDictionary:dic];
                    [weakSelf.dataArr addObject:model];
                }
            }
            
            [weakSelf.tmpTableView reloadData];
        }
        else{
            
            if ([responseObject[@"message"] isEqualToString:@"token过期，请重新登录"]) {
                [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"UTOKEN"];
                
            }{
                [ViewHelps showHUDWithText:responseObject[@"message"]];
            }
        }
        
        
    } failure:^(NSError * _Nullable error) {
        
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        [RequestSever showMsgWithError:error];
    }];

}

#pragma mark --  headerView
- (UIView *)headerView{
    
    if (!_headerView) {
        _headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, KScreenWidth, MDXFrom6(310))];
        [_headerView setBackgroundColor:[UIColor whiteColor]];
        
        NSArray *arr = @[@"zx_fdesign",@"zx_worker",@"zx_vision",@"zx_inspect",@"zx_design"];
        NSArray *tarr = @[@"找设计师",@"找工长",@"找监理",@"免费验房",@"免费报价"];
        for (NSInteger i = 0 ; i < 5; i ++) {
            UIView *back = [[UIView alloc] initWithFrame:CGRectMake(KScreenWidth*i/5, 0, KScreenWidth/5, MDXFrom6(90))];
            [back addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(selectService:)]];
            [back setTag:i];
            [_headerView addSubview:back];
            
            [back addSubview:[Tools creatImage:CGRectMake(MDXFrom6(22.5), MDXFrom6(20), MDXFrom6(30), MDXFrom6(30)) image:arr[i]]];
            [back addSubview:[Tools creatLabel:CGRectMake(0, MDXFrom6(55), KScreenWidth/5, MDXFrom6(25)) font:[UIFont systemFontOfSize:12] color:[UIColor colorWithHexString:@"#3b3b3b"] alignment:(NSTextAlignmentCenter) title:tarr[i]]];
            
        }
        
        
//        [_headerView addSubview:[Tools creatImage:CGRectMake(MDXFrom6(10), MDXFrom6(90), KScreenWidth - MDXFrom6(20), MDXFrom6(210)) image:@"zx_banner"]];
        [_headerView addSubview:self.bannerScroll];
        
    }
    return _headerView;
}

- (IanScrollView *)bannerScroll{
    
    if (!_bannerScroll) {
        _bannerScroll = [[IanScrollView alloc] initWithFrame:CGRectMake(MDXFrom6(10), MDXFrom6(90), KScreenWidth - MDXFrom6(20), MDXFrom6(210))];
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
    return self.dataArr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    DecorateTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"DecorateTableViewCell"];
    if (!cell) {
        cell = [[DecorateTableViewCell alloc] initWithStyle:(UITableViewCellStyleDefault) reuseIdentifier:@"DecorateTableViewCell"];
    }
    
    if (indexPath.row < self.dataArr.count) {
        [cell bandDataWithModel:self.dataArr[indexPath.row]];
    }
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 305;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    
    return hederHeight;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    
    UIView *header = [[UIView alloc] initWithFrame:CGRectMake(0, 0, KScreenWidth, hederHeight)];
    [header setBackgroundColor:[UIColor whiteColor]];
    
    [header addSubview:[Tools setLineView:CGRectMake(0, 0, KScreenWidth , MDXFrom6(10))]];
    
    [header addSubview:[Tools creatImage:CGRectMake(MDXFrom6(10), MDXFrom6(30), MDXFrom6(21), MDXFrom6(18)) url:@"" image:@"zx_case"]];
    
    [header addSubview:[Tools creatLabel:CGRectMake(MDXFrom6(40), MDXFrom6(15), MDXFrom6(300), MDXFrom6(45)) font:[UIFont boldSystemFontOfSize:16] color:[UIColor colorWithHexString:@"#3B3B3B"] alignment:(NSTextAlignmentLeft) title:@"装修成品"]];
    
    
    return header;
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    DecorateModel *model = self.dataArr[indexPath.row];
    
    HouseDetailsViewController *VC  = [[HouseDetailsViewController alloc] init];
    VC.house_id = model.whole_hosue_id;
    [self.navigationController pushViewController:VC animated:YES];
}

#pragma mark -- click 事件
//
- (void)jumpSearch{
    
    SearchViewController *vc = [[SearchViewController alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)selectService:(UITapGestureRecognizer *)sender{
    
    switch (sender.view.tag) {
        case 0:
        {
            DesignerViewController *controller = [[DesignerViewController alloc] init];
            [self.navigationController pushViewController:controller animated:YES];
            
        }
            break;
        case 1:
        {
            MasterViewController *controller = [[MasterViewController alloc] init];
            [self.navigationController pushViewController:controller animated:YES];
            
        }
            break;
            
        case 2:
        {
            PlaceSupervisorViewController *controller = [[PlaceSupervisorViewController alloc] init];
            [self.navigationController pushViewController:controller animated:YES];
            
        }
            break;
        case 3:
        {
            HouseInspectViewController *controller = [[HouseInspectViewController alloc] init];
            [self.navigationController pushViewController:controller animated:YES];
            
        }
            break;
        case 4:
        {
            LOGIN
            FreeOfferViewController *controller = [[FreeOfferViewController alloc] init];
            [self.navigationController pushViewController:controller animated:YES];
            
        }
            break;
            
            
        default:
            break;
    }
    
    NSLog(@"%ld",(long)sender.view.tag);
}

#pragma mark -- delegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
//    CGFloat sectionHeaderHeight = hederHeight;
//    if (scrollView.contentOffset.y<=sectionHeaderHeight&&scrollView.contentOffset.y>=0) {
//        scrollView.contentInset = UIEdgeInsetsMake(-scrollView.contentOffset.y, 0, 0, 0);
//    } else if (scrollView.contentOffset.y>=sectionHeaderHeight) {
//        scrollView.contentInset = UIEdgeInsetsMake(-sectionHeaderHeight, 0, 0, 0);
//    }
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
