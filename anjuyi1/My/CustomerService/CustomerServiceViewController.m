//
//  CustomerServiceViewController.m
//  anjuyi1
//
//  Created by 李 on 2018/6/3.
//  Copyright © 2018年 lsy. All rights reserved.
//
//  在线客服

#import "CustomerServiceViewController.h"

@interface CustomerServiceViewController ()

@end

@implementation CustomerServiceViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self setTitle:@"在线客服"];
    
    [self baseForDefaultLeftNavButton];
    
    
    NSArray *tArr = @[@"微信客服",@"QQ客服",@"电话客服",@"在线客服"];
    NSArray *iArr = @[@"online_wx",@"online_qq",@"online_dhkf",@"online_kf"];
    
    for (NSInteger i = 0; i < 4; i++) {
        UIView *backView = [[UIView alloc] initWithFrame:CGRectMake(KScreenWidth*(i%2)/2, MDXFrom6(115)*(i/2), KScreenWidth/2, KScreenWidth/2)];
        [backView setTag:i];
        [backView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(selectCustomerService:)]];
        [self.view addSubview:backView];
        
        [backView addSubview:[Tools creatImage:CGRectMake(MDXFrom6(73.75), MDXFrom6(20), MDXFrom6(40), MDXFrom6(40)) image:iArr[i]]];
        
        [backView addSubview:[Tools creatLabel:CGRectMake(0, MDXFrom6(75), KScreenWidth/2, 20) font:[UIFont systemFontOfSize:15] color:[UIColor blackColor] alignment:(NSTextAlignmentCenter) title:tArr[i]]];
    }
    
    [self.view addSubview:[Tools setLineView:CGRectMake(0, 0, KScreenWidth, 1.5)]];
    
    [self.view addSubview:[Tools setLineView:CGRectMake(KScreenWidth/2,1 ,1 , MDXFrom6(230))]];
    
    [self.view addSubview:[Tools setLineView:CGRectMake(0, MDXFrom6(115), KScreenWidth, 1)]];
    
    [self.view addSubview:[Tools setLineView:CGRectMake(0, MDXFrom6(230), KScreenWidth, 1)]];
    
    
}


- (void)selectCustomerService:(UITapGestureRecognizer *)sender{
    
    switch (sender.view.tag) {
        case 2:
            [self callPhone:@"1008611"];
            break;
            
        default:
            break;
    }
}

//打电话
-(void)callPhone:(NSString *)phoneNumber{
    if (![Tools isSIMInstalled]) {
        [ViewHelps showHUDWithText:@"该设备不能打电话"];
        return;
    }
    NSString *cleanedString =[[phoneNumber componentsSeparatedByCharactersInSet:[[NSCharacterSet characterSetWithCharactersInString:@"0123456789-+()"] invertedSet]] componentsJoinedByString:@""];
    NSString *escapedPhoneNumber = [cleanedString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSString *str_url = [[NSString alloc]initWithFormat:@"tel://%@", escapedPhoneNumber];
    NSURL *telURL = [NSURL URLWithString:[NSString stringWithFormat:str_url, escapedPhoneNumber]];
    UIWebView *mCallWebview = [[UIWebView alloc] init] ;
    [self.view addSubview:mCallWebview];
    [mCallWebview loadRequest:[NSURLRequest requestWithURL:telURL]];
    
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
