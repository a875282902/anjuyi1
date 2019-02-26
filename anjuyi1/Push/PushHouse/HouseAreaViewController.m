//
//  HouseAreaViewController.m
//  anjuyi1
//
//  Created by apple on 2018/7/15.
//  Copyright © 2018年 lsy. All rights reserved.
//

#import "HouseAreaViewController.h"
#import "HouseCityViewController.h"

@interface HouseAreaViewController ()
{
    NSString * areaStr;
}

@property (nonatomic,strong)UILabel * areaLabel;

@end

@implementation HouseAreaViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self baseForDefaultLeftNavButton];
    
    areaStr = @"0";
    
    [self  setUpUI];
}


- (void)setUpUI{
    
    UIButton *btn = [Tools creatButton:CGRectMake(15, KViewHeight - 80, KScreenWidth - 30, 50) font:[UIFont systemFontOfSize:16] color:[UIColor whiteColor] title:@"确定" image:@""];
    [btn setBackgroundColor:MDRGBA(255, 181, 0, 1)];
    [btn.layer setCornerRadius:5];
    [btn setClipsToBounds:YES];
    [btn addTarget:self action:@selector(sureHouseArea) forControlEvents:(UIControlEventTouchUpInside)];
    [self.view addSubview:btn];
    
    CGFloat height = KViewHeight - 310;
    
    NSArray *tArr = @[@"1",@"2",@"3",@"4",@"5",@"6",@"7",@"8",@"9",@"·",@"0",@""];
    NSArray *iArr = @[@"",@"",@"",@"",@"",@"",@"",@"",@"",@"",@"",@"del_aj"];
    
    for (NSInteger i = 0 ; i < 12 ; i ++) {
        
        UIButton *btn = [Tools creatButton:CGRectMake(KScreenWidth*(i%3) /3,height + 50*(i/3), KScreenWidth/3, 50) font:[UIFont boldSystemFontOfSize:23] color:[UIColor blackColor] title:tArr[i] image:iArr[i]];
        [btn setTag:i];
        [btn addTarget:self action:@selector(selectNum:) forControlEvents:(UIControlEventTouchUpInside)];
        [self.view addSubview:btn];
    }
    
    [self.view addSubview:[Tools setLineView:CGRectMake(KScreenWidth/3, height, 2, 200)]];
    [self.view addSubview:[Tools setLineView:CGRectMake(KScreenWidth*2/3, height, 2, 200)]];
    [self.view addSubview:[Tools setLineView:CGRectMake(0, height + 50, KScreenWidth , 2)]];
    [self.view addSubview:[Tools setLineView:CGRectMake(0, height + 100, KScreenWidth , 2)]];
    [self.view addSubview:[Tools setLineView:CGRectMake(0, height + 150, KScreenWidth , 2)]];
    
    
    [self.view addSubview:[Tools creatLabel:CGRectMake(0, 25, KScreenWidth, 21) font:[UIFont systemFontOfSize:21] color:[UIColor blackColor] alignment:(NSTextAlignmentCenter) title:@"房子的装修面积是多少？"]];

    NSString *areass = @"0.00  平米";
    
    self.areaLabel = [Tools creatLabel:CGRectMake(0, 86, KScreenWidth, 21) font:[UIFont systemFontOfSize:21] color:[UIColor colorWithHexString:@"#999999"] alignment:(NSTextAlignmentCenter) title:areass];
    
    [self.areaLabel setAttributedText:[self attributedStringWithString:areass]];
    [self.view addSubview:self.areaLabel];
    
    
}

- (void)sureHouseArea{
    
    if ([areaStr integerValue] == 0) {
        [ViewHelps showHUDWithText:@"请输入房屋装修面积"];
        return;
    }
    
    if (self.house_id) {
        [self editHouseInfo];
    }
    else{
        [self.houseDic setValue:areaStr forKey:@"proportion"];
        
        HouseCityViewController *vc = [[HouseCityViewController alloc] init];
        vc.houseDic = self.houseDic;
        [self.navigationController pushViewController:vc animated:YES];
    }
}

- (void)selectNum:(UIButton *)sender{
    
    if (sender.tag <= 8) {
        
        if ([areaStr floatValue] > 0) {
            areaStr = [NSString stringWithFormat:@"%@%ld",areaStr,(long)(sender.tag+1)];
        }
        else{
            
            if (![areaStr containsString:@"."]) {
                
                areaStr = [NSString stringWithFormat:@"%ld",(long)(sender.tag+1)];
            }
            else{
                areaStr = [NSString stringWithFormat:@"%@%ld",areaStr,(long)(sender.tag+1)];
            }
        }

    }
    else if (sender.tag == 9){
        
        if (![areaStr containsString:@"."]) {
            
            if ([areaStr floatValue]> 0 ) {
                areaStr = [NSString stringWithFormat:@"%@.",areaStr];
            }
            else{
                areaStr = @"0.";
            }
        }
    }
    else if (sender.tag == 10){
        
        if ([areaStr floatValue] > 0) {
            areaStr = [NSString stringWithFormat:@"%@0",areaStr];
        }
    }
    else if (sender.tag == 11){
        
        if ([areaStr length] > 0) {
            areaStr = [areaStr substringToIndex:(areaStr.length - 1)];
        }
    }
    
    [self.areaLabel setAttributedText:[self attributedStringWithString:[NSString stringWithFormat:@"%@     平米",areaStr]]];
}

- (NSAttributedString *)attributedStringWithString:(NSString *)str{
    
    NSMutableAttributedString *arrs = [[NSMutableAttributedString alloc] initWithString:str];
    [arrs addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:16] range:NSMakeRange(str.length - 2, 2)];
    [arrs addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithHexString:@"#47BABA"] range:NSMakeRange(str.length - 2, 2)];
    
    return arrs;
}

#pragma mark -- 修改房屋信息
- (void)editHouseInfo{
    
    
    NSString *path = [NSString stringWithFormat:@"%@/whole_house/update_house_info",KURL];
    
    NSDictionary *header = @{@"token":UTOKEN};
    
    NSDictionary *parame = @{@"id":self.house_id,
                             @"proportion":areaStr};
    
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    __weak typeof(self) weakSelf = self;
    
    [HttpRequest POSTWithHeader:header url:path parameters:parame success:^(id  _Nullable responseObject) {
        
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        
        if ([responseObject[@"code"] integerValue] == 200) {
            
            [weakSelf.navigationController popViewControllerAnimated:YES];
        }
        else{
            
            [ViewHelps showHUDWithText:responseObject[@"message"]];
        }
        
        
    } failure:^(NSError * _Nullable error) {
        
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        [RequestSever showMsgWithError:error];
    }];
    
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
