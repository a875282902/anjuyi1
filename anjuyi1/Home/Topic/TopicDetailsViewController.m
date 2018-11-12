//
//  TopicDetailsViewController.m
//  anjuyi1
//
//  Created by apple on 2018/8/10.
//  Copyright © 2018年 lsy. All rights reserved.
//

#import "TopicDetailsViewController.h"
#import "TopicCommentModel.h"
#import "TopicCommentTableViewCell.h"
#import "AddTopicCommentViewController.h"

@interface TopicDetailsViewController ()<UITableViewDelegate,UITableViewDataSource,TopicCommentTableViewCellDelegate>

@property (nonatomic,strong) UITableView               * tmpTableView;
@property (nonatomic,strong) NSMutableArray            * dataArr;
@property (nonatomic,strong) UIView                    * navView;
@property (nonatomic,strong) UIView                    * headerView;
@property (nonatomic,strong) NSMutableDictionary       * topicInfo;
@property (nonatomic,assign) NSInteger                   page;
@property (nonatomic,strong) NSIndexPath               * adoptIndex;

@end

@implementation TopicDetailsViewController

- (void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:animated];
    
    [self setNavigationLeftBarButtonWithImageNamed:@""];
    [self.navigationController setNavigationBarHidden:YES animated:YES];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.

    self.page = 1;
    self.dataArr = [NSMutableArray array];
    [self.view addSubview:self.tmpTableView];
    [self.view addSubview:self.navView];
    [self requsetData];
    [self pullDownRefresh];
    
    [self load];
}

- (void)requsetData{
    
    NSString *path = [NSString stringWithFormat:@"%@/topic_info/topic_detail_info",KURL];

    NSDictionary *dic = @{@"topic_id":self.topic_id};
    
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    __weak typeof(self) weakSelf = self;
    
    [HttpRequest POST:path parameters:dic success:^(id  _Nullable responseObject) {
        
        [MBProgressHUD hideHUDForView:weakSelf.view animated:YES];
        
        if ([responseObject[@"code"] integerValue] == 200) {
            
            weakSelf.topicInfo = [NSMutableDictionary dictionaryWithDictionary:responseObject[@"datas"]];
            
            [weakSelf setUpHeaderView];
        }
        else{
            
            [ViewHelps showHUDWithText:responseObject[@"message"]];
        }
        
        
    } failure:^(NSError * _Nullable error) {
        
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        [RequestSever showMsgWithError:error];
    }];

}

#pragma mark -- refresh
- (void)load{
    __weak typeof(self) weakSelf = self;
    
    self.tmpTableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        weakSelf.page = 1;
        [weakSelf.dataArr removeAllObjects];
        [weakSelf.tmpTableView.mj_footer resetNoMoreData];
        [weakSelf pullDownRefresh];
    }];
    

    self.tmpTableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        weakSelf.page ++;
        [weakSelf pullUpLoadMore];
    }];
    

}
//下拉刷新
- (void)pullDownRefresh{
    NSString *path = [NSString stringWithFormat:@"%@/topic_info/topic_detail_evaluate",KURL];
    
    NSDictionary *dic = @{@"topic_id":self.topic_id,@"page":[NSString stringWithFormat:@"%ld",self.page]};
    
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    __weak typeof(self) weakSelf = self;
    
    [HttpRequest POST:path parameters:dic success:^(id  _Nullable responseObject) {
        
        [MBProgressHUD hideHUDForView:weakSelf.view animated:YES];
        
        if ([responseObject[@"code"] integerValue] == 200) {
            
            if ([responseObject[@"datas"] isKindOfClass:[NSArray class]]) {
                
                for (NSDictionary *dic in responseObject[@"datas"]) {
                    TopicCommentModel *model = [[TopicCommentModel alloc] initWithDictionary:dic];
                    
                   NSInteger num = KHeight(model.content, (KScreenWidth - 83), 100000, 16).size.height/16;
                    
                    if (num>3) {
                        model.isShowAllButton = NO;
                    }
                    else{
                        model.isShowAllButton = YES;
                    }
                   
                    
                    [weakSelf.dataArr addObject:model];
                }
            }
        }
        else{
            
            [ViewHelps showHUDWithText:responseObject[@"message"]];
        }
        
        [weakSelf.tmpTableView reloadData];
        [weakSelf.tmpTableView.mj_header endRefreshing];
        
        if (weakSelf.dataArr.count < weakSelf.page *10) {
            [weakSelf.tmpTableView.mj_footer endRefreshingWithNoMoreData];
        }
        
    } failure:^(NSError * _Nullable error) {
        
        [MBProgressHUD hideHUDForView:weakSelf.view animated:YES];
        [RequestSever showMsgWithError:error];
    }];

}
//上拉加载
- (void)pullUpLoadMore{
    NSString *path = [NSString stringWithFormat:@"%@/topic_info/topic_detail_evaluate",KURL];
    
    NSDictionary *header = @{@"token":UTOKEN};
    NSDictionary *dic = @{@"topic_id":self.topic_id,@"page":[NSString stringWithFormat:@"%ld",self.page]};
    
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    __weak typeof(self) weakSelf = self;
    
    [HttpRequest POSTWithHeader:header url:path parameters:dic success:^(id  _Nullable responseObject) {
        
        [MBProgressHUD hideHUDForView:weakSelf.view animated:YES];
        
        if ([responseObject[@"code"] integerValue] == 200) {
            
            if ([responseObject[@"datas"] isKindOfClass:[NSArray class]]) {
                
                for (NSDictionary *dic in responseObject[@"datas"]) {
                    TopicCommentModel *model = [[TopicCommentModel alloc] initWithDictionary:dic];
                    [weakSelf.dataArr addObject:model];
                }
            }
        }
        else{
            
            [ViewHelps showHUDWithText:responseObject[@"message"]];
        }
        
        [weakSelf.tmpTableView reloadData];
        [weakSelf.tmpTableView.mj_footer endRefreshing];
        
        if (weakSelf.dataArr.count < weakSelf.page *10) {
            [weakSelf.tmpTableView.mj_footer endRefreshingWithNoMoreData];
        }
        
    } failure:^(NSError * _Nullable error) {
        
        [MBProgressHUD hideHUDForView:weakSelf.view animated:YES];
        [RequestSever showMsgWithError:error];
    }];
}

#pragma mark -- UI
- (UIView *)navView{
    
    if (!_navView) {
        _navView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, KScreenWidth, KTopHeight)];
        [_navView setBackgroundColor:self.backColor];
        
        UIButton *back = [Tools creatButton:CGRectMake(MDXFrom6(10), KStatusBarHeight + 2, 40, 40) font:[UIFont systemFontOfSize:12] color:[UIColor whiteColor] title:@"" image:@"my_back"];
        [back addTarget:self action:@selector(back) forControlEvents:(UIControlEventTouchUpInside)];
        [_navView addSubview:back];

        
        UIButton *share = [Tools creatButton:CGRectMake(KScreenWidth - 50, KStatusBarHeight + 2, 40, 40) font:[UIFont systemFontOfSize:12] color:[UIColor whiteColor] title:@"" image:@"share_w"];
        [share addTarget:self action:@selector(share) forControlEvents:(UIControlEventTouchUpInside)];
        [_navView addSubview:share];

    }
    return _navView;
}

- (UIView *)headerView{
    
    if (!_headerView) {
        _headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, KScreenWidth, MDXFrom6(189))];
        [_headerView setBackgroundColor:self.backColor];
    }
    return _headerView;
}

- (void)setUpHeaderView{
    
    [self.headerView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    
    [self.headerView addSubview:[Tools creatLabel:CGRectMake(30, 10, KScreenWidth - 60, 18) font:[UIFont boldSystemFontOfSize:18] color:[UIColor whiteColor] alignment:(NSTextAlignmentCenter) title:self.topicInfo[@"title"]]];
    [self.headerView addSubview:[Tools creatLabel:CGRectMake(30, 43, KScreenWidth - 60, 40) font:[UIFont systemFontOfSize:15] color:[UIColor whiteColor] alignment:(NSTextAlignmentCenter) title:self.topicInfo[@"content"]]];
    
    [self.headerView addSubview:[Tools creatImage:CGRectMake(0, MDXFrom6(70), KScreenWidth, MDXFrom6(119)) image:@"fb_backgroud"]];
    
    [self.headerView addSubview:[Tools creatImage:CGRectMake(0, MDXFrom6(140), KScreenWidth, MDXFrom6(25)) image:@"my_center_yj"]];
    
    UIView *vciew = [[UIView alloc] initWithFrame:CGRectMake(0, MDXFrom6(165), KScreenWidth, MDXFrom6(24))];
    [vciew setBackgroundColor:[UIColor whiteColor]];
    [self.headerView addSubview:vciew];
    
    
    [self.view addSubview:[Tools setLineView:CGRectMake(0, KScreenHeight - 80, KScreenWidth, 1)]];
    
    if ([self.topicInfo[@"status"] integerValue]==0) {
        
        UIButton *btn = [Tools creatButton:CGRectMake(MDXFrom6(20),KScreenHeight -  17.5 - 45  -KPlaceHeight, MDXFrom6(160), 45) font:[UIFont systemFontOfSize:18] color:[UIColor whiteColor] title:@"参与话题" image:@""];
        [btn setBackgroundColor:GCOLOR];
        [btn.layer setCornerRadius:22.5];
        [btn setClipsToBounds:YES];
        [btn addTarget:self action:@selector(participaTopic) forControlEvents:(UIControlEventTouchUpInside)];
        [self.view addSubview:btn];
        
        if ([self.topicInfo[@"is_author"] integerValue]==0) {
 
            UIButton *btn1 = [Tools creatButton:CGRectMake(MDXFrom6(195),KScreenHeight -  17.5 - 45 - KPlaceHeight, MDXFrom6(160), 45) font:[UIFont systemFontOfSize:18] color:[UIColor whiteColor] title:@"关注" image:@""];
            [btn1 setBackgroundColor:GCOLOR];
            [btn1 setTitle:@"已关注" forState:(UIControlStateSelected)];
            [btn1.layer setCornerRadius:22.5];
            [btn1 setClipsToBounds:YES];
            [btn1 addTarget:self action:@selector(follwTopic:) forControlEvents:(UIControlEventTouchUpInside)];
            [self.view addSubview:btn1];
            
            if ([self.topicInfo[@"is_follow"] integerValue]==1) {
                [btn1 setSelected:YES];
            }
        }
        else{
            [btn setFrame:CGRectMake((KScreenWidth - 200)/2.0, KScreenHeight -  17.5 - 45- KPlaceHeight, 200, 45)];
        }
        
    }
    
    
    
}

#pragma mark -- tableView
- (UITableView *)tmpTableView{
    
    if (!_tmpTableView) {
        _tmpTableView = [[UITableView alloc] initWithFrame:CGRectMake(0,KTopHeight, KScreenWidth, KViewHeight-80) style:(UITableViewStylePlain)];
        [_tmpTableView setSeparatorStyle:(UITableViewCellSeparatorStyleNone)];
        if (@available(iOS 11.0, *)) {
            [_tmpTableView setContentInsetAdjustmentBehavior:(UIScrollViewContentInsetAdjustmentNever)];
        }
        [_tmpTableView setRowHeight:UITableViewAutomaticDimension];
        [_tmpTableView setEstimatedRowHeight:100.0f];
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
    
    TopicCommentTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"TopicCommentTableViewCell"];
    if (!cell) {
        cell = [[TopicCommentTableViewCell alloc] initWithStyle:(UITableViewCellStyleDefault) reuseIdentifier:@"TopicCommentTableViewCell"];
    }
    if (indexPath.row < self.dataArr.count) {

        TopicCommentModel *model = self.dataArr[indexPath.row];
        
        if ([model.isBest integerValue] == 1) {
            self.adoptIndex = indexPath;
        }
        if ([self.topicInfo[@"is_author"] integerValue]==1) {
            model.isAuthor = YES;
        }

        [cell bandDataWithModel:model];
        [cell setDelegate:self];
    }
    return cell;
}

#pragma mark -- TopicCommentTableViewCellDelegate

- (void)likeWithCell:(TopicCommentTableViewCell *)cell{
    LOGIN
    NSIndexPath *indexPath = [self.tmpTableView indexPathForCell:cell];
    TopicCommentModel *model = self.dataArr[indexPath.row];
    
    NSString *path = [NSString stringWithFormat:@"%@/topic/user_zan",KURL];
    
    NSDictionary *header = @{@"token":UTOKEN};
    NSDictionary *dic = @{@"answer_id":model.ID};
    
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    __weak typeof(self) weakSelf = self;
    
    [HttpRequest POSTWithHeader:header url:path parameters:dic success:^(id  _Nullable responseObject) {
        
        [MBProgressHUD hideHUDForView:weakSelf.view animated:YES];
        
        if ([responseObject[@"code"] integerValue] == 200) {
            [ViewHelps showHUDWithText:responseObject[@"message"]];
            
            if ([model.is_zan integerValue]==0) {
                
                model.zan_num = [NSString stringWithFormat:@"%ld",[model.zan_num integerValue]+1];
            }else{
                
                model.zan_num = [NSString stringWithFormat:@"%ld",[model.zan_num integerValue]-1];
            }
            
            model.is_zan = [model.is_zan integerValue]==0?@"1":@"0";
            
            [weakSelf.dataArr replaceObjectAtIndex:indexPath.row withObject:model];
            [weakSelf.tmpTableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:(UITableViewRowAnimationAutomatic)];
            
        }
        else{
            
            [ViewHelps showHUDWithText:responseObject[@"message"]];
        }
        
        
    } failure:^(NSError * _Nullable error) {
        
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        [RequestSever showMsgWithError:error];
    }];

    
}

- (void)collectWithCell:(TopicCommentTableViewCell *)cell{
    
    LOGIN
    
    NSIndexPath *indexPath = [self.tmpTableView indexPathForCell:cell];
    TopicCommentModel *model = self.dataArr[indexPath.row];
    
    NSString *path = [NSString stringWithFormat:@"%@/topic/user_collect",KURL];
    
    NSDictionary *header = @{@"token":UTOKEN};
    NSDictionary *dic = @{@"answer_id":model.ID};
    
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    __weak typeof(self) weakSelf = self;
    
    [HttpRequest POSTWithHeader:header url:path parameters:dic success:^(id  _Nullable responseObject) {
        
        [MBProgressHUD hideHUDForView:weakSelf.view animated:YES];
        
        if ([responseObject[@"code"] integerValue] == 200) {
            [ViewHelps showHUDWithText:responseObject[@"message"]];
            
            if ([model.is_collect integerValue]==0) {
                
                model.collect_num = [NSString stringWithFormat:@"%ld",[model.collect_num integerValue]+1];
            }else{
                
                model.collect_num = [NSString stringWithFormat:@"%ld",[model.collect_num integerValue]-1];
            }
            
            model.is_collect = [model.is_collect integerValue]==0?@"1":@"0";
            
            [weakSelf.dataArr replaceObjectAtIndex:indexPath.row withObject:model];
            [weakSelf.tmpTableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:(UITableViewRowAnimationNone)];
            
        }
        else{
            
            [ViewHelps showHUDWithText:responseObject[@"message"]];
        }
        
        
    } failure:^(NSError * _Nullable error) {
        
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        [RequestSever showMsgWithError:error];
    }];
    
    
}

- (void)adoptWithCell:(TopicCommentTableViewCell *)cell{
    LOGIN
    NSIndexPath *indexPath = [self.tmpTableView indexPathForCell:cell];
    TopicCommentModel *model = self.dataArr[indexPath.row];
    
    NSString *path = [NSString stringWithFormat:@"%@/topic/set_best_answer",KURL];
    
    NSDictionary *header = @{@"token":UTOKEN};
    NSDictionary *dic = @{@"answer_id":model.ID};
    
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    __weak typeof(self) weakSelf = self;
    
    [HttpRequest POSTWithHeader:header url:path parameters:dic success:^(id  _Nullable responseObject) {
        
        [MBProgressHUD hideHUDForView:weakSelf.view animated:YES];
        
        if ([responseObject[@"code"] integerValue] == 200) {
            [ViewHelps showHUDWithText:responseObject[@"message"]];
            
            model.isBest = [model.isBest integerValue]==0?@"1":@"0";
            
            if (weakSelf.adoptIndex) {
                //把采纳的改为未采纳
                TopicCommentModel *model1 = self.dataArr[weakSelf.adoptIndex.row];
                model1.isBest = @"0";
                [weakSelf.dataArr replaceObjectAtIndex:weakSelf.adoptIndex.row withObject:model1];
                [weakSelf.tmpTableView reloadRowsAtIndexPaths:@[weakSelf.adoptIndex] withRowAnimation:(UITableViewRowAnimationNone)];
            }
           
        
            [weakSelf.dataArr replaceObjectAtIndex:indexPath.row withObject:model];
            [weakSelf.tmpTableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:(UITableViewRowAnimationNone)];
            
             weakSelf.adoptIndex = indexPath;
            
        }
        else{
            
            [ViewHelps showHUDWithText:responseObject[@"message"]];
        }
        
        
    } failure:^(NSError * _Nullable error) {
        
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        [RequestSever showMsgWithError:error];
    }];
    
}

- (void)shareWithCell:(TopicCommentTableViewCell *)cell{
    
    
}

- (void)showAllWithCell:(TopicCommentTableViewCell *)cell{
    
    NSIndexPath *indexPath = [self.tmpTableView indexPathForCell:cell];
    TopicCommentModel *model = self.dataArr[indexPath.row];
    
    model.isShow = !model.isShow;
    
    [self.dataArr replaceObjectAtIndex:indexPath.row withObject:model];
    [self.tmpTableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:(UITableViewRowAnimationNone)];
    
    [self.tmpTableView scrollToRowAtIndexPath:indexPath atScrollPosition:(UITableViewScrollPositionTop) animated:YES];
}

#pragma mark -- 事件
- (void)back{
    [self.navigationController popViewControllerAnimated:YES];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
}
- (void)share{
    
    //显示分享面板
    [UMSocialUIManager showShareMenuViewInWindowWithPlatformSelectionBlock:^(UMSocialPlatformType platformType, NSDictionary *userInfo) {
        // 根据获取的platformType确定所选平台进行下一步操作
        
        //创建分享消息对象
        UMSocialMessageObject *messageObject = [UMSocialMessageObject messageObject];
        
        //创建网页内容对象
        UMShareWebpageObject *shareObject = [UMShareWebpageObject shareObjectWithTitle:self.topicInfo[@"share_title"] descr:self.topicInfo[@"share_desc"] thumImage:self.topicInfo[@"share_img"]];
        //设置网页地址
        shareObject.webpageUrl =[NSString stringWithFormat:@"%@",self.topicInfo[@"share_url"]];
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
    NSDictionary *dic = @{@"user_id":self.topicInfo[@"user_id"],@"id":self.topicInfo[@"id"],@"type":@"6"};
    
    [HttpRequest POST:path parameters:dic success:^(id  _Nullable responseObject) {
    } failure:^(NSError * _Nullable error) {
        
    }];
    
}


- (void)participaTopic{
    LOGIN
    AddTopicCommentViewController *vc = [[AddTopicCommentViewController alloc] init];
    vc.topic_id = self.topic_id;
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)follwTopic:(UIButton *)sender{
    
    LOGIN

    NSString *path = [NSString stringWithFormat:@"%@/topic/follow_topic",KURL];
    
    NSDictionary *header = @{@"token":UTOKEN};
    
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    [HttpRequest POSTWithHeader:header url:path parameters:@{@"topic_id":self.topic_id} success:^(id  _Nullable responseObject) {
        
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        
        if ([responseObject[@"code"] integerValue] == 200) {
            
            [sender setSelected:!sender.selected];
            [ViewHelps showHUDWithText:sender.selected?@"关注成功":@"取消成功"];
            
        }
        else{
            
            [ViewHelps showHUDWithText:responseObject[@"message"]];
        }
        
        
    } failure:^(NSError * _Nullable error) {
        
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        [RequestSever showMsgWithError:error];
    }];

    
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
