//
//  AccountSecurityVC.m
//  anjuyi1
//
//  Created by 李 on 2018/6/8.
//  Copyright © 2018年 lsy. All rights reserved.
//

#import "AccountSecurityVC.h"
#import "ChangePhoneVC.h"
#import "ChangepasswordVC.h"

@interface AccountSecurityVC ()<UIScrollViewDelegate>

@property (nonatomic,strong)UIScrollView *tmpScrollView;

@end

@implementation AccountSecurityVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self setTitle:@"账号安全"];
    [self setNavigationLeftBarButtonWithImageNamed:@"ss_back"];
    
    [self.view addSubview:self.tmpScrollView];
    [self.view addSubview:[Tools setLineView:CGRectMake(0, 0, KScreenWidth, 1.5)]];
    
    [self setUpUI];
    
    
    
}

-(UIScrollView *)tmpScrollView{
    
    if (!_tmpScrollView) {
        _tmpScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, KScreenWidth, KScreenHeight)];
        [_tmpScrollView setShowsVerticalScrollIndicator:NO];
        [_tmpScrollView setShowsHorizontalScrollIndicator:NO];
        [_tmpScrollView setDelegate:self];
    }
    return _tmpScrollView;
}

- (void)setUpUI{
    
    CGFloat height = 0 ;
    
    NSArray *tArr = @[@"修改手机号",@"修改密码"];
    NSArray *dArr = @[@"13213692355",@""];
    
    for (NSInteger i = 0 ; i < 2 ; i ++) {
        UIView *backView = [[UIView alloc] initWithFrame:CGRectMake(0, height, KScreenWidth , 50)];
        [backView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapAccount:)]];
        [backView setTag:i];
        [self.tmpScrollView addSubview:backView];
        
        [backView addSubview:[Tools creatLabel:CGRectMake(10, 0, 200, 50) font:[UIFont systemFontOfSize:15] color:[UIColor blackColor] alignment:(NSTextAlignmentLeft) title:tArr[i]]];
        
        [backView addSubview:[Tools creatLabel:CGRectMake(10, 0, KScreenWidth-45, 50) font:[UIFont systemFontOfSize:15] color:[UIColor colorWithHexString:@"#666666"] alignment:(NSTextAlignmentRight) title:dArr[i]]];
        
        [backView addSubview:[Tools creatImage:CGRectMake(KScreenWidth - 25, 20, 6, 10) image:@"jilu_rili_arrow"]];
        
        [backView addSubview:[Tools setLineView:CGRectMake(10, 49, KScreenWidth - 20, 1)]];
        
        height += 50;
    }
    
    [self.tmpScrollView addSubview:[Tools setLineView:CGRectMake(0, height, KScreenWidth, 10)]];
    
    height += 20;
    
    NSArray * iArr = @[@"zhaq_wx",@"zhaq_wb",@"zhaq_qq"];

    NSArray * iTArr = @[@"微信绑定",@"微博绑定",@"QQ绑定"];
    
    for (NSInteger i = 0 ; i < 3 ; i++) {
        
        UIView *backView = [[UIView alloc] initWithFrame:CGRectMake(0, height, KScreenWidth , 60)];
        [backView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(bandAccount:)]];
        [backView setTag:i];
        [self.tmpScrollView addSubview:backView];
        
        [backView addSubview:[Tools creatImage:CGRectMake(10, 10, 40, 40) image:iArr[i]]];
        
        [backView addSubview:[Tools creatLabel:CGRectMake(60, 0, KScreenWidth - 70, 60) font:[UIFont systemFontOfSize:15] color:[UIColor blackColor] alignment:(NSTextAlignmentLeft) title:iTArr[i]]];
        
        [backView addSubview:[Tools creatLabel:CGRectMake(60, 0, KScreenWidth - 80, 60) font:[UIFont systemFontOfSize:15] color:[UIColor colorWithHexString:@"666666"] alignment:(NSTextAlignmentRight) title:@"已绑定"]];
        
        [backView addSubview:[Tools setLineView:CGRectMake(10, 59, KScreenWidth - 30, 1)]];
        
        
        height += 60;
    }

    
    UIButton *btn = [Tools creatButton:CGRectMake(10, KScreenHeight - KTopHeight - 80   , KScreenWidth - 20, 50) font:[UIFont systemFontOfSize:16] color:[UIColor whiteColor] title:@"注销该账号" image:@""];
    [btn setBackgroundColor:MDRGBA(255, 181, 0, 1)];
    [btn.layer setCornerRadius:5];
    [btn setClipsToBounds:YES];
    [btn addTarget:self action:@selector(logoutAccount) forControlEvents:(UIControlEventTouchUpInside)];
    [self.view addSubview:btn];
}

- (void)tapAccount:(UITapGestureRecognizer *)sender{
    if (sender.view.tag == 0) {
        ChangePhoneVC *cont = [[ChangePhoneVC alloc] init];
        [self.navigationController pushViewController:cont animated:YES];
    }
    else{
        ChangepasswordVC *cont = [[ChangepasswordVC alloc] init];
        [self.navigationController pushViewController:cont animated:YES];
    }
    
}

- (void)bandAccount:(UITapGestureRecognizer *)sender{
    
    
}

- (void)logoutAccount{
    
    [self creatAlertViewControllerWithMessage:@"确定要注销该账号吗？"];
}

- (void)creatAlertViewControllerWithMessage:(NSString *)message{
    
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示" message:message preferredStyle:(UIAlertControllerStyleAlert)];
    
    UIAlertAction *trueA = [UIAlertAction actionWithTitle:@"确定" style:(UIAlertActionStyleCancel) handler:^(UIAlertAction * _Nonnull action) {
        
        
        
    }];
    
    UIAlertAction *falseA = [UIAlertAction actionWithTitle:@"取消" style:(UIAlertActionStyleDefault) handler:^(UIAlertAction * _Nonnull action) {
        
        
        
    }];
    
    [alert addAction:trueA];
    
    [alert addAction:falseA];
    
    [self presentViewController:alert animated:YES completion:nil];
    
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
