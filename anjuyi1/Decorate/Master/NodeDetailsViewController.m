//
//  MyPushPhotoDetailsViewController.m
//  anjuyi1
//
//  Created by apple on 2018/7/25.
//  Copyright © 2018年 lsy. All rights reserved.
//

#import "NodeDetailsViewController.h"
#import "NodeCommentView.h"
#import <IQKeyboardManager.h>
#import "SpaceImageTableViewCell.h"
#import "HouseCommentTableViewCell.h"
#import "CommentModel.h"
#import "EditPushPhotoViewController.h"
#import "FunctionBarView.h"
#import "CommentDetalisViewController.h"
#import "PersonalViewController.h"

@interface NodeDetailsViewController ()<UITableViewDelegate,UITableViewDataSource>
{
    UIButton *backBtn;
    UIButton *shareBtn;
    UIImageView *headerBackImage;
}

@property (nonatomic,strong)UIView               *  navView;
@property (nonatomic,strong)NodeCommentView      *  commentV;
@property (nonatomic,strong)UIView               *  infoView;
@property (nonatomic,strong)UIView               *  footView;
@property (nonatomic,strong)FunctionBarView      *  functionBar;

@property (nonatomic,strong)NSMutableDictionary  *  nodeInfo;
@property (nonatomic,strong)UITableView          *  tmpTableView;
@property (nonatomic,strong)NSMutableArray       *  commentArr;//评论数组

@end

@implementation NodeDetailsViewController

- (void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:animated];
    [IQKeyboardManager sharedManager].enableAutoToolbar = NO;
    [IQKeyboardManager sharedManager].shouldResignOnTouchOutside = YES;
    [self baseForDefaultLeftNavButton];
    [self.navigationController setNavigationBarHidden:YES animated:YES];
    
}

- (void)viewWillDisappear:(BOOL)animated{
    
    [super viewWillDisappear:animated];
    [IQKeyboardManager sharedManager].enableAutoToolbar = YES;
    [self.navigationController setNavigationBarHidden:NO animated:YES];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.commentArr = [NSMutableArray array];
    
    [self.view addSubview:self.tmpTableView];
    [self getnodeInfo];
    
    [self.view addSubview:self.navView];
    [self.view addSubview:self.functionBar];
    [self.view addSubview:self.commentV];
}

- (void)getnodeInfo{
    
    NSString *path = [NSString stringWithFormat:@"%@/project_info/get_article_detail",KURL];

    NSDictionary *parameter = @{@"article_id":self.nodeID};
    
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    __weak typeof(self) weakSelf = self;
    
    [HttpRequest POST:path parameters:parameter success:^(id  _Nullable responseObject) {
        
        [MBProgressHUD hideHUDForView:weakSelf.view animated:YES];
        
        if ([responseObject[@"code"] integerValue] == 200) {
            
            weakSelf.nodeInfo = [NSMutableDictionary dictionaryWithDictionary:responseObject[@"datas"]];
            
            [weakSelf createnodeInfo];
            
            for (NSDictionary *dic in weakSelf.nodeInfo[@"evaluate_list"]) {
                CommentModel *model = [[CommentModel alloc] init];
                model.commit_id = dic[@"id"];
                model.member_info = @{@"nick_name":dic[@"name"],@"head":dic[@"head"]};
                model.content = dic[@"content"];
                model.create_time = dic[@"create_time"];
                [weakSelf.commentArr addObject:model];
            }
            
            
            
            [weakSelf createFootView];
            
            [weakSelf createFunctionBar];
        }
        else{
            
            [ViewHelps showHUDWithText:responseObject[@"message"]];
        }
        
        [weakSelf.tmpTableView reloadData];
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


- (NodeCommentView *)commentV{
    
    if (!_commentV) {
        _commentV = [[NodeCommentView alloc] initWithFrame:CGRectMake(0, 0, KScreenWidth, KScreenHeight)];
        WKSELF;
        [_commentV setShowCommentDetali:^(NSString *eva_id) {
            CommentDetalisViewController *vc = [[CommentDetalisViewController alloc] init];
            vc.eva_id = eva_id;
            vc.type = 3;
            [weakSelf.navigationController pushViewController:vc animated:YES];
        }];
        
        //展示用户详情
        [_commentV setShowReviewerDetail:^(BaseViewController *vc) {
            [weakSelf.navigationController pushViewController:vc animated:YES];
        }];
        
        [_commentV setNodeid:self.nodeID];
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
        _functionBar = [[FunctionBarView alloc] initWithFrame:CGRectMake(0, KScreenHeight - KPlaceHeight - 50, KScreenWidth, 50)];
        [_functionBar addSubview:[Tools setLineView:CGRectMake(0, 0, KScreenWidth, 2)]];
    }
    return _functionBar;
}


- (void)createnodeInfo{
    
    [self.infoView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    
    CGFloat height = 0;
    
    headerBackImage  = [Tools creatImage:CGRectMake(0, 0, KScreenWidth,  750.0*KScreenWidth/750.0)  url:self.nodeInfo[@"article_info"][@"image_url"] image:@""];
    [self.infoView addSubview:headerBackImage];
    
    height += 750.0*KScreenWidth/750.0 + 20;
    
    UIImageView *header = [Tools creatImage:CGRectMake(20, height+20, 43, 43) url:self.nodeInfo[@"foreman"][@"head"] image:@""];
    [header.layer setCornerRadius:21.5];
    [self.infoView addSubview:header];
    
    NSString *name = self.nodeInfo[@"foreman"][@"nickname"];
    CGFloat nameW = KHeight(name, 10000, 20, 18).size.width + 20;
    
    UILabel *nameLabel = [Tools creatLabel:CGRectMake(65,  height+20 ,nameW , 25) font:[UIFont systemFontOfSize:18] color:[UIColor blackColor] alignment:(NSTextAlignmentLeft) title:name];
    [self.infoView addSubview:nameLabel];
    
    UILabel *typeLabel = [Tools creatLabel:CGRectMake(65+ nameW, height+22.5 , 50, 20) font:[UIFont systemFontOfSize:12] color:[UIColor colorWithHexString:@"#fffefe"] alignment:(NSTextAlignmentCenter) title:self.nodeInfo[@"foreman"][@"level"]];
    [typeLabel.layer setCornerRadius:5];
    [typeLabel setBackgroundColor:[UIColor colorWithHexString:@"#5cc6c6"]];
    [self.infoView addSubview:typeLabel];
    
    if (KScreenWidth < 65+nameW + 50 + 110+20) {
        [typeLabel setFrame:CGRectMake(KScreenWidth - 190, height+22.5, 50, 20)];
        [nameLabel setFrame:CGRectMake(65,  height+20 ,KScreenWidth - 245 , 25)];
    }
    
    [self.infoView addSubview:[Tools creatLabel:CGRectMake(65,height+ 45 ,KScreenWidth - 185 , 20) font:[UIFont systemFontOfSize:12] color:[UIColor colorWithHexString:@"#999999"] alignment:(NSTextAlignmentLeft) title:self.nodeInfo[@"member_info"][@"position"]]];
    
    UIView *backView = [[UIView alloc] initWithFrame:CGRectMake(0, height, KScreenWidth - 110, 83)];
    [backView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(showPersonDetails)]];
    [self.infoView addSubview:backView];
    
        UIButton *attentionbtn = [Tools creatButton:CGRectMake(KScreenWidth - 110, height+25, 90, 33) font:[UIFont systemFontOfSize:16] color:[UIColor colorWithHexString:@"#5cc6c6"] title:@"关注" image:@""];
        [attentionbtn setBackgroundColor:MDRGBA(219, 245, 245, 1)];
        [attentionbtn.layer setCornerRadius:16.5];
        [attentionbtn setTitle:@"已关注" forState:(UIControlStateSelected)];
        [attentionbtn setSelected:[self.nodeInfo[@"is_follow"] integerValue]==0?NO:YES];
        [attentionbtn addTarget:self action:@selector(attentionToAuthor:) forControlEvents:(UIControlEventTouchUpInside)];
        [self.infoView addSubview:attentionbtn];
    
    
    
    height += 83+15;
    
    [self.infoView addSubview:[Tools creatLabel:CGRectMake(15, height, KScreenWidth - 30, 50) font:[UIFont systemFontOfSize:19] color:[UIColor blackColor] alignment:(NSTextAlignmentLeft) title:self.nodeInfo[@"article_info"][@"text"]]];
    
    height += 50 + 10;
    
    UIButton *time = [Tools creatButton:CGRectMake(15, height, KScreenWidth - 30, 12) font:[UIFont systemFontOfSize:12] color:[UIColor colorWithHexString:@"#666666"] title:[NSString stringWithFormat:@"   发布于 %@",self.nodeInfo[@"article_info"][@"create_time"]] image:@"xq_time"];
    [time setContentHorizontalAlignment:(UIControlContentHorizontalAlignmentLeft)];
    [self.infoView addSubview:time];
    
    height += 12 + 10;
    
    
    [self.infoView addSubview:[Tools setLineView:CGRectMake(15, height, KScreenWidth - 30, 1)]];
    
    [self.infoView setFrame:CGRectMake(0, 0, KScreenWidth, height)];
}

- (void)createFootView{
    
    [self.footView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
//    if (self.commentArr.count == 0) {
//        [self.footView setFrame:CGRectMake(0, 0, KScreenWidth, 0.001)];
//
//    }
//    else{
    
        [self.footView setFrame:CGRectMake(0, 0, KScreenWidth, 80)];
        
        UIButton *btn = [Tools creatButton:CGRectMake(30, 20, KScreenWidth-60, 40) font:[UIFont systemFontOfSize:16] color:[UIColor colorWithHexString:@"#666666"] title:[NSString stringWithFormat:@"查看全部%@条评论",self.nodeInfo[@"evaluate_num"]] image:@""];
        [btn addTarget:self action:@selector(checkMoreComment) forControlEvents:(UIControlEventTouchUpInside)];
        [self.footView addSubview:btn];
        
        [self.footView addSubview:[Tools setLineView:CGRectMake(0, 79, KScreenWidth, 1)]];
//    }
    
    [self.tmpTableView setTableFooterView:self.footView];
}

- (void)createFunctionBar{
    
    [self.functionBar.likeButton setSelected:[self.nodeInfo[@"is_zan"] integerValue]==0?NO:YES];
    [self.functionBar.likeButton setTitle:[NSString stringWithFormat: @"  %@",self.nodeInfo[@"zan_num"]] forState:(UIControlStateNormal)];
    [self.functionBar.likeButton addTarget:self action:@selector(likeThisHouse:) forControlEvents:(UIControlEventTouchUpInside)];
    
    [self.functionBar.collectButton setTitle:[NSString stringWithFormat:  @" %@",self.nodeInfo[@"collect_num"]] forState:(UIControlStateNormal)];
    [self.functionBar.collectButton setSelected:[self.nodeInfo[@"is_collect"] integerValue]==0?NO:YES];
    [self.functionBar.collectButton addTarget:self action:@selector(collectThisHouse:) forControlEvents:(UIControlEventTouchUpInside)];
    
    [self.functionBar.backView.layer setCornerRadius:5];
    [self.functionBar.backView setClipsToBounds:YES];
    
    [self.functionBar.backView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(commentThisHouse)]];
}

#pragma mark -- tableView
- (UITableView *)tmpTableView{
    
    if (!_tmpTableView) {
        _tmpTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, KScreenWidth, KScreenHeight - 50 - KPlaceHeight) style:(UITableViewStyleGrouped)];
        [_tmpTableView setSeparatorStyle:(UITableViewCellSeparatorStyleNone)];
        if (@available(iOS 11.0, *)) {
            [_tmpTableView setContentInsetAdjustmentBehavior:(UIScrollViewContentInsetAdjustmentNever)];
        }
        [_tmpTableView setBackgroundColor:[UIColor whiteColor]];
        [_tmpTableView setRowHeight:UITableViewAutomaticDimension];
        [_tmpTableView setEstimatedRowHeight:100.0f];
        [_tmpTableView setShowsVerticalScrollIndicator:NO];
        [_tmpTableView setShowsHorizontalScrollIndicator:NO];
        [_tmpTableView setTableHeaderView:self.infoView];
        [_tmpTableView setDataSource:self];
        [_tmpTableView setDelegate:self];
    }
    return _tmpTableView;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    
    return self.commentArr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    HouseCommentTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"HouseCommentTableViewCell1"];
    if (!cell) {
        cell = [[HouseCommentTableViewCell alloc] initWithStyle:(UITableViewCellStyleDefault) reuseIdentifier:@"HouseCommentTableViewCell1"];
    }
    if (indexPath.row < self.commentArr.count) {
        CommentModel *model = self.commentArr[indexPath.row];
        [cell bandDataWith:model];
        
        [cell setShowPresonDetail:^{
            
            if (model.member_info[@"user_id"]) {
                PersonalViewController *vc = [[PersonalViewController alloc] init];
                vc.user_id = model.member_info[@"user_id"];
                [self.navigationController pushViewController:vc animated:YES];
            }
            else{
                [ViewHelps showHUDWithText:@"user_id 不存在"];
            }
            
        }];
    }
    return cell;
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    CommentModel *model = self.commentArr[indexPath.row];
    
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示" message:@"评论操作" preferredStyle:(UIAlertControllerStyleActionSheet)];
    
    [alert addAction:[UIAlertAction actionWithTitle:@"回复" style:(UIAlertActionStyleDefault) handler:^(UIAlertAction * _Nonnull action) {
        self.commentV.commit_id = model.commit_id;
        [self.commentV addComment];
    }]];
    
    [alert addAction:[UIAlertAction actionWithTitle:@"详情" style:(UIAlertActionStyleDefault) handler:^(UIAlertAction * _Nonnull action) {
        
        CommentDetalisViewController *vc = [[CommentDetalisViewController alloc] init];
        vc.eva_id = model.commit_id;
        vc.type = 3;
        [self.navigationController pushViewController:vc animated:YES];
    }]];
    
    [alert addAction:[UIAlertAction actionWithTitle:@"取消" style:(UIAlertActionStyleCancel) handler:nil]];
    
    [self presentViewController:alert animated:YES completion:nil];
    
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
        UMShareWebpageObject *shareObject =[UMShareWebpageObject shareObjectWithTitle:self.nodeInfo[@"share_title"] descr:self.nodeInfo[@"share_desc"] thumImage:self.nodeInfo[@"share_img"]];
        //设置网页地址
        shareObject.webpageUrl =[NSString stringWithFormat:@"%@",self.nodeInfo[@"share_url"]];
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
    NSDictionary *dic = @{@"user_id":self.nodeInfo[@"foreman"][@"id"],@"id":self.nodeInfo[@"article_info"][@"id"],@"type":@"4"};
    
    [HttpRequest POST:path parameters:dic success:^(id  _Nullable responseObject) {
    } failure:^(NSError * _Nullable error) {
        
    }];
    
}


- (void)showPersonDetails{
    
    PersonalViewController *vc = [[PersonalViewController alloc] init];
    vc.user_id = self.nodeInfo[@"foreman"][@"id"];
    
    [self.navigationController pushViewController:vc animated:YES];
}
// 关注
- (void)attentionToAuthor:(UIButton *)sender{
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
    NSDictionary *dic = @{@"user_id":self.nodeInfo[@"foreman"][@"id"]};
    
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

- (void)checkMoreComment{
    
    [self.commentV openDisplay];
}

- (void)commentThisHouse{
    self.commentV.commit_id = @"0";
    [self.commentV addComment];
}

- (void)collectThisHouse:(UIButton *)sender{
    LOGIN
    NSString *path = [NSString stringWithFormat:@"%@/Project/member_collect",KURL];
    
    NSDictionary *header = @{@"token":UTOKEN};
    NSDictionary *dic = @{@"article_id":self.nodeID};
    
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
    NSString *path = [NSString stringWithFormat:@"%@/Project/member_zan",KURL];
    
    NSDictionary *header = @{@"token":UTOKEN};
    NSDictionary *dic = @{@"article_id":self.nodeID};
    
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
        [self.navView setBackgroundColor:MDRGBA(255, 255, 255, scrollView.contentOffset.y/KScreenWidth)];
        
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
            rect.size.height = KScreenWidth - point.y;
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
