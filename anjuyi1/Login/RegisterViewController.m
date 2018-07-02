//
//  LoginViewController.m
//  anjuyi1
//
//  Created by apple on 2018/6/13.
//  Copyright © 2018年 lsy. All rights reserved.
//
//  注册页面
//  怎么修改不懂呢

#import "RegisterViewController.h"
#import "RootViewController.h"
#import "LoginViewController.h"
#import "SetPasswordVC.h"

@interface RegisterViewController ()
{
    UIButton *codeBtn;
    NSInteger time;
    NSString *userNames;
    NSString *passwords;
}

@property (nonatomic,strong)NSTimer *timer;


@end

@implementation RegisterViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self.navigationController.navigationBar setHidden:YES];
    
    [self.view setBackgroundColor:[UIColor whiteColor]];
    
    userNames = @"";
    passwords = @"";
    
    [self setUpUI];
    
}

- (void)setUpUI{
    
    UIButton *registerb = [Tools creatButton:CGRectMake(MDXFrom6(35), KStatusBarHeight + MDXFrom6(30), MDXFrom6(60), MDXFrom6(30))  font:[UIFont systemFontOfSize:16] color:[UIColor colorWithHexString:@"#e9c700"] title:@"登录" image:@""];
    [registerb setContentHorizontalAlignment:(UIControlContentHorizontalAlignmentLeft)];
    [registerb.titleLabel setTextAlignment:(NSTextAlignmentLeft)];
    [registerb addTarget:self action:@selector(jumpLogin) forControlEvents:(UIControlEventTouchUpInside)];
    [self.view addSubview:registerb];
    
    CGFloat height = KStatusBarHeight + MDXFrom6(90);
    
    
    [self.view addSubview:[Tools creatLabel:CGRectMake(MDXFrom6(35), height, KScreenWidth - MDXFrom6(70), 22) font:[UIFont systemFontOfSize:21] color:[UIColor blackColor] alignment:(NSTextAlignmentLeft) title:@"欢迎入住"]];
    
    height += 50;
    
    [self.view addSubview:[Tools creatLabel:CGRectMake(MDXFrom6(35), height, MDXFrom6(45), 30) font:[UIFont systemFontOfSize:16] color:[UIColor colorWithHexString:@"#3b3b3b"] alignment:(NSTextAlignmentLeft) title:@"+86"]];
    
    
    // ----  手机号码
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
    
    
    // ----  验证码
    UITextField *passWord = [[UITextField alloc] initWithFrame:CGRectMake(MDXFrom6(35), height, MDXFrom6(305), 30)];
    [passWord setPlaceholder:@"验证码"];
    [passWord setFont:[UIFont systemFontOfSize:16]];
    [passWord setTag:2];
    [passWord setKeyboardType:(UIKeyboardTypeNumberPad)];
    [passWord addTarget:self action:@selector(textValueChange:) forControlEvents:(UIControlEventEditingChanged)];
    [self.view addSubview:passWord];
    
    
    
    UIButton *codeBtn1 = [Tools creatButton:CGRectMake(KScreenWidth - 130, height -2.5, 95, 35) font:[UIFont systemFontOfSize:15] color:[UIColor whiteColor] title:@"获取验证码" image:@""];
    [codeBtn1 setBackgroundColor:BTNCOLOR];
    [codeBtn1.layer setCornerRadius:5];
    [codeBtn1 setClipsToBounds:YES];
    [codeBtn1 setTag:1];
    [codeBtn1 addTarget:self action:@selector(getCode:) forControlEvents:(UIControlEventTouchUpInside)];
    [self.view addSubview:codeBtn1];
    
    codeBtn = codeBtn1;
    
    height += 40;
    [self.view addSubview:[self creatLine:CGRectMake(MDXFrom6(35), height, MDXFrom6(305), 1)]];
    
    height += 40;
    
    UIButton *btn = [Tools creatButton:CGRectMake(MDXFrom6(35), height, KScreenWidth - MDXFrom6(70), MDXFrom6(50)) font:[UIFont systemFontOfSize:18] color:[UIColor whiteColor] title:@"立即注册" image:@""];
    [btn setBackgroundColor:BTNCOLOR];
    [btn.layer setCornerRadius:5];
    [btn setClipsToBounds:YES];
    [btn addTarget:self action:@selector(registert) forControlEvents:(UIControlEventTouchUpInside)];
    [self.view addSubview:btn];
    
    height += MDXFrom6(80);
    
    [self.view addSubview:[Tools creatImage:CGRectMake(MDXFrom6(110.5), height, MDXFrom6(154), MDXFrom6(33)) image:@"ajy_logo"]];
    
    [self.view addSubview:[Tools creatLabel:CGRectMake(MDXFrom6(35), KScreenHeight - 80, MDXFrom6(200), 30) font:[UIFont systemFontOfSize:14] color:[UIColor colorWithHexString:@"#3b3b3b"] alignment:(NSTextAlignmentLeft) title:@"使用社交账号登录"]];
    
    //    dl_wx dl_qq
    
    UIButton *wxLogin = [Tools creatButton:CGRectMake(MDXFrom6(240), KScreenHeight - 80 - MDXFrom6(10), MDXFrom6(53), MDXFrom6(53)) font:[UIFont systemFontOfSize:1] color:[UIColor blackColor] title:@"" image:@"dl_wx"];
    [self.view addSubview:wxLogin];
    
    UIButton *qqLogin = [Tools creatButton:CGRectMake(MDXFrom6(300), KScreenHeight - 80 - MDXFrom6(10), MDXFrom6(53), MDXFrom6(53)) font:[UIFont systemFontOfSize:1] color:[UIColor blackColor] title:@"" image:@"dl_qq"];
    [self.view addSubview:qqLogin];
    
    
    
}

- (UIView *)creatLine:(CGRect)rect{
    
    UIView *v = [[UIView alloc] initWithFrame:rect];
    [v setBackgroundColor:[UIColor colorWithHexString:@"#d1d1d1"]];
    return v;
}

- (void)textValueChange:(UITextField *)sender{// tag 1 为账号  2 为密码
    if (sender.tag == 1) {
        
        if (sender.text.length > 11) {
            [sender setText:[sender.text substringToIndex:11]];
        }
        
        userNames = sender.text;
    }
    
    if (sender.tag == 2) {
        if (sender.text.length > 6) {
            [sender setText:[sender.text substringToIndex:6]];
        }
        
        passwords = sender.text;
    }
    
}


#pragma mark --  登录  立即注册 获取验证码 

- (void)jumpLogin{
    
    if (self.navigationController.viewControllers.count > 1) {
        [self.navigationController popViewControllerAnimated:YES];
    }
    else{
        LoginViewController *vc = [[LoginViewController alloc] init];
        [self.navigationController pushViewController:vc animated:YES];
    }
    
}


- (void)registert{
    
    if (userNames.length == 11 && passwords.length == 6) {
    
        NSString *path = [NSString stringWithFormat:@"%@/login/register_check_mobile",KURL];
        
        NSDictionary *dic = @{@"mobile":userNames,@"code":passwords};
        
        [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        
        [HttpRequest POST:path parameters:dic success:^(id  _Nullable responseObject) {
            
            [MBProgressHUD hideHUDForView:self.view animated:YES];
            
            if ([responseObject[@"code"] integerValue] == 200) {
                SetPasswordVC *vc = [[SetPasswordVC alloc] init];
                vc.phone = self->userNames;
                [self.navigationController pushViewController:vc animated:YES];
            }
            else{
                
                [ViewHelps showHUDWithText:responseObject[@"message"]];
            }
            
        } failure:^(NSError * _Nullable error) {
            
            [MBProgressHUD hideHUDForView:self.view animated:YES];
            [RequestSever showMsgWithError:error];
            
        }];
    }
    else{
        
        [ViewHelps showHUDWithText:@"手机号或验证码输入错误"];
    }
    
}

- (void)getCode:(UIButton *)sender{
    
    if (userNames.length !=11) {

        [ViewHelps showHUDWithText:@"请输入正确的手机号"];
        return;
    }
    
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    NSString *path = [NSString stringWithFormat:@"%@/login/getMobileCode",KURL];
    
    NSDictionary *dic = @{@"mobile":userNames};
    
    [HttpRequest POST:path parameters:dic success:^(id  _Nullable responseObject) {
        
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        
        if ([responseObject[@"code"] integerValue] == 200) {
            if (!self.timer) {
                self.timer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(timeChange) userInfo:nil repeats:YES];
            }
            else {
                [self.timer setFireDate:[NSDate distantPast]];
            }
            
            [sender removeTarget:self action:@selector(getCode:) forControlEvents:(UIControlEventTouchUpInside)];
            
            self->time = 60;
            
            [sender setTitle:@"60 S" forState:(UIControlStateNormal)];
            
            [ViewHelps showHUDWithText:@"验证码发送成功，请注意查收"];
        }
        
        
    } failure:^(NSError * _Nullable error) {
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        [RequestSever showMsgWithError:error];
    }];
    
    
}

- (void)timeChange{
    
    time -- ;
    
    if (time<1) {
        if (![codeBtn.titleLabel.text isEqualToString:@"获取验证码"]) {
            [codeBtn setTitle:@"获取验证码" forState:(UIControlStateNormal)];
            [codeBtn addTarget:self action:@selector(getCode:) forControlEvents:(UIControlEventTouchUpInside)];
            
            [self.timer setFireDate:[NSDate distantFuture]];
        }
        
    }
    else{
        [codeBtn setTitle:[NSString stringWithFormat:@"%ld S",time] forState:(UIControlStateNormal)];
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
