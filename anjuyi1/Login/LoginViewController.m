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

#import <TencentOpenAPI/TencentOAuth.h>
#import <WXApi.h>

#import "ThirdLoginViewController.h"

@interface LoginViewController ()<TencentSessionDelegate,WXApiDelegate>
{
    NSString *userName;
    NSString *password;
    NSDictionary *_wxDic;
}

@property (nonatomic,strong) TencentOAuth * tencentOAuth;

@end

@implementation LoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleDefault;
    [self.navigationController.navigationBar setHidden:YES];
    
    [self.view setBackgroundColor:[UIColor whiteColor]];
    
    [self setUpUI];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(pushLogoin:) name:@"pushLogoin" object:nil];
    
    _tencentOAuth = [[TencentOAuth alloc] initWithAppId:QQID andDelegate:self];
    _tencentOAuth.redirectURI = @"www.qq.com";
}

- (void)setUpUI{
    
    UIButton *registerb = [Tools creatButton:CGRectMake(MDXFrom6(35), KStatusBarHeight + MDXFrom6(30), MDXFrom6(60), MDXFrom6(30))  font:[UIFont systemFontOfSize:16] color:[UIColor colorWithHexString:@"#e9c700"] title:@"注册" image:@""];
    [registerb setContentHorizontalAlignment:(UIControlContentHorizontalAlignmentLeft)];
    [registerb.titleLabel setTextAlignment:(NSTextAlignmentLeft)];
    [registerb addTarget:self action:@selector(jumpRegister) forControlEvents:(UIControlEventTouchUpInside)];
    [self.view addSubview:registerb];
    
    UIButton *backButton = [Tools creatButton:CGRectMake(KScreenWidth -  MDXFrom6(95), KStatusBarHeight + MDXFrom6(30), MDXFrom6(60), MDXFrom6(30))  font:[UIFont systemFontOfSize:16] color:[UIColor colorWithHexString:@"#e9c700"] title:@"返回" image:@""];
    [backButton setContentHorizontalAlignment:(UIControlContentHorizontalAlignmentLeft)];
    [backButton.titleLabel setTextAlignment:(NSTextAlignmentLeft)];
    [backButton addTarget:self action:@selector(back) forControlEvents:(UIControlEventTouchUpInside)];
    [self.view addSubview:backButton];
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
    [qqLogin addTarget:self action:@selector(qqLogin:) forControlEvents:(UIControlEventTouchUpInside)];
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

- (void)back{
    
    [self.navigationController dismissViewControllerAnimated:YES completion:nil];
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
            [self saveInfoBack:responseObject[@"datas"]];
        }
        else{
            
            [ViewHelps showHUDWithText:responseObject[@"message"]];
        }
        
    } failure:^(NSError * _Nullable error) {
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        [RequestSever showMsgWithError:error];
    }];
}
#pragma mark -- WX登录
- (void)wxLogin:(UIButton *)sender{
    
    SendAuthReq *req = [[SendAuthReq alloc] init];
    req.scope = @"snsapi_userinfo";
    req.state = @"anjuyi123213sadqdqdasddqdq";
    req.openID = WXID;

    [WXApi sendAuthReq:req viewController:self delegate:self];
}
//微信登录
#pragma mark - WXApiDelegate
-(void)onResp:(BaseResp *)resp{
    
    //判断是否是微信认证的处理结果
    if ([resp isKindOfClass:[SendAuthResp class]]) {
        SendAuthResp *temp = (SendAuthResp *)resp;
        //如果你点击了取消，这里的temp.code 就是空值
        if (temp.code != NULL) {
            //此处判断下返回来的code值是否为错误码
            /*此处接口地址为微信官方提供，我们只需要将返回来的code值传入再配合appId和appSecret即可获取到accessToken，openId和refreshToken */
            //https://api.weixin.qq.com/sns  /oauth2/access_token
            NSString *accessUrlStr = [NSString stringWithFormat:@"%@/oauth2/access_token?appid=%@&secret=%@&code=%@&grant_type=authorization_code", @"https://api.weixin.qq.com/sns", WXID, WXSECRET, temp.code];

            [HttpRequest GET:accessUrlStr parameters:nil success:^(id  _Nonnull responseObject) {
                [self p_successedWeiChatLogin:responseObject];
            } failure:^(NSError * _Nonnull error) {
                
            }];
        }
    }
}


- (void)p_successedWeiChatLogin:(NSDictionary *)dic{
    NSDictionary *returnObject = [NSDictionary dictionary];
    returnObject = dic;
    [[NSNotificationCenter defaultCenter] postNotificationName:@"pushLogoin" object:self userInfo:dic];
}

- (void)pushLogoin:(NSNotification *)sender{
    
    NSDictionary *dic = sender.userInfo;
    _wxDic = dic;
    [self checkISBand:dic[@"openid"] type:@"1"];
}

- (void)getWXUserInfo{
    
    if (!_wxDic) {
        return;
    }
    NSString *path = @"https://api.weixin.qq.com/sns/userinfo";
    NSDictionary *dic =@{@"access_token":_wxDic[@"access_token"],
                         @"lang":@"zh_CN",
                         @"openid":_wxDic[@"openid"]};
    [HttpRequest GET:path parameters:dic success:^(id  _Nonnull responseObject) {
        if ([responseObject[@"ret"] integerValue] == 0) {
            ThirdLoginViewController *vc = [[ThirdLoginViewController alloc] init];
            vc.userInfo = [NSMutableDictionary dictionaryWithDictionary:@{@"open_id":responseObject[@"openid"],@"type":@"1",@"head":responseObject[@"headimgurl"],@"nickname":responseObject[@"nickname"]}];
            [self.navigationController pushViewController:vc animated:YES];
        }
    } failure:^(NSError * _Nonnull error) {
        
    }];
}
#pragma mark -- QQ登录
- (void)qqLogin:(UIButton *)sender{
    
    NSArray * _permissions = [NSArray arrayWithObjects:@"get_user_info",@"get_simple_userinfo", @"add_t", nil];
    [self->_tencentOAuth authorize:_permissions inSafari:NO];
    
}

-(void)tencentDidLogin{
    
    if (_tencentOAuth.accessToken && 0 != [_tencentOAuth.accessToken length])
    {
//        [ViewHelps showHUDWithText:@"登录成功"];
        [self checkISBand:_tencentOAuth.openId type:@"3"];
    }
    else
    {
        [ViewHelps showHUDWithText:@"登录不成功 没有获取accesstoken"];
    }
}

-(void)tencentDidNotLogin:(BOOL)cancelled
{
    
    if (cancelled)
    {
        [ViewHelps showHUDWithText:@"用户取消登录"];
    }
    else
    {
        [ViewHelps showHUDWithText:@"登录失败"];
    }
}

-(void)tencentDidNotNetWork
{
    [ViewHelps showHUDWithText:@"无网络连接，请设置网络"];
}

- (void)getQQUserInfo{
    
    NSString *path = @"https://graph.qq.com/user/get_user_info";
    NSDictionary *dic =@{@"access_token":_tencentOAuth.accessToken,
                         @"oauth_consumer_key":QQID,
                         @"openid":_tencentOAuth.openId};
    [HttpRequest GET:path parameters:dic success:^(id  _Nonnull responseObject) {
        if ([responseObject[@"ret"] integerValue] == 0) {
            ThirdLoginViewController *vc = [[ThirdLoginViewController alloc] init];
            vc.userInfo = [NSMutableDictionary dictionaryWithDictionary:@{@"open_id":self->_tencentOAuth.openId,@"type":@"3",@"head":responseObject[@"figureurl_qq_1"],@"nickname":responseObject[@"nickname"]}];
            [self.navigationController pushViewController:vc animated:YES];
        }
    } failure:^(NSError * _Nonnull error) {
        
    }];
}
#pragma mark -- 查询账号是否绑定 && 获取账号信息
//查询账号是否绑定
- (void)checkISBand:(NSString *)open_id type:(NSString *)type{
    
    NSString *path = [NSString stringWithFormat:@"%@/login/three_login",KURL];
    
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    __weak typeof(self) weakSelf = self;
    
    [HttpRequest POST:path parameters:@{@"open_id":open_id,@"type":type} success:^(id  _Nullable responseObject) {
        
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        
        if ([responseObject[@"code"] integerValue] == 200) {
            [weakSelf saveInfoBack:responseObject[@"datas"]];
        }
        else if ([responseObject[@"code"] integerValue] == 202) {
            
            if ([type isEqualToString:@"3"]) {
                [weakSelf getQQUserInfo];
            }
            if ([type isEqualToString:@"1"]) {
                [weakSelf getWXUserInfo];
            }
        }
        else{
            
            [ViewHelps showHUDWithText:responseObject[@"message"]];
        }
        
        
    } failure:^(NSError * _Nullable error) {
        
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        [RequestSever showMsgWithError:error];
    }];
}



//保存utoken
- (void)saveInfoBack:(NSDictionary *)dic{
    [ViewHelps showHUDWithText:@"登录成功"];
    [[NSUserDefaults standardUserDefaults] setValue:dic[@"token"] forKey:@"UTOKEN"];
    
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
