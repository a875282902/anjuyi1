//
//  ChangeNameViewController.m
//  anjuyi1
//
//  Created by 李 on 2018/6/8.
//  Copyright © 2018年 lsy. All rights reserved.
//

#import "ChangeNameViewController.h"

@interface ChangeNameViewController ()

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
    [self.view addSubview:textField];
    
    [self.view addSubview:[Tools setLineView:CGRectMake(15, 50, KScreenWidth - 30, 1.5)]];
    
    [self.view addSubview:[Tools creatLabel:CGRectMake(15, 60, KScreenWidth - 30, 50) font:[UIFont systemFontOfSize:12] color:[UIColor colorWithHexString:@"#999999"] alignment:(NSTextAlignmentLeft) title:@"昵称可以是中英文、数字的任意组合，30天只能修改一次昵称。"]];

    [self.view addSubview:[Tools creatImage:CGRectMake(KScreenWidth - 40, 21.5, 17, 17) image:@"mm_tick"]];
}

- (void)rightButtonTouchUpInside:(id)sender{
    
    [self.navigationController popViewControllerAnimated:YES];
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
