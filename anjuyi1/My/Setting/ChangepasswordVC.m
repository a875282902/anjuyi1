//
//  ChangepasswordVC.m
//  anjuyi1
//
//  Created by 李 on 2018/6/8.
//  Copyright © 2018年 lsy. All rights reserved.
//

#import "ChangepasswordVC.h"

@interface ChangepasswordVC ()<UIScrollViewDelegate>

@property (nonatomic,strong) UIScrollView  * tmpScrollView;


@end

@implementation ChangepasswordVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self setTitle:@"修改密码"];
    
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

    NSArray *tArr = @[@"请输入原始密码",@"请输入新密码",@"请确认新密码"];
    
    for (NSInteger i = 0 ; i < 3 ; i++) {

        UITextField *textField = [[UITextField alloc] initWithFrame:CGRectMake(15, height, KScreenWidth - 30, 60)];
        [textField setFont:[UIFont systemFontOfSize:15]];
        [textField setPlaceholder:tArr[i]];
        [textField setValue:[UIColor colorWithHexString:@"#999999"] forKeyPath:@"_placeholderLabel.textColor"];
        [self.view addSubview:textField];
        

        [self.view addSubview:[Tools setLineView:CGRectMake(15,height+59, KScreenWidth - 30, 1)]];
        
        [self.view addSubview:[Tools creatImage:CGRectMake(KScreenWidth - 40,height+ 21.5, 17, 17) image:@"mm_tick"]];
        
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

- (void)sureChange{
    
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
