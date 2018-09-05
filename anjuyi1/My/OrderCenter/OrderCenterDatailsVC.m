//
//  OrderCenterDatailsVC.m
//  anjuyi1
//
//  Created by 李 on 2018/6/8.
//  Copyright © 2018年 lsy. All rights reserved.
//

#import "OrderCenterDatailsVC.h"

@interface OrderCenterDatailsVC ()<UIScrollViewDelegate>

@property (nonatomic,strong)UITableView *tmpTableView;
@property (nonatomic,strong)UIScrollView *tmpScrollView;
@property (nonatomic,strong)NSDictionary *data;

@end

@implementation OrderCenterDatailsVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setTitle:@"订单详情"];
    [self baseForDefaultLeftNavButton];
    
    [self.view addSubview:self.tmpScrollView];
    
    [self.view addSubview:[Tools setLineView:CGRectMake(0, 0, KScreenWidth, 1)]];
    
    [self requestOrderInfo];
}

- (void)requestOrderInfo{
    
    
    NSString *path = [NSString stringWithFormat:@"%@/task/detail",KURL];
    
    NSDictionary *header = @{@"token":UTOKEN};
    
    
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    __weak typeof(self) weakSelf = self;
    
    [HttpRequest POSTWithHeader:header url:path parameters:@{@"id":self.orderId} success:^(id  _Nullable responseObject) {
        
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        
        if ([responseObject[@"code"] integerValue] == 200) {
            
            weakSelf.data = responseObject[@"datas"];
            
            [weakSelf setUpContentView];
        }
        else{
            
            [ViewHelps showHUDWithText:responseObject[@"message"]];
        }
        
        
    } failure:^(NSError * _Nullable error) {
        
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        [RequestSever showMsgWithError:error];
    }];

    
}

#pragma mark -- scrollview
-(UIScrollView *)tmpScrollView{
    
    if (!_tmpScrollView) {
        _tmpScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, KScreenWidth, KViewHeight - 90)];
        [_tmpScrollView setShowsVerticalScrollIndicator:NO];
        [_tmpScrollView setShowsHorizontalScrollIndicator:NO];
        if (@available(iOS 11.0, *)) {
            [_tmpScrollView setContentInsetAdjustmentBehavior:(UIScrollViewContentInsetAdjustmentNever)];
        }
        [_tmpScrollView setDelegate:self];
    }
    return _tmpScrollView;
}

- (void)setUpContentView{
    
    NSArray *tArr = @[@"地区",@"类型",@"户型",@"预算",@"户主名字",@"户型面积",@"户型图",@"备注"];
    NSArray *dArr = @[[NSString stringWithFormat:@"%@ %@ %@",self.data[@"province"],self.data[@"city"],self.data[@"area"]],
                      self.data[@"type"],
                      [NSString stringWithFormat:@"%@%@",self.data[@"room"],self.data[@"hall"]],
                      [NSString stringWithFormat:@"%@元",self.data[@"budget"]],
                      self.data[@"name"],
                      [NSString stringWithFormat:@"%@平米",self.data[@"proportion"]]];
    
    
    CGFloat height = 0;
    
    for (NSInteger i = 0 ; i < 6; i++) {
        
        [self.tmpScrollView addSubview:[Tools creatLabel:CGRectMake(10, height, 70, 45) font:[UIFont systemFontOfSize:16] color:[UIColor colorWithHexString:@"#666666"] alignment:(NSTextAlignmentLeft) title:tArr[i]]];
        
        [self.tmpScrollView addSubview:[Tools creatLabel:CGRectMake(90, height, KScreenWidth - 100, 45) font:[UIFont systemFontOfSize:16] color:[UIColor colorWithHexString:@"#000000"] alignment:(NSTextAlignmentRight) title:dArr[i]]];
        
        [self.tmpScrollView addSubview:[Tools setLineView:CGRectMake(0, height+44, KScreenWidth, 1)]];
        
        height += 45;
    }
    

    [self.tmpScrollView addSubview:[Tools creatLabel:CGRectMake(10, height, 70, 45) font:[UIFont systemFontOfSize:16] color:[UIColor colorWithHexString:@"#666666"] alignment:(NSTextAlignmentLeft) title:@"户型图"]];
    [self.tmpScrollView addSubview:[Tools creatImage:CGRectMake(KScreenWidth - 160, height +10, 150, 150) url:self.data[@"doorimg1"] image:@""]];
    [self.tmpScrollView addSubview:[Tools setLineView:CGRectMake(0, height+169, KScreenWidth, 1)]];
    
    height+= 170;
    
    [self.tmpScrollView addSubview:[Tools creatLabel:CGRectMake(10, height, 70, 45) font:[UIFont systemFontOfSize:16] color:[UIColor colorWithHexString:@"#666666"] alignment:(NSTextAlignmentLeft) title:@"备注"]];
    
    [self.tmpScrollView addSubview:[Tools creatLabel:CGRectMake(90, height, KScreenWidth - 100, 45) font:[UIFont systemFontOfSize:16] color:[UIColor colorWithHexString:@"#000000"] alignment:(NSTextAlignmentRight) title:self.data[@"requirements"]]];
    
    [self.tmpScrollView addSubview:[Tools setLineView:CGRectMake(0, height+44, KScreenWidth, 1)]];
    
    height += 45;
    
    
    [self.tmpScrollView setContentSize:CGSizeMake(KScreenWidth, height+20)];
    
    UIButton *btn = [Tools creatButton:CGRectMake(10,KViewHeight - 70, KScreenWidth -20, 50) font:[UIFont systemFontOfSize:16] color:[UIColor whiteColor] title:@"接受订单" image:@""];
    [btn setBackgroundColor:MDRGBA(255, 181, 0, 1)];
    [btn.layer setCornerRadius:5];
    [btn setClipsToBounds:YES];
    [btn addTarget:self action:@selector(acceptOrders) forControlEvents:(UIControlEventTouchUpInside)];
    [self.view addSubview:btn];
}



- (void)acceptOrders{
    
    
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
