//
//  SettlementViewController.m
//  anjuyi1
//
//  Created by 李 on 2018/6/9.
//  Copyright © 2018年 lsy. All rights reserved.
//

#import "SettlementViewController.h"

@interface SettlementViewController ()<UIScrollViewDelegate>

@property (nonatomic,strong) UIScrollView  * tmpScrollView;

@end

@implementation SettlementViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self setTitle:@"结算中心"];
    
    [self baseForDefaultLeftNavButton];
    
    [self.view addSubview:self.tmpScrollView];
    
    [self.view addSubview:[Tools setLineView:CGRectMake(0, 0, KScreenWidth, 1)]];
    
    [self setUpContent];
}

#pragma mark -- UI
-(UIScrollView *)tmpScrollView{
    
    if (!_tmpScrollView) {
        _tmpScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, KScreenWidth, KScreenHeight - KTopHeight)];
        [_tmpScrollView setShowsVerticalScrollIndicator:NO];
        [_tmpScrollView setShowsHorizontalScrollIndicator:NO];
        [_tmpScrollView setDelegate:self];
    }
    return _tmpScrollView;
}

- (void)setUpContent{
    
    CGFloat height = MDXFrom6(15);
    
    [self.tmpScrollView addSubview:[Tools creatImage:CGRectMake(MDXFrom6(15), height, MDXFrom6(120), MDXFrom6(120)) image:@"find_jlpq_img"]];
    [self.tmpScrollView addSubview:[Tools creatLabel:CGRectMake(MDXFrom6(150), height, KScreenWidth - MDXFrom6(165), MDXFrom6(30)) font:[UIFont systemFontOfSize:16] color:[UIColor colorWithHexString:@"#3b3b3b"] alignment:(NSTextAlignmentLeft) title:@"全程监理服务"]];
    [self.tmpScrollView addSubview:[Tools creatLabel:CGRectMake(MDXFrom6(150),MDXFrom6(45), KScreenWidth - MDXFrom6(165), MDXFrom6(30)) font:[UIFont systemFontOfSize:14] color:[UIColor colorWithHexString:@"#3b3b3b"] alignment:(NSTextAlignmentLeft) title:@"选择户型"]];
    [self.tmpScrollView addSubview:[Tools creatLabel:CGRectMake(MDXFrom6(150), MDXFrom6(75), KScreenWidth - MDXFrom6(165), MDXFrom6(30)) font:[UIFont systemFontOfSize:14] color:[UIColor colorWithHexString:@"#3b3b3b"] alignment:(NSTextAlignmentLeft) title:@"选择服务类型"]];
    [self.tmpScrollView addSubview:[Tools creatLabel:CGRectMake(MDXFrom6(150), MDXFrom6(105), KScreenWidth - MDXFrom6(165), MDXFrom6(30)) font:[UIFont systemFontOfSize:12] color:[UIColor colorWithHexString:@"#ff0000"] alignment:(NSTextAlignmentLeft) title:@"￥123元/平米"]];
    
    height += MDXFrom6(145);
    
    [self.tmpScrollView addSubview:[Tools setLineView:CGRectMake(0, height, KScreenWidth, 1)]];
    
    NSArray *tArr = @[@"姓名",@"手机",@"房屋面积",@"房屋地址",@"房屋户型",@"装修方式",@"开工时间",@"保险方式"];
    NSArray *pArr = @[@"请输入您的姓名",@"请输入您的手机",@"请输入您的房产建筑面积",@"请选择您的房产地址",@"请选择您的房屋户型",@"请选择您的装修方式",@"请选择您的开工时间",@"请选择您的保险方式"];
    
    for (NSInteger i = 0 ; i < 8 ; i++) {
        
        [self.tmpScrollView addSubview:[Tools creatLabel:CGRectMake(MDXFrom6(20), height, MDXFrom6(95), 50) font:[UIFont systemFontOfSize:14] color:[UIColor colorWithHexString:@"#3b3b3b"] alignment:(NSTextAlignmentLeft) title:tArr[i]]];
        
        if (i < 3) {
            UITextField *textField = [[UITextField alloc] initWithFrame:CGRectMake(MDXFrom6(115), height, MDXFrom6(250), 50)];
            [textField setFont:[UIFont systemFontOfSize:14]];
            [textField setPlaceholder:pArr[i]];
            [textField setValue:[UIColor colorWithHexString:@"#999999"] forKeyPath:@"_placeholderLabel.textColor"];
            [textField addTarget:self action:@selector(textValueChange:) forControlEvents:(UIControlEventEditingChanged)];
            if (i != 0) {
                [textField setKeyboardType:(UIKeyboardTypeNumberPad)];
            }
            [textField setTag:i];
            [self.tmpScrollView addSubview:textField];
            
        }
        else{
            
            UILabel *label = [Tools creatLabel:CGRectMake(MDXFrom6(115), height, MDXFrom6(250), 50) font:[UIFont systemFontOfSize:14] color:[UIColor colorWithHexString:@"#999999"] alignment:(NSTextAlignmentLeft) title:pArr[i]];
            [label setUserInteractionEnabled:YES];
            [label setTag:i];
            [label addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(selectTypeToSelectInformation:)]];
            [self.tmpScrollView addSubview:label];
            
            [self.tmpScrollView addSubview:[Tools creatImage:CGRectMake(KScreenWidth - 23 , 16.5 +height, 8, 17) image:@"sy_arrow"]];
            
            
        }
       
        [self.tmpScrollView addSubview:[Tools setLineView:CGRectMake(0, height + 49, KScreenWidth, 1)]];
        height += 50;
        
    }
    
    height += 20;
    
    [self.tmpScrollView addSubview:[Tools creatLabel:CGRectMake(MDXFrom6(20), height, MDXFrom6(95), 20) font:[UIFont systemFontOfSize:14] color:[UIColor colorWithHexString:@"#3b3b3b"] alignment:(NSTextAlignmentLeft) title:@"支付方式"]];
    
    NSArray *iArr = @[@"",@"yinlianico",@"",@"integrat"];
    
    for (NSInteger i = 0 ; i < 4 ; i++) {
        
    }
    
    
    [self.tmpScrollView setContentSize:CGSizeMake(KScreenWidth, height)];
    
}

- (void)textValueChange:(UITextField *)sender{
    
    
}

- (void)selectTypeToSelectInformation:(UITapGestureRecognizer *)sender{
    
    
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
