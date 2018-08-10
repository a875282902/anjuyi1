//
//  ChangepasswordVC.m
//  anjuyi1
//
//  Created by 李 on 2018/6/8.
//  Copyright © 2018年 lsy. All rights reserved.
//

#import "ChangepasswordVC.h"

@interface ChangepasswordVC ()<UIScrollViewDelegate>

@property (nonatomic,strong) UIScrollView       * tmpScrollView;
@property (nonatomic,strong) NSMutableArray     * textArr;

@end

@implementation ChangepasswordVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self setTitle:@"修改密码"];
    
    [self baseForDefaultLeftNavButton];
    self.textArr = [NSMutableArray arrayWithObjects:@"",@"",@"",@"",@"",@"", nil];
    [self.view addSubview:self.tmpScrollView];
    
    [self.view addSubview:[Tools setLineView:CGRectMake(0, 0, KScreenWidth, 1)]];
    
    [self setUpUI];
}

-(UIScrollView *)tmpScrollView{
    
    if (!_tmpScrollView) {
        _tmpScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, KScreenWidth, KScreenHeight- KTopHeight)];
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
    
    CGFloat height = 20;

    NSArray *tArr = @[@"请输入原始密码",@"请输入新密码",@"请确认新密码"];
    
    for (NSInteger i = 0 ; i < 3 ; i++) {

        UITextField *textField = [[UITextField alloc] initWithFrame:CGRectMake(15, height, KScreenWidth - 30, 60)];
        [textField setFont:[UIFont systemFontOfSize:15]];
        [textField setPlaceholder:tArr[i]];
        [textField setValue:[UIColor colorWithHexString:@"#999999"] forKeyPath:@"_placeholderLabel.textColor"];
        [textField addTarget:self action:@selector(textValueChange:) forControlEvents:(UIControlEventEditingChanged)];
        [textField setTag:i];
        [self.view addSubview:textField];
        

        [self.view addSubview:[Tools setLineView:CGRectMake(15,height+59, KScreenWidth - 30, 1)]];
        
//        [self.view addSubview:[Tools creatImage:CGRectMake(KScreenWidth - 40,height+ 21.5, 17, 17) image:@"mm_tick"]];
        
        height += 60;
    }
    
    height += 40;
    
    UIButton *btn = [Tools creatButton:CGRectMake(15,height , KScreenWidth - 30, 50) font:[UIFont systemFontOfSize:16] color:[UIColor whiteColor] title:@"确认修改" image:@""];
    [btn setBackgroundColor:MDRGBA(255, 181, 0, 1)];
    [btn.layer setCornerRadius:5];
    [btn setClipsToBounds:YES];
    [btn addTarget:self action:@selector(sureChange) forControlEvents:(UIControlEventTouchUpInside)];
    [self.view addSubview:btn];
    
}

- (void)textValueChange:(UITextField *)sender{
    
    [self.textArr replaceObjectAtIndex:sender.tag withObject:sender.text];
}

- (void)sureChange{
    
    
    NSArray *tArr = @[@"请输入原始密码",@"请输入新密码",@"请确认新密码"];
    for (NSInteger i = 0 ; i < tArr.count; i++) {
        if ([self.textArr[i] length] == 0) {
            [ViewHelps showHUDWithText:tArr[i]];
            
            return;
        }
    }
    NSString *path = [NSString stringWithFormat:@"%@/member/update_password",KURL];
    
    NSDictionary *header = @{@"token":UTOKEN};
    NSDictionary *parameter = @{@"password_old":self.textArr[0],
                                @"password":self.textArr[1],
                                @"password_confirm":self.textArr[2]};
    
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
