//
//  HouseInspectViewController.m
//  anjuyi1
//
//  Created by apple on 2018/6/14.
//  Copyright © 2018年 lsy. All rights reserved.
//
//  免费验房

#import "HouseInspectViewController.h"
//#import "SelectLocationVC.h"//选择地址
#import "SelectCityView.h"
#import "LSYLocation.h"

@interface HouseInspectViewController ()<LSYLocationDelegta,SelectCityViewDelegate>
{
    NSInteger time;
    UIButton *codeBtn;
    NSDictionary *_province;
    NSDictionary *_city;
    NSDictionary *_area;
    UIButton *_selectLocationBtn;
}

@property (nonatomic,strong)NSMutableArray * textArr;
@property (nonatomic,strong)NSTimer        * timer;
@property (nonatomic,strong)UILabel        * location;
@property (nonatomic,strong)LSYLocation    * locationSevice;
@property (nonatomic,strong)SelectCityView * selectCityView;

@end

@implementation HouseInspectViewController

- (void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:animated];
    
    [self setNavigationLeftBarButtonWithImageNamed:@""];
    [self.navigationController setNavigationBarHidden:YES animated:YES];
}

- (void)viewWillDisappear:(BOOL)animated{
    
    [super viewWillDisappear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
}


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.textArr = [NSMutableArray arrayWithObjects:@"",@"",@"",@"", nil];
    time = 60;

    [self.view setBackgroundColor:[UIColor whiteColor]];

    [self setUpUI];
    
    [self.locationSevice beginUpdatingLocation];
    
    [self.view addSubview:self.selectCityView];
    
}


- (void)setUpUI{
    
    UIButton *registerb = [Tools creatButton:CGRectMake(MDXFrom6(35), KStatusBarHeight + MDXFrom6(30), MDXFrom6(60), MDXFrom6(30))  font:[UIFont systemFontOfSize:16] color:[UIColor colorWithHexString:@"#e9c700"] title:@"" image:@"ss_back"];
    [registerb setContentHorizontalAlignment:(UIControlContentHorizontalAlignmentLeft)];
    [registerb.titleLabel setTextAlignment:(NSTextAlignmentLeft)];
    [registerb addTarget:self action:@selector(back) forControlEvents:(UIControlEventTouchUpInside)];
    [self.view addSubview:registerb];
    
    CGFloat height = KStatusBarHeight + MDXFrom6(90);
    
    
    [self.view addSubview:[Tools creatLabel:CGRectMake(MDXFrom6(35), height, KScreenWidth - MDXFrom6(70), 22) font:[UIFont systemFontOfSize:21] color:[UIColor blackColor] alignment:(NSTextAlignmentLeft) title:@"免费验房"]];
    
    height += 50;
    
    [self.view addSubview:[Tools creatImage:CGRectMake(MDXFrom6(35), height + 10, 15, 15) image:@"add_add"]];
    
    CGRect rect = [@"北京  朝阳区" boundingRectWithSize:CGSizeMake(1000000, 35) options:NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:15]} context:nil];
    
    self.location = [Tools creatLabel:CGRectMake(MDXFrom6(60), height, rect.size.width , 35) font:[UIFont systemFontOfSize:15] color:[UIColor blackColor] alignment:(NSTextAlignmentLeft) title:@"北京  朝阳区"];
    [self.view addSubview:self.location];
    
    UIButton * rechange = [Tools creatButton:CGRectMake(MDXFrom6(80) + rect.size.width, height, MDXFrom6(80), MDXFrom6(35)) font:[UIFont systemFontOfSize:14] color:[UIColor colorWithHexString:@"#23b7b5"] title:@"重新选择" image:@""];
    [rechange setBackgroundColor:[UIColor colorWithHexString:@"#eaf8f8"]];
    [rechange.layer setCornerRadius:7.5];
    [rechange.layer setBorderColor:[UIColor colorWithHexString:@"#34bab8"].CGColor];
    [rechange.layer setBorderWidth:1];
    [rechange addTarget:self action:@selector(rechangeLocation:) forControlEvents:(UIControlEventTouchUpInside)];
    [self.view addSubview:rechange];
    
    _selectLocationBtn = rechange;
    
    height += 50;
    
    
    NSArray *tArr = @[@"输入小区名字",@"输入具体楼号：例7号楼1001",@"输入联系手机号码",@"验证码"];
    
    for (NSInteger i = 0 ; i <  4; i++) {
        UITextField *userName = [[UITextField alloc] initWithFrame:CGRectMake(MDXFrom6(35), height, MDXFrom6(305), 50)];
        [userName setPlaceholder:tArr[i]];
        [userName setFont:[UIFont systemFontOfSize:16]];
        [userName setClearButtonMode:(UITextFieldViewModeAlways)];
        [userName setTag:i];
        [userName addTarget:self action:@selector(textValueChange:) forControlEvents:(UIControlEventEditingChanged)];
        [self.view addSubview:userName];
        
        [self.view addSubview:[self creatLine:CGRectMake(MDXFrom6(35), height + 49, MDXFrom6(305), 1)]];
        
        height += 50;
        
        if (i == 3) {
            UIButton *codeBtn1 = [Tools creatButton:CGRectMake(KScreenWidth - 130, height - 42.5 , 95, 35) font:[UIFont systemFontOfSize:15] color:[UIColor whiteColor] title:@"获取验证码" image:@""];
            [codeBtn1 setBackgroundColor:BTNCOLOR];
            [codeBtn1.layer setCornerRadius:5];
            [codeBtn1 setClipsToBounds:YES];
            [codeBtn1 setTag:1];
            [codeBtn1 addTarget:self action:@selector(getCode:) forControlEvents:(UIControlEventTouchUpInside)];
            [self.view addSubview:codeBtn1];
            
            codeBtn = codeBtn1;
        }
    }
    
  

    height += 40;
    
    UIButton *btn = [Tools creatButton:CGRectMake(MDXFrom6(35), height, KScreenWidth - MDXFrom6(70), MDXFrom6(50)) font:[UIFont systemFontOfSize:18] color:[UIColor whiteColor] title:@"提交" image:@""];
    [btn setBackgroundColor:[UIColor colorWithHexString:@"#ffb638"]];
    [btn.layer setCornerRadius:5];
    [btn setClipsToBounds:YES];
    [btn addTarget:self action:@selector(submit) forControlEvents:(UIControlEventTouchUpInside)];
    [self.view addSubview:btn];
    
}

- (UIView *)creatLine:(CGRect)rect{
    
    UIView *v = [[UIView alloc] initWithFrame:rect];
    [v setBackgroundColor:[UIColor colorWithHexString:@"#d1d1d1"]];
    return v;
}

#pragma mark -- 点击事件   返回  重新选择
- (void)back{
    
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)rechangeLocation:(UIButton *)sender{
    
    [self.selectCityView show];
}

- (SelectCityView *)selectCityView{
    
    if (!_selectCityView) {
        
        _selectCityView = [[SelectCityView alloc] initWithFrame:CGRectMake(0, 0 , KScreenWidth, KScreenHeight)];
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
    
    if (MDXFrom6(60) + rect.size.width + 95 < KScreenWidth) {
        [self->_location setText:address];
        [self->_location setFrame:CGRectMake(MDXFrom6(60), self->_location.frame.origin.y, rect.size.width , 35)];
        [self->_selectLocationBtn setFrame:CGRectMake(MDXFrom6(75) + rect.size.width, self->_selectLocationBtn.frame.origin.y, 80, 35)];
    }
    else{
        
        [self->_location setText:address];
        [self->_location setFrame:CGRectMake(MDXFrom6(60),self->_location.frame.origin.y , KScreenWidth - 95 - 55-15 , 35)];
        [self->_selectLocationBtn setFrame:CGRectMake(KScreenWidth - 95, self->_selectLocationBtn.frame.origin.y, 80, 35)];
    }
    
}

- (void)textValueChange:(UITextField *)sender{// tag 1 为账号
    
    [self.textArr replaceObjectAtIndex:sender.tag withObject:sender.text];
}

// 提交
- (void)submit{
    
    LOGIN
    NSString *path = [NSString stringWithFormat:@"%@/free/free_house",KURL];
    
    NSDictionary *header = @{@"token":UTOKEN};
    NSDictionary *parameter = @{@"province":_province[@"key"],
                                @"city":_city[@"key"],
                                @"area":_area[@"key"],
                                @"community":self.textArr[0],
                                @"detailed":self.textArr[1],
                                @"phone":self.textArr[2],
                                @"code":self.textArr[3]};
    
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    __weak typeof(self) weakSelf = self;
    
    [HttpRequest POSTWithHeader:header url:path parameters:parameter success:^(id  _Nullable responseObject) {
        
        [MBProgressHUD hideHUDForView:weakSelf.view animated:YES];
        
        if ([responseObject[@"code"] integerValue] == 200) {
            
            [weakSelf.navigationController popViewControllerAnimated:YES];
        }
        else{
            
            [ViewHelps showHUDWithText:responseObject[@"message"]];
        }
        
        
    } failure:^(NSError * _Nullable error) {
        
        [MBProgressHUD hideHUDForView:weakSelf.view animated:YES];
        [RequestSever showMsgWithError:error];
    }];

}

#pragma mark -- 验证码
- (void)getCode:(UIButton *)sender{
    
    if ([self.textArr[2] length] !=11) {
        
        [ViewHelps showHUDWithText:@"请输入正确的手机号"];
        return;
    }
    
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    NSString *path = [NSString stringWithFormat:@"%@/login/getMobileCode",KURL];
    
    NSDictionary *dic = @{@"mobile":self.textArr[2]};
    
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
        else{
            
            [ViewHelps showHUDWithText:responseObject[@"message"]];
        }
        
    } failure:^(NSError * _Nullable error) {
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        [RequestSever showMsgWithError:error];
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
        [codeBtn setTitle:[NSString stringWithFormat:@"%ld S",(long)time] forState:(UIControlStateNormal)];
    }
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
