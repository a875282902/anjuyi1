//
//  HouseDetailsViewController.m
//  anjuyi1
//
//  Created by apple on 2018/7/24.
//  Copyright © 2018年 lsy. All rights reserved.
//

#import "HouseDetailsViewController.h"

@interface HouseDetailsViewController ()
{
    UIButton *backBtn;
    UIButton *shareBtn;
}

@property (nonatomic,strong) UIView * navView;

@end

@implementation HouseDetailsViewController


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
 
    // Do any additional setup after loading the view.
    
    [self.view addSubview:self.navView];
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
        
        [_navView addSubview:[Tools setLineView:CGRectMake(0, KTopHeight - 1, KScreenWidth, 1)]];
    }
    return _navView;
}



#pragma mark -- 点击事件
- (void)back{
    
    [self.navigationController popViewControllerAnimated:YES];
    
}

- (void)share{
    
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
