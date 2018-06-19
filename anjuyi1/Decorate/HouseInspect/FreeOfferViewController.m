//
//  FreeOfferViewController.m
//  anjuyi1
//
//  Created by apple on 2018/6/14.
//  Copyright © 2018年 lsy. All rights reserved.
//
//  免费报价

#import "FreeOfferViewController.h"
#import "SelectLocationVC.h"//选择地址

@interface FreeOfferViewController ()
{
    NSInteger time;
    UIButton *codeBtn;
}

@property (nonatomic,strong)NSMutableArray * textArr;
@property (nonatomic,strong)NSTimer        * timer;
@property (nonatomic,strong)UILabel        * location;

@end

@implementation FreeOfferViewController

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
    
    self.textArr = [NSMutableArray arrayWithObjects:@"",@"",@"",@"", nil];
    time = 60;
    
    [self.view setBackgroundColor:[UIColor whiteColor]];
    
    [self setUpUI];
    
}

- (void)setUpUI{
    
    UIButton *registerb = [Tools creatButton:CGRectMake(MDXFrom6(35), KStatusBarHeight + MDXFrom6(30), MDXFrom6(60), MDXFrom6(30))  font:[UIFont systemFontOfSize:16] color:[UIColor colorWithHexString:@"#e9c700"] title:@"" image:@"ss_back"];
    [registerb setContentHorizontalAlignment:(UIControlContentHorizontalAlignmentLeft)];
    [registerb.titleLabel setTextAlignment:(NSTextAlignmentLeft)];
    [registerb addTarget:self action:@selector(back) forControlEvents:(UIControlEventTouchUpInside)];
    [self.view addSubview:registerb];
    
    CGFloat height = KStatusBarHeight + MDXFrom6(90);
    
    
    [self.view addSubview:[Tools creatLabel:CGRectMake(MDXFrom6(35), height, KScreenWidth - MDXFrom6(70), 22) font:[UIFont systemFontOfSize:21] color:[UIColor blackColor] alignment:(NSTextAlignmentLeft) title:@"免费报价"]];
    
    height += 50;
    
    height = [self selectLocationView:height];//房屋地址

    height = [self selectRoomModelView:height];//房屋户型
    
    height = [self inputPersonInfor:height];//个人信息

    
    height += 40;
    
    [self.view addSubview:[Tools creatLabel:CGRectMake(0, height, KScreenWidth, 20) font:[UIFont systemFontOfSize:18] color:[UIColor redColor] alignment:(NSTextAlignmentCenter) title:@"预估价格：23万元"]];
    
    height += 60;
    
    UIButton *btn = [Tools creatButton:CGRectMake(MDXFrom6(35), height, KScreenWidth - MDXFrom6(70), MDXFrom6(50)) font:[UIFont systemFontOfSize:18] color:[UIColor whiteColor] title:@"提交" image:@""];
    [btn setBackgroundColor:[UIColor colorWithHexString:@"#ffb638"]];
    [btn.layer setCornerRadius:5];
    [btn setClipsToBounds:YES];
    [btn addTarget:self action:@selector(submit) forControlEvents:(UIControlEventTouchUpInside)];
    [self.view addSubview:btn];
    
}

// ---------- 选择地址 -------
- (CGFloat)selectLocationView:(CGFloat)height{
    
    [self.view addSubview:[Tools creatImage:CGRectMake(MDXFrom6(35), height + 10, 15, 15) image:@"add_add"]];
    
    CGRect rect = [@"北京  朝阳区" boundingRectWithSize:CGSizeMake(1000000, 35) options:NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:15]} context:nil];
    
    self.location = [Tools creatLabel:CGRectMake(MDXFrom6(60), height, rect.size.width , 35) font:[UIFont systemFontOfSize:15] color:[UIColor blackColor] alignment:(NSTextAlignmentLeft) title:@"北京  朝阳区"];
    [self.view addSubview:self.location];
    
    UIButton * rechange = [Tools creatButton:CGRectMake(MDXFrom6(80) + rect.size.width, height, MDXFrom6(80), MDXFrom6(35)) font:[UIFont systemFontOfSize:14] color:[UIColor colorWithHexString:@"#23b7b5"] title:@"重新选择" image:@""];
    [rechange setBackgroundColor:[UIColor colorWithHexString:@"#eaf8f8"]];
    [rechange.layer setCornerRadius:7.5];
    [rechange.layer setBorderColor:[UIColor colorWithHexString:@"#34bab8"].CGColor];
    [rechange.layer setBorderWidth:1];
    [rechange addTarget:self action:@selector(rechangeLocation:) forControlEvents:(UIControlEventTouchUpInside)];
    [self.view addSubview:rechange];
    
    return height + 50;
}

// ---------- 选择户型 -------
- (CGFloat)selectRoomModelView:(CGFloat)height{
    
    [self.view addSubview:[Tools creatLabel:CGRectMake(MDXFrom6(35), height, MDXFrom6(50), 30) font:[UIFont systemFontOfSize:15] color:[UIColor colorWithHexString:@"#999999"] alignment:(NSTextAlignmentLeft) title:@"户型："]];
    
    UILabel *room = [Tools creatLabel:CGRectMake(MDXFrom6(100), height, MDXFrom6(100), 30) font:[UIFont systemFontOfSize:13] color:[UIColor colorWithHexString:@"#3b3b3b"] alignment:(NSTextAlignmentCenter) title:@"三室"];
    [room.layer setBorderWidth:1];
    [room.layer setCornerRadius:5];
    [room.layer setBorderColor:[UIColor colorWithHexString:@"#d1d1d1"].CGColor];
    [self.view addSubview:room];
    
    [room addSubview:[Tools creatImage:CGRectMake(MDXFrom6(100) - 20, 12.5 , 8, 5) image:@"guess_xjt"]];
    
    UILabel *hall = [Tools creatLabel:CGRectMake(MDXFrom6(210), height, MDXFrom6(100), 30) font:[UIFont systemFontOfSize:13] color:[UIColor colorWithHexString:@"#3b3b3b"] alignment:(NSTextAlignmentCenter) title:@"二厅"];
    [hall.layer setBorderWidth:1];
    [hall.layer setCornerRadius:5];
    [hall.layer setBorderColor:[UIColor colorWithHexString:@"#d1d1d1"].CGColor];
    [self.view addSubview:hall];
    
    [hall addSubview:[Tools creatImage:CGRectMake(MDXFrom6(100) - 20, 12.5 , 8, 5) image:@"guess_xjt"]];
    
    
    return height + 40;
}


- (CGFloat)inputPersonInfor:(CGFloat)height{
    
    // ---------- 输入信息 -------
    NSArray *tArr = @[@"输入您的住宅面积(整数)",@"输入联系手机号码",@"验证码"];
    
    for (NSInteger i = 0 ; i <  3; i++) {
        UITextField *userName = [[UITextField alloc] initWithFrame:CGRectMake(MDXFrom6(35), height, MDXFrom6(305), 50)];
        [userName setPlaceholder:tArr[i]];
        [userName setFont:[UIFont systemFontOfSize:16]];
        [userName setClearButtonMode:(UITextFieldViewModeAlways)];
        [userName setTag:i];
        [userName setKeyboardType:(UIKeyboardTypeNumberPad)];
        [userName addTarget:self action:@selector(textValueChange:) forControlEvents:(UIControlEventEditingChanged)];
        [self.view addSubview:userName];
        
        [self.view addSubview:[self creatLine:CGRectMake(MDXFrom6(35), height + 49, MDXFrom6(305), 1)]];
        
        height += 50;
        
        if (i == 2) {
            UIButton *codeBtn1 = [Tools creatButton:CGRectMake(KScreenWidth - 130, height - 42.5 , 95, 35) font:[UIFont systemFontOfSize:15] color:[UIColor whiteColor] title:@"获取验证码" image:@""];
            [codeBtn1 setBackgroundColor:BTNCOLOR];
            [codeBtn1.layer setCornerRadius:5];
            [codeBtn1 setClipsToBounds:YES];
            [codeBtn1 setTag:1];
            [codeBtn1 addTarget:self action:@selector(getCode:) forControlEvents:(UIControlEventTouchUpInside)];
            [self.view addSubview:codeBtn1];
            
            codeBtn = codeBtn1;
        }
    }
    return height;
}

- (UIView *)creatLine:(CGRect)rect{
    
    UIView *v = [[UIView alloc] initWithFrame:rect];
    [v setBackgroundColor:[UIColor colorWithHexString:@"#d1d1d1"]];
    return v;
}

#pragma mark -- 点击事件   返回  重新选择
- (void)back{
    
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)rechangeLocation:(UIButton *)sender{
    
    SelectLocationVC *vc = [[SelectLocationVC alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)textValueChange:(UITextField *)sender{// tag 1 为账号
    
    [self.textArr replaceObjectAtIndex:sender.tag withObject:sender.text];
}


// 提交
- (void)submit{
    
    
}

#pragma mark -- 验证码
- (void)getCode:(UIButton *)sender{
    
    if ([self.textArr[2] length] !=11) {
        
        [ViewHelps showHUDWithText:@"请输入正确的手机号"];
        return;
    }
    
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    NSString *path = [NSString stringWithFormat:@"%@/login/getMobileCode",KURL];
    
    NSDictionary *dic = @{@"mobile":self.textArr[2]};
    
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
        [ViewHelps showHUDWithText:@"验证码发送失败，请再次发送"];
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
