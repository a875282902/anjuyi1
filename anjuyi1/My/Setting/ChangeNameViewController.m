//
//  ChangeNameViewController.m
//  anjuyi1
//
//  Created by 李 on 2018/6/8.
//  Copyright © 2018年 lsy. All rights reserved.
//

#import "ChangeNameViewController.h"
#import "NSString+Predicate.h"

@interface ChangeNameViewController ()
{
    UIImageView *firstI;
    NSString *nickName;
}

@end

@implementation ChangeNameViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self setTitle:@"修改昵称"];
    [self setNavigationLeftBarButtonWithTitle:@"取消" color:[UIColor blackColor]];
    [self setNavigationRightBarButtonWithTitle:@"保存" color:[UIColor colorWithHexString:@"#47BABA"]];
    
    [self.view addSubview:[Tools setLineView:CGRectMake(0, 0, KScreenWidth , 1.5)]];
    
    UITextField *textField = [[UITextField alloc] initWithFrame:CGRectMake(15, 20, KScreenWidth - 30, 20)];
    [textField setFont:[UIFont systemFontOfSize:16]];
    [textField setPlaceholder:@"请输入您的昵称"];
    [textField addTarget:self action:@selector(textValueChange:) forControlEvents:(UIControlEventEditingChanged)];
    [self.view addSubview:textField];
    
    [self.view addSubview:[Tools setLineView:CGRectMake(15, 50, KScreenWidth - 30, 1.5)]];
    
    [self.view addSubview:[Tools creatLabel:CGRectMake(15, 60, KScreenWidth - 30, 50) font:[UIFont systemFontOfSize:12] color:[UIColor colorWithHexString:@"#999999"] alignment:(NSTextAlignmentLeft) title:@"昵称可以是中英文、数字的任意组合，30天只能修改一次昵称。"]];
    
    firstI = [Tools creatImage:CGRectMake(KScreenWidth - 40, 21.5, 17, 17) image:@"mm_tick"];
    
    [self.view addSubview:firstI];
}

- (void)textValueChange:(UITextField *)sender{
    
    if (sender.text.length > 30) {
        [sender setText:[sender.text substringToIndex:30]];
    }
    
    if ([sender.text isValidAlphaNumberPassword] || [sender.text isValidNumberAndLetterPassword]) {
        [firstI setImage:[UIImage imageNamed:@"mm_tick"]];
    }
    else{
        [firstI setImage:[UIImage imageNamed:@"xgmm_cw"]];
    }
    
    nickName = sender.text;
}


- (void)rightButtonTouchUpInside:(id)sender{
    
    
    NSString *path = [NSString stringWithFormat:@"%@/Member/update_nickname",KURL];
    
    NSDictionary *header = @{@"token":UTOKEN};
    NSDictionary *parameter = @{@"name":nickName};
    
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    __weak typeof(self) weakSelf = self;
    
    [HttpRequest POSTWithHeader:header url:path parameters:parameter success:^(id  _Nullable responseObject) {
        
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        
        if ([responseObject[@"code"] integerValue] == 200) {
            
            [weakSelf.navigationController popViewControllerAnimated:YES];
        }
        else{
            
            [ViewHelps showHUDWithText:responseObject[@"message"]];
        }
        
        
    } failure:^(NSError * _Nullable error) {
        
        [MBProgressHUD hideHUDForView:self.view animated:YES];
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
