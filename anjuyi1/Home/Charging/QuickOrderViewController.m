//
//  QuickOrderViewController.m
//  anjuyi1
//
//  Created by apple on 2018/6/14.
//  Copyright © 2018年 lsy. All rights reserved.
//
//  快速下单

#import "QuickOrderViewController.h"
#import "SelectCityView.h"//选择城市
#import "SelectView.h"//选择框
#import "LSYLocation.h"

@interface QuickOrderViewController ()<UIScrollViewDelegate,SelectViewDelegate,LSYLocationDelegta,SelectCityViewDelegate>
{
    NSInteger time;
    UIButton *codeBtn;
    NSDictionary *_province;
    NSDictionary *_city;
    NSDictionary *_area;
    UIButton *_selectLocationBtn;
    UILabel *_demandType;
    NSDictionary *_selectDemandDic;
}

@property (nonatomic,strong)NSMutableArray * textArr;
@property (nonatomic,strong)NSMutableArray * demandArr;
@property (nonatomic,strong)UIScrollView   * tmpScrollView;
@property (nonatomic,strong)NSTimer        * timer;
@property (nonatomic,strong)UILabel        * location;
@property (nonatomic,strong)SelectView     * selectDemand;

@property (nonatomic,strong)LSYLocation    * locationSevice;
@property (nonatomic,strong)SelectCityView * selectCityView;//选择城市

@end

@implementation QuickOrderViewController



- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.textArr = [NSMutableArray arrayWithObjects:@"",@"",@"",@"", @"",@"",@"",@"",@"",@"",@"",@"",nil];
    time = 60;
    self.demandArr = [NSMutableArray array];
    
    [self baseForDefaultLeftNavButton];
    [self setTitle:@"充电桩实地测量"];
    
    [self.view addSubview:self.tmpScrollView];
    

    [self getData];
    
    [self setUpUI];
    
    [self.view addSubview:self.selectDemand];
    
    [self.locationSevice beginUpdatingLocation];
    
    [self.view addSubview:self.selectCityView];
    
}
#pragma mark -- network
- (void)getData{
    
    
    NSString *path = [NSString stringWithFormat:@"%@/Charging/add_quick_order_info",KURL];
    
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    __weak typeof(self) weakSelf = self;
    
    [HttpRequest POST:path parameters:nil success:^(id  _Nullable responseObject) {
        
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        
        if ([responseObject[@"code"] integerValue] == 200) {
            
            if ([responseObject[@"datas"][@"requirements"] isKindOfClass:[NSArray class]]) {
                
                for (NSDictionary *dic in responseObject[@"datas"][@"requirements"]) {
                    [weakSelf.demandArr addObject:dic];
                }
            }
        }
        else{
            
            [ViewHelps showHUDWithText:responseObject[@"message"]];
        }
        
        
    } failure:^(NSError * _Nullable error) {
        
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        [RequestSever showMsgWithError:error];
    }];
}

- (SelectView *)selectDemand{
    
    if (!_selectDemand) {
        
        _selectDemand = [[SelectView alloc] initWithFrame:CGRectMake(0, 0 , KScreenWidth, KViewHeight)];
        [_selectDemand setDelegate:self];
    }
    return _selectDemand;
}

#pragma mark -- scrollview
-(UIScrollView *)tmpScrollView{
    
    if (!_tmpScrollView) {
        _tmpScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 55, KScreenWidth, KViewHeight -55)];
        if (@available(iOS 11.0, *)) {
            [_tmpScrollView setContentInsetAdjustmentBehavior:(UIScrollViewContentInsetAdjustmentNever)];
        }
        [_tmpScrollView setShowsVerticalScrollIndicator:NO];
        [_tmpScrollView setShowsHorizontalScrollIndicator:NO];
        [_tmpScrollView setDelegate:self];
    }
    return _tmpScrollView;
}

- (void)setUpUI{
    
    [self craeteAleartView];
    
    CGFloat height = 25;

    [self.tmpScrollView addSubview:[Tools creatLabel:CGRectMake(15, height, 85, 16) font:[UIFont systemFontOfSize:16] color:[UIColor colorWithHexString:@"#333333"] alignment:(NSTextAlignmentLeft) title:@"咨询/下单"]];
    
    height += 41;
    
    [self.tmpScrollView addSubview:[Tools creatImage:CGRectMake(15, height + 10, 15, 15) image:@"add_add"]];
    
    CGRect rect = [@"----" boundingRectWithSize:CGSizeMake(1000000, 35) options:NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:15]} context:nil];
    
    self.location = [Tools creatLabel:CGRectMake(40, height, rect.size.width , 35) font:[UIFont systemFontOfSize:15] color:[UIColor blackColor] alignment:(NSTextAlignmentLeft) title:@"----"];
    [self.tmpScrollView addSubview:self.location];
    
    UIButton * rechange = [Tools creatButton:CGRectMake(55 + rect.size.width, height, 80, 35) font:[UIFont systemFontOfSize:14] color:[UIColor colorWithHexString:@"#23b7b5"] title:@"重新选择" image:@""];
    [rechange setBackgroundColor:[UIColor colorWithHexString:@"#eaf8f8"]];
    [rechange.layer setCornerRadius:7.5];
    [rechange.layer setBorderColor:[UIColor colorWithHexString:@"#34bab8"].CGColor];
    [rechange.layer setBorderWidth:1];
    [rechange addTarget:self action:@selector(rechangeLocation:) forControlEvents:(UIControlEventTouchUpInside)];
    [self.tmpScrollView addSubview:rechange];
    
    _selectLocationBtn = rechange;
    
    height += 50;
    
    
    height = [self inputPersonInfor:height];
    
    height += 35;
    
    UIButton *btn = [Tools creatButton:CGRectMake(15, height, KScreenWidth - 30, 50) font:[UIFont systemFontOfSize:18] color:[UIColor whiteColor] title:@"提交" image:@""];
    [btn setBackgroundColor:[UIColor colorWithHexString:@"#ffb638"]];
    [btn.layer setCornerRadius:5];
    [btn setClipsToBounds:YES];
    [btn addTarget:self action:@selector(submit) forControlEvents:(UIControlEventTouchUpInside)];
    [self.tmpScrollView addSubview:btn];
    
    height += 70;
    
    [self.tmpScrollView addSubview:[Tools creatLabel:CGRectMake(15, height, KScreenWidth - 30, 30) font:[UIFont systemFontOfSize:12] color:[UIColor colorWithHexString:@"#333333"] alignment:(NSTextAlignmentCenter) title:@"提示：报名后，客服会与您电话联系，请你保持电话畅通"]];
    
    height += 50;
    
    [self.tmpScrollView setContentSize:CGSizeMake(KScreenWidth, height)];
    
}

- (void)craeteAleartView{
    
    UIView * alertView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, KScreenWidth, 50)];
    [alertView setBackgroundColor:MDRGBA(246, 246, 246, 1)];
    [self.view addSubview:alertView];
    
    NSString *str = @"测量说明：报名实地测量的用户需先阅读《安装须知》后，才可进行测量报名。";
    
    NSMutableAttributedString *attS = [[NSMutableAttributedString alloc] initWithString:str];
    
    [attS setAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:12],NSForegroundColorAttributeName:[UIColor colorWithHexString:@"#999999"]} range:NSMakeRange(0, str.length)];
    [attS setAttributes:@{NSForegroundColorAttributeName:BTNCOLOR,NSFontAttributeName:[UIFont systemFontOfSize:12]} range:NSMakeRange(18, 6)];
    
    
    UILabel *label = [Tools creatLabel:CGRectMake(15, 0, KScreenWidth - 2*15, 50) font:[UIFont systemFontOfSize:12] color:TCOLOR alignment:(NSTextAlignmentLeft) title:@""];
    [label setAttributedText:attS];
    [alertView addSubview:label];
}

- (CGFloat)inputPersonInfor:(CGFloat)height{
    
    UIView *back = [[UIView alloc] initWithFrame:CGRectMake(15, height, MDXFrom6(345), 50)];
    [back addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(selectDemandType:)]];
    [self.tmpScrollView addSubview:back];
    _demandType = [Tools creatLabel:CGRectMake(0, 0,MDXFrom6(345), 50) font:[UIFont systemFontOfSize:16] color:MDRGBA(153, 153, 153, 1) alignment:(NSTextAlignmentLeft) title:@"点击选择需求类型"];
    [back addSubview:_demandType];
    
    [back addSubview:[Tools creatImage:CGRectMake(MDXFrom6(345) - 8, 20, 6, 10) image:@"arrow_dark"]];
    
    [self.tmpScrollView addSubview:[self creatLine:CGRectMake(15, height + 49, MDXFrom6(345), 1)]];
    
    height += 50;
    
    // ---------- 输入信息 -------
    NSArray *tArr = @[@"需求明细",@"输入联系手机号码",@"联系人姓名",@"验证码",@"详细地址",@"预约时间",@"备注"];
    
    for (NSInteger i = 0 ; i <  tArr.count; i++) {
        UITextField *userName = [[UITextField alloc] initWithFrame:CGRectMake(15, height, MDXFrom6(345), 50)];
        [userName setPlaceholder:tArr[i]];
        [userName setFont:[UIFont systemFontOfSize:16]];
        [userName setClearButtonMode:(UITextFieldViewModeAlways)];
        [userName setTag:i];
        [userName setKeyboardType:(UIKeyboardTypeDefault)];
        [userName addTarget:self action:@selector(textValueChange:) forControlEvents:(UIControlEventEditingChanged)];
        [userName setValue:MDRGBA(153, 153, 153, 1) forKeyPath:@"_placeholderLabel.textColor"];
        [self.tmpScrollView addSubview:userName];
        
        if (i==1 || i==3) {
            [userName setKeyboardType:(UIKeyboardTypeNumberPad)];
        }
        
        if (i == 3) {
            UIButton *codeBtn1 = [Tools creatButton:CGRectMake(KScreenWidth - 130, height + 7.5 , 95, 35) font:[UIFont systemFontOfSize:15] color:[UIColor whiteColor] title:@"获取验证码" image:@""];
            [codeBtn1 setBackgroundColor:BTNCOLOR];
            [codeBtn1.layer setCornerRadius:5];
            [codeBtn1 setClipsToBounds:YES];
            [codeBtn1 setTag:1];
            [codeBtn1 addTarget:self action:@selector(getCode:) forControlEvents:(UIControlEventTouchUpInside)];
            [self.tmpScrollView addSubview:codeBtn1];

            [userName setFrame:CGRectMake(15, height, MDXFrom6(345) - 130, 50)];
            
            codeBtn = codeBtn1;
        }
        
        [self.tmpScrollView addSubview:[self creatLine:CGRectMake(15, height + 49, MDXFrom6(345), 1)]];
        
        height += 50;
        
    }
    return height;
}

- (UIView *)creatLine:(CGRect)rect{
    
    UIView *v = [[UIView alloc] initWithFrame:rect];
    [v setBackgroundColor:[UIColor colorWithHexString:@"#d1d1d1"]];
    return v;
}
#pragma mark -- 获取地址
- (LSYLocation *)locationSevice{
    
    if (!_locationSevice) {
        _locationSevice = [[LSYLocation alloc] init];
        [_locationSevice setDelegate:self];
    }
    return _locationSevice;
}

- (void)loctionWithProvince:(NSDictionary *)province city:(NSDictionary *)city area:(NSDictionary *)area{
    [self sureProvince:province city:city area:area];
}
#pragma mark -- 点击事件   选择需求类型  重新选择

- (void)selectDemandType:(UITapGestureRecognizer *)sender{
    
    [self.selectDemand setDataArr:self.demandArr];
    [self.selectDemand show];
}

- (void)selectCityWithInfo:(NSDictionary *)info view:(SelectView *)selectCity{
    
    [_demandType setText:info[@"name"]];
    [_demandType setTextColor:[UIColor blackColor]];
    _selectDemandDic = info;
}

- (void)rechangeLocation:(UIButton *)sender{
    
    [self.selectCityView show];
}

- (SelectCityView *)selectCityView{
    
    if (!_selectCityView) {
        
        _selectCityView = [[SelectCityView alloc] initWithFrame:CGRectMake(0, 0 , KScreenWidth, KViewHeight)];
        [_selectCityView setDelegate:self];
    }
    return _selectCityView;
}

- (void)sureProvince:(NSDictionary *)province city:(NSDictionary *)city area:(NSDictionary *)area{
    
    _province = province;
    _city = city;
    _area = area;
    
    NSString *address = [NSString stringWithFormat:@"%@ %@ %@",province[@"value"],city[@"value"],area[@"value"]];

    
    CGRect rect = [address boundingRectWithSize:CGSizeMake(1000000, 35) options:NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:15]} context:nil];
    
    if (55 + rect.size.width + 95 < KScreenWidth) {
        [self->_location setText:address];
        [self->_location setFrame:CGRectMake(40, self->_location.frame.origin.y, rect.size.width , 35)];
        [self->_selectLocationBtn setFrame:CGRectMake(55 + rect.size.width, self->_selectLocationBtn.frame.origin.y, 80, 35)];
    }
    else{
        
        [self->_location setText:address];
        [self->_location setFrame:CGRectMake(40,self->_location.frame.origin.y , KScreenWidth - 95 - 55-15 , 35)];
        [self->_selectLocationBtn setFrame:CGRectMake(KScreenWidth - 95, self->_selectLocationBtn.frame.origin.y, 80, 35)];
    }

}

- (void)textValueChange:(UITextField *)sender{// tag 1 为账号
    
    [self.textArr replaceObjectAtIndex:sender.tag withObject:sender.text];
}


// 提交
- (void)submit{
    
    LOGIN
    
    NSArray *tArr = @[@"需求明细",@"联系手机号码",@"联系人姓名",@"验证码",@"详细地址",@"预约时间"];
    for (NSInteger i = 0; i <tArr.count ; i++) {
        if ([self.textArr[i] length]==0) {
            
            [ViewHelps showHUDWithText:[NSString stringWithFormat:@"请输入%@",tArr[i]]];
            return;
        }
    }
    
    if (!_selectDemandDic) {
        [ViewHelps showHUDWithText:@"请选择需求类型"];
        return;
    }
    
    if (!_area) {
        [ViewHelps showHUDWithText:@"请选择所在城市"];
        return;
    }
    
    
    NSString *path = [NSString stringWithFormat:@"%@/Charging/quick_order",KURL];

    NSDictionary *dic = @{@"type":@"0",
                          @"province":_province[@"key"],
                          @"city":_city[@"key"],
                          @"area":_area[@"key"],
                          @"demand":self.textArr[0],
                          @"phone":self.textArr[1],
                          @"name":self.textArr[2],
                          @"code":self.textArr[3],
                          @"detailed":self.textArr[4],
                          @"contributors":self.textArr[5],
                          @"note":self.textArr[6],
                          @"requirements":_selectDemandDic[@"id"]};
    
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    __weak typeof(self) weakSelf = self;
    
    [HttpRequest POST:path parameters:dic success:^(id  _Nullable responseObject) {
        
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

#pragma mark -- 验证码
- (void)getCode:(UIButton *)sender{
    
    if ([self.textArr[1] length] !=11) {
        
        [ViewHelps showHUDWithText:@"请输入正确的手机号"];
        return;
    }
    
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    NSString *path = [NSString stringWithFormat:@"%@/login/getMobileCode",KURL];
    
    NSDictionary *dic = @{@"mobile":self.textArr[1]};
    
    [HttpRequest POST:path parameters:dic success:^(id  _Nullable responseObject) {
        
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        
        if ([responseObject[@"code"] integerValue] == 200) {
            if (!self.timer) {
                self.timer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(timeChange) userInfo:nil repeats:YES];
            }
            else {
                [self.timer setFireDate:[NSDate distantPast]];
            }
            
            [sender removeTarget:self action:@selector(getCode:) forControlEvents:(UIControlEventTouchUpInside)];
            
            self->time = 60;
            
            [sender setTitle:@"60 S" forState:(UIControlStateNormal)];
            
            [ViewHelps showHUDWithText:@"验证码发送成功，请注意查收"];
        }
        
        
    } failure:^(NSError * _Nullable error) {
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        [ViewHelps showHUDWithText:@"验证码发送失败，请再次发送"];
    }];
    
    
}

- (void)timeChange{
    
    time -- ;
    
    if (time<1) {
        if (![codeBtn.titleLabel.text isEqualToString:@"获取验证码"]) {
            [codeBtn setTitle:@"获取验证码" forState:(UIControlStateNormal)];
            [codeBtn addTarget:self action:@selector(getCode:) forControlEvents:(UIControlEventTouchUpInside)];
            
            [self.timer setFireDate:[NSDate distantFuture]];
        }
        
    }
    else{
        [codeBtn setTitle:[NSString stringWithFormat:@"%ld S",time] forState:(UIControlStateNormal)];
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
