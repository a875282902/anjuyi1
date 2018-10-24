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
#import <TencentOpenAPI/TencentOAuth.h>
#import <WXApi.h>

#import "ThirdLoginViewController.h"

@interface AccountSecurityVC ()<UIScrollViewDelegate,TencentSessionDelegate,WXApiDelegate>
{
    NSDictionary *_wxDic;
}

@property (nonatomic,strong) TencentOAuth * tencentOAuth;
@property (nonatomic,strong)UIScrollView *tmpScrollView;

@property (nonatomic,strong)NSMutableDictionary *phoneDic;

@end

@implementation AccountSecurityVC

- (void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:animated];
    if (self.phoneDic) {
    
        [self getPhone];
    }
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self setTitle:@"账号安全"];
    [self setNavigationLeftBarButtonWithImageNamed:@"ss_back"];
    
    [self.view addSubview:self.tmpScrollView];
    [self.view addSubview:[Tools setLineView:CGRectMake(0, 0, KScreenWidth, 1.5)]];
    
    [self setUpUI];
    [self getPhone];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(pushLogoin:) name:@"pushLogoin" object:nil];
    
    _tencentOAuth = [[TencentOAuth alloc] initWithAppId:QQID andDelegate:self];
    _tencentOAuth.redirectURI = @"www.qq.com";
}

-(void)leftButtonTouchUpInside:(id)sender{
    
      [[NSNotificationCenter defaultCenter] removeObserver:self name:@"pushLogoin" object:nil];
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)getPhone{
    
    
    NSString *path = [NSString stringWithFormat:@"%@/member/account_security",KURL];
    
    NSDictionary *header = @{@"token":UTOKEN};
    
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    __weak typeof(self) weakSelf = self;
    
    [HttpRequest POSTWithHeader:header url:path parameters:nil success:^(id  _Nullable responseObject) {
        
        [MBProgressHUD hideHUDForView:weakSelf.view animated:YES];
        
        if ([responseObject[@"code"] integerValue] == 200) {
            
            weakSelf.phoneDic = [NSMutableDictionary dictionaryWithDictionary:responseObject[@"datas"]];
            
            [weakSelf setUpUI];
        }
        else{
            
            [ViewHelps showHUDWithText:responseObject[@"message"]];
        }
        
        
    } failure:^(NSError * _Nullable error) {
        
        [MBProgressHUD hideHUDForView:weakSelf.view animated:YES];
        [RequestSever showMsgWithError:error];
    }];

}

-(UIScrollView *)tmpScrollView{
    
    if (!_tmpScrollView) {
        _tmpScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, KScreenWidth, KScreenHeight)];
        if (@available(iOS 11.0, *)) {
            [_tmpScrollView setContentInsetAdjustmentBehavior:(UIScrollViewContentInsetAdjustmentNever)];
        }
        [_tmpScrollView setShowsVerticalScrollIndicator:NO];
        [_tmpScrollView setShowsHorizontalScrollIndicator:NO];
        [_tmpScrollView setDelegate:self];
    }
    return _tmpScrollView;
}

- (void)setUpUI{
    
    [self.tmpScrollView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    
    CGFloat height = 0 ;
    
    NSArray *tArr = @[@"修改手机号",@"修改密码"];
    NSArray *dArr = @[@"",@""];
    if (self.phoneDic) {
        dArr = @[self.phoneDic[@"phone"],@""];
    }
    
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
    
    NSArray * iArr = @[@"zhaq_qq",@"zhaq_wx",@"alipayico"];

    NSArray * iTArr = @[@"QQ绑定",@"微信绑定",@"支付宝绑定"];
    
    NSArray * idArr = @[@"0",@"0",@"0"];
    
    if (self.phoneDic) {
        idArr = @[self.phoneDic[@"is_qq"],self.phoneDic[@"is_wechat"],self.phoneDic[@"is_zfb"]];
    }
    
    
    for (NSInteger i = 0 ; i < 3 ; i++) {
        
        UIView *backView = [[UIView alloc] initWithFrame:CGRectMake(0, height, KScreenWidth , 60)];
        [backView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(bandAccount:)]];
        [backView setTag:i];
        [self.tmpScrollView addSubview:backView];
        
        [backView addSubview:[Tools creatImage:CGRectMake(10, 10, 40, 40) image:iArr[i]]];
        
        [backView addSubview:[Tools creatLabel:CGRectMake(60, 0, KScreenWidth - 70, 60) font:[UIFont systemFontOfSize:15] color:[UIColor blackColor] alignment:(NSTextAlignmentLeft) title:iTArr[i]]];
        
        [backView addSubview:[Tools creatLabel:CGRectMake(60, 0, KScreenWidth - 80, 60) font:[UIFont systemFontOfSize:15] color:[UIColor colorWithHexString:@"666666"] alignment:(NSTextAlignmentRight) title:[idArr[i] integerValue]==0?@"未绑定":@"已绑定"]];
        
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
    
    //QQ 微信 支付宝
    
    if (sender.view.tag == 0) {
        
        if ([self.phoneDic[@"is_qq"] integerValue] == 1) {
            [self creatAlertViewControllerWithMessage:@"确定解除QQ的绑定吗？" type:1];
        }else{
            [self bandQQ];
        }
    }
    if (sender.view.tag == 1) {
        
        if ([self.phoneDic[@"is_wechat"] integerValue] == 1) {
            [self creatAlertViewControllerWithMessage:@"确定解除微信的绑定吗？" type:2];
        }else{
            [self bandWX];
        }
    }

}

- (void)creatAlertViewControllerWithMessage:(NSString *)message type:(NSInteger)type{
    
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示" message:message preferredStyle:(UIAlertControllerStyleAlert)];
    
    [alert addAction:[UIAlertAction actionWithTitle:@"确定" style:(UIAlertActionStyleCancel) handler:^(UIAlertAction * _Nonnull action) {
        [self closeBand:type];
    }]];
    
    [alert addAction:[UIAlertAction actionWithTitle:@"取消" style:(UIAlertActionStyleDefault) handler:^(UIAlertAction * _Nonnull action) {
        
    }]];
    
    [self presentViewController:alert animated:YES completion:nil];
    
}
- (void)closeBand:(NSInteger)type{
    
    NSString *path = [NSString stringWithFormat:@"%@//member/unbind_three_login",KURL];

    NSDictionary *header = @{@"token":UTOKEN};
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];

    [HttpRequest POSTWithHeader:header url:path parameters:@{@"type":[NSString stringWithFormat:@"%ld",type]} success:^(id  _Nullable responseObject) {

        [MBProgressHUD hideHUDForView:self.view animated:YES];

        [ViewHelps showHUDWithText:responseObject[@"message"]];


    } failure:^(NSError * _Nullable error) {

        [MBProgressHUD hideHUDForView:self.view animated:YES];
        [RequestSever showMsgWithError:error];
    }];
}

#pragma mark -- WX绑定
- (void)bandWX{
    
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
    [self getWXUserInfo];
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
            [self presentViewController:vc animated:YES completion:nil];
        }
    } failure:^(NSError * _Nonnull error) {
        
    }];
}
#pragma mark -- QQ绑定
- (void)bandQQ{
    
    NSArray * _permissions = [NSArray arrayWithObjects:@"get_user_info",@"get_simple_userinfo", @"add_t", nil];
    [self->_tencentOAuth authorize:_permissions inSafari:NO];
    
}

-(void)tencentDidLogin{
    
    if (_tencentOAuth.accessToken && 0 != [_tencentOAuth.accessToken length])
    {
        [self getQQUserInfo];//获取QQ用户信息
    }
    else
    {
        [ViewHelps showHUDWithText:@"绑定不成功 没有获取accesstoken"];
    }
}

-(void)tencentDidNotLogin:(BOOL)cancelled
{
    
    if (cancelled)
    {
        [ViewHelps showHUDWithText:@"用户取消绑定"];
    }
    else
    {
        [ViewHelps showHUDWithText:@"登录绑定"];
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
            [self presentViewController:vc animated:YES completion:nil];
        }
    } failure:^(NSError * _Nonnull error) {
        
    }];
}

#pragma mark --- 注销账户
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
