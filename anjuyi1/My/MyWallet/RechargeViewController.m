//
//  RechargeViewController.m
//  anjuyi1
//
//  Created by 李 on 2018/6/3.
//  Copyright © 2018年 lsy. All rights reserved.
//
//  充值

#import "RechargeViewController.h"

#define Padding MDXFrom6(15)

@interface RechargeViewController ()<UIScrollViewDelegate,UITextFieldDelegate>
{
    NSString *money;
    UITextField * rechargeTextField;
}

@property (nonatomic,strong)UIScrollView    * tmpScrollView;
@property (nonatomic,strong)NSMutableArray  * btnArr;

@end

@implementation RechargeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self setTitle:@"充值"];
    
    [self baseForDefaultLeftNavButton];
    
    [self.view addSubview:self.tmpScrollView];
    
    [self.view addSubview:[Tools setLineView:CGRectMake(0, 0, KScreenWidth, 1)]];
    
    [self setUpUI];
}

- (UIScrollView *)tmpScrollView{
    
    if (!_tmpScrollView) {
        _tmpScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, KScreenWidth, KScreenHeight - KTopHeight)];
        [_tmpScrollView setDelegate:self];
        if (@available(iOS 11.0, *)) {
            [_tmpScrollView setContentInsetAdjustmentBehavior:(UIScrollViewContentInsetAdjustmentNever)];
        }
        [_tmpScrollView setShowsVerticalScrollIndicator:NO];
        [_tmpScrollView setShowsHorizontalScrollIndicator:NO];
    }
    return _tmpScrollView;
}

- (void)setUpUI{
    
    CGFloat height = 0.0f;
    
    for (NSInteger i = 0 ; i < 6 ; i++) {
        
        NSString *string = @"50元\n售价：50元";
        NSMutableAttributedString *str = [[NSMutableAttributedString alloc] initWithString:string];
        
        if (i != 5) {
            NSRange range=[string rangeOfString:@"售"];
            
            NSRange r = NSMakeRange(range.location, string.length - range.location);
            
            [str addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:12] range:r];
            [str addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithHexString:@"#999999"] range:r];
        }
        else{
            str = [[NSMutableAttributedString alloc] initWithString:@"其他金额"];
            [str addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithHexString:@"#999999"] range:NSMakeRange(0, 4)];
            [str addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:17] range:NSMakeRange(0, 4)];
        }
       
        
        UIButton *btn = [UIButton buttonWithType:(UIButtonTypeCustom)];
        [btn setAttributedTitle:str forState:(UIControlStateNormal)];
        [btn.titleLabel setNumberOfLines:0];
        [btn.layer setCornerRadius:5];
        [btn.layer setBorderColor:[UIColor colorWithHexString:@"#dddddd"].CGColor];
        [btn.layer setBorderWidth:1];
        [btn.titleLabel setTextAlignment:(NSTextAlignmentCenter)];
        [btn setFrame:CGRectMake(MDXFrom6(15+120*(i%3)), MDXFrom6(15+70*(i/3)), MDXFrom6(105), MDXFrom6(60))];
        [btn addTarget:self action:@selector(rechargeDidPress:) forControlEvents:(UIControlEventTouchUpInside)];
        [btn setTag:i];
        [self.tmpScrollView addSubview:btn];
        
    }
    
    height += MDXFrom6(15+70*2) +MDXFrom6(25);
    
    UITextField *textField = [[UITextField alloc] initWithFrame:CGRectMake(Padding, height, KScreenWidth - Padding *2 , MDXFrom6(30))];
    [textField setPlaceholder:@"输入充值金额(整数)"];
    [textField setFont:[UIFont systemFontOfSize:16]];
    [textField setKeyboardType:(UIKeyboardTypeNumberPad)];
    [textField setDelegate:self];
    [textField addTarget:self action:@selector(textValueChange:) forControlEvents:(UIControlEventEditingChanged)];
    [self.tmpScrollView addSubview:textField];
    
    rechargeTextField = textField;
    
    height += MDXFrom6(40);
    
    [self.tmpScrollView addSubview:[Tools setLineView:CGRectMake(Padding, height, KScreenWidth - Padding *2, 1)]];
    
    height += MDXFrom6(20);
    
    [self.tmpScrollView addSubview:[Tools creatLabel:CGRectMake(Padding, height, KScreenWidth - 2*Padding, MDXFrom6(30)) font:[UIFont systemFontOfSize:18] color:[UIColor blackColor] alignment:(NSTextAlignmentLeft) title:@"支付方式"]];
    
    height += MDXFrom6(35);
    
    self.btnArr = [NSMutableArray array];
    
    NSArray *iArr = @[@"wxico",@"alipayico",@"yinlianico"];
    NSArray *tArr = @[@"微信支付",@"支付宝支付",@"银联支付"];
    
    for (NSInteger i = 0; i < 3; i++) {
        
        UIView *backView = [[UIView alloc] initWithFrame:CGRectMake(0, height + MDXFrom6(65*i), KScreenWidth , MDXFrom6(65))];
        [backView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(selectPayType:)]];
        [backView setTag:i];
        [self.tmpScrollView addSubview:backView];
        
        [backView addSubview:[Tools creatImage:CGRectMake(MDXFrom6(20), MDXFrom6(15), MDXFrom6(35), MDXFrom6(35)) image:iArr[i]]];
        
        [backView addSubview:[Tools creatLabel:CGRectMake(MDXFrom6(65), 0, MDXFrom6(200), MDXFrom6(65)) font:[UIFont systemFontOfSize:16] color:[UIColor blackColor] alignment:(NSTextAlignmentLeft) title:tArr[i]]];
        
        UIImageView *vie = [Tools creatImage:CGRectMake(MDXFrom6(325), MDXFrom6(21.5), MDXFrom6(22), MDXFrom6(22)) image:@"unselected"];
        [backView addSubview:vie];
        
        [self.btnArr addObject:vie];
        
        [backView addSubview:[Tools setLineView:CGRectMake(Padding, MDXFrom6(64), KScreenWidth - 2*Padding, MDXFrom6(1))]];
        
    }
    
    height += MDXFrom6(65*3)+MDXFrom6(25);
    
    UIButton *btn = [UIButton buttonWithType:(UIButtonTypeCustom)];
    [btn setFrame:CGRectMake(Padding, height , KScreenWidth - Padding*2, MDXFrom6(50))];
    [btn setTitle:@"支付" forState:(UIControlStateNormal)];
    [btn setTitleColor:[UIColor whiteColor] forState:(UIControlStateNormal)];
    [btn setBackgroundColor:[UIColor colorWithHexString:@"#ffb638"]];
    [btn.layer setCornerRadius:3];
    [btn.titleLabel setFont:[UIFont systemFontOfSize:18]];
    
    [btn addTarget:self action:@selector(recharge) forControlEvents:(UIControlEventTouchUpInside)];
    [self.tmpScrollView addSubview:btn];
    
    height += MDXFrom6(80);
    
    [self.tmpScrollView setContentSize:CGSizeMake(KScreenWidth, height)];
}


- (void)rechargeDidPress:(UIButton *)sender{
    
    if (sender.tag == 5) {
        [rechargeTextField becomeFirstResponder];
    }
}

- (void)textValueChange:(UITextField *)textField{
    
    money = textField.text;
    
}

- (void)selectPayType:(UITapGestureRecognizer *)sender{
    
    for (UIImageView *im in self.btnArr) {
        [im setImage:[UIImage imageNamed:@"unselected"]];
    }
    
    [(UIImageView *)self.btnArr[sender.view.tag] setImage:[UIImage imageNamed:@"selected"]];
}

- (void)recharge{
    
    
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
