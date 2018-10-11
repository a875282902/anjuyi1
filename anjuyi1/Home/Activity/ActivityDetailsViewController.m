//
//  ActivityDetailsViewController.m
//  anjuyi1
//
//  Created by apple on 2018/8/7.
//  Copyright © 2018年 lsy. All rights reserved.
//

#import "ActivityDetailsViewController.h"
#import "ActivityList.h"
#import "PhotoDetailsViewController.h"
#import "AddActivityPhotoViewController.h"

@interface ActivityDetailsViewController ()<UIScrollViewDelegate,ActivityListDelegate>
{
    UIButton *backBtn;
    UIButton *shareBtn;
}
@property (nonatomic,strong)UIView         *  navView;
@property (nonatomic,strong)UIScrollView   *  tmpScrollView;
@property (nonatomic,strong)NSMutableArray *  channelArr;
@property (nonatomic,strong)NSMutableArray *  viewArr;
@property (nonatomic,strong)UIView         *  channelView;
@property (nonatomic,strong)UIView         *  lineView;
@end

@implementation ActivityDetailsViewController

- (void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:animated];
    
    [self setNavigationLeftBarButtonWithImageNamed:@""];
    [self.navigationController setNavigationBarHidden:YES animated:YES];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.

    self.channelArr = [NSMutableArray array];
    self.viewArr = [NSMutableArray array];
    
    [self getActivityInfo];

}

- (void)getActivityInfo{
    
    
    NSString *path = [NSString stringWithFormat:@"%@/activity/get_activity_detail",KURL];
    
    NSDictionary *dic = @{@"activity_id":self.activity_id};
    
    
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    __weak typeof(self) weakSelf = self;
    
    [HttpRequest POST:path parameters:dic success:^(id  _Nullable responseObject) {
        
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        
        if ([responseObject[@"code"] integerValue] == 200) {
            
            [weakSelf setUpInfoView:responseObject[@"datas"]];
        }
        else{
            
            [ViewHelps showHUDWithText:responseObject[@"message"]];
        }
        
        
    } failure:^(NSError * _Nullable error) {
        
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        [RequestSever showMsgWithError:error];
    }];

}

#pragma mark -- UI
- (UIView *)navView{
    
    if (!_navView) {
        _navView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, KScreenWidth, KTopHeight)];
        [_navView setBackgroundColor:MDRGBA(255, 255, 255, 0)];
        
        UIButton *back = [Tools creatButton:CGRectMake(MDXFrom6(10), KStatusBarHeight + 2, 40, 40) font:[UIFont systemFontOfSize:12] color:[UIColor whiteColor] title:@"" image:@"ss_back"];
        [back addTarget:self action:@selector(back) forControlEvents:(UIControlEventTouchUpInside)];
        [_navView addSubview:back];
        
        backBtn = back;
        
        UIButton *share = [Tools creatButton:CGRectMake(KScreenWidth - 50, KStatusBarHeight + 2, 40, 40) font:[UIFont systemFontOfSize:12] color:[UIColor whiteColor] title:@"" image:@"share"];
        [share addTarget:self action:@selector(share) forControlEvents:(UIControlEventTouchUpInside)];
        [_navView addSubview:share];
        
        shareBtn = share;
    }
    return _navView;
}

-(UIScrollView *)tmpScrollView{
    
    if (!_tmpScrollView) {
        _tmpScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 100, KScreenWidth, KViewHeight-100)];
        [_tmpScrollView setShowsVerticalScrollIndicator:NO];
        [_tmpScrollView setShowsHorizontalScrollIndicator:NO];
        if (@available(iOS 11.0, *)) {
            [_tmpScrollView setContentInsetAdjustmentBehavior:(UIScrollViewContentInsetAdjustmentNever)];
        }
        [_tmpScrollView setDelegate:self];
    }
    return _tmpScrollView;
}



- (void)setUpInfoView:(NSDictionary *)dic{
    
    [self.view addSubview:[Tools creatImage:CGRectMake(0, 0, KScreenWidth, MDXFrom6(210)) url:dic[@"img"] image:@""]];
    
    UIView *resultsView = [[UIView alloc] initWithFrame:CGRectMake(15, 0 , KScreenWidth - 30, 100)];
    [resultsView setCenter:CGPointMake(KScreenWidth/2, MDXFrom6(210))];
    [resultsView setBackgroundColor:[UIColor whiteColor]];
    [resultsView.layer setShadowColor:[UIColor blackColor].CGColor];
    [resultsView.layer setCornerRadius:5];
    [resultsView.layer setShadowOpacity:0.1];
    [resultsView.layer setShadowOffset:CGSizeMake(2, 4)];
    [self.view addSubview:resultsView];
    
    UILabel *stautsLabel = [Tools creatLabel:CGRectMake(20, 10, 50, 20) font:[UIFont systemFontOfSize:10] color:[UIColor whiteColor] alignment:(NSTextAlignmentCenter) title:@"正在征集"];
    [stautsLabel setBackgroundColor:[UIColor colorWithHexString:@"#2cb7b5"]];
    [stautsLabel.layer setCornerRadius:5];
    [resultsView addSubview:stautsLabel];
    
    [resultsView addSubview:[Tools creatLabel:CGRectMake(20, 40, KScreenWidth - 70, 15) font:[UIFont systemFontOfSize:15] color:TCOLOR alignment:(NSTextAlignmentLeft) title:dic[@"title"]]];
    
    [resultsView addSubview:[Tools creatLabel:CGRectMake(20, 70, KScreenWidth - 70, 15) font:[UIFont systemFontOfSize:12] color:[UIColor colorWithHexString:@"#666666"] alignment:(NSTextAlignmentLeft) title:dic[@"text"]]];
    
    [self.view addSubview:self.navView];
    
    
    CGFloat height = MDXFrom6(210)+65;
    
    UIView *channelView = [[UIView alloc] initWithFrame:CGRectMake(0, height, KScreenWidth, 35)];
    [channelView setBackgroundColor:[UIColor whiteColor]];
    [self.view addSubview:channelView];
    
    [self setUpChannelView:channelView];
    
    height+= 45;
    
    [self.tmpScrollView setFrame:CGRectMake(0, height, KScreenWidth, KScreenHeight - height - 80)];
    [self.tmpScrollView setPagingEnabled:YES];
    [self.tmpScrollView setContentSize:CGSizeMake(KScreenWidth *2, KScreenHeight - height - 80)];
    [self.view addSubview:self.tmpScrollView];
    [self setUpScrollViewContent];
    

    UIButton *btn = [Tools creatButton:CGRectMake((KScreenWidth-200)/2, KScreenHeight - 65, 200, 50) font:[UIFont systemFontOfSize:17] color:[UIColor whiteColor] title:@"参与征集" image:@""];
    [btn setBackgroundColor:GCOLOR];
    [btn.layer setCornerRadius:25];
    [btn setClipsToBounds:YES];
    [btn addTarget:self action:@selector(addActivityToList) forControlEvents:(UIControlEventTouchUpInside)];
    [self.view addSubview:btn];
    
    
}

- (void)setUpChannelView:(UIView *)channelView{
    NSArray *arr = @[@"精选",@"最新"];
    for (NSInteger i = 0 ; i < 2; i++) {
        UIButton *btn = [Tools creatButton:CGRectMake(i==0?(KScreenWidth/2 - 50):KScreenWidth/2, 0, 50, 30) font:[UIFont systemFontOfSize:16] color:[UIColor blackColor] title:arr[i] image:@""];
        [btn setTitleColor:GCOLOR forState:(UIControlStateSelected)];
        [btn setTag:i];
        [btn addTarget:self action:@selector(channelChangeValue:) forControlEvents:(UIControlEventTouchUpInside)];
        [channelView addSubview:btn];
        
        if (i==0) {
            [btn setSelected:YES];
        
        }
        
        [self.channelArr addObject:btn];
    }
    
    self.lineView = [[UIView alloc] initWithFrame:CGRectMake(KScreenWidth/2 - 40, 32, 30, 2)];
    [self.lineView setBackgroundColor:GCOLOR];
    [channelView addSubview:self.lineView];
    
    self.channelView = channelView;
}

- (void)setUpScrollViewContent{
    
    for (NSInteger i = 0 ; i < 2 ; i++) {
        ActivityList *listV = [[ActivityList alloc] initWithFrame:CGRectMake(KScreenWidth *i, 0, KScreenWidth, self.tmpScrollView.frame.size.height)];
        [listV setDelegate:self];
        [listV setDataWitIndex:i==0?1:0 withActivityid:self.activity_id];
        [self.tmpScrollView addSubview:listV];
        
        [self.viewArr addObject:listV];
    }
    
}

#pragma mark -- 事件
- (void)back{
    
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)share{
    
}

- (void)channelChangeValue:(UIButton *)sender{
    
    if (!sender.selected) {
        for (UIButton *btn in self.channelArr) {
            [btn setSelected:NO];
        }
        sender.selected = !sender.selected;
        
        [UIView animateWithDuration:.5 animations:^{
           
            [self.lineView setCenter:CGPointMake(sender.center.x, self.lineView.center.y)];
            [self.tmpScrollView setContentOffset:CGPointMake(KScreenWidth*sender.tag, 0) animated:YES];
        }];
    }
}

- (void)backViewScroll:(CGFloat)y{
  
//    if (y>0) {
//
//        [UIView animateWithDuration:.5 animations:^{
//            
//            [self.channelView setCenter:CGPointMake(KScreenWidth/2, self.navView.frame.size.height+(35/2.0))];
//            [self.tmpScrollView setFrame:CGRectMake(0, self.navView.frame.size.height+35, KScreenWidth , KScreenHeight -self.navView.frame.size.height - 80 -35 )];
//        }];
//    }
//    else{
//        
//        [UIView animateWithDuration:.2 animations:^{
//            [self.channelView setCenter:CGPointMake(KScreenWidth/2, MDXFrom6(210)+65+(35/2.0))];
//            [self.tmpScrollView setFrame:CGRectMake(0, MDXFrom6(210)+65+45, KScreenWidth , KScreenHeight -(MDXFrom6(210)+65+45) - 80 )];
//        }];
//    }
//    
//    [self refreScrollViewFrame];
}

- (void)refreScrollViewFrame{
    
    [self.tmpScrollView setContentSize:CGSizeMake(KScreenWidth *2, self.tmpScrollView.frame.size.height)];
    
    for (ActivityList *listV in self.viewArr) {
        
        [listV setFrame:CGRectMake(listV.frame.origin.x, listV.frame.origin.y, listV.frame.size.width, self.tmpScrollView.frame.size.height)];
        
        [listV refreFrame];
    }
    
}

-  (void)selectPhotoToShow:(NSString *)photoId{
    
    PhotoDetailsViewController *vc = [[PhotoDetailsViewController alloc] init];
    vc.photo_id = photoId;
    [self.navigationController pushViewController:vc animated:YES];
}

//参与征集
- (void)addActivityToList{
    LOGIN
    AddActivityPhotoViewController *VC = [[AddActivityPhotoViewController alloc] init];
    VC.activity_id = self.activity_id;
    [self.navigationController pushViewController:VC animated:YES];
}


#pragma mark -- scrollVIew 协议 、、 数据刷新
- (void) scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate{
    if (scrollView == self.tmpScrollView) {
        
        // 如果在拖动结束的时候，没有减速的过程
        if (!decelerate){
            
            NSInteger page = scrollView.contentOffset.x/KScreenWidth;
            
            [self channelChangeValue:self.channelArr[page]];
        }
    }
    
}
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    if (scrollView == self.tmpScrollView) {
        NSInteger page = scrollView.contentOffset.x/KScreenWidth;
        
        [self channelChangeValue:self.channelArr[page]];
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
