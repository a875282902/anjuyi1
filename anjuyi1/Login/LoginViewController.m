//
//  LoginViewController.m
//  anjuyi1
//
//  Created by apple on 2018/6/13.
//  Copyright © 2018年 lsy. All rights reserved.
//
//  登录页面

#import "LoginViewController.h"
#import "RootViewController.h"
#import "RegisterViewController.h"

@interface LoginViewController ()
{
    NSString *userName;
    NSString *password;
}

@end

@implementation LoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleDefault;
    [self.navigationController.navigationBar setHidden:YES];
    
    [self.view setBackgroundColor:[UIColor whiteColor]];
    
    [self setUpUI];
     
}

- (void)setUpUI{
    
    UIButton *registerb = [Tools creatButton:CGRectMake(MDXFrom6(35), KStatusBarHeight + MDXFrom6(30), MDXFrom6(60), MDXFrom6(30))  font:[UIFont systemFontOfSize:16] color:[UIColor colorWithHexString:@"#e9c700"] title:@"注册" image:@""];
    [registerb setContentHorizontalAlignment:(UIControlContentHorizontalAlignmentLeft)];
    [registerb.titleLabel setTextAlignment:(NSTextAlignmentLeft)];
    [registerb addTarget:self action:@selector(jumpRegister) forControlEvents:(UIControlEventTouchUpInside)];
    [self.view addSubview:registerb];
    CGFloat height = KStatusBarHeight + MDXFrom6(90);
    
    
    [self.view addSubview:[Tools creatLabel:CGRectMake(MDXFrom6(35), height, KScreenWidth - MDXFrom6(70), 22) font:[UIFont systemFontOfSize:21] color:[UIColor blackColor] alignment:(NSTextAlignmentLeft) title:@"欢迎回来"]];
    
    height += 50;
    
    [self.view addSubview:[Tools creatLabel:CGRectMake(MDXFrom6(35), height, MDXFrom6(45), 30) font:[UIFont systemFontOfSize:16] color:[UIColor colorWithHexString:@"#3b3b3b"] alignment:(NSTextAlignmentLeft) title:@"+86"]];
    
    UITextField *userName = [[UITextField alloc] initWithFrame:CGRectMake(MDXFrom6(90), height, MDXFrom6(250), 30)];
    [userName setPlaceholder:@"手机号码"];
    [userName setFont:[UIFont systemFontOfSize:16]];
    [userName setClearButtonMode:(UITextFieldViewModeAlways)];
    [userName setKeyboardType:(UIKeyboardTypeNumberPad)];
    [userName setTag:1];
    [userName addTarget:self action:@selector(textValueChange:) forControlEvents:(UIControlEventEditingChanged)];
    [self.view addSubview:userName];

    
    height += 30;
    
    [self.view addSubview:[self creatLine:CGRectMake(MDXFrom6(35), height, MDXFrom6(305), 1)]];
    
    UIView *v = [[UIView alloc] initWithFrame:CGRectMake(MDXFrom6(85), height, MDXFrom6(10), 1)];
    [v setBackgroundColor:[UIColor whiteColor]];
    [self.view addSubview:v];
    
    height += 30;
    
    UITextField *passWord = [[UITextField alloc] initWithFrame:CGRectMake(MDXFrom6(35), height, MDXFrom6(305), 30)];
    [passWord setPlaceholder:@"密码"];
    [passWord setFont:[UIFont systemFontOfSize:16]];
    [passWord setClearButtonMode:(UITextFieldViewModeAlways)];
    [passWord setSecureTextEntry:YES];
    [passWord setTag:2];
    [passWord addTarget:self action:@selector(textValueChange:) forControlEvents:(UIControlEventEditingChanged)];
    [self.view addSubview:passWord];
    
    height += 30;
    [self.view addSubview:[self creatLine:CGRectMake(MDXFrom6(35), height, MDXFrom6(305), 1)]];
    
    height += 40;

    UIButton *btn = [Tools creatButton:CGRectMake(MDXFrom6(35), height, KScreenWidth - MDXFrom6(70), MDXFrom6(50)) font:[UIFont systemFontOfSize:18] color:[UIColor whiteColor] title:@"登录" image:@""];
    [btn setBackgroundColor:[UIColor colorWithHexString:@"#ffb638"]];
    [btn.layer setCornerRadius:5];
    [btn setClipsToBounds:YES];
    [btn addTarget:self action:@selector(login) forControlEvents:(UIControlEventTouchUpInside)];
    [self.view addSubview:btn];
    
    height += MDXFrom6(80);
    
    [self.view addSubview:[Tools creatImage:CGRectMake(MDXFrom6(110.5), height, MDXFrom6(154), MDXFrom6(33)) image:@"ajy_logo"]];
    
    [self.view addSubview:[Tools creatLabel:CGRectMake(MDXFrom6(35), KScreenHeight - 80, MDXFrom6(200), 30) font:[UIFont systemFontOfSize:14] color:[UIColor colorWithHexString:@"#3b3b3b"] alignment:(NSTextAlignmentLeft) title:@"使用社交账号登录"]];
    
//    dl_wx dl_qq
    
    UIButton *wxLogin = [Tools creatButton:CGRectMake(MDXFrom6(240), KScreenHeight - 80 - MDXFrom6(10), MDXFrom6(53), MDXFrom6(53)) font:[UIFont systemFontOfSize:1] color:[UIColor blackColor] title:@"" image:@"dl_wx"];
    [wxLogin addTarget:self action:@selector(wxLogin:) forControlEvents:(UIControlEventTouchUpInside)];
    [self.view addSubview:wxLogin];
    
    UIButton *qqLogin = [Tools creatButton:CGRectMake(MDXFrom6(300), KScreenHeight - 80 - MDXFrom6(10), MDXFrom6(53), MDXFrom6(53)) font:[UIFont systemFontOfSize:1] color:[UIColor blackColor] title:@"" image:@"dl_qq"];
    [self.view addSubview:qqLogin];
    
    
    
}

- (UIView *)creatLine:(CGRect)rect{
    
    UIView *v = [[UIView alloc] initWithFrame:rect];
    [v setBackgroundColor:[UIColor colorWithHexString:@"#d1d1d1"]];
    return v;
}

- (void)jumpRegister{
    
    if (self.navigationController.viewControllers.count > 1) {
        [self.navigationController popViewControllerAnimated:YES];
    }
    else{
        RegisterViewController *cont = [[RegisterViewController alloc] init];
        [self.navigationController pushViewController:cont animated:YES];
    }
}

- (void)textValueChange:(UITextField *)sender{// tag 1 为账号  2 为密码
    
    if (sender.tag == 1) {
        userName = sender.text;
    }
    
    if (sender.tag == 2) {
        password = sender.text;
    }
}

- (void)login{
    
    if (userName.length != 11) {
        [ViewHelps showHUDWithText:@"请输入手机号码"];
        return;
    }
    
    if (password.length < 6) {
        [ViewHelps showHUDWithText:@"请输入密码"];
        return;
    }
    
    NSString *path = [NSString stringWithFormat:@"%@/login/login",KURL];
    
    NSDictionary *dic = @{@"mobile":userName,@"password":password};
    
    [MBProgressHUD showHUDAddedTo:self.view animated:YES].label.text = @"登录中···";
    
    [HttpRequest POST:path parameters:dic success:^(id  _Nullable responseObject) {
        
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        
        if ([responseObject[@"code"] integerValue] == 200) {
            [[NSUserDefaults standardUserDefaults] setValue:responseObject[@"datas"][@"token"] forKey:@"UTOKEN"];
            
            [self dismissViewControllerAnimated:YES completion:nil];
        }
        else{
            
            [ViewHelps showHUDWithText:responseObject[@"message"]];
        }
        
    } failure:^(NSError * _Nullable error) {
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        [RequestSever showMsgWithError:error];
    }];
}

- (void)wxLogin:(UIButton *)sender{
    
    [self dismissViewControllerAnimated:YES completion:nil];
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
