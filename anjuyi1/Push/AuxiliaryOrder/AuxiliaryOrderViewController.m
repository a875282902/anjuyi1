//
//  AuxiliaryOrderViewController.m
//  anjuyi1
//
//  Created by apple on 2018/9/13.
//  Copyright © 2018年 lsy. All rights reserved.
//

#import "AuxiliaryOrderViewController.h"
#import "PhotoOrderViewController.h"

@interface AuxiliaryOrderViewController ()
@property (weak, nonatomic) IBOutlet UIImageView *phoneOrder;
@property (weak, nonatomic) IBOutlet UIImageView *callOrder;

@end

@implementation AuxiliaryOrderViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    [self baseForDefaultLeftNavButton];
    [self setTitle:@"辅助下单"];
    
    [self.view addSubview:[Tools setLineView:CGRectMake(0, 0, KScreenWidth, 1)]];
    [self.phoneOrder addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(selectSupervisorService)]];
    [self.callOrder addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(selectSignService)]];
}

#pragma mark -- 点击事件
- (void)leftButtonTouchUpInside:(id)sender{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)selectSupervisorService{
    
    PhotoOrderViewController *vc = [[PhotoOrderViewController alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)selectSignService{
    
    
    NSString *path = [NSString stringWithFormat:@"%@/auxiliary_order/get_tel",KURL];
    
    NSDictionary *header = @{@"token":UTOKEN};
    
    
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    __weak typeof(self) weakSelf = self;
    
    [HttpRequest POSTWithHeader:header url:path parameters:nil success:^(id  _Nullable responseObject) {
        
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        
        if ([responseObject[@"code"] integerValue] == 200) {
            
            [weakSelf callPhone:responseObject[@"datas"][@"tel"]];
        }
        else{
            
            [ViewHelps showHUDWithText:responseObject[@"message"]];
        }
        
        
    } failure:^(NSError * _Nullable error) {
        
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        [RequestSever showMsgWithError:error];
    }];

}
-(void)callPhone:(NSString *)phoneNumber{
    
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
