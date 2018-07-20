//
//  MyViewController.m
//  anjuyi
//
//  Created by 李 on 2018/5/29.
//  Copyright © 2018年 lsy. All rights reserved.
//

#import "MyViewController.h"
#import "BaseNaviViewController.h"
#import "PhotoSelectController.h"

#import "SettingViewController.h"
#import "PersonalViewController.h"//个人主页

#import "MyPhotoViewController.h"//我的图片
#import "MyArticleViewController.h"//我的文章
#import "MyColletViewController.h"//我的收藏
#import "DraftBoxViewController.h"//草稿箱

#import "MyAnswerViewController.h"//我的回答
#import "MyFriendViewController.h"//关注的好友
#import "MyTopicViewController.h"//关注的话题
#import "CollectShopViewController.h"//收藏商品

#import "CustomerServiceViewController.h"//在线客服
#import "MyOrderViewController.h"//我的订单
#import "MyCouponsViewController.h"//我的优惠券
#import "MyWalletViewController.h"//我的钱包

#import "IntegralMallViewController.h"//积分商城
#import "CommentViewController.h"//评论
#import "ContractViewController.h"//合同管理
#import "DistributionViewController.h"//分销统计

#import "CraftsmenViewController.h"//工匠汇
#import "OrderCenterViewController.h"//接单中心


@interface MyViewController ()<UIScrollViewDelegate,PhotoSelectControllerDelegate>
{
    NSString *_image_url;
}

@property (nonatomic,strong)UIView                    * navView;
@property (nonatomic,strong)UIScrollView              * tmpScrollView;
@property (nonatomic,strong)UIImageView               * headerImage;
@property (nonatomic,strong)NSMutableDictionary       * data;

@end

@implementation MyViewController

- (void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:animated];
    UIImage *tmpImage = [UIImage imageWithColor:[UIColor colorWithHexString:@"#7dd3d3"]];
    
    [self.navigationController.navigationBar setBackgroundImage:tmpImage forBarMetrics:UIBarMetricsDefault];
    
    [self getPersonInfo];
}

- (void)viewWillDisappear:(BOOL)animated{
    
    [super viewWillDisappear:animated];
    UIImage *tmpImage = [UIImage imageWithColor:[UIColor whiteColor]];
    
    [self.navigationController.navigationBar setBackgroundImage:tmpImage forBarMetrics:UIBarMetricsDefault];
}


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self.view setBackgroundColor:[UIColor colorWithHexString:@"#7dd3d3"]];
    
    [self.view addSubview:self.tmpScrollView];

    [self setNavigationDoubleRightBarButtonWithImageNamed:@"my_notice" imageNamed2:@"my_set"];
    
}
#pragma mark -- 获取个人信息
- (void)getPersonInfo{
    
    NSString *path = [NSString stringWithFormat:@"%@/Member/get_member_info",KURL];
    
    NSDictionary *header = @{@"token":UTOKEN};
    
    __weak typeof(self) weakSelf = self;
    
    [HttpRequest POSTWithHeader:header url:path parameters:nil success:^(id  _Nullable responseObject) {
        
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        
        if ([responseObject[@"code"] integerValue] == 200) {
            if ([responseObject[@"datas"] isKindOfClass:[NSDictionary class]]) {
                
                weakSelf.data = [NSMutableDictionary dictionaryWithDictionary:responseObject[@"datas"]];
             
                [weakSelf setUpUi];
            }
            
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
- (UIScrollView *)tmpScrollView{
    //designer_xq_banner
    if (!_tmpScrollView) {
        _tmpScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, -KTopHeight, KScreenWidth, KScreenHeight-KTabBarHeight)];
        if (@available(iOS 11.0, *)) {
            [_tmpScrollView setContentInsetAdjustmentBehavior:(UIScrollViewContentInsetAdjustmentNever)];
        }
        [_tmpScrollView setDelegate:self];
        [_tmpScrollView setBackgroundColor:MDRGBA(0, 0, 0, 0)];

        [_tmpScrollView setContentSize:CGSizeMake(KScreenWidth, 2*KScreenHeight)];
        [_tmpScrollView setShowsVerticalScrollIndicator:NO];
        [_tmpScrollView setShowsHorizontalScrollIndicator:NO];
    }
    return _tmpScrollView;
}

- (void)setUpUi{
    
    [self.tmpScrollView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    
    CGFloat height = KTopHeight+MDXFrom6(20);
    
    self.headerImage = [Tools creatImage:CGRectMake(MDXFrom6(15), height , MDXFrom6(60), MDXFrom6(60)) url:self.data?self.data[@"head"]:@"" image:@""];
    [self.headerImage.layer setCornerRadius:MDXFrom6(30)];
    [self.headerImage addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(chooseImageFromIphone)]];
    [self.tmpScrollView addSubview:self.headerImage];
    
    [self.tmpScrollView addSubview:[Tools creatLabel:CGRectMake(MDXFrom6(85), height, MDXFrom6(200), MDXFrom6(30)) font:[UIFont systemFontOfSize:18] color:[UIColor whiteColor] alignment:(NSTextAlignmentLeft) title:self.data?self.data[@"nickname"]:@""]];
    
    
    UIButton * showPerson =[Tools creatButton:CGRectMake(MDXFrom6(80), height+MDXFrom6(30), MDXFrom6(150), MDXFrom6(30)) font:[UIFont systemFontOfSize:12] color:[UIColor whiteColor] title:@"查看个人主页" image:@"my_rig_arrow"];
    [showPerson addTarget:self action:@selector(showPerson) forControlEvents:(UIControlEventTouchUpInside)];
     [self.tmpScrollView addSubview:showPerson];
    
    [showPerson setTitleEdgeInsets:UIEdgeInsetsMake(0, 0, 0, MDXFrom6(150)-80)];
    [showPerson setImageEdgeInsets:UIEdgeInsetsMake(0, 85, 0, MDXFrom6(150)-85 -12)];
    
    height += MDXFrom6(60+35);
    
    [self.tmpScrollView addSubview:[Tools creatImage:CGRectMake(0, height, KScreenWidth, MDXFrom6(25)) image:@"my_center_yj"]];

    height += MDXFrom6(25);

    height = [self setUpButton:height];
    
    height = [self setUpLineService:height];
    
    [self.tmpScrollView setContentSize:CGSizeMake(KScreenWidth, height)];
    
}



- (CGFloat)setUpButton:(CGFloat)height{
    
    NSArray *iArr = @[@"my_img",@"my_house",@"collect",@"my_draft",
                      @"my_interlocution",@"my_friend",@"my_topic",@"my_shop_collect",
                      @"my_line_cus",@"my_order",@"my_coupon",@"my_wallt",
                      @"my_acc",@"my_comment",@"my_pact",@"my_distribution"];
    
    NSArray *tArr = @[@"我的图片",@"我的文章",@"我的收藏",@"草稿箱",
                      @"我的回答",@"关注的好友",@"关注的话题",@"商品收藏",
                      @"在线客服",@"我的订单",@"我的优惠券",@"我的钱包",
                      @"积分商城",@"我的评论",@"合同管理",@"分销统计"];
    
    for (NSInteger i = 0 ; i < 16 ; i ++) {
        UIView *backView = [[UIView alloc] initWithFrame:CGRectMake(KScreenWidth*(i%4)/4,height+ MDXFrom6(80*ceil(i/4)), KScreenWidth/4, MDXFrom6(80))];
        [backView setBackgroundColor:[UIColor whiteColor]];
        [backView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(selectProject:)]];
        [backView setTag:i];
        [self.tmpScrollView addSubview:backView];
        
        [backView addSubview:[Tools creatImage:CGRectMake(MDXFrom6(29.375), MDXFrom6(10), MDXFrom6(35), MDXFrom6(30)) image:iArr[i]]];
        
        [backView addSubview:[Tools creatLabel:CGRectMake(0, MDXFrom6(50), KScreenWidth/4, MDXFrom6(20)) font:[UIFont systemFontOfSize:12] color:[UIColor colorWithHexString:@"#333333"] alignment:(NSTextAlignmentCenter) title:tArr[i]]];
        
    }
    
    [self.tmpScrollView addSubview:[Tools setLineView:CGRectMake(0, height + MDXFrom6(80*4), KScreenWidth, MDXFrom6(10))]];
    
    return height + MDXFrom6(80*4)+MDXFrom6(10);
}

- (CGFloat)setUpLineService:(CGFloat)height{
    
    NSArray *iArr = @[@"my_rz",@"my_share",@"my_buy",@"my_taking"];
    
    NSArray *tArr = @[@"设计/工长入驻",@"推荐给朋友",@"代购下单",@"接单中心"];
    
    for (NSInteger i = 0 ; i < 4 ; i ++) {
        UIView *backView = [[UIView alloc] initWithFrame:CGRectMake(0,height+ MDXFrom6(55*i), KScreenWidth, MDXFrom6(55))];
        [backView setBackgroundColor:[UIColor whiteColor]];
        [backView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(selectLineProject:)]];
        [backView setTag:i];
        [self.tmpScrollView addSubview:backView];
        
        [backView addSubview:[Tools creatImage:CGRectMake(MDXFrom6(20), MDXFrom6(15), MDXFrom6(25), MDXFrom6(25)) image:iArr[i]]];
        
        [backView addSubview:[Tools creatLabel:CGRectMake(MDXFrom6(55), 0, MDXFrom6(280), MDXFrom6(55)) font:[UIFont systemFontOfSize:12] color:[UIColor colorWithHexString:@"#555555"] alignment:(NSTextAlignmentLeft) title:tArr[i]]];
        
        [backView addSubview:[Tools creatImage:CGRectMake(KScreenWidth - MDXFrom6(26), MDXFrom6(21.5), MDXFrom6(6), MDXFrom6(12)) image:@"my_enter"]];
        
        [backView addSubview:[Tools setLineView:CGRectMake(MDXFrom6(15), MDXFrom6(54), KScreenWidth-MDXFrom6(30), MDXFrom6(1))]];
    }
    
    UIView *writView = [[UIView alloc] initWithFrame:CGRectMake(0, height + MDXFrom6(55*4), KScreenWidth, KScreenHeight)];
    [writView setBackgroundColor:[UIColor whiteColor]];
    [self.tmpScrollView addSubview:writView];
    
    return height + MDXFrom6(55*4)+MDXFrom6(10);
}

#pragma mark --  点击事件

- (void)doubleRightButtonTouchUpInside:(UIButton *)sender{
    [self setNavWrite];
    
    if (sender.tag == 1) {
        
    }
    else{
        
        SettingViewController *controller = [[SettingViewController alloc] init];
        [self.navigationController pushViewController:controller animated:YES];
    }
    
}

//查看个人主页
- (void)showPerson{
    [self setNavWrite];
    PersonalViewController *controller = [[PersonalViewController alloc] init];
    [self.navigationController pushViewController:controller animated:YES];
}

//选择项目
- (void)selectProject:(UITapGestureRecognizer *)sender{
    [self setNavWrite];
    switch (sender.view.tag) {

        case 0:
        {
            MyPhotoViewController *controller = [[MyPhotoViewController alloc] init];
            [self.navigationController pushViewController:controller animated:YES];
            
        }
            break;
        case 1:
        {
            MyArticleViewController *controller = [[MyArticleViewController alloc] init];
            [self.navigationController pushViewController:controller animated:YES];
            
        }
            break;
        case 2:
        {
            MyColletViewController *controller = [[MyColletViewController alloc] init];
            [self.navigationController pushViewController:controller animated:YES];
            
        }
            break;
        case 3:
        {
            DraftBoxViewController *controller = [[DraftBoxViewController alloc] init];
            [self.navigationController pushViewController:controller animated:YES];
            
        }
            break;
        case 4:
        {
            MyAnswerViewController *controller = [[MyAnswerViewController alloc] init];
            [self.navigationController pushViewController:controller animated:YES];
            
        }
            break;
        case 5:
        {
            MyFriendViewController *controller = [[MyFriendViewController alloc] init];
            [self.navigationController pushViewController:controller animated:YES];
            
        }
            break;
        case 6:
        {
            MyTopicViewController *controller = [[MyTopicViewController alloc] init];
            [self.navigationController pushViewController:controller animated:YES];
            
        }
            break;
        case 7:
        {
            CollectShopViewController *controller = [[CollectShopViewController alloc] init];
            [self.navigationController pushViewController:controller animated:YES];
            
        }
            break;
        case 8:
        {
            CustomerServiceViewController *controller = [[CustomerServiceViewController alloc] init];
            [self.navigationController pushViewController:controller animated:YES];
            
        }
            break;
        case 9:
        {
            MyOrderViewController *controller = [[MyOrderViewController alloc] init];
            [self.navigationController pushViewController:controller animated:YES];
            
        }
            break;
        case 10:
        {
            MyCouponsViewController *controller = [[MyCouponsViewController alloc] init];
            [self.navigationController pushViewController:controller animated:YES];
            
        }
            break;
        case 11:
        {
            MyWalletViewController *controller = [[MyWalletViewController alloc] init];
            [self.navigationController pushViewController:controller animated:YES];
            
        }
            break;
        case 12:
        {
            IntegralMallViewController *controller = [[IntegralMallViewController alloc] init];
            [self.navigationController pushViewController:controller animated:YES];
            
        }
            break;
        case 13:
        {
            CommentViewController *controller = [[CommentViewController alloc] init];
            [self.navigationController pushViewController:controller animated:YES];
            
        }
            break;
        case 14:
        {
            ContractViewController *controller = [[ContractViewController alloc] init];
            [self.navigationController pushViewController:controller animated:YES];
            
        }
            break;
        case 15:
        {
            DistributionViewController *controller = [[DistributionViewController alloc] init];
            [self.navigationController pushViewController:controller animated:YES];
            
        }
            break;
            
        default:
            break;
    }
}

- (void)selectLineProject:(UITapGestureRecognizer *)sender{
    
    switch (sender.view.tag) {
        case 0:
        {
            CraftsmenViewController *controller = [[CraftsmenViewController alloc] init];
            [self.navigationController pushViewController:controller animated:YES];
        }
            break;
        case 3:
        {
            OrderCenterViewController *controller = [[OrderCenterViewController alloc] init];
            [self.navigationController pushViewController:controller animated:YES];
        }
            break;
            
        default:
            break;
    }
}


#pragma mark -- 选择照片
- (void)chooseImageFromIphone{
    
    // 判断有没有访问相册的权限
    if(![UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypePhotoLibrary]){
        
        NSLog(@"没有访问相册的权限");
        return;
        
    }
    
    PhotoSelectController *vc = [[PhotoSelectController alloc] init];
    [vc setDelegate:self];
    [vc setIsClip:NO];
    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:vc];
    [self presentViewController:nav animated:YES completion:nil];
    
}

- (void)selectImage:(UIImage *)image{
    
    [self upLoadImage:image];
}


- (void)upLoadImage:(UIImage *)image{
    
    NSString *path = [NSString stringWithFormat:@"%@/Upload/upload",KURL];
    
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    __weak typeof(self) weakSelf = self;
    
    [HttpRequest uploadFileWithInferface:path parameters:nil fileData:UIImageJPEGRepresentation(image, 0.7) serverName:@"file" saveName:@"232323.png" mimeType:(MCPNGImageFileType) progress:^(float progress) {
        
    } success:^(id  _Nullable responseObject) {
        
        [MBProgressHUD hideHUDForView:weakSelf.view animated:YES];
        
        if ([responseObject[@"code"] integerValue] == 200) {
            
            
            if ([responseObject[@"datas"][@"route"] integerValue]==200) {
                
                self->_image_url =responseObject[@"datas"][@"fullPath"];
                
                [weakSelf editPersonHeader];
            }
        }
        else{
            
            [ViewHelps showHUDWithText:responseObject[@"message"]];
        }
    } failure:^(NSError * _Nullable error) {
        
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        [RequestSever showMsgWithError:error];
    }];
    
}

- (void)editPersonHeader{
    
    
    NSString *path = [NSString stringWithFormat:@"%@/Member/update_head",KURL];
    
    NSDictionary *header = @{@"token":UTOKEN};
    NSDictionary *paramet = @{@"head":_image_url};
    
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    __weak typeof(self) weakSelf = self;
    [HttpRequest POSTWithHeader:header url:path parameters:paramet success:^(id  _Nullable responseObject) {
        
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        
        if ([responseObject[@"code"] integerValue] == 200) {
            
            [weakSelf.headerImage sd_setImageWithURL:[NSURL URLWithString:self->_image_url]];
        }
        else{
            
            [ViewHelps showHUDWithText:responseObject[@"message"]];
        }
        
        
    } failure:^(NSError * _Nullable error) {
        
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        [RequestSever showMsgWithError:error];
    }];
    
}


- (void)setNavWrite{
    
    UIImage *tmpImage = [UIImage imageWithColor:[UIColor whiteColor]];
    
    [self.navigationController.navigationBar setBackgroundImage:tmpImage forBarMetrics:UIBarMetricsDefault];
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
