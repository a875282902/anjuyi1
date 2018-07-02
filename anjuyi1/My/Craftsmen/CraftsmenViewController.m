//
//  CraftsmenViewController.m
//  anjuyi1
//
//  Created by 李 on 2018/6/8.
//  Copyright © 2018年 lsy. All rights reserved.
//

#import "CraftsmenViewController.h"
#import "CraftsmanTypeVC.h"//工匠类型

@interface CraftsmenViewController ()<UIScrollViewDelegate>
{
    NSInteger time;
    UIButton *codeBtn;
}
@property (nonatomic,strong)UIScrollView *tmpScrollView;

@property (nonatomic,strong)NSTimer *timer;

@end

@implementation CraftsmenViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setTitle:@"工匠汇"];
    [self baseForDefaultLeftNavButton];
    
    [self.view addSubview:self.tmpScrollView];
    
    [self.view addSubview:[Tools setLineView:CGRectMake(0, 0, KScreenWidth, 1)]];
    
    [self setUpUi];
}

-(UIScrollView *)tmpScrollView{
    
    if (!_tmpScrollView) {
        _tmpScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, KScreenWidth, KScreenHeight-KTopHeight)];
        [_tmpScrollView setShowsVerticalScrollIndicator:NO];
        [_tmpScrollView setShowsHorizontalScrollIndicator:NO];
        [_tmpScrollView setDelegate:self];
    }
    return _tmpScrollView;
}

- (void)setUpUi{
    
    CGFloat height = 40;
    
    [self.tmpScrollView addSubview:[Tools creatImage:CGRectMake((KScreenWidth-35)/2.0, height, 35, 35) image:@"gjrz_shiming"]];
    
    height += 40;
    
    [self.tmpScrollView addSubview:[Tools creatLabel:CGRectMake(0, height, KScreenWidth, 20) font:[UIFont boldSystemFontOfSize:18] color:[UIColor colorWithHexString:@"#ffb638"] alignment:(NSTextAlignmentCenter) title:@"实名认证"]];
    
    height += 40;
    
    NSArray *tArr = @[@"输入银联卡号",@"请输入身份证号",@"输入银行预留手机号",@"姓名",@"验证码"];
    
    for (NSInteger i = 0 ; i < 5 ; i++) {
        
        UITextField *textField = [[UITextField alloc] initWithFrame:CGRectMake(15, height, KScreenWidth - 30, 60)];
        [textField setFont:[UIFont systemFontOfSize:15]];
        [textField setPlaceholder:tArr[i]];
        [textField setValue:[UIColor colorWithHexString:@"#999999"] forKeyPath:@"_placeholderLabel.textColor"];
        [self.tmpScrollView addSubview:textField];
        
        [self.tmpScrollView addSubview:[Tools setLineView:CGRectMake(15, height + 59, KScreenWidth - 30, 1)]];
        
        height += 60;
    }
    
    codeBtn = [Tools creatButton:CGRectMake(KScreenWidth - 120, height - 47.5  , 105, 35) font:[UIFont systemFontOfSize:15] color:[UIColor whiteColor] title:@"获取验证码" image:@""];
    [codeBtn setBackgroundColor:[UIColor colorWithHexString:@"#ffb638"]];
    [codeBtn.layer setCornerRadius:5];
    [codeBtn setClipsToBounds:YES];
    [codeBtn setTag:2];
    [codeBtn addTarget:self action:@selector(getCode:) forControlEvents:(UIControlEventTouchUpInside)];
    [self.tmpScrollView addSubview:codeBtn];
    
    height += 20;

    UIButton *btn = [Tools creatButton:CGRectMake(15, height , KScreenWidth - 30, 50) font:[UIFont systemFontOfSize:16] color:[UIColor whiteColor] title:@"实名认证" image:@""];
    [btn setBackgroundColor:MDRGBA(255, 181, 0, 1)];
    [btn.layer setCornerRadius:5];
    [btn setClipsToBounds:YES];
    [btn addTarget:self action:@selector(sureAuthentication) forControlEvents:(UIControlEventTouchUpInside)];
    [self.tmpScrollView addSubview:btn];
    
    height += 75;
    
    NSString *str = @"说明：工匠汇入驻人员必须完成实名认证后，阅读《入驻须知》后，才可以入驻平台，开始接单或发布内容。";
    
    NSMutableAttributedString *attS = [[NSMutableAttributedString alloc] initWithString:str];
    
    [attS setAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:12],NSForegroundColorAttributeName:[UIColor colorWithHexString:@"#999999"]} range:NSMakeRange(0, str.length)];
    [attS setAttributes:@{NSForegroundColorAttributeName:[UIColor redColor],NSFontAttributeName:[UIFont systemFontOfSize:12]} range:NSMakeRange(22, 6)];
    [attS addAttribute:NSUnderlineStyleAttributeName value:@(NSUnderlineStyleSingle|NSUnderlinePatternSolid) range:NSMakeRange(23, 4)];
    [attS addAttribute:NSUnderlineColorAttributeName value:[UIColor redColor] range:NSMakeRange(23, 4)];
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(15, height, KScreenWidth - 30, 40)];
    [label setAttributedText:attS];
    [label setNumberOfLines:0];
    [self.tmpScrollView addSubview:label];
    
    height += 60;
    
    [self.tmpScrollView setContentSize:CGSizeMake(KScreenWidth, height)];
}

- (void)getCode:(UIButton *)sender{
    
    if (!self.timer) {
        self.timer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(timeChange) userInfo:nil repeats:YES];
    }
    
    [sender removeTarget:self action:@selector(getCode:) forControlEvents:(UIControlEventTouchUpInside)];
    
    [sender setTitle:@"60 S" forState:(UIControlStateNormal)];
    
    time = 60;
    
}

- (void)timeChange{
    
    time -- ;
    
    if (time<1) {
        
        if (![codeBtn.titleLabel.text isEqualToString:@"获取验证码"]) {
            [codeBtn setTitle:@"获取验证码" forState:(UIControlStateNormal)];
            [codeBtn addTarget:self action:@selector(getCode:) forControlEvents:(UIControlEventTouchUpInside)];
        }
    }
    else{
        [codeBtn setTitle:[NSString stringWithFormat:@"%ld S",time] forState:(UIControlStateNormal)];
    }
}

- (void)sureAuthentication{
    
    CraftsmanTypeVC *vc = [[CraftsmanTypeVC alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
    
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
