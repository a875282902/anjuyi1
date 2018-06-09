
//
//  CraftSmenDetailsVC.m
//  anjuyi1
//
//  Created by 李 on 2018/6/8.
//  Copyright © 2018年 lsy. All rights reserved.
//

#import "CraftSmenDetailsVC.h"

@interface CraftSmenDetailsVC ()<UIScrollViewDelegate,UITextViewDelegate>
{
    UILabel *_personPlace;
    UILabel *_servicePlace;
}

@property (nonatomic,strong)UIScrollView     *tmpScrollView;
@property (nonatomic,strong)NSMutableArray   *labelArr;

@end

@implementation CraftSmenDetailsVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setTitle:@"工匠汇"];
    [self baseForDefaultLeftNavButton];
    
    [self.view addSubview:self.tmpScrollView];
    
    [self.view addSubview:[Tools setLineView:CGRectMake(0, 0, KScreenWidth, 1)]];
    
    [self setUpUI];
}

-(UIScrollView *)tmpScrollView{
    
    if (!_tmpScrollView) {
        _tmpScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, KScreenWidth, KScreenHeight - KTopHeight)];
        [_tmpScrollView setShowsVerticalScrollIndicator:NO];
        [_tmpScrollView setShowsHorizontalScrollIndicator:NO];
        [_tmpScrollView setContentSize:CGSizeMake(KScreenWidth , MDXFrom6(551))];
        [_tmpScrollView setDelegate:self];
    }
    return _tmpScrollView;
}

- (void)setUpUI{
    
    CGFloat height = 0;
    
    [self.tmpScrollView addSubview:[Tools setLineView:CGRectMake(0, 0, KScreenWidth, 40)]];
    [self.tmpScrollView addSubview:[Tools creatLabel:CGRectMake(15, 0, KScreenWidth - 30, 40) font:[UIFont systemFontOfSize:12] color:[UIColor colorWithHexString:@"#666666"] alignment:(NSTextAlignmentLeft) title:@"说明：请详细填写自己的经验与经历，会影响到后续接单。"]];
    
    height += 40;
    
    NSArray *tArr = @[@"服务类型",@"从业时间",@"接单数量"];
    
    for (NSInteger i = 0 ; i < 3 ; i ++) {
        UIView *v = [[UIView alloc] initWithFrame:CGRectMake(0, height, KScreenWidth, 50)];
        [v addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(selectMyExperience:)]];
        [v setTag:i];
        [self.tmpScrollView addSubview:v];
        
        height += 50;
        
        [v addSubview:[Tools creatLabel:CGRectMake(15, 0, 200, 50) font:[UIFont systemFontOfSize:16] color:[UIColor colorWithHexString:@"#666666"] alignment:(NSTextAlignmentLeft) title:tArr[i]]];
        
        UILabel *label = [Tools creatLabel:CGRectMake(15, 0, KScreenWidth - 45, 50) font:[UIFont systemFontOfSize:16] color:[UIColor colorWithHexString:@"#999999"] alignment:(NSTextAlignmentRight) title:@"请选择"];
        [v addSubview:label];
        
        [self.labelArr addObject:label];
        
        [v addSubview:[Tools creatImage:CGRectMake(KScreenWidth - 21, 20, 6, 10) image:@"arrow_dark"]];
        
        [v addSubview:[Tools setLineView:CGRectMake(15, 49, KScreenWidth - 30, 1)]];
    }
    
    [self.tmpScrollView addSubview:[Tools setLineView:CGRectMake(0, height, KScreenWidth, 10)]];
    
    height += 25;
    
    [self.tmpScrollView addSubview:[Tools creatLabel:CGRectMake(15, height, 200, 40) font:[UIFont systemFontOfSize:16] color:[UIColor colorWithHexString:@"#666666"] alignment:(NSTextAlignmentLeft) title:@"客单量"]];
    
    UITextField *minPrice = [[UITextField alloc] initWithFrame:CGRectMake(KScreenWidth - 235, height, 100, 40)];
    [minPrice setBorderStyle:(UITextBorderStyleRoundedRect)];
    [minPrice setTextAlignment:(NSTextAlignmentCenter)];
    [minPrice setPlaceholder:@"输入低价"];
    [minPrice setKeyboardType:(UIKeyboardTypeNumberPad)];
    [minPrice setFont:[UIFont systemFontOfSize:16]];
    [self.tmpScrollView addSubview:minPrice];
    
    UITextField *maxPrice = [[UITextField alloc] initWithFrame:CGRectMake(KScreenWidth - 115, height,100, 40)];
    [maxPrice setBorderStyle:(UITextBorderStyleRoundedRect)];
    [maxPrice setTextAlignment:(NSTextAlignmentCenter)];
    [maxPrice setPlaceholder:@"输入高价"];
    [maxPrice setKeyboardType:(UIKeyboardTypeNumberPad)];
    [maxPrice setFont:[UIFont systemFontOfSize:16]];
    [self.tmpScrollView addSubview:maxPrice];
    
    height += 40+10;
    
    [self.tmpScrollView addSubview:[Tools setLineView:CGRectMake(15, height, KScreenWidth - 30, 1)]];
    
    height += 15;
    
    [self.tmpScrollView addSubview:[Tools creatLabel:CGRectMake(15, height, 200, 25) font:[UIFont systemFontOfSize:16] color:[UIColor colorWithHexString:@"#666666"] alignment:(NSTextAlignmentLeft) title:@"个人简介"]];
    
    UITextView *textView = [[UITextView alloc] initWithFrame:CGRectMake(MDXFrom6(100), height, KScreenWidth - 115,100)];
    [textView setDelegate:self];
    [textView setFont:[UIFont systemFontOfSize:16]];
    [textView setTextColor:[UIColor blackColor]];
    [textView.layer setBorderWidth:1];
    [textView.layer setCornerRadius:5];
    [textView.layer setBorderColor:[UIColor colorWithHexString:@"#eeeeee"].CGColor];
    [textView setTag:1001];
    [self.tmpScrollView addSubview:textView];
    
    _personPlace = [[UILabel alloc] initWithFrame:CGRectMake(5, 9 , KScreenWidth, 16)];
    [_personPlace setTextColor:[UIColor colorWithHexString:@"#666666"]];
    [_personPlace setText:@"请输入您的个人简介"];
    [_personPlace setFont:[UIFont systemFontOfSize:16]];
    [textView addSubview:_personPlace];
    
    height += 120;
    
    [self.tmpScrollView addSubview:[Tools setLineView:CGRectMake(15, height, KScreenWidth - 30, 1)]];
    
    height += 15;
    
    [self.tmpScrollView addSubview:[Tools creatLabel:CGRectMake(15, height, 200, 25) font:[UIFont systemFontOfSize:16] color:[UIColor colorWithHexString:@"#666666"] alignment:(NSTextAlignmentLeft) title:@"服务简介"]];
    
    UITextView *ftextView = [[UITextView alloc] initWithFrame:CGRectMake(MDXFrom6(100), height, KScreenWidth - 115,100)];
    [ftextView setDelegate:self];
    [ftextView setFont:[UIFont systemFontOfSize:16]];
    [ftextView setTextColor:[UIColor blackColor]];
    [ftextView.layer setBorderWidth:1];
    [ftextView.layer setCornerRadius:5];
    [ftextView setTag:1002];
    [ftextView.layer setBorderColor:[UIColor colorWithHexString:@"#eeeeee"].CGColor];
    [self.tmpScrollView addSubview:ftextView];
    
    _servicePlace = [[UILabel alloc] initWithFrame:CGRectMake(5, 9 , KScreenWidth, 16)];
    [_servicePlace setTextColor:[UIColor colorWithHexString:@"#666666"]];
    [_servicePlace setText:@"请输入您的服务简介"];
    [_servicePlace setFont:[UIFont systemFontOfSize:16]];
    [ftextView addSubview:_servicePlace];

     height += 135;
    
    [self.tmpScrollView addSubview:[Tools setLineView:CGRectMake(15, height, KScreenWidth - 30, 1)]];
    
    UIView *v = [[UIView alloc] initWithFrame:CGRectMake(0, height, KScreenWidth, 50)];
    [v addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(selectServiceLocation)]];
    [v setTag:101];
    [self.tmpScrollView addSubview:v];
    
    height += 50;
    
    [v addSubview:[Tools creatLabel:CGRectMake(15, 0, 200, 50) font:[UIFont systemFontOfSize:16] color:[UIColor colorWithHexString:@"#666666"] alignment:(NSTextAlignmentLeft) title:@"服务地区"]];
    
    UILabel *label = [Tools creatLabel:CGRectMake(15, 0, KScreenWidth - 45, 50) font:[UIFont systemFontOfSize:16] color:[UIColor colorWithHexString:@"#999999"] alignment:(NSTextAlignmentRight) title:@"点击进行多选"];
    [v addSubview:label];
    
    [self.labelArr addObject:label];
    
    [v addSubview:[Tools creatImage:CGRectMake(KScreenWidth - 21, 20, 6, 10) image:@"arrow_dark"]];
    
    [v addSubview:[Tools setLineView:CGRectMake(15, 49, KScreenWidth - 30, 1)]];
    
    height += 15;
    
    UIButton *btn = [Tools creatButton:CGRectMake(15,height  , KScreenWidth - 30, 50) font:[UIFont systemFontOfSize:16] color:[UIColor whiteColor] title:@"提交" image:@""];
    [btn setBackgroundColor:MDRGBA(255, 181, 0, 1)];
    [btn.layer setCornerRadius:5];
    [btn setClipsToBounds:YES];
    [btn addTarget:self action:@selector(upDataToService) forControlEvents:(UIControlEventTouchUpInside)];
    [self.tmpScrollView addSubview:btn];
    
    height += 90;
    
    [self.tmpScrollView setContentSize:CGSizeMake(KScreenWidth, height)];
}

#pragma mark -- 点击事件
- (void)selectMyExperience:(UITapGestureRecognizer *)sender{
    
}

- (void)selectServiceLocation{
    
    
}

- (void)upDataToService{
    
    [self.navigationController popToRootViewControllerAnimated:YES];
}

- (void)textViewDidChangeSelection:(UITextView *)textView{

    if (textView.tag == 1001) {
        if (textView.text.length == 0) {
            [_personPlace setHidden:NO];
        }
        else{
            [_personPlace setHidden:YES];
        }
    }
    else{
        
        if (textView.text.length == 0) {
            [_servicePlace setHidden:NO];
        }
        else{
            [_servicePlace setHidden:YES];
        }
        
    }
    
    if (textView.text.length>100) {
        
        [textView setText:[textView.text substringToIndex:100]];
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