//
//  SetPasswordVC.m
//  anjuyi1
//
//  Created by apple on 2018/6/13.
//  Copyright © 2018年 lsy. All rights reserved.
//
//  设置密码 

#import "SetPasswordVC.h"
#import "NSString+Predicate.h"
#import "SetUserNameVC.h"//设置昵称

@interface SetPasswordVC ()
{
    NSString *userNames;
    NSString *passwords;
    UIImageView *firstI;
    UIImageView *secondI;
}

@end

@implementation SetPasswordVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self setUpUI];
}

- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer{
    
    return NO;
}

- (void)setUpUI{
    
    UIButton *next = [Tools creatButton:CGRectMake(KScreenWidth - MDXFrom6(130), KStatusBarHeight + MDXFrom6(15), MDXFrom6(110), MDXFrom6(30))  font:[UIFont systemFontOfSize:16] color:[UIColor colorWithHexString:@"#000000"] title:@"下一步" image:@""];
    [next setContentHorizontalAlignment:(UIControlContentHorizontalAlignmentRight)];
    [next.titleLabel setTextAlignment:(NSTextAlignmentRight)];
    [next addTarget:self action:@selector(nextSteps) forControlEvents:(UIControlEventTouchUpInside)];
    [self.view addSubview:next];
    
    CGFloat height = KStatusBarHeight + MDXFrom6(70);
    
    
    [self.view addSubview:[Tools creatLabel:CGRectMake(MDXFrom6(35), height, KScreenWidth - MDXFrom6(70), 22) font:[UIFont systemFontOfSize:21] color:[UIColor blackColor] alignment:(NSTextAlignmentLeft) title:@"设置密码"]];
    
    height += 50;
    
    [self.view addSubview:[Tools creatLabel:CGRectMake(MDXFrom6(35), height, KScreenWidth - MDXFrom6(70), 22) font:[UIFont systemFontOfSize:14] color:[UIColor blackColor] alignment:(NSTextAlignmentLeft) title:@"6-30位的英文或数字"]];
    
    height += 50;
    
    // ----  输入密码
    UITextField *userName = [[UITextField alloc] initWithFrame:CGRectMake(MDXFrom6(35), height, MDXFrom6(305), 60)];
    [userName setPlaceholder:@"输入密码"];
    [userName setFont:[UIFont systemFontOfSize:16]];
    [userName setTag:1];
    [userName addTarget:self action:@selector(textValueChange:) forControlEvents:(UIControlEventEditingChanged)];
    [self.view addSubview:userName];
    
    
    //xgmm_cw
    firstI = [Tools creatImage:CGRectMake(KScreenWidth - MDXFrom6(35)-17, 22.5 +height , 17, 15) image:@"mm_tick"];
    [self.view addSubview:firstI];
    
    height += 60;
    
    [self.view addSubview:[self creatLine:CGRectMake(MDXFrom6(35), height-1, MDXFrom6(305), 1)]];
    
    // ---- 再次输入密码
    UITextField *passWord = [[UITextField alloc] initWithFrame:CGRectMake(MDXFrom6(35), height, MDXFrom6(305), 60)];
    [passWord setPlaceholder:@"再次输入密码"];
    [passWord setFont:[UIFont systemFontOfSize:16]];
    [passWord setTag:2];
    [passWord addTarget:self action:@selector(textValueChange:) forControlEvents:(UIControlEventEditingChanged)];
    [self.view addSubview:passWord];
    
    //xgmm_cw
    secondI = [Tools creatImage:CGRectMake(KScreenWidth - MDXFrom6(35)-17, 22.5 +height , 17, 15) image:@"mm_tick"];
    [self.view addSubview:secondI];
    
    height += 60;
    
    [self.view addSubview:[self creatLine:CGRectMake(MDXFrom6(35), height-1, MDXFrom6(305), 1)]];
    

    
    
}

- (UIView *)creatLine:(CGRect)rect{
    
    UIView *v = [[UIView alloc] initWithFrame:rect];
    [v setBackgroundColor:[UIColor colorWithHexString:@"#d1d1d1"]];
    return v;
}

- (void)textValueChange:(UITextField *)sender{// tag 1 为账号  2 为密码
    if (sender.tag == 1) {
        
        if (sender.text.length > 30) {
            [sender setText:[sender.text substringToIndex:30]];
        }
        
        if ([sender.text isValidNumberAndLetterPassword]) {
            [firstI setImage:[UIImage imageNamed:@"mm_tick"]];
        }
        else{
            [firstI setImage:[UIImage imageNamed:@"xgmm_cw"]];
        }
        
        userNames = sender.text;
        
    }
    
    if (sender.tag == 2) {
        if (sender.text.length > 30) {
            [sender setText:[sender.text substringToIndex:30]];
        }
        
        if ([sender.text isEqualToString:userNames]) {
            [secondI setImage:[UIImage imageNamed:@"mm_tick"]];
        }
        else{
            [secondI setImage:[UIImage imageNamed:@"xgmm_cw"]];
            
        }
        
        passwords = sender.text;
        
    }
    
}


#pragma mark -- 下一步
- (void)nextSteps{
    
    if ([userNames isValidNumberAndLetterPassword] && [passwords isEqualToString:userNames]) {
        
        SetUserNameVC *vc = [[SetUserNameVC alloc] init];
        vc.phone = self.phone;
        vc.password = passwords;
        [self.navigationController pushViewController:vc animated:YES];
        
    }
    else{
        [ViewHelps showHUDWithText:@"两次密码输入不一样"];
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
