//
//  PhotoDetailsViewController.m
//  anjuyi1
//
//  Created by apple on 2018/7/25.
//  Copyright © 2018年 lsy. All rights reserved.
//

#import "PhotoDetailsViewController.h"
#import "PhotoCommentView.h"
#import <IQKeyboardManager.h>
#import "SpaceImageTableViewCell.h"
#import "HouseCommentTableViewCell.h"
#import "CommentModel.h"

#import "CommentDetalisViewController.h"

@interface PhotoDetailsViewController ()<UITableViewDelegate,UITableViewDataSource>
{
    UIButton *backBtn;
    UIButton *shareBtn;
    UIImageView *headerBackImage;
}

@property (nonatomic,strong)UIView               *  navView;
@property (nonatomic,strong)PhotoCommentView     *  commentV;
@property (nonatomic,strong)UIView               *  infoView;
@property (nonatomic,strong)UIView               *  footView;
@property (nonatomic,strong)UIView               *  functionBar;

@property (nonatomic,strong)NSMutableDictionary  *  photoInfo;
@property (nonatomic,strong)UITableView          *  tmpTableView;
@property (nonatomic,strong)NSMutableArray       *  commentArr;//评论数组

@end

@implementation PhotoDetailsViewController

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
    [self getphotoInfo];
    
    [self.view addSubview:self.navView];
    [self.view addSubview:self.functionBar];
    [self.view addSubview:self.commentV];
}

- (void)getphotoInfo{
    
    NSString *path = [NSString stringWithFormat:@"%@/Index/image_detail",KURL];
    
    NSDictionary *parameter = @{@"id":self.photo_id};
    
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    __weak typeof(self) weakSelf = self;
    
    [HttpRequest POST:path parameters:parameter success:^(id  _Nullable responseObject) {
        
        [MBProgressHUD hideHUDForView:weakSelf.view animated:YES];
        [weakSelf.commentArr removeAllObjects];
        if ([responseObject[@"code"] integerValue] == 200) {
            
            weakSelf.photoInfo = [NSMutableDictionary dictionaryWithDictionary:responseObject[@"datas"]];
            
            [weakSelf createphotoInfo];
            
            for (NSDictionary *dic in weakSelf.photoInfo[@"evaluate_list"]) {
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


- (PhotoCommentView *)commentV{
    
    if (!_commentV) {
        _commentV = [[PhotoCommentView alloc] initWithFrame:CGRectMake(0, 0, KScreenWidth, KScreenHeight)];
        
        WKSELF;
        
        [_commentV setSelectCommentDetails:^(NSString *eva_id) {
           
            CommentDetalisViewController *vc = [[CommentDetalisViewController alloc] init];
            vc.eva_id = eva_id;
            vc.type = 1;
            [weakSelf.navigationController pushViewController:vc animated:YES];
            
        }];
        [_commentV setPhoto_id:self.photo_id];
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
        _functionBar = [[UIView alloc] initWithFrame:CGRectMake(0, KScreenHeight - 50, KScreenWidth, 50)];
        [_functionBar addSubview:[Tools setLineView:CGRectMake(0, 0, KScreenWidth, 2)]];
    }
    return _functionBar;
}


- (void)createphotoInfo{
    
    [self.infoView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    
    CGFloat height = 0;
    
    headerBackImage  = [Tools creatImage:CGRectMake(0, 0, KScreenWidth,  750.0*KScreenWidth/750.0)  url:self.photoInfo[@"cover"] image:@""];
    [self.infoView addSubview:headerBackImage];
    
    height += 750.0*KScreenWidth/750.0 + 20;
    
    UIImageView *header = [Tools creatImage:CGRectMake(20, height+20, 43, 43) url:self.photoInfo[@"member_info"][@"head"] image:@""];
    [header.layer setCornerRadius:21.5];
    [self.infoView addSubview:header];
    
    NSString *name = self.photoInfo[@"member_info"][@"nickname"];
    CGFloat nameW = KHeight(name, 10000, 20, 18).size.width + 20;
    
    [self.infoView addSubview:[Tools creatLabel:CGRectMake(65,  height+20 ,nameW , 25) font:[UIFont systemFontOfSize:18] color:[UIColor blackColor] alignment:(NSTextAlignmentLeft) title:name]];
    
    UILabel *typeLabel = [Tools creatLabel:CGRectMake(65+ nameW, height+22.5 , 50, 20) font:[UIFont systemFontOfSize:12] color:[UIColor colorWithHexString:@"#fffefe"] alignment:(NSTextAlignmentCenter) title:self.photoInfo[@"member_info"][@"level"]];
    [typeLabel.layer setCornerRadius:5];
    [typeLabel setBackgroundColor:[UIColor colorWithHexString:@"#5cc6c6"]];
    [self.infoView addSubview:typeLabel];
    
    [self.infoView addSubview:[Tools creatLabel:CGRectMake(65,height+ 45 ,KScreenWidth - 75 , 20) font:[UIFont systemFontOfSize:12] color:[UIColor colorWithHexString:@"#999999"] alignment:(NSTextAlignmentLeft) title:self.photoInfo[@"member_info"][@"position"]]];
    
    UIButton *attentionbtn = [Tools creatButton:CGRectMake(KScreenWidth - 110, height+25, 90, 33) font:[UIFont systemFontOfSize:16] color:[UIColor colorWithHexString:@"#5cc6c6"] title:@"关注" image:@""];
    [attentionbtn setBackgroundColor:MDRGBA(219, 245, 245, 1)];
    [attentionbtn.layer setCornerRadius:16.5];
    [attentionbtn setTitle:@"已关注" forState:(UIControlStateSelected)];
    [attentionbtn setSelected:[self.photoInfo[@"is_follow"] integerValue]==0?NO:YES];
    [attentionbtn addTarget:self action:@selector(attentionToAuthor:) forControlEvents:(UIControlEventTouchUpInside)];
    [self.infoView addSubview:attentionbtn];
    
    
    height += 83+15;
    
    [self.infoView addSubview:[Tools creatLabel:CGRectMake(15, height, KScreenWidth - 30, 50) font:[UIFont systemFontOfSize:19] color:[UIColor blackColor] alignment:(NSTextAlignmentLeft) title:self.photoInfo[@"content"]]];
    
    height += 50 + 10;
    
    UIButton *time = [Tools creatButton:CGRectMake(15, height, KScreenWidth - 30, 12) font:[UIFont systemFontOfSize:12] color:[UIColor colorWithHexString:@"#666666"] title:[NSString stringWithFormat:@"   发布于 %@",self.photoInfo[@"create_time"]] image:@"xq_time"];
    [time setContentHorizontalAlignment:(UIControlContentHorizontalAlignmentLeft)];
    [self.infoView addSubview:time];
    
    height += 12 + 10;
    
    height = [self setUpLabelView:height];
    
    [self.infoView addSubview:[Tools setLineView:CGRectMake(15, height, KScreenWidth - 30, 1)]];
    
    [self.infoView setFrame:CGRectMake(0, 0, KScreenWidth, height)];
}

- (CGFloat)setUpLabelView:(CGFloat)height{
    CGFloat x = 15.0f;
    CGFloat y = 20.0f+height;
    CGFloat w = 0;
    CGFloat h = 30.0f;
    
    NSArray *arr = self.photoInfo[@"tag_list"];
    
    
    for (NSInteger i = 0 ; i < arr.count ; i ++) {
        
        NSString *str = [NSString stringWithFormat:@"#%@",arr[i]];
        
        NSAttributedString *atts = [[NSAttributedString alloc] initWithString:str];
        
        CGRect rext = [atts boundingRectWithSize:CGSizeMake(10000, 30) options:(NSStringDrawingUsesFontLeading|NSStringDrawingUsesLineFragmentOrigin) context:nil];
        
        w = rext.size.width + 20.0f;
        
        if (w+x > KScreenWidth) {
            y += 40.f;
            x = 15.0f;
        }
        
        UIButton *btn = [Tools creatButton:CGRectMake(x, y, w, h) font:[UIFont systemFontOfSize:14] color:[UIColor colorWithHexString:@"#2cb7b5"] title:str image:@""];
        [btn setBackgroundColor:[UIColor colorWithHexString:@"#eaf8f8"]];
        [btn.layer setBorderWidth:1];
        [btn.layer setBorderColor:[UIColor colorWithHexString:@"#34bab8"].CGColor];
        [btn.layer setCornerRadius:5];
        [btn setClipsToBounds:YES];
        [btn setTag:i];
        [self.infoView addSubview:btn];
        
        x += w+ 10.0f;
        
    }
    
    
    
    return y+40.0f;
}

- (void)createFootView{
    
    [self.footView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    if (self.commentArr.count == 0) {
        [self.footView setFrame:CGRectMake(0, 0, KScreenWidth, 0.001)];
        
    }
    else{
        
        [self.footView setFrame:CGRectMake(0, 0, KScreenWidth, 80)];
        
        UIButton *btn = [Tools creatButton:CGRectMake(30, 20, KScreenWidth-60, 40) font:[UIFont systemFontOfSize:16] color:[UIColor colorWithHexString:@"#666666"] title:[NSString stringWithFormat:@"查看全部%@条评论",self.photoInfo[@"evaluate_num"]] image:@""];
        [btn addTarget:self action:@selector(checkMoreComment) forControlEvents:(UIControlEventTouchUpInside)];
        [self.footView addSubview:btn];
        
        [self.footView addSubview:[Tools setLineView:CGRectMake(0, 79, KScreenWidth, 1)]];
    }
}

- (void)createFunctionBar{
    
    UIButton *zanbutton = [Tools creatButton:CGRectMake(KScreenWidth - 70, 10, 70, 30) font:[UIFont systemFontOfSize:15] color:[UIColor colorWithHexString:@"#666666"] title:[NSString stringWithFormat:@" %@",self.photoInfo[@"zan_num"]] image:@"like"];
    [zanbutton setImage:[UIImage imageNamed:@"like_xz"] forState:(UIControlStateSelected)];
    [zanbutton setSelected:[self.photoInfo[@"is_zan"] integerValue]==0?NO:YES];
    [zanbutton addTarget:self action:@selector(likeThisHouse:) forControlEvents:(UIControlEventTouchUpInside)];
    [self.functionBar addSubview:zanbutton];
    
    UIButton *collectbutton = [Tools creatButton:CGRectMake(KScreenWidth - 140, 10, 70, 30) font:[UIFont systemFontOfSize:15] color:[UIColor colorWithHexString:@"#666666"] title:[NSString stringWithFormat:@" %@",self.photoInfo[@"collect_num"]] image:@"colle"];
    [collectbutton setImage:[UIImage imageNamed:@"colle_xz"] forState:(UIControlStateSelected)];
    [collectbutton setSelected:[self.photoInfo[@"is_collect"] integerValue]==0?NO:YES];
    [collectbutton addTarget:self action:@selector(collectThisHouse:) forControlEvents:(UIControlEventTouchUpInside)];
    [self.functionBar addSubview:collectbutton];
    
    UIView *backView = [[UIView alloc] initWithFrame:CGRectMake(15, 10, KScreenWidth - 160, 30)];
    [backView setBackgroundColor:MDRGBA(242, 242, 242, 1)];
    [backView.layer setCornerRadius:5];
    [backView setClipsToBounds:YES];
    [self.functionBar addSubview:backView];
    
    [backView addSubview:[Tools creatLabel:CGRectMake(10, 0, KScreenWidth - 150, 30) font:[UIFont systemFontOfSize:14] color:MDRGBA(185, 185, 185, 1) alignment:(NSTextAlignmentLeft) title:@"留下你的意见，让房子更加美丽。"]];
    
    [backView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(commentThisHouse)]];
}

#pragma mark -- tableView
- (UITableView *)tmpTableView{
    
    if (!_tmpTableView) {
        _tmpTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, KScreenWidth, KScreenHeight - 50) style:(UITableViewStyleGrouped)];
        [_tmpTableView setSeparatorStyle:(UITableViewCellSeparatorStyleNone)];
        if (@available(iOS 11.0, *)) {
            [_tmpTableView setContentInsetAdjustmentBehavior:(UIScrollViewContentInsetAdjustmentNever)];
        }
        [_tmpTableView setBackgroundColor:[UIColor whiteColor]];
        [_tmpTableView setRowHeight:UITableViewAutomaticDimension];
        [_tmpTableView setShowsVerticalScrollIndicator:NO];
        [_tmpTableView setShowsHorizontalScrollIndicator:NO];
        [_tmpTableView setTableHeaderView:self.infoView];
        [_tmpTableView setTableFooterView:self.footView];
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
        
        [cell bandDataWith:self.commentArr[indexPath.row]];
    }
    return cell;
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    CommentModel *model = self.commentArr[indexPath.row];
    
    CommentDetalisViewController *vc = [[CommentDetalisViewController alloc] init];
    vc.eva_id = model.commit_id;
    vc.type = 1;
    [self.navigationController pushViewController:vc animated:YES];
    
}

#pragma mark -- 点击事件
- (void)back{
    
    [self.navigationController popViewControllerAnimated:YES];
    
}

- (void)share{

}


// 关注
- (void)attentionToAuthor:(UIButton *)sender{
    
    if (!sender.selected) {
        [self attention:[NSString stringWithFormat:@"%@/follow/insert_follow",KURL] btn:sender];
    }
    else{
        [self attention:[NSString stringWithFormat:@"%@/Follow/cancel_follow",KURL] btn:sender];
    }
    
}

- (void)attention:(NSString *)path btn:(UIButton *)sender{
    LOGIN
    NSDictionary *header = @{@"token":UTOKEN};
    NSDictionary *dic = @{@"user_id":self.photoInfo[@"member_info"][@"user_id"]};
    
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
    [self.commentV addComment];
}

- (void)collectThisHouse:(UIButton *)sender{
    LOGIN
    NSString *path = [NSString stringWithFormat:@"%@/MemberImage/member_collect",KURL];
    
    NSDictionary *header = @{@"token":UTOKEN};
    NSDictionary *dic = @{@"id":self.photo_id};
    
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    __weak typeof(self) weakSelf = self;
    
    [HttpRequest POSTWithHeader:header url:path parameters:dic success:^(id  _Nullable responseObject) {
        
        [MBProgressHUD hideHUDForView:weakSelf.view animated:YES];
        
        if ([responseObject[@"code"] integerValue] == 200) {
            [ViewHelps showHUDWithText:@"收藏成功"];
            [sender setTitle:[NSString stringWithFormat:@" %ld",[sender.titleLabel.text integerValue] + 1] forState:(UIControlStateNormal)];
            [sender setSelected:YES];
        }
        else if ([responseObject[@"code"] integerValue] == 201){
            [sender setTitle:[NSString stringWithFormat:@" %ld",[sender.titleLabel.text integerValue] - 1] forState:(UIControlStateNormal)];
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
    NSString *path = [NSString stringWithFormat:@"%@/MemberImage/member_zan",KURL];
    
    NSDictionary *header = @{@"token":UTOKEN};
    NSDictionary *dic = @{@"id":self.photo_id};
    
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    __weak typeof(self) weakSelf = self;
    
    [HttpRequest POSTWithHeader:header url:path parameters:dic success:^(id  _Nullable responseObject) {
        
        [MBProgressHUD hideHUDForView:weakSelf.view animated:YES];
        
        if ([responseObject[@"code"] integerValue] == 200) {
            [ViewHelps showHUDWithText:@"点赞成功"];
            [sender setTitle:[NSString stringWithFormat:@" %ld",[sender.titleLabel.text integerValue] + 1] forState:(UIControlStateNormal)];
            [sender setSelected:YES];
        }
        else if ([responseObject[@"code"] integerValue] == 201){
            [sender setTitle:[NSString stringWithFormat:@" %ld",[sender.titleLabel.text integerValue] - 1] forState:(UIControlStateNormal)];
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
