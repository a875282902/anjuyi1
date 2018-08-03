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

@property (nonatomic,strong)NSMutableArray *textArr;

@end

@implementation ChangePhoneVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self setTitle:@"修改手机号"];
    
    oldTime = 0;
    newTime = 0;
    
    self.textArr = [NSMutableArray arrayWithObjects:@"",@"",@"",@"",@"",@"",@"",@"", nil];
    
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
        [textField setKeyboardType:(UIKeyboardTypePhonePad)];
        [textField addTarget:self action:@selector(textFieldValueChange:) forControlEvents:(UIControlEventEditingChanged)];
        [textField setTag:i];
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


#pragma mark -- 事件
- (void)textFieldValueChange:(UITextField *)sender{
    
    [self.textArr replaceObjectAtIndex:sender.tag withObject:sender.text];
    
}
- (void)sureChange{
    NSArray *tArr = @[@"请输入手机号",@"请输入验证码",@"请输入新手机号",@"请输入新手机号验证码"];
    for (NSInteger i = 0 ; i < tArr.count; i++) {
        if ([self.textArr[i] length] == 0) {
            [ViewHelps showHUDWithText:tArr[i]];
            
            return;
        }
    }
    
    
    NSString *path = [NSString stringWithFormat:@"%@/member/update_phone",KURL];
    
    NSDictionary *header = @{@"token":UTOKEN};
    NSDictionary *parameter = @{@"code_yuan":self.textArr[1],
                                @"mobile_edit":self.textArr[2],
                                @"code_edit":self.textArr[3]};
    
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    __weak typeof(self) weakSelf = self;
    
    [HttpRequest POSTWithHeader:header url:path parameters:parameter success:^(id  _Nullable responseObject) {
        
        [MBProgressHUD hideHUDForView:weakSelf.view animated:YES];
        
        if ([responseObject[@"code"] integerValue] == 200) {
            
             [ViewHelps showHUDWithText:@"修改成功"];
             [weakSelf.navigationController popViewControllerAnimated:YES];
        }
        else{
            
            [ViewHelps showHUDWithText:responseObject[@"message"]];
        }
        
    } failure:^(NSError * _Nullable error) {
        
        [MBProgressHUD hideHUDForView:weakSelf.view animated:YES];
        [RequestSever showMsgWithError:error];
    }];

}

- (void)getCode:(UIButton *)sender{
    
    NSString *phone = @"";
    if (sender.tag == 1) {
        phone = self.textArr[0];
    }
    else if (sender.tag == 2){
        phone = self.textArr[2];
    }
    
    if (phone.length !=11) {
        
        [ViewHelps showHUDWithText:@"请输入正确的手机号"];
        return;
    }
    
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    NSString *path = [NSString stringWithFormat:@"%@/login/getMobileCode",KURL];
    
    NSDictionary *dic = @{@"mobile":phone};
    
    [HttpRequest POST:path parameters:dic success:^(id  _Nullable responseObject) {
        
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        
        if ([responseObject[@"code"] integerValue] == 200) {
           
            
            if (!self.timer) {
                self.timer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(timeChange) userInfo:nil repeats:YES];
            }
            
            [sender removeTarget:self action:@selector(getCode:) forControlEvents:(UIControlEventTouchUpInside)];
            
            [sender setTitle:@"60 S" forState:(UIControlStateNormal)];
            
            if (sender.tag == 1) {
               self-> oldTime = 60;
            }
            else if (sender.tag == 2){
                self->newTime = 60;
            }
            
            self->index = sender.tag ;
            
            [ViewHelps showHUDWithText:@"验证码发送成功，请注意查收"];
        }
        else{
            [ViewHelps showHUDWithText:responseObject[@"message"]];
        }
        
    } failure:^(NSError * _Nullable error) {
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        [RequestSever showMsgWithError:error];
    }];

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
