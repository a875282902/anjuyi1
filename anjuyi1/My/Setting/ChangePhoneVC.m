//
//  ChangepasswordVC.m
//  anjuyi1
//
//  Created by 李 on 2018/6/8.
//  Copyright © 2018年 lsy. All rights reserved.
//

#import "ChangePhoneVC.h"

@interface ChangePhoneVC ()<UIScrollViewDelegate>
{
    NSInteger oldTime;
    NSInteger newTime;
    UIButton *oldBtn;
    UIButton *newBtn;
    NSInteger index;
}

@property (nonatomic,strong) UIScrollView  * tmpScrollView;

@property (nonatomic,strong)NSTimer *timer;

@end

@implementation ChangePhoneVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self setTitle:@"修改密码"];
    
    oldTime = 0;
    newTime = 0;
    
    [self baseForDefaultLeftNavButton];
    
    [self.view addSubview:self.tmpScrollView];
    
    [self.view addSubview:[Tools setLineView:CGRectMake(0, 0, KScreenWidth, 1)]];
    
    [self setUpUI];
}

-(UIScrollView *)tmpScrollView{
    
    if (!_tmpScrollView) {
        _tmpScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, KScreenWidth, KScreenHeight- KTopHeight)];
        [_tmpScrollView setShowsVerticalScrollIndicator:NO];
        [_tmpScrollView setShowsHorizontalScrollIndicator:NO];
        [_tmpScrollView setDelegate:self];
    }
    return _tmpScrollView;
}

- (void)setUpUI{
    
    CGFloat height = 20;
    
    NSArray *tArr = @[@"请输入手机号",@"请输入验证码",@"请输入新手机号",@"请输入新手机号验证码"];
    
    for (NSInteger i = 0 ; i < 4 ; i++) {
        
        UITextField *textField = [[UITextField alloc] initWithFrame:CGRectMake(15, height, KScreenWidth - 30, 60)];
        [textField setFont:[UIFont systemFontOfSize:15]];
        [textField setPlaceholder:tArr[i]];
        [textField setValue:[UIColor colorWithHexString:@"#999999"] forKeyPath:@"_placeholderLabel.textColor"];
        [self.tmpScrollView addSubview:textField];
        
        [self.tmpScrollView addSubview:[Tools setLineView:CGRectMake(15, height + 59, KScreenWidth - 30, 1)]];
        
        height += 60;
    }
    
    height += 40;
    
    UIButton *codeBtn1 = [Tools creatButton:CGRectMake(KScreenWidth - 120, 32.5 , 105, 35) font:[UIFont systemFontOfSize:15] color:[UIColor whiteColor] title:@"获取验证码" image:@""];
    [codeBtn1 setBackgroundColor:[UIColor colorWithHexString:@"#ffb638"]];
    [codeBtn1.layer setCornerRadius:5];
    [codeBtn1 setClipsToBounds:YES];
    [codeBtn1 setTag:1];
    [codeBtn1 addTarget:self action:@selector(getCode:) forControlEvents:(UIControlEventTouchUpInside)];
    [self.tmpScrollView addSubview:codeBtn1];
    
    oldBtn = codeBtn1;
    
    UIButton *codeBtn2 = [Tools creatButton:CGRectMake(KScreenWidth - 120, 152.5 , 105, 35) font:[UIFont systemFontOfSize:15] color:[UIColor whiteColor] title:@"获取验证码" image:@""];
    [codeBtn2 setBackgroundColor:[UIColor colorWithHexString:@"#ffb638"]];
    [codeBtn2.layer setCornerRadius:5];
    [codeBtn2 setClipsToBounds:YES];
    [codeBtn2 setTag:2];
    [codeBtn2 addTarget:self action:@selector(getCode:) forControlEvents:(UIControlEventTouchUpInside)];
    [self.tmpScrollView addSubview:codeBtn2];
    
    newBtn = codeBtn2;
    
    
    UIButton *btn = [Tools creatButton:CGRectMake(15,height , KScreenWidth - 30, 50) font:[UIFont systemFontOfSize:16] color:[UIColor whiteColor] title:@"重新绑定" image:@""];
    [btn setBackgroundColor:MDRGBA(255, 181, 0, 1)];
    [btn.layer setCornerRadius:5];
    [btn setClipsToBounds:YES];
    [btn addTarget:self action:@selector(sureChange) forControlEvents:(UIControlEventTouchUpInside)];
    [self.tmpScrollView addSubview:btn];
    
    height += 70;
    
    [self.tmpScrollView setContentSize:CGSizeMake(KScreenWidth, height)];
    
}

- (void)sureChange{
    
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)getCode:(UIButton *)sender{
    
    if (!self.timer) {
        self.timer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(timeChange) userInfo:nil repeats:YES];
    }
    
    [sender removeTarget:self action:@selector(getCode:) forControlEvents:(UIControlEventTouchUpInside)];
    
    [sender setTitle:@"60 S" forState:(UIControlStateNormal)];
    
    if (sender.tag == 1) {
        oldTime = 60;
    }
    else if (sender.tag == 2){
        newTime = 60;
    }
    
    index = sender.tag ;
}

- (void)timeChange{
    
    oldTime --;
    newTime --;
    
    
    if (oldTime<1) {
        if (![oldBtn.titleLabel.text isEqualToString:@"获取验证码"]) {
            [oldBtn setTitle:@"获取验证码" forState:(UIControlStateNormal)];
            [oldBtn addTarget:self action:@selector(getCode:) forControlEvents:(UIControlEventTouchUpInside)];
        }
        
    }
    else{
        [oldBtn setTitle:[NSString stringWithFormat:@"%ld S",oldTime] forState:(UIControlStateNormal)];
    }
    
    if (newTime<1) {
        
        if (![newBtn.titleLabel.text isEqualToString:@"获取验证码"]) {
            [newBtn setTitle:@"获取验证码" forState:(UIControlStateNormal)];
            [newBtn addTarget:self action:@selector(getCode:) forControlEvents:(UIControlEventTouchUpInside)];
        }
    }
    else{
        [newBtn setTitle:[NSString stringWithFormat:@"%ld S",newTime] forState:(UIControlStateNormal)];
    }
    
    
}

- (void)dealloc{
    
    [self.timer invalidate];
    self.timer = nil;
    
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
