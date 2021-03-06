//
//  MyPushHouseDetailsViewController.m
//  anjuyi1
//
//  Created by apple on 2018/7/25.
//  Copyright © 2018年 lsy. All rights reserved.
//

#import "MyPushHouseDetailsViewController.h"
#import "HouseCommentView.h"
#import <IQKeyboardManager.h>
#import "SpaceImageTableViewCell.h"
#import "HouseCommentTableViewCell.h"
#import "CommentModel.h"
#import "QuestionTableViewCell.h"
#import "FunctionBarView.h"
#import "HouseInfoViewController.h"
#import "BaseNaviViewController.h"
#import "CommentDetalisViewController.h"
#import "PersonalViewController.h"

@interface MyPushHouseDetailsViewController ()<UITableViewDelegate,UITableViewDataSource>
{
    UIButton *backBtn;
    UIButton *shareBtn;
    UIImageView *headerBackImage;
}

@property (nonatomic,strong)UIView               *  navView;
@property (nonatomic,strong)HouseCommentView     *  commentV;
@property (nonatomic,strong)UIView               *  infoView;
@property (nonatomic,strong)UIView               *  footView;
@property (nonatomic,strong)FunctionBarView      *  functionBar;

@property (nonatomic,strong)NSMutableDictionary  *  houseInfo;
@property (nonatomic,strong)UITableView          *  tmpTableView;
@property (nonatomic,strong)NSMutableArray       *  dataArr;//内容数组
@property (nonatomic,strong)NSMutableArray       *  titleArr;//section 的数组
@property (nonatomic,strong)NSMutableArray       *  commentArr;//评论数组
@property (nonatomic,strong)NSMutableArray       *  questionArr;//问题数组
@end

@implementation MyPushHouseDetailsViewController

- (void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:animated];
    [IQKeyboardManager sharedManager].enableAutoToolbar = NO;
    [IQKeyboardManager sharedManager].shouldResignOnTouchOutside = YES;
    [self baseForDefaultLeftNavButton];
    [self.navigationController setNavigationBarHidden:YES animated:YES];

    if ([self.houseInfo allKeys].count != 0) {
        [self getHouseInfo];
    }
}

- (void)viewWillDisappear:(BOOL)animated{
    
    [super viewWillDisappear:animated];
    [IQKeyboardManager sharedManager].enableAutoToolbar = YES;
    [self.navigationController setNavigationBarHidden:NO animated:YES];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.dataArr = [NSMutableArray array];
    self.titleArr = [NSMutableArray array];
    self.commentArr = [NSMutableArray array];
    self.questionArr = [NSMutableArray array];
    
    [self.view addSubview:self.tmpTableView];
    [self getHouseInfo];
    
    [self.view addSubview:self.navView];
//    [self.view addSubview:self.functionBar];
    [self.view addSubview:self.commentV];
}

- (void)getHouseInfo{
    
    NSString *path = [NSString stringWithFormat:@"%@/WholeHouseInfo/detail",KURL];
    
    NSDictionary *header = @{@"token":UTOKEN};
    NSDictionary *parameter = @{@"house_id":self.house_id};
    
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    __weak typeof(self) weakSelf = self;
    
    [HttpRequest POSTWithHeader:header url:path parameters:parameter success:^(id  _Nullable responseObject) {
        
        [MBProgressHUD hideHUDForView:weakSelf.view animated:YES];
        
        if ([responseObject[@"code"] integerValue] == 200) {
            
            weakSelf.houseInfo = [NSMutableDictionary dictionaryWithDictionary:responseObject[@"datas"]];
            
            [weakSelf.titleArr removeAllObjects];
            [weakSelf.dataArr removeAllObjects];
            [weakSelf.questionArr removeAllObjects];
            [weakSelf.commentArr removeAllObjects];
            
            for (NSDictionary *dic in weakSelf.houseInfo[@"space_image"]) {
                NSMutableArray *arr = [NSMutableArray array];
                for (NSDictionary *dict in dic[@"image"]) {
                    [arr addObject:dict];
                }
                [weakSelf.titleArr addObject:dic[@"name"]];
                [weakSelf.dataArr addObject:arr];
            }
            
            for (NSDictionary *dic in weakSelf.houseInfo[@"QA"]) {
                [weakSelf.questionArr addObject:dic];
            }
            [weakSelf.titleArr addObject:@"问答"];
        
            for (NSDictionary *dic in weakSelf.houseInfo[@"evaluate_list"]) {
                CommentModel *model = [[CommentModel alloc] init];
                model.commit_id = dic[@"id"];
                model.member_info = @{@"nick_name":dic[@"name"],@"head":dic[@"head"]};
                model.content = dic[@"content"];
                model.create_time = dic[@"create_time"];
                [weakSelf.commentArr addObject:model];
            }
            [weakSelf.titleArr addObject:@"评论"];
            
            [weakSelf.tmpTableView reloadData];
            [weakSelf createHouseInfo];
            [weakSelf createFootView];
            
//            [weakSelf createFunctionBar];
        
        }
        else{
            
            [ViewHelps showHUDWithText:responseObject[@"message"]];
        }
        
        
    } failure:^(NSError * _Nullable error) {
        
        [MBProgressHUD hideHUDForView:weakSelf.view animated:YES];
        [RequestSever showMsgWithError:error];
    }];

    
}

#pragma mark --  UI
- (UIView *)navView{
    
    if (!_navView) {
        _navView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, KScreenWidth, KTopHeight)];
        
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


- (HouseCommentView *)commentV{
    
    if (!_commentV) {
        _commentV = [[HouseCommentView alloc] initWithFrame:CGRectMake(0, 0, KScreenWidth, KScreenHeight)];
        [_commentV setHouse_id:self.house_id];
        WKSELF;
        [_commentV setSelectCommentToshow:^(UIViewController *vc) {

            [weakSelf.navigationController pushViewController:vc animated:YES];
        }];
        //展示用户详情
        [_commentV setShowReviewerDetail:^(BaseViewController *vc) {
            [weakSelf.navigationController pushViewController:vc animated:YES];
        }];
    }
    return _commentV;
}

- (UIView *)infoView{
    
    if (!_infoView) {
        _infoView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, KScreenWidth, 1)];
        [_infoView setBackgroundColor:[UIColor whiteColor]];
    }
    return _infoView;
}
- (UIView *)footView{
    
    if (!_footView) {
        _footView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, KScreenWidth, 1)];
        [_footView setBackgroundColor:[UIColor whiteColor]];
    }
    return _footView;
}

- (UIView *)functionBar{
    
    if (!_functionBar) {
        _functionBar = [[FunctionBarView alloc] initWithFrame:CGRectMake(0, KScreenHeight - 50-KPlaceHeight, KScreenWidth, 50)];
        [_functionBar addSubview:[Tools setLineView:CGRectMake(0, 0, KScreenWidth, 2)]];
    }
    return _functionBar;
}


- (void)createHouseInfo{
    
    [self.infoView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    
    CGFloat height = 0;
   
    headerBackImage  = [Tools creatImage:CGRectMake(0, 0, KScreenWidth,  572*KScreenWidth/750.0)  url:self.houseInfo[@"house_info"][@"cover"] image:@""];
    [self.infoView addSubview:headerBackImage];
    
    height += 572*KScreenWidth/750.0 + 20;
    
    //    [self.infoView addSubview:[Tools creatLabel:CGRectMake(15, height, KScreenWidth - 30, 50) font:[UIFont systemFontOfSize:19] color:[UIColor blackColor] alignment:(NSTextAlignmentLeft) title:self.houseInfo[@"house_info"][@"title"]]];
    
    height = [self creatHeaderViewTitle:height];
    
    UIButton *time = [Tools creatButton:CGRectMake(15, height, KScreenWidth - 30, 12) font:[UIFont systemFontOfSize:12] color:[UIColor colorWithHexString:@"#666666"] title:[NSString stringWithFormat:@"   发布于 %@",self.houseInfo[@"house_info"][@"create_time"]] image:@"xq_time"];
    [time setContentHorizontalAlignment:(UIControlContentHorizontalAlignmentRight)];
    [self.infoView addSubview:time];
    
    height += 12 + 10;
    
    [self.infoView addSubview:[Tools setLineView:CGRectMake(15, height, KScreenWidth - 30, 1)]];
    
    
    UIImageView *header = [Tools creatImage:CGRectMake(20, height+20, 43, 43) url:self.houseInfo[@"house_own_info"][@"head"] image:@""];
    [header.layer setCornerRadius:21.5];
    [self.infoView addSubview:header];
    
    NSString *name = self.houseInfo[@"house_own_info"][@"nickname"];
    CGFloat nameW = KHeight(name, 10000, 20, 18).size.width + 20;
    
    [self.infoView addSubview:[Tools creatLabel:CGRectMake(65,  height+20 ,nameW , 25) font:[UIFont systemFontOfSize:18] color:[UIColor blackColor] alignment:(NSTextAlignmentLeft) title:name]];
    
    UILabel *typeLabel = [Tools creatLabel:CGRectMake(65+ nameW, height+22.5 , 50, 20) font:[UIFont systemFontOfSize:12] color:[UIColor colorWithHexString:@"#fffefe"] alignment:(NSTextAlignmentCenter) title:self.houseInfo[@"house_own_info"][@"level"]];
    [typeLabel.layer setCornerRadius:5];
    [typeLabel setBackgroundColor:[UIColor colorWithHexString:@"#5cc6c6"]];
    [self.infoView addSubview:typeLabel];
    
    [self.infoView addSubview:[Tools creatLabel:CGRectMake(65,height+ 45 ,KScreenWidth - 75 , 20) font:[UIFont systemFontOfSize:12] color:[UIColor colorWithHexString:@"#999999"] alignment:(NSTextAlignmentLeft) title:self.houseInfo[@"house_own_info"][@"position"]]];
    
    UIButton *attentionbtn = [Tools creatButton:CGRectMake(KScreenWidth - 110, height+25, 90, 33) font:[UIFont systemFontOfSize:16] color:[UIColor colorWithHexString:@"#5cc6c6"] title:@"编辑" image:@""];
    [attentionbtn setBackgroundColor:MDRGBA(219, 245, 245, 1)];
    [attentionbtn.layer setCornerRadius:16.5];
    [attentionbtn setSelected:[self.houseInfo[@"is_follow"] integerValue]==0?NO:YES];
    [attentionbtn setHidden:!self.isEdit];
    [attentionbtn addTarget:self action:@selector(editHouse:) forControlEvents:(UIControlEventTouchUpInside)];
    [self.infoView addSubview:attentionbtn];

    height += 83+15;
    
    UIView *descView = [[UIView alloc] initWithFrame:CGRectMake(20, height, KScreenWidth - 40, 70)];
    [descView.layer setBorderWidth:1];
    [descView.layer setBorderColor:[UIColor colorWithHexString:@"#dddddd"].CGColor];
    [descView.layer setCornerRadius:5];
    [descView setClipsToBounds:YES];
    [self.infoView addSubview:descView];
    
    NSArray *tArr = @[@"户型",@"面积",@"费用",@"位置"];
    NSArray *dArr = @[self.houseInfo[@"house_info"][@"door"],
                      [NSString stringWithFormat:@"%@m²",self.houseInfo[@"house_info"][@"proportion"]],
                      [NSString stringWithFormat:@"%@万元",self.houseInfo[@"house_info"][@"cost"]],
                      self.houseInfo[@"house_info"][@"city_name"]];
    CGFloat w = (KScreenWidth - 40)/4;
    
    for (NSInteger i = 0 ; i < 4 ; i++) {
        
        [descView addSubview:[Tools creatLabel:CGRectMake(w*i, 17, w, 12) font:[UIFont systemFontOfSize:12] color:[UIColor colorWithHexString:@"#666666"] alignment:(NSTextAlignmentCenter) title:tArr[i]]];
        
        [descView addSubview:[Tools creatLabel:CGRectMake(w*i, 40, w, 15) font:[UIFont boldSystemFontOfSize:15] color:[UIColor colorWithHexString:@"#000000"] alignment:(NSTextAlignmentCenter) title:dArr[i]]];
        
        [descView addSubview:[Tools setLineView:CGRectMake(w*i-1, 10, 1, 50)]];
    }
    
    height += 95;
    
    if (![self.houseInfo[@"said"] isKindOfClass:[NSNull class]] && self.houseInfo[@"said"]) {
        
        [self.infoView addSubview:[Tools creatLabel:CGRectMake(20,height ,KScreenWidth - 40 , 20) font:[UIFont boldSystemFontOfSize:18] color:[UIColor colorWithHexString:@"#000000"] alignment:(NSTextAlignmentLeft) title:@"说在前面"]];
        
        height += 35;
        
        CGFloat h = KHeight(self.houseInfo[@"said"], KScreenWidth - 40, 10000, 14).size.height;
        
        [self.infoView addSubview:[Tools creatLabel:CGRectMake(20,height ,KScreenWidth - 40 , h) font:[UIFont systemFontOfSize:14] color:[UIColor colorWithHexString:@"#000000"] alignment:(NSTextAlignmentLeft) title:self.houseInfo[@"said"]]];
        
        height += h+15;
    }
    
    [self.infoView setFrame:CGRectMake(0, 0, KScreenWidth, height)];
    [self.tmpTableView setTableHeaderView:self.infoView];
}

- (CGFloat)creatHeaderViewTitle:(CGFloat)heigt{
    
    UILabel * typeLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 50, 20)];
    [typeLabel setText:@"家装"];
    [typeLabel setTextColor:GCOLOR];
    [typeLabel setTextAlignment:(NSTextAlignmentCenter)];
    [typeLabel setFont:[UIFont systemFontOfSize:10.0f]];
    [typeLabel.layer setCornerRadius:5];
    [typeLabel.layer setBorderWidth:1];
    [typeLabel.layer setBorderColor:GCOLOR.CGColor];
    
    UILabel * label1 = [[UILabel alloc] initWithFrame:CGRectMake(15, heigt, KScreenWidth - 30, 10)];
    [label1 setNumberOfLines:0];
    [self.infoView addSubview:label1];
    
    NSString *title = [NSString stringWithFormat:@"%@  ",self.houseInfo[@"house_info"][@"title"]];
    
    NSMutableAttributedString *ste = [[NSMutableAttributedString alloc] initWithString:title attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:19.0f]}];
    NSTextAttachment *ach = [[NSTextAttachment alloc] initWithData:nil ofType:nil];
    ach.image = [self imageWithUIView:typeLabel];
    ach.bounds = CGRectMake(0, -3, 50, 20);
    NSAttributedString *string = [NSAttributedString attributedStringWithAttachment:ach];
    [ste insertAttributedString:string atIndex:[title length]];
    
    [label1 setAttributedText:ste];
    [label1 sizeToFit];
    
    return heigt + label1.frame.size.height + 10;
}
- (UIImage*) imageWithUIView:(UIView*) view
{
    UIGraphicsBeginImageContext(view.bounds.size);
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    [view.layer renderInContext:ctx];
    UIImage* tImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return tImage;
}
- (void)createFootView{
    
    [self.footView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    if (self.commentArr.count == 0) {
        [self.footView setFrame:CGRectMake(0, 0, KScreenWidth, 0.001)];
    }
    else{
    
    [self.footView setFrame:CGRectMake(0, 0, KScreenWidth, 80)];
    
    UIButton *btn = [Tools creatButton:CGRectMake(30, 20, KScreenWidth-60, 40) font:[UIFont systemFontOfSize:16] color:[UIColor colorWithHexString:@"#666666"] title:[NSString stringWithFormat:@"查看全部%@条评论",self.houseInfo[@"evaluate_num"]] image:@""];
    [btn addTarget:self action:@selector(checkMoreComment) forControlEvents:(UIControlEventTouchUpInside)];
    [self.footView addSubview:btn];
    
    [self.footView addSubview:[Tools setLineView:CGRectMake(0, 79, KScreenWidth, 1)]];
    }
    
    [self.tmpTableView setTableFooterView:self.footView];
}

- (void)createFunctionBar{
    
    [self.functionBar.likeButton setSelected:[self.houseInfo[@"is_zan"] integerValue]==0?NO:YES];
    [self.functionBar.likeButton setTitle:[NSString stringWithFormat: @"  %@",self.houseInfo[@"zan_num"]] forState:(UIControlStateNormal)];
    [self.functionBar.likeButton addTarget:self action:@selector(likeThisHouse:) forControlEvents:(UIControlEventTouchUpInside)];
    
    [self.functionBar.collectButton setTitle:[NSString stringWithFormat:  @" %@",self.houseInfo[@"collect_num"]] forState:(UIControlStateNormal)];
    [self.functionBar.collectButton setSelected:[self.houseInfo[@"is_collect"] integerValue]==0?NO:YES];
    [self.functionBar.collectButton addTarget:self action:@selector(collectThisHouse:) forControlEvents:(UIControlEventTouchUpInside)];
    
    [self.functionBar.backView.layer setCornerRadius:5];
    [self.functionBar.backView setClipsToBounds:YES];
    
    [self.functionBar.backView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(commentThisHouse)]];
}

#pragma mark -- tableView
- (UITableView *)tmpTableView{
    
    if (!_tmpTableView) {
        _tmpTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, KScreenWidth, KScreenHeight - KPlaceHeight) style:(UITableViewStyleGrouped)];
        [_tmpTableView setSeparatorStyle:(UITableViewCellSeparatorStyleNone)];
        if (@available(iOS 11.0, *)) {
            [_tmpTableView setContentInsetAdjustmentBehavior:(UIScrollViewContentInsetAdjustmentNever)];
        }
        [_tmpTableView setBackgroundColor:[UIColor whiteColor]];
        [_tmpTableView setRowHeight:UITableViewAutomaticDimension];
        [_tmpTableView setEstimatedRowHeight:500.0f];
        [_tmpTableView setShowsVerticalScrollIndicator:NO];
        [_tmpTableView setShowsHorizontalScrollIndicator:NO];
        [_tmpTableView setDataSource:self];
        [_tmpTableView setDelegate:self];
    }
    return _tmpTableView;
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    
    return self.titleArr.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    if (section == self.dataArr.count) {
        return self.questionArr.count;
    }
    if (section == self.dataArr.count+1) {
        return self.commentArr.count;
    }
    
    return [self.dataArr[section] count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (indexPath.section < self.dataArr.count) {
        SpaceImageTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"SpaceImageTableViewCell"];
        if (!cell) {
            cell = [[SpaceImageTableViewCell alloc] initWithStyle:(UITableViewCellStyleDefault) reuseIdentifier:@"SpaceImageTableViewCell"];
        }
        
        if (indexPath.row < self.dataArr.count) {
            
            [cell bandDataWithDic:self.dataArr[indexPath.section][indexPath.row]];
        }
        return cell;
    }
    else  if (indexPath.section == self.dataArr.count) {
        
        QuestionTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"QuestionTableViewCell1"];
        if (!cell) {
            cell = [[QuestionTableViewCell alloc] initWithStyle:(UITableViewCellStyleDefault) reuseIdentifier:@"QuestionTableViewCell1"];
        }
        if (indexPath.row < self.questionArr.count) {
            
            [cell bandDataWithDictionary:self.questionArr[indexPath.row]];
        }
        return cell;
    }
    else{
        
        HouseCommentTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"HouseCommentTableViewCell1"];
        if (!cell) {
            cell = [[HouseCommentTableViewCell alloc] initWithStyle:(UITableViewCellStyleDefault) reuseIdentifier:@"HouseCommentTableViewCell1"];
        }
        if (indexPath.row < self.commentArr.count) {
            CommentModel *model = self.commentArr[indexPath.row];
            [cell bandDataWith:model];
            
            [cell setShowPresonDetail:^{
                PersonalViewController *vc = [[PersonalViewController alloc] init];
                vc.user_id = model.member_info[@"user_id"];
                [self.navigationController pushViewController:vc animated:YES];
            }];
            
        }
        return cell;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.001f;
}
- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    return [UIView new];
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (section == self.titleArr.count-1 && self.commentArr.count == 0) {
        return 0.00f;
    }
    if (section == self.titleArr.count-2 && self.questionArr.count == 0) {
        return 0.00f;
    }
    
    return 20.0f;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, KScreenWidth, 20)];
    [view setBackgroundColor:[UIColor whiteColor]];
    if (section < self.titleArr.count) {
        [view addSubview:[Tools creatLabel:CGRectMake(20, 0, KScreenWidth  -40, 20) font:[UIFont boldSystemFontOfSize:18] color:[UIColor blackColor] alignment:(NSTextAlignmentLeft) title:self.titleArr[section]]];
    }
    if (section == self.titleArr.count-1 && self.commentArr.count == 0) {
        return [UIView new];
    }
    if (section == self.titleArr.count-2 && self.questionArr.count == 0) {
        return [UIView new];
    }
    return view;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (indexPath.section > self.dataArr.count) {
        CommentModel *model = self.commentArr[indexPath.row];
        
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示" message:@"评论操作" preferredStyle:(UIAlertControllerStyleActionSheet)];
        
        [alert addAction:[UIAlertAction actionWithTitle:@"回复" style:(UIAlertActionStyleDefault) handler:^(UIAlertAction * _Nonnull action) {
            
            self.commentV.commit_id = model.commit_id;
            [self.commentV addComment];
        }]];
        
        [alert addAction:[UIAlertAction actionWithTitle:@"详情" style:(UIAlertActionStyleDefault) handler:^(UIAlertAction * _Nonnull action) {
            
            CommentDetalisViewController *vc = [[CommentDetalisViewController alloc] init];
            vc.type = 2;
            vc.eva_id = model.commit_id ;
            [self.navigationController pushViewController:vc animated:YES];
        }]];
        
        [alert addAction:[UIAlertAction actionWithTitle:@"取消" style:(UIAlertActionStyleCancel) handler:nil]];
        
        [self presentViewController:alert animated:YES completion:nil];
    }
  
}

#pragma mark -- 点击事件
- (void)back{
    
    [self.navigationController popViewControllerAnimated:YES];
    
}

- (void)share{
    
    //显示分享面板
    [UMSocialUIManager showShareMenuViewInWindowWithPlatformSelectionBlock:^(UMSocialPlatformType platformType, NSDictionary *userInfo) {
        // 根据获取的platformType确定所选平台进行下一步操作
        
        //创建分享消息对象
        UMSocialMessageObject *messageObject = [UMSocialMessageObject messageObject];
        
        //创建网页内容对象
        UMShareWebpageObject *shareObject = [UMShareWebpageObject shareObjectWithTitle:self.houseInfo[@"share_title"] descr:self.houseInfo[@"share_desc"] thumImage:self.houseInfo[@"share_img"]];
        //设置网页地址
        shareObject.webpageUrl =[NSString stringWithFormat:@"%@",self.houseInfo[@"share_url"]];
        //分享消息对象设置分享内容对象
        messageObject.shareObject = shareObject;
        
        //调用分享接口
        [[UMSocialManager defaultManager] shareToPlatform:platformType messageObject:messageObject currentViewController:self completion:^(id data, NSError *error) {
            
            if (error) {
                
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    [Tools showShareError:error];
                    
                });
            }else{
                
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    
                    UMSocialShareResponse *resp = data;
                    //分享结果消息
                    NSLog(@"response message is %@",resp.message);
                    //第三方原始返回的数据
                    NSLog(@"%@",resp.originalResponse);
                    
                    [self shareSuccess];
                    
                    
                });
            }
        }];
    }];
}
- (void)shareSuccess{
    
    NSString *path = [NSString stringWithFormat:@"%@/member/share",KURL];
    NSDictionary *dic = @{@"user_id":self.houseInfo[@"house_own_info"][@"id"],@"id":self.houseInfo[@"house_info"][@"id"],@"type":@"2"};
    
    [HttpRequest POST:path parameters:dic success:^(id  _Nullable responseObject) {
    } failure:^(NSError * _Nullable error) {
        
    }];
    
}

// 编辑
- (void)editHouse:(UIButton *)sender{
    
    HouseInfoViewController *vc = [[HouseInfoViewController alloc] init];
    vc.house_id = self.house_id;
    vc.type = 2;
    BaseNaviViewController *nav = [[BaseNaviViewController alloc] initWithRootViewController:vc];
    [self presentViewController:nav animated:YES completion:nil];
}

- (void)checkMoreComment{
    
    [self.commentV openDisplay];
}

- (void)commentThisHouse{
    self.commentV.commit_id = @"0";
    [self.commentV addComment];
}

- (void)collectThisHouse:(UIButton *)sender{
    
    NSString *path = [NSString stringWithFormat:@"%@/WholeHouse/member_collect",KURL];
    
    NSDictionary *header = @{@"token":UTOKEN};
    NSDictionary *dic = @{@"house_id":self.house_id};
    
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    __weak typeof(self) weakSelf = self;
    
    [HttpRequest POSTWithHeader:header url:path parameters:dic success:^(id  _Nullable responseObject) {
        
        [MBProgressHUD hideHUDForView:weakSelf.view animated:YES];
        
        if ([responseObject[@"code"] integerValue] == 200) {
            [ViewHelps showHUDWithText:@"收藏成功"];
            [sender setTitle:[NSString stringWithFormat:@" %ld",(long)([sender.titleLabel.text intValue] + 1)] forState:(UIControlStateNormal)];
            [sender setSelected:YES];
        }
        else if ([responseObject[@"code"] integerValue] == 201){
            [sender setTitle:[NSString stringWithFormat:@" %ld",(long)([sender.titleLabel.text intValue] - 1)] forState:(UIControlStateNormal)];
            [sender setSelected:NO];
        }
        else{
            
            [ViewHelps showHUDWithText:responseObject[@"message"]];
        }
        
        
    } failure:^(NSError * _Nullable error) {
        
        [MBProgressHUD hideHUDForView:weakSelf.view animated:YES];
        [RequestSever showMsgWithError:error];
    }];
    
}
- (void)likeThisHouse:(UIButton *)sender{
    LOGIN
    NSString *path = [NSString stringWithFormat:@"%@/WholeHouse/member_zan",KURL];
    
    NSDictionary *header = @{@"token":UTOKEN};
    NSDictionary *dic = @{@"house_id":self.house_id};
    
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    __weak typeof(self) weakSelf = self;
    
    [HttpRequest POSTWithHeader:header url:path parameters:dic success:^(id  _Nullable responseObject) {
        
        [MBProgressHUD hideHUDForView:weakSelf.view animated:YES];
        
        if ([responseObject[@"code"] integerValue] == 200) {
            [ViewHelps showHUDWithText:@"点赞成功"];
            [sender setTitle:[NSString stringWithFormat:@" %ld",(long)([sender.titleLabel.text intValue] + 1)] forState:(UIControlStateNormal)];
            [sender setSelected:YES];
        }
        else if ([responseObject[@"code"] integerValue] == 201){
            [sender setTitle:[NSString stringWithFormat:@" %ld",(long)([sender.titleLabel.text intValue] - 1)] forState:(UIControlStateNormal)];
            [sender setSelected:NO];
        }
        else{
            
            [ViewHelps showHUDWithText:responseObject[@"message"]];
        }
        
        
    } failure:^(NSError * _Nullable error) {
        
        [MBProgressHUD hideHUDForView:weakSelf.view animated:YES];
        [RequestSever showMsgWithError:error];
    }];
    
}

#pragma mark -- delegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    
    if (scrollView == self.tmpTableView) {
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
            rect.origin.x =  point.y /2;
            rect.size.width = KScreenWidth - point.y;
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
