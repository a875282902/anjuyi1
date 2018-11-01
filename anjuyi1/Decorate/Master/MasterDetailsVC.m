//
//  DesignerDetailsVC.m
//  anjuyi1
//
//  Created by 李 on 2018/5/31.
//  Copyright © 2018年 lsy. All rights reserved.
//
//  工长详情

#import "MasterDetailsVC.h"
#import "ProjectListVC.h"
#import "ProjectDetailsVC.h"

#import "PhotoListViewController.h"
#import "PhotoDetailsViewController.h"//图片详情

#import "HouseListViewController.h"
#import "HouseDetailsViewController.h"//整屋详情详情

#import "StrategyListViewController.h"
#import "AnswerListViewController.h"

@interface MasterDetailsVC ()<UIScrollViewDelegate>
{
    UIButton *backBtn;
    UIButton *shareBtn;
    
    UIImageView *headerBackImage;
}

@property (nonatomic,strong)UIScrollView   *  tmpScrollView;

@property (nonatomic,strong)UIView         *  navView;

@property (nonatomic,strong)NSDictionary   *  data;

@end

@implementation MasterDetailsVC

- (void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:animated];
    
    [self setNavigationLeftBarButtonWithImageNamed:@""];
    
    [self.navigationController setNavigationBarHidden:YES animated:YES];
}

- (void)viewWillDisappear:(BOOL)animated{
    
    [super viewWillDisappear:animated];
    
    [self.navigationController setNavigationBarHidden:NO animated:YES];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.view addSubview:self.tmpScrollView];
    
    [self.view addSubview:self.navView];
    
    [self getData];
}

- (void)getData{
    
    
    NSString *path = [NSString stringWithFormat:@"%@/work/worker_detail",KURL];

    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    __weak typeof(self) weakSelf = self;
    
    [HttpRequest POST:path parameters:@{@"user_id":self.masterID} success:^(id  _Nullable responseObject) {
        
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        
        if ([responseObject[@"code"] integerValue] == 200) {
            
            weakSelf.data = responseObject[@"datas"];
            
            [weakSelf setUpScrollView];
        }
        else{
            
            [ViewHelps showHUDWithText:responseObject[@"message"]];
        }
        
        
    } failure:^(NSError * _Nullable error) {
        [weakSelf.navigationController popViewControllerAnimated:YES];
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        [RequestSever showMsgWithError:error];
    }];

}

- (UIScrollView *)tmpScrollView{
    //designer_xq_banner
    if (!_tmpScrollView) {
        _tmpScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, KScreenWidth, KScreenHeight-KPlaceHeight)];
        if (@available(iOS 11.0, *)) {
            [_tmpScrollView setContentInsetAdjustmentBehavior:(UIScrollViewContentInsetAdjustmentNever)];
        }
        [_tmpScrollView setDelegate:self];
        [_tmpScrollView setShowsVerticalScrollIndicator:NO];
        [_tmpScrollView setShowsHorizontalScrollIndicator:NO];
    }
    return _tmpScrollView;
}

- (UIView *)navView{
    
    if (!_navView) {
        _navView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, KScreenWidth, KTopHeight)];
        [_navView setBackgroundColor:MDRGBA(255, 255, 255, 0)];
        
        UIButton *back = [Tools creatButton:CGRectMake(MDXFrom6(10), KStatusBarHeight + 2, 40, 40) font:[UIFont systemFontOfSize:12] color:[UIColor whiteColor] title:@"" image:@"my_back"];
        [back addTarget:self action:@selector(back) forControlEvents:(UIControlEventTouchUpInside)];
        [_navView addSubview:back];
        
        backBtn = back;
        
        UIButton *share = [Tools creatButton:CGRectMake(KScreenWidth - 50, KStatusBarHeight + 2, 40, 40) font:[UIFont systemFontOfSize:12] color:[UIColor whiteColor] title:@"" image:@"designer_xq_zf"];
        [share addTarget:self action:@selector(share) forControlEvents:(UIControlEventTouchUpInside)];
        [_navView addSubview:share];
        
        shareBtn = share;
    }
    return _navView;
}

- (void)setUpScrollView{
    
    CGFloat height = 0.0f;
    
    UIImageView *headerBack = [Tools creatImage:CGRectMake(0, 0, KScreenWidth, MDXFrom6(286.5)) image:@"designer_xq_banner"];
    [self.tmpScrollView addSubview:headerBack];
    
    headerBackImage = headerBack;
    
    height = KStatusBarHeight +MDXFrom6(65);
    
    [self.tmpScrollView addSubview:[Tools creatLabel:CGRectMake(MDXFrom6(15), height, MDXFrom6(345), MDXFrom6(32)) font:[UIFont systemFontOfSize:30] color:[UIColor whiteColor] alignment:(NSTextAlignmentLeft) title:self.data[@"member_info"][@"nickname"]]];
    
    UIImageView *headerImage = [Tools creatImage:CGRectMake(MDXFrom6(300), height, MDXFrom6(60), MDXFrom6(60)) url:self.data[@"member_info"][@"head"] image:@"fb_tx_img"];
    [headerImage setClipsToBounds:YES];
    [headerImage.layer setCornerRadius:MDXFrom6(30)];
    [self.tmpScrollView addSubview:headerImage];
    
    UILabel *typeLabel = [Tools creatLabel:CGRectMake(MDXFrom6(300), height+MDXFrom6(70), MDXFrom6(60), MDXFrom6(20)) font:[UIFont systemFontOfSize:12] color:[UIColor whiteColor] alignment:(NSTextAlignmentCenter) title:@"工长"];
    [typeLabel.layer setCornerRadius:5];
    [typeLabel setBackgroundColor:[UIColor colorWithHexString:@"#2CB7B5"]];
    [typeLabel setClipsToBounds:YES];
    [self.tmpScrollView addSubview:typeLabel];
    
    
    height += MDXFrom6(42);
    
    [self.tmpScrollView addSubview:[Tools creatLabel:CGRectMake(MDXFrom6(15), height, MDXFrom6(345), MDXFrom6(20)) font:[UIFont systemFontOfSize:12] color:[UIColor whiteColor] alignment:(NSTextAlignmentLeft) title:self.data[@"member_info"][@"address"]]];
    
    height += MDXFrom6(25);
    
    [self.tmpScrollView addSubview:[Tools creatLabel:CGRectMake(MDXFrom6(15), height, MDXFrom6(345), MDXFrom6(20)) font:[UIFont systemFontOfSize:12] color:[UIColor whiteColor] alignment:(NSTextAlignmentLeft) title:@"工长"]];
    
    height = MDXFrom6(226.5);
    
    NSArray *tArr = @[@"关注",@"被关注",@"已预约"];
    NSArray *dArr = @[self.data[@"follow"][@"follow_num"],
                      self.data[@"follow"][@"fan_num"],
                      @"123"];
    
    for (NSInteger i = 0; i < 3 ; i++) {
        [self.tmpScrollView addSubview:[Tools creatLabel:CGRectMake(MDXFrom6(75*i), height, MDXFrom6(75), MDXFrom6(20)) font:[UIFont systemFontOfSize:12] color:[UIColor whiteColor] alignment:(NSTextAlignmentCenter) title:tArr[i]]];
        [self.tmpScrollView addSubview:[Tools creatLabel:CGRectMake(MDXFrom6(75*i), height+MDXFrom6(30), MDXFrom6(75), MDXFrom6(20)) font:[UIFont boldSystemFontOfSize:18] color:[UIColor whiteColor] alignment:(NSTextAlignmentCenter) title:dArr[i]]];
    }
    
    UIButton *likeBtn = [Tools creatButton:CGRectMake(MDXFrom6(260), height, MDXFrom6(100), MDXFrom6(35)) font:[UIFont boldSystemFontOfSize:14] color:[UIColor whiteColor] title:@"关注" image:@""];
    [likeBtn setTitle:@"已关注" forState:(UIControlStateSelected)];
    [likeBtn setBackgroundColor:MDRGBA(255, 180, 0, 1)];
    [likeBtn.layer setCornerRadius:MDXFrom6(17.5f)];
    [likeBtn setClipsToBounds:YES];
    [likeBtn setSelected:[self.data[@"is_follow"] integerValue]==1?YES:NO];//1 关注
    [likeBtn addTarget:self action:@selector(like:) forControlEvents:(UIControlEventTouchUpInside)];
    [self.tmpScrollView addSubview:likeBtn];
    
    [likeBtn setImageEdgeInsets:UIEdgeInsetsMake(0, 0, 0,8)];
    [likeBtn setTitleEdgeInsets:UIEdgeInsetsMake(0, 8, 0, 0)];
    
    height = MDXFrom6(286.5);
    
    NSArray *tArr2 = @[@"图片",@"整屋",@"攻略",@"回答"];
    NSArray *dArr2 = @[self.data[@"image_num"],
                       self.data[@"house_num"],
                       self.data[@"strategy_num"],
                       self.data[@"answer_num"]];
    
    for (NSInteger i = 0 ; i < 4 ; i++) {
        UIView *backView = [[UIView alloc] initWithFrame:CGRectMake(KScreenWidth*i/4, height, KScreenWidth/4, MDXFrom6(80))];
        [backView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(selectType:)]];
        [backView setTag:i];
        [self.tmpScrollView addSubview:backView];
        
        [backView addSubview:[Tools creatLabel:CGRectMake(0, MDXFrom6(17), KScreenWidth/4, MDXFrom6(20)) font:[UIFont systemFontOfSize:14] color:[UIColor colorWithHexString:@"#333333"] alignment:(NSTextAlignmentCenter) title:tArr2[i]]];
        
        [backView addSubview:[Tools creatLabel:CGRectMake(0, MDXFrom6(44), KScreenWidth/4, MDXFrom6(25)) font:[UIFont boldSystemFontOfSize:18] color:[UIColor colorWithHexString:@"#000000"] alignment:(NSTextAlignmentCenter) title:dArr2[i]]];
        
        [backView addSubview:[Tools setLineView:CGRectMake(KScreenWidth/4-1.5, MDXFrom6(15), 1.5, MDXFrom6(50))]];
    }
    
    height += MDXFrom6(80);
    
    [self.tmpScrollView addSubview:[Tools setLineView:CGRectMake(0, height, KScreenWidth, 1.5)]];
    
    //服务信息
    if (self.data[@"service"]) {
       height = [self setUpService:height];
    }
    
    //项目
    if (self.data[@"project_list"] && [self.data[@"project_list"] count]>0) {
        height = [self setUpProject:height];
    }
    
    //整屋
    if (self.data[@"house_list"] && [self.data[@"house_list"] count]>0) {
        height = [self setUpAllHouse:height];
    }
    //图片
    if (self.data[@"img_list"] && [self.data[@"img_list"] count]>0) {
        height = [self setUpPhoto:height];
    }
    [self.tmpScrollView setContentSize:CGSizeMake(KScreenWidth, height)];
}

#pragma mark -- 服务 项目 整屋 图片
//服务
- (CGFloat)setUpService:(CGFloat)height{
    
    [self.tmpScrollView addSubview:[Tools creatLabel:CGRectMake(MDXFrom6(15), height, KScreenWidth - MDXFrom6(30), MDXFrom6(55)) font:[UIFont boldSystemFontOfSize:18] color:[UIColor blackColor] alignment:(NSTextAlignmentLeft) title:@"服务信息"]];
    
    height += MDXFrom6(55);
    
    UIView *serviceView = [[UIView alloc] initWithFrame:CGRectMake(MDXFrom6(15), height, KScreenWidth - MDXFrom6(30), MDXFrom6(200))];
    [serviceView.layer setCornerRadius:5];
    [serviceView.layer setBorderColor:[UIColor colorWithHexString:@"#efefef"].CGColor];
    [serviceView.layer setBorderWidth:1];
    [serviceView setClipsToBounds:YES];
    [self.tmpScrollView addSubview:serviceView];
    
    CGFloat serviceH = 0.0f;//服务view 的高度自适应
    
    NSArray *tArr3 = @[@"服务地区",@"服务范围",@"服务报价",@"服务介绍"];
    NSArray *dArr3 = @[self.data[@"service"][@"service_region"],
                       self.data[@"service"][@"service"],
                       [NSString stringWithFormat:@"%@-%@元/m²",self.data[@"service"][@"guestLow"],self.data[@"service"][@"guestHigh"]],
                       self.data[@"service"][@"personal"]];
    
    for (NSInteger i = 0 ; i < 4 ; i ++) {
        
        serviceH += MDXFrom6(16);
        
        [serviceView addSubview:[Tools creatLabel:CGRectMake(0, serviceH, MDXFrom6(90), MDXFrom6(20)) font:[UIFont systemFontOfSize:14] color:[UIColor colorWithHexString:@"#666666"] alignment:(NSTextAlignmentCenter) title:tArr3[i]]];
        
        CGFloat sDetailsH = [dArr3[i] boundingRectWithSize:CGSizeMake(MDXFrom6(230), 1000000) options:(NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading) attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:14]} context:nil].size.height +MDXFrom6(5);
        
        [serviceView addSubview:[Tools creatLabel:CGRectMake(MDXFrom6(90), serviceH, MDXFrom6(230), sDetailsH) font:[UIFont systemFontOfSize:14] color:[UIColor colorWithHexString:@"#000000"] alignment:(NSTextAlignmentLeft) title:dArr3[i]]];
        
        serviceH += sDetailsH+MDXFrom6(15);
        
    }
    
    [serviceView setFrame:CGRectMake(MDXFrom6(15), height, KScreenWidth - MDXFrom6(30), serviceH)];
    
    return height += serviceH;
}

//项目
- (CGFloat)setUpProject:(CGFloat)height{
    
    UIView *allHouse = [[UIView alloc] initWithFrame:CGRectMake(0, height, KScreenWidth, MDXFrom6(55))];
    [allHouse addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(showProject)]];
    [self.tmpScrollView addSubview:allHouse];
    
    [allHouse addSubview:[Tools creatLabel:CGRectMake(MDXFrom6(15), 0, KScreenWidth - MDXFrom6(30), MDXFrom6(55)) font:[UIFont boldSystemFontOfSize:18] color:[UIColor blackColor] alignment:(NSTextAlignmentLeft) title:@"项目详情"]];
    
    [allHouse addSubview:[Tools creatImage:CGRectMake(MDXFrom6(350), MDXFrom6(18.5), MDXFrom6(10.8), MDXFrom6(18)) image:@"jilu_rili_arrow"]];
    
    height += MDXFrom6(55);
    
    UIScrollView *allHouseScroll = [[UIScrollView alloc] initWithFrame:CGRectMake(0, height, KScreenWidth, MDXFrom6(205))];
    [allHouseScroll setShowsVerticalScrollIndicator:NO];
    [allHouseScroll setShowsHorizontalScrollIndicator:NO];
    [self.tmpScrollView addSubview:allHouseScroll];
    
    NSArray * arr = self.data[@"project_list"];
    
    [allHouseScroll setContentSize:CGSizeMake(MDXFrom6(15+225*arr.count), MDXFrom6(205))];
    
    
    for (NSInteger i = 0 ; i <  arr.count; i++) {
        
        NSDictionary *dic = arr[i];
        
        UIView *back = [[UIView alloc] initWithFrame:CGRectMake(MDXFrom6(15+225*i), 0, MDXFrom6(205), MDXFrom6(205))];
        [back addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(showProjectDetails:)]];
        [back setTag:i];
        [back.layer setCornerRadius:5];
        [back.layer setBorderColor:[UIColor colorWithHexString:@"#efefef"].CGColor];
        [back.layer setBorderWidth:1.5];
        [back setClipsToBounds:YES];
        [allHouseScroll addSubview:back];
        
        [back addSubview:[Tools creatImage:CGRectMake(0, 0, MDXFrom6(205), MDXFrom6(110)) url:dic[@"picture"] image:@"designer_xq_zw_case"]];
        
        [back addSubview:[Tools creatLabel:CGRectMake(MDXFrom6(10), MDXFrom6(125), MDXFrom6(65), MDXFrom6(20)) font:[UIFont systemFontOfSize:MDXFrom6(14)] color:[UIColor blackColor] alignment:(NSTextAlignmentLeft) title:dic[@"nameregister"]]];
        
        [back addSubview:[Tools creatLabel:CGRectMake(MDXFrom6(75), MDXFrom6(125), MDXFrom6(125), MDXFrom6(20)) font:[UIFont systemFontOfSize:MDXFrom6(10)] color:[UIColor colorWithHexString:@"#999999"] alignment:(NSTextAlignmentLeft) title:[NSString stringWithFormat:@"%@   %@m²",dic[@"room_hall"],dic[@"areaop"]]]];
        
        [back addSubview:[Tools creatImage:CGRectMake(MDXFrom6(10), MDXFrom6(170), MDXFrom6(17), MDXFrom6(10)) image:@"leader_xq_browse"]];
        
        [back addSubview:[Tools creatLabel:CGRectMake(MDXFrom6(30), MDXFrom6(169), MDXFrom6(40), MDXFrom6(12)) font:[UIFont systemFontOfSize:12] color:[UIColor colorWithHexString:@"#999999"] alignment:(NSTextAlignmentLeft) title:dic[@"visits"]]];
        
        [back addSubview:[Tools creatImage:CGRectMake(MDXFrom6(70), MDXFrom6(167.5), MDXFrom6(15), MDXFrom6(15)) image:@"leader_xq_like"]];
        
        [back addSubview:[Tools creatLabel:CGRectMake(MDXFrom6(88), MDXFrom6(169), MDXFrom6(40), MDXFrom6(12)) font:[UIFont systemFontOfSize:MDXFrom6(12)] color:[UIColor colorWithHexString:@"#999999"] alignment:(NSTextAlignmentLeft) title:dic[@"zan"]]];
        
        UIButton *checkDetails = [Tools creatButton:CGRectMake(MDXFrom6(125), MDXFrom6(162.5), MDXFrom6(70), MDXFrom6(25)) font:[UIFont systemFontOfSize:12] color:[UIColor colorWithHexString:@"#34bab8"] title:@"查看案例" image:@""];
        [checkDetails setBackgroundColor:[UIColor colorWithHexString:@"#eaf8f8"]];
        [checkDetails.layer setBorderColor:[UIColor colorWithHexString:@"#34bab8"].CGColor];
        [checkDetails.layer setBorderWidth:1];
        [checkDetails.layer setCornerRadius:MDXFrom6(2.5)];
        [checkDetails addTarget:self action:@selector(showProjectDetails:) forControlEvents:(UIControlEventTouchUpInside)];
        [checkDetails setTag:i];
        [back addSubview:checkDetails];
        
    }
    
    
    height += MDXFrom6(205);
    
    return height;
}

//整屋
- (CGFloat)setUpAllHouse:(CGFloat)height{
    
    UIView *allHouse = [[UIView alloc] initWithFrame:CGRectMake(0, height, KScreenWidth, MDXFrom6(55))];
    [allHouse addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(showAllHouse)]];
    [self.tmpScrollView addSubview:allHouse];
    
    [allHouse addSubview:[Tools creatLabel:CGRectMake(MDXFrom6(15), 0, KScreenWidth - MDXFrom6(30), MDXFrom6(55)) font:[UIFont boldSystemFontOfSize:18] color:[UIColor blackColor] alignment:(NSTextAlignmentLeft) title:@"整屋"]];
    
    [allHouse addSubview:[Tools creatImage:CGRectMake(MDXFrom6(350), MDXFrom6(18.5), MDXFrom6(10.8), MDXFrom6(18)) image:@"jilu_rili_arrow"]];
    
    height += MDXFrom6(55);
    
    UIScrollView *allHouseScroll = [[UIScrollView alloc] initWithFrame:CGRectMake(0, height, KScreenWidth, MDXFrom6(205))];
    [allHouseScroll setShowsVerticalScrollIndicator:NO];
    [allHouseScroll setShowsHorizontalScrollIndicator:NO];
    [self.tmpScrollView addSubview:allHouseScroll];
    
    NSArray *arr = self.data[@"house_list"];
    
    [allHouseScroll setContentSize:CGSizeMake(MDXFrom6(15+225*arr.count), MDXFrom6(205))];
    
    for (NSInteger i = 0 ; i <  arr.count; i++) {
        
        NSDictionary *dic = arr[i];
        
        UIView *back = [[UIView alloc] initWithFrame:CGRectMake(MDXFrom6(15+225*i), 0, MDXFrom6(205), MDXFrom6(205))];
        [back addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(selectAllHouse:)]];
        [back setTag:i];
        [back.layer setCornerRadius:5];
        [back.layer setBorderColor:[UIColor colorWithHexString:@"#efefef"].CGColor];
        [back.layer setBorderWidth:1.5];
        [back setClipsToBounds:YES];
        [allHouseScroll addSubview:back];
        
        [back addSubview:[Tools creatImage:CGRectMake(0, 0, MDXFrom6(205), MDXFrom6(110)) url:dic[@"cover"] image:@"designer_xq_zw_case"]];
        
        [back addSubview:[Tools creatLabel:CGRectMake(MDXFrom6(10), MDXFrom6(120), MDXFrom6(185), MDXFrom6(40)) font:[UIFont systemFontOfSize:MDXFrom6(15)] color:[UIColor blackColor] alignment:(NSTextAlignmentLeft) title:dic[@"title"]]];
        
        [back addSubview:[Tools creatLabel:CGRectMake(MDXFrom6(10), MDXFrom6(170), MDXFrom6(185), MDXFrom6(20)) font:[UIFont systemFontOfSize:MDXFrom6(12)] color:[UIColor colorWithHexString:@"#999999"] alignment:(NSTextAlignmentLeft) title:[NSString stringWithFormat:@"%@ %@平米",dic[@"door"],dic[@"proportion"]]]];
    }
    
    
    height += MDXFrom6(205);
    
    return height;
}

//图片
- (CGFloat)setUpPhoto:(CGFloat)height{
    
    //图片
    UIView *photo = [[UIView alloc] initWithFrame:CGRectMake(0, height, KScreenWidth, MDXFrom6(55))];
    [photo addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(showPhoto)]];
    [self.tmpScrollView addSubview:photo];
    
    [photo addSubview:[Tools creatLabel:CGRectMake(MDXFrom6(15), 0, KScreenWidth - MDXFrom6(30), MDXFrom6(55)) font:[UIFont boldSystemFontOfSize:18] color:[UIColor blackColor] alignment:(NSTextAlignmentLeft) title:@"图片"]];
    
    [photo addSubview:[Tools creatImage:CGRectMake(MDXFrom6(350), MDXFrom6(18.5), MDXFrom6(10.8), MDXFrom6(18)) image:@"jilu_rili_arrow"]];
    
    height += MDXFrom6(55);
    
    NSArray *arr = self.data[@"img_list"];
    
    for (NSInteger i = 0; i < arr.count; i++) {
        
        UIImageView *imageview = [Tools creatImage:CGRectMake(MDXFrom6(15+120*(i%3)), MDXFrom6(120*(i/3))+height, MDXFrom6(105), MDXFrom6(105)) url:arr[i][@"cover"] image:@"designer_xq_img_case"];
        [imageview.layer setCornerRadius:5];
        [imageview addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(showImageDetails:)]];
        [imageview setTag:i];
        [imageview setClipsToBounds:YES];
        [self.tmpScrollView addSubview:imageview];
        
    }
    
    return height += ceil(arr.count/3.0)*MDXFrom6(120);
}


#pragma mark -- 点击事件
- (void)back{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)share{
    
    
}

//关注
- (void)like:(UIButton *)sender{
    LOGIN
    if (!sender.selected) {
        [self attention:[NSString stringWithFormat:@"%@/follow/insert_follow",KURL] btn:sender];
    }
    else{
        [self attention:[NSString stringWithFormat:@"%@/Follow/cancel_follow",KURL] btn:sender];
    }
    
}

- (void)attention:(NSString *)path btn:(UIButton *)sender{
    
    NSDictionary *header = @{@"token":UTOKEN};
    NSDictionary *dic = @{@"user_id":self.data[@"member_info"][@"id"]};
    
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    __weak typeof(self) weakSelf = self;
    
    [HttpRequest POSTWithHeader:header url:path parameters:dic success:^(id  _Nullable responseObject) {
        
        [MBProgressHUD hideHUDForView:weakSelf.view animated:YES];
        
        [ViewHelps showHUDWithText:responseObject[@"message"]];
        if ([responseObject[@"code"] integerValue]==200) {
            sender.selected = !sender.selected;
        }
        
    } failure:^(NSError * _Nullable error) {
        
        [MBProgressHUD hideHUDForView:weakSelf.view animated:YES];
        [RequestSever showMsgWithError:error];
    }];
    
    
}
//选择图片 整屋 评价 回答
- (void)selectType:(UITapGestureRecognizer *)sender{
    
    switch (sender.view.tag) {
        case 0:
        {
            PhotoListViewController *vc = [[PhotoListViewController alloc] init];
            vc.user_id = self.data[@"member_info"][@"id"];
            [self.navigationController pushViewController:vc animated:YES];
        }
            break;
        case 1:
        {
            HouseListViewController *vc = [[HouseListViewController alloc] init];
            vc.user_id = self.data[@"member_info"][@"id"];
            [self.navigationController pushViewController:vc animated:YES];
        }
            break;
        case 2:
        {
            StrategyListViewController *vc = [[StrategyListViewController alloc] init];
            vc.user_id = self.data[@"member_info"][@"id"];
            [self.navigationController pushViewController:vc animated:YES];
        }
            break;
        case 3:
        {
            AnswerListViewController *vc = [[AnswerListViewController alloc] init];
            vc.user_id =self.data[@"member_info"][@"id"];
            [self.navigationController pushViewController:vc animated:YES];
        }
            break;
            
        default:
            break;
    }
}

//展示项目详情
- (void)showProject{
    
    ProjectListVC *controller = [[ProjectListVC alloc] init];
    controller.user_id = self.data[@"member_info"][@"id"];
    [self.navigationController pushViewController:controller animated:YES];
    
}

- (void)showProjectDetails:(id)sender{
    NSArray * arr = self.data[@"project_list"];
    ProjectDetailsVC *controll = [[ProjectDetailsVC alloc] init];
    if ([sender isKindOfClass:[UIButton class]]) {
        controll.projectID = arr[((UIButton *)sender).tag][@"id"];
    }
    else{
        controll.projectID = arr[((UITapGestureRecognizer *)sender).view.tag][@"id"];
    }
    [self.navigationController pushViewController:controll animated:YES];
}

//展示整屋的
- (void)showAllHouse{
    
    HouseListViewController *vc = [[HouseListViewController alloc] init];
    vc.user_id = self.data[@"member_info"][@"id"];
    [self.navigationController pushViewController:vc animated:YES];
}

//整屋案例
- (void)selectAllHouse:(UITapGestureRecognizer *)sender{
    NSArray *arr = self.data[@"house_list"];
    HouseDetailsViewController *vc = [[HouseDetailsViewController alloc] init];
    vc.house_id = arr[sender.view.tag][@"id"];
    [self.navigationController pushViewController:vc animated:YES];
    
}
//展示图片列表
- (void)showPhoto{
    
    PhotoListViewController *vc = [[PhotoListViewController alloc] init];
    vc.user_id = self.data[@"member_info"][@"id"];
    [self.navigationController pushViewController:vc animated:YES];
    
}
//展示图片详情
- (void)showImageDetails:(UITapGestureRecognizer *)sender{
    NSArray *arr = self.data[@"img_list"];
    PhotoDetailsViewController *vc = [[PhotoDetailsViewController alloc] init];
    vc.photo_id = arr[sender.view.tag][@"id"];
    [self.navigationController pushViewController:vc animated:YES];
}



#pragma mark -- delegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    
    if (scrollView == self.tmpScrollView) {
        [self.navView setBackgroundColor:MDRGBA(255, 255, 255, scrollView.contentOffset.y/286.5)];
        
        if (scrollView.contentOffset.y > 265) {
            [shareBtn setImage:[UIImage imageNamed:@"share"] forState:(UIControlStateNormal)];
            [backBtn setImage:[UIImage imageNamed:@"ss_back"] forState:(UIControlStateNormal)];
        }
        else{
            
            [shareBtn setImage:[UIImage imageNamed:@"designer_xq_zf"] forState:(UIControlStateNormal)];
            [backBtn setImage:[UIImage imageNamed:@"my_back"] forState:(UIControlStateNormal)];
        }
        
        
        CGPoint point = scrollView.contentOffset;
        
        if (point.y < 0) {
            CGRect rect = headerBackImage.frame;
            rect.origin.y =point.y ;
            rect.size.height =MDXFrom6(286.5) - point.y;
            headerBackImage.frame = rect;
        }
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
