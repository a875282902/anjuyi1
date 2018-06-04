//
//  HomeViewController.m
//  anjuyi
//
//  Created by 李 on 2018/5/29.
//  Copyright © 2018年 lsy. All rights reserved.
//

#import "HomeViewController.h"
#import "SearchView.h"
#import "HomeTableViewCell.h"

#define hederHeight MDXFrom6(55)

@interface HomeViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic,strong)UITableView     *    tmpTableView;
@property (nonatomic,strong)NSMutableArray  *    dataArr;
@property (nonatomic,strong)UIView          *    headerView;
@property (nonatomic,strong)UIView          *    footView;

@end

@implementation HomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setAutomaticallyAdjustsScrollViewInsets:NO];
    [self.view setBackgroundColor:[UIColor colorWithHexString:@"#f6f6f6"]];
    
    //搜索框
    SearchView *search = [[SearchView alloc] initWithFrame:CGRectMake(0, 0, MDXFrom6(320), 30) Title:@"整屋搜索"];
    [search addTarget:self action:@selector(jumpSearch)];
    [self.navigationItem setTitleView:search];
    
    [self setNavigationRightBarButtonWithImageNamed:@"inform"];
    
    [self.view addSubview:self.tmpTableView];
    
    [self setUpHeaderView];
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
    
    CGFloat height = MDXFrom6(10);
    
    [self.headerView addSubview:[self setImageViewWithFrame:CGRectMake(MDXFrom6(10), height, KScreenWidth - MDXFrom6(20), MDXFrom6(160)) andImageName:@"fw_al" andTag:0]];

    height += MDXFrom6(170);
    
    [self.headerView addSubview:[self setImageViewWithFrame:CGRectMake(MDXFrom6(10), height,MDXFrom6(175), MDXFrom6(150)) andImageName:@"fw_al1" andTag:1]];
    
    [self.headerView addSubview:[self setImageViewWithFrame:CGRectMake(MDXFrom6(195), height,MDXFrom6(175), MDXFrom6(150)) andImageName:@"al2" andTag:2]];
    
    height += MDXFrom6(170);
    
    UIScrollView * activityScroll = [[UIScrollView alloc] initWithFrame:CGRectMake(0, height, KScreenWidth, MDXFrom6(59))];
    [activityScroll setShowsVerticalScrollIndicator:NO];
    [activityScroll setShowsHorizontalScrollIndicator:NO];
    [activityScroll setContentSize:CGSizeMake(KScreenWidth, activityScroll.frame.size.height)];
    [self.headerView addSubview:activityScroll];
    
    //storage Charging  shop
    NSArray *arr = @[@"storage",@"Charging",@"shop"];
    for (NSInteger i = 0 ; i < 3; i++) {
        
        [activityScroll addSubview:[self setImageViewWithFrame:CGRectMake(MDXFrom6(10)+MDXFrom6(124*i), 0,MDXFrom6(114), MDXFrom6(59)) andImageName:arr[i] andTag:(i+3)]];
    }
    
    height += MDXFrom6(59)+MDXFrom6(15);
    
    [self.headerView addSubview:[self setImageViewWithFrame:CGRectMake(MDXFrom6(10), height, KScreenWidth - MDXFrom6(20), MDXFrom6(127.5)) andImageName:@"add_tu" andTag:6]];
    
    height += MDXFrom6(127.5)+MDXFrom6(10);
    
    [self.headerView setFrame:CGRectMake(0, 0, KScreenWidth, height)];
}

- (UIImageView *)setImageViewWithFrame:(CGRect)rect andImageName:(NSString *)imageName andTag:(NSInteger)tag{
    
    UIImageView * wholeHouse = [[UIImageView alloc] initWithFrame:rect];
    [wholeHouse setImage:[UIImage imageNamed:imageName]];
    [wholeHouse setUserInteractionEnabled:YES];
    [wholeHouse addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(selectActivity:)]];
    [wholeHouse setTag:tag];
    
    return wholeHouse;
}




#pragma mark -- footView
- (UIView *)footView{
    
    if (!_footView) {
        _footView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, KScreenWidth, MDXFrom6(50))];
        [_footView setBackgroundColor:[UIColor colorWithHexString:@"#f6f6f6"]];
        
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, KScreenWidth, MDXFrom6(50))];
        [label setText:@"我是有底线的~"];
        [label setTextAlignment:(NSTextAlignmentCenter)];
        [label setTextColor:[UIColor blackColor]];
        [_footView addSubview:label];
        
    }
    return _footView;
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
        [_tmpTableView setTableFooterView:self.footView];
        [_tmpTableView setDataSource:self];
        [_tmpTableView setDelegate:self];
    }
    return _tmpTableView;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    if (section == 0) {
    
        return 1;
    }
    return 20;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 1) {
        HomeTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"HomeViewControllerTableViewCell"];
        if (!cell) {
            cell = [[HomeTableViewCell alloc] initWithStyle:(UITableViewCellStyleDefault) reuseIdentifier:@"HomeViewControllerTableViewCell"];
        }
        
        return cell;
    }
    else{
        
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"HomeViewControllerTableViewCell1"];
        if (!cell) {
            cell = [[UITableViewCell alloc] initWithStyle:(UITableViewCellStyleDefault) reuseIdentifier:@"HomeViewControllerTableViewCell1"];
        }
        
        [cell setSelectionStyle:(UITableViewCellSelectionStyleNone)];
        
        [cell.contentView.subviews respondsToSelector:@selector(removeFromSuperview)];
        
        [cell.contentView addSubview:[self creatLikeView]];
        
        return cell;
    }
  
}

- (UIView *)creatLikeView{
    
    UIView *likeView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, KScreenWidth, MDXFrom6(440))];
    [likeView setBackgroundColor:[UIColor whiteColor]];
    
    UIImageView *hederImage = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, MDXFrom6(40), MDXFrom6(40))];
    [hederImage setCenter:CGPointMake(MDXFrom6(30), MDXFrom6(40))];
    [hederImage setBackgroundColor:[UIColor redColor]];
    [hederImage.layer setCornerRadius:MDXFrom6(20)];
    [hederImage setClipsToBounds:YES];
    [likeView addSubview:hederImage];
    
    [likeView addSubview:[Tools creatLabel:CGRectMake(MDXFrom6(60), MDXFrom6(20), MDXFrom6(250), MDXFrom6(20)) font:[UIFont systemFontOfSize:12] color:[UIColor colorWithHexString:@"#000000"] alignment:(NSTextAlignmentLeft) title:@"我是小房主"]];
    
    [likeView addSubview:[Tools creatLabel:CGRectMake(MDXFrom6(60), MDXFrom6(40), MDXFrom6(250), MDXFrom6(20)) font:[UIFont systemFontOfSize:10] color:[UIColor colorWithHexString:@"#999999"] alignment:(NSTextAlignmentLeft) title:@"我是小房主"]];
    
    UIButton *attention = [UIButton buttonWithType:(UIButtonTypeCustom)];
    [attention setFrame:CGRectMake(0, 0, MDXFrom6(60), MDXFrom6(25))];
    [attention setCenter:CGPointMake(KScreenWidth - MDXFrom6(40), MDXFrom6(40))];
    [attention.layer setBorderColor:[UIColor colorWithHexString:@"#E77C03"].CGColor];
    [attention.layer setCornerRadius:MDXFrom6(12.5f)];
    [attention.layer setBorderWidth:MDXFrom6(1)];
    [attention setClipsToBounds:YES];
    [attention setTitle:@"+关注" forState:(UIControlStateNormal)];
    [attention.titleLabel setFont:[UIFont systemFontOfSize:12]];
    [attention setTitleColor:[UIColor colorWithHexString:@"#E77C03"] forState:(UIControlStateNormal)];
    [attention addTarget:self action:@selector(attentionType:) forControlEvents:(UIControlEventTouchUpInside)];
    [likeView addSubview:attention];
    
    //
    UIImageView *coverImage = [[UIImageView alloc] initWithFrame:CGRectMake(MDXFrom6(10), MDXFrom6(75), KScreenWidth - MDXFrom6(20), MDXFrom6(225))];
    [coverImage setBackgroundColor:[UIColor redColor]];
    [coverImage.layer setCornerRadius:MDXFrom6(5)];
    [coverImage setClipsToBounds:YES];
    [likeView addSubview:coverImage];
    
    //
    UIView *back = [[UIView alloc] initWithFrame:CGRectMake(0, MDXFrom6(140), coverImage.frame.size.width, MDXFrom6(170))];
    [back setBackgroundColor:MDRGBA(0, 0, 0, .5)];
    [coverImage addSubview:back];
    
    [back addSubview:[Tools creatLabel:CGRectMake(MDXFrom6(10), MDXFrom6(10), back.frame.size.width - MDXFrom6(20), MDXFrom6(20)) font:[UIFont systemFontOfSize:14] color:[UIColor whiteColor] alignment:(NSTextAlignmentLeft) title:@"换新房后没钱装修"]];
    
    [back addSubview:[Tools creatLabel:CGRectMake(MDXFrom6(10), MDXFrom6(40), back.frame.size.width - MDXFrom6(20), MDXFrom6(40)) font:[UIFont systemFontOfSize:12] color:[UIColor whiteColor] alignment:(NSTextAlignmentLeft) title:@"换新房后没钱装修换新房后没钱装修换新房后没钱装修换新房后没钱装修换新房后没钱装修换新房后没钱装修换新房后没钱装修"]];
    
    // 分享
    UIButton *shareBtn = [Tools creatButton:CGRectMake(MDXFrom6(10), MDXFrom6(310), MDXFrom6(25), MDXFrom6(23)) font:[UIFont systemFontOfSize:12] color:[UIColor whiteColor] title:@"" image:@"fw"];
    [shareBtn addTarget:self action:@selector(shareToFriend) forControlEvents:(UIControlEventTouchUpInside)];
    [likeView addSubview:shareBtn];
    
    // 评论
    UIButton *commentBtn = [Tools creatButton:CGRectMake(MDXFrom6(145), MDXFrom6(310), MDXFrom6(70), MDXFrom6(23)) font:[UIFont systemFontOfSize:12] color:[UIColor colorWithHexString:@"#000000"] title:@"12312" image:@"com"];
    [commentBtn addTarget:self action:@selector(comment) forControlEvents:(UIControlEventTouchUpInside)];
    [likeView addSubview:commentBtn];
    
    //  收藏
    UIButton *likeBtn = [Tools creatButton:CGRectMake(MDXFrom6(225), MDXFrom6(310), MDXFrom6(70), MDXFrom6(23)) font:[UIFont systemFontOfSize:12] color:[UIColor colorWithHexString:@"#000000"] title:@"12312" image:@"colle"];
    [likeBtn addTarget:self action:@selector(collect) forControlEvents:(UIControlEventTouchUpInside)];
    [likeView addSubview:likeBtn];
    
    // 点赞
    UIButton *zanBtn = [Tools creatButton:CGRectMake(MDXFrom6(305), MDXFrom6(310), MDXFrom6(70), MDXFrom6(23)) font:[UIFont systemFontOfSize:12] color:[UIColor colorWithHexString:@"#000000"] title:@"999931" image:@"like"];
    [zanBtn addTarget:self action:@selector(like) forControlEvents:(UIControlEventTouchUpInside)];
    [likeView addSubview:zanBtn];
    
    [likeView addSubview:[Tools setLineView:CGRectMake(0, MDXFrom6(345), KScreenWidth, 1)]];
    
    
    UIScrollView * activityScroll = [[UIScrollView alloc] initWithFrame:CGRectMake(0, MDXFrom6(355), KScreenWidth, MDXFrom6(65))];
    [activityScroll setShowsVerticalScrollIndicator:NO];
    [activityScroll setShowsHorizontalScrollIndicator:NO];
    [activityScroll setContentSize:CGSizeMake(MDXFrom6(500), activityScroll.frame.size.height)];
    [likeView addSubview:activityScroll];
    //storage Charging  shop
    NSArray *arr = @[@"gue_bg_img",@"gue_bg_img1",@"gue_bg_img2"];
    for (NSInteger i = 0 ; i < 3; i++) {
        
        UIImageView *image =[self setImageViewWithFrame:CGRectMake(MDXFrom6(10)+MDXFrom6(130*i), 0,MDXFrom6(120), MDXFrom6(65)) andImageName:arr[i] andTag:(i+100)];
        [activityScroll addSubview:image];
        
        [image addSubview:[Tools creatLabel:CGRectMake(0, 0, MDXFrom6(120), MDXFrom6(65)) font:[UIFont systemFontOfSize:12] color:[UIColor blackColor] alignment:(NSTextAlignmentCenter) title:@"验收毛培f昂\n需要注意哪些问题"]];
    }
    
    return likeView;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 1) {
        return 120;
    }
    if (indexPath.section == 0) {
        return MDXFrom6(440);
    }
    
    return 0;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    
    if (section == 0) {
        
        UIView *header = [[UIView alloc] initWithFrame:CGRectMake(0, 0, KScreenWidth, hederHeight)];
        [header setBackgroundColor:[UIColor whiteColor]];
    
        [header addSubview:[Tools setLineView:CGRectMake(0, 0, KScreenWidth, MDXFrom6(10))]];
        
        [header addSubview:[self setImageViewWithFrame:CGRectMake(MDXFrom6(10), MDXFrom6(27.5), MDXFrom6(2), MDXFrom6(10)) andImageName:@"guess_kike" andTag:10001]];
        [header addSubview:[Tools creatLabel:CGRectMake(MDXFrom6(22), MDXFrom6(10), MDXFrom6(300), MDXFrom6(45)) font:[UIFont systemFontOfSize:10] color:[UIColor colorWithHexString:@"#999999"] alignment:(NSTextAlignmentLeft) title:@"猜你喜欢  有色墙"]];
        [header addSubview:[self setImageViewWithFrame:CGRectMake(MDXFrom6(357), MDXFrom6(30), MDXFrom6(8), MDXFrom6(5)) andImageName:@"guess_xjt" andTag:10002]];
        [header addSubview:[Tools setLineView:CGRectMake(0, hederHeight-1, KScreenWidth, 1)]];
        [header addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(selectLikeType:)]];
        return header;
        
    }
    else if (section == 1){
        UIView *header = [[UIView alloc] initWithFrame:CGRectMake(0, 0, KScreenWidth, hederHeight)];
        [header setBackgroundColor:[UIColor whiteColor]];
        
        [header addSubview:[Tools setLineView:CGRectMake(0, 0, KScreenWidth, MDXFrom6(10))]];
        
        [header addSubview:[self setImageViewWithFrame:CGRectMake(MDXFrom6(10), MDXFrom6(22.5), MDXFrom6(20), MDXFrom6(20)) andImageName:@"recom" andTag:10003]];
        [header addSubview:[Tools creatLabel:CGRectMake(MDXFrom6(40), MDXFrom6(10), MDXFrom6(300), MDXFrom6(45)) font:[UIFont systemFontOfSize:16] color:[UIColor colorWithHexString:@"#000000"] alignment:(NSTextAlignmentLeft) title:@"推荐商品"]];

        [header addSubview:[Tools creatLabel:CGRectMake(MDXFrom6(0), MDXFrom6(10), MDXFrom6(365), MDXFrom6(45)) font:[UIFont systemFontOfSize:14] color:[UIColor colorWithHexString:@"#666666"] alignment:(NSTextAlignmentRight) title:@"查看更多 〉"]];
        [header addSubview:[Tools setLineView:CGRectMake(0, hederHeight-1, KScreenWidth, 1)]];
        [header addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(moreShop)]];
        return header;
        
    }
    return [[UIView alloc] init];
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    
    if (section == 0) {
        return hederHeight;
    }
    else if (section == 1){
        
        return hederHeight;
    }
    return 0;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
}

#pragma mark -- click
//跳转到搜索页
- (void)jumpSearch{
    
    
}

- (void)selectActivity:(UITapGestureRecognizer *)sender{
    
    switch (sender.view.tag) {
        case 0://整屋案例
            {
                
            }
            break;
            
        case 1://话题
        {
            
            
        }
            break;
            
        case 2://活动精选
        {
            
            
        }
            break;
            
        default:
            break;
    }
    
}
//选择 喜欢类型
- (void)selectLikeType:(UITapGestureRecognizer *)sender{
    
    CGRect rect = [sender.view convertRect: sender.view.bounds toView:self.view];
    
    NSLog(@"%@",NSStringFromCGRect(rect));
    
}
//更多商品
- (void)moreShop{
    
    
}

//关注
- (void)attentionType:(UIButton *)sender{
    
    
    
}
//分享
- (void)shareToFriend{
    
    
}

//评论
- (void)comment{
    
    
}
//收藏
- (void)collect{
    
}

//点赞
- (void)like{
    
    
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