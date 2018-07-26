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

@interface MyPushHouseDetailsViewController ()<UIScrollViewDelegate>
{
    UIButton *backBtn;
    UIButton *shareBtn;
    UIImageView *headerBackImage;
}

@property (nonatomic,strong)UIScrollView     *  tmpScrollView;
@property (nonatomic,strong)UIView           *  navView;
@property (nonatomic,strong)HouseCommentView *  commentV;
@property (nonatomic,strong)UIView           *  infoView;
@property (nonatomic,strong)UIView           *  contentView;
@property (nonatomic,strong)UIView           *  commentView;

@end

@implementation MyPushHouseDetailsViewController

- (void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:animated];
    [IQKeyboardManager sharedManager].enableAutoToolbar = NO;
    [IQKeyboardManager sharedManager].shouldResignOnTouchOutside = YES;
    [self setNavigationLeftBarButtonWithImageNamed:@""];
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
    
    [self.view addSubview:self.tmpScrollView];
    [self.view addSubview:self.commentV];
    
}

#pragma mark --  UI

-(UIScrollView *)tmpScrollView{
    
    if (!_tmpScrollView) {
        _tmpScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, KScreenWidth, KViewHeight)];
        [_tmpScrollView setShowsVerticalScrollIndicator:NO];
        [_tmpScrollView setShowsHorizontalScrollIndicator:NO];
        [_tmpScrollView setDelegate:self];
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


- (HouseCommentView *)commentV{
    
    if (!_commentV) {
        _commentV = [[HouseCommentView alloc] initWithFrame:CGRectMake(0, 0, KScreenWidth, KScreenHeight)];
        [_commentV setHouse_id:self.house_id];
    }
    return _commentV;
}

- (UIView *)infoView{
    
    if (!_infoView) {
        _infoView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, KScreenWidth, 1)];
    }
    return _infoView;
}

- (UIView *)commentView{
    
    if (!_commentView) {
        _commentView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, KScreenWidth, 1)];
    }
    return _commentView;
}

- (UIView *)contentView{
    
    if (!_contentView) {
        _contentView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, KScreenWidth, 1)];
    }
    return _contentView;
}

- (void)createHouseInfo{
    
    [self.infoView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    
    CGFloat height = 0;
   
    [self.infoView addSubview:[Tools creatImage:CGRectMake(0, 0, KScreenWidth,  572*KScreenWidth/750.0) image:@"designer_case"]];

}

- (void)refreScrollViewFrame{
    
    [UIView animateWithDuration:.2 animations:^{
        
        [self.contentView setFrame:CGRectMake(0, self.infoView.frame.size.height, KScreenWidth, self.contentView.frame.size.height)];
        
        [self.commentView setFrame:CGRectMake(0, self.infoView.frame.size.height+self.contentView.frame.size.height, KScreenWidth, self.commentView.frame.size.height)];
    }];
    
}

#pragma mark -- 点击事件
- (void)back{
    
    [self.navigationController popViewControllerAnimated:YES];
    
}

- (void)share{
    
}

- (void)checkMoreComment{
    
    [self.commentV openDisplay];
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
