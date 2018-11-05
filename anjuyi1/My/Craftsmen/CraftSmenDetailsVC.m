
//
//  CraftSmenDetailsVC.m
//  anjuyi1
//
//  Created by 李 on 2018/6/8.
//  Copyright © 2018年 lsy. All rights reserved.
//

#import "CraftSmenDetailsVC.h"
#import "SelectTypeView.h"
#import "SelectCityView.h"

@interface CraftSmenDetailsVC ()<UIScrollViewDelegate,UITextViewDelegate,SelectTypeViewDelegate,SelectCityViewDelegate>
{
    UILabel *_personPlace;
    UILabel *_servicePlace;
    
    NSString * minPrice;
    NSString * maxPrice;
    NSString * personDetails;
    NSString * serviceDetails;
    
    NSDictionary * areaDic;
}

@property (nonatomic,strong)UIScrollView     *tmpScrollView;

@property (nonatomic,strong)NSMutableArray   *labelArr;
@property (nonatomic,strong)NSMutableArray   *serviceArr;//保存选择的服务类型

@property (nonatomic,strong)SelectTypeView   *selectType;
@property (nonatomic,strong)NSDictionary     *typeDic;
@property (nonatomic,strong)SelectCityView   *selectCity;


@end

@implementation CraftSmenDetailsVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setTitle:@"工匠汇"];
    [self baseForDefaultLeftNavButton];
    
    self.labelArr = [NSMutableArray array];
    self.serviceArr = [NSMutableArray array];
    
    [self.view addSubview:self.tmpScrollView];
    
    [self.view addSubview:[Tools setLineView:CGRectMake(0, 0, KScreenWidth, 1)]];
    
    [self setUpUI];
    
    [self requestData];
    
    [self.view addSubview:self.selectType];
    
    [self.view addSubview:self.selectCity];
}

- (void)requestData{
    
    NSString *path = [NSString stringWithFormat:@"%@/Craftsman/get_crafts_info",KURL];
    
    NSDictionary *header = @{@"token":UTOKEN};
    
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    __weak typeof(self) weakSelf = self;
    
    [HttpRequest POSTWithHeader:header url:path parameters:@{@"type":self.craftsmenType} success:^(id  _Nullable responseObject) {
        
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        
        if ([responseObject[@"code"] integerValue] == 200) {
            weakSelf.typeDic = responseObject[@"datas"][@"info"];
        }
        else{
            
            [ViewHelps showHUDWithText:responseObject[@"message"]];
        }

    } failure:^(NSError * _Nullable error) {
        
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        [RequestSever showMsgWithError:error];
    }];

}

-(UIScrollView *)tmpScrollView{
    
    if (!_tmpScrollView) {
        _tmpScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, KScreenWidth, KScreenHeight - KTopHeight)];
        if (@available(iOS 11.0, *)) {
            [_tmpScrollView setContentInsetAdjustmentBehavior:(UIScrollViewContentInsetAdjustmentNever)];
        }
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
    
    NSArray *tArr = @[@"服务类型",@"从业时间",@"接单数量",@"认证等级"];
    
    for (NSInteger i = 0 ; i < 4 ; i ++) {
        UIView *v = [[UIView alloc] initWithFrame:CGRectMake(0, height, KScreenWidth, 50)];
        [v addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(selectMyExperience:)]];
        [v setTag:i];
        [self.tmpScrollView addSubview:v];
        
        height += 50;
        
        [v addSubview:[Tools creatLabel:CGRectMake(15, 0, 200, 50) font:[UIFont systemFontOfSize:16] color:[UIColor colorWithHexString:@"#666666"] alignment:(NSTextAlignmentLeft) title:tArr[i]]];
        
        UILabel *label = [Tools creatLabel:CGRectMake(15, 0, KScreenWidth - 45, 50) font:[UIFont systemFontOfSize:16] color:[UIColor colorWithHexString:@"#999999"] alignment:(NSTextAlignmentRight) title:@"请选择"];
        [v addSubview:label];
        [label setTag:i];
        [self.labelArr addObject:label];
        [self.serviceArr addObject:@""];
        
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
    [minPrice addTarget:self action:@selector(minPriceChangeValue:) forControlEvents:(UIControlEventEditingChanged)];
    [minPrice setKeyboardType:(UIKeyboardTypeNumberPad)];
    [minPrice setFont:[UIFont systemFontOfSize:16]];
    [self.tmpScrollView addSubview:minPrice];
    
    UITextField *maxPrice = [[UITextField alloc] initWithFrame:CGRectMake(KScreenWidth - 115, height,100, 40)];
    [maxPrice setBorderStyle:(UITextBorderStyleRoundedRect)];
    [maxPrice setTextAlignment:(NSTextAlignmentCenter)];
    [maxPrice setPlaceholder:@"输入高价"];
    [maxPrice addTarget:self action:@selector(maxPriceChangeValue:) forControlEvents:(UIControlEventEditingChanged)];
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


- (SelectTypeView *)selectType{
    
    if (!_selectType) {
        
        _selectType = [[SelectTypeView alloc] initWithFrame:CGRectMake(0, 0 , KScreenWidth, KViewHeight)];
        [_selectType setDelegate:self];
    }
    return _selectType;
}
- (SelectCityView *)selectCity{
    
    if (!_selectCity) {
        
        _selectCity = [[SelectCityView alloc] initWithFrame:CGRectMake(0, 0 , KScreenWidth, KViewHeight)];
        [_selectCity setDelegate:self];
    }
    return _selectCity;
}

#pragma mark -- 点击事件
//选择服务类型
- (void)selectMyExperience:(UITapGestureRecognizer *)sender{
    
    NSArray *arr = @[@"service_type",@"employment_time",@"single_num",@"level"];

    [self.selectType setDataArr:((NSArray *)[self.typeDic valueForKey:arr[sender.view.tag]])];
    [self.selectType setTag:sender.view.tag];
    [self.selectType show];
}

- (void)selectTypeWithInfo:(NSDictionary *)info view:(SelectTypeView *)selectView{
    
    UILabel *label = self.labelArr[selectView.tag];
    
    [label setText:info[@"value"]];
    [label setTextColor:TCOLOR];
    
    [self.serviceArr replaceObjectAtIndex:selectView.tag withObject:info];
}

//选择地址
- (void)selectServiceLocation{
    
    [self.selectCity show];
    
}

- (void)sureProvince:(NSDictionary *)province city:(NSDictionary *)city area:(NSDictionary *)area{
    
    UILabel *label = self.labelArr[4];
    [label setText:[NSString stringWithFormat:@"%@  %@ %@",province[@"value"],city[@"value"] ,area[@"value"]]];
    [label setTextColor:TCOLOR];
    
    areaDic = area;
}

//最低价
- (void)minPriceChangeValue:(UITextField *)sender{
    
    minPrice = sender.text;
}

//最高价
- (void)maxPriceChangeValue:(UITextField *)sender{
    
    maxPrice = sender.text;
}

- (void)upDataToService{
    
    NSArray *arr = @[@"请选择服务类型",@"请选择从业时间",@"请选择接单数",@"请选择接认证等级"];
    
    for (NSInteger i = 0 ; i < self.serviceArr.count; i++) {
        id obj = self.serviceArr[i];
        if (![obj isKindOfClass:[NSDictionary class]]) {
            [ViewHelps showHUDWithText:arr[i]];
            return;
        }
    }
    
    if (!minPrice) {
        [ViewHelps showHUDWithText:@"请输入最低价"];
        return;
    }
    if (!maxPrice) {
        [ViewHelps showHUDWithText:@"请输入最高价"];
        return;
    }
    if (!personDetails) {
        [ViewHelps showHUDWithText:@"请输入个人简介"];
        return;
    }
    if (!serviceDetails) {
        [ViewHelps showHUDWithText:@"请输入服务简介"];
        return;
    }
    
    if (!areaDic) {
        [ViewHelps showHUDWithText:@"请选择服务地区"];
        return;
    }
    
    NSString *path = [NSString stringWithFormat:@"%@/Craftsman/enter_crafts",KURL];
    
    NSDictionary *header = @{@"token":UTOKEN};
    NSDictionary *dic = @{@"type":self.craftsmenType,
                          @"service_craftsman_type":self.serviceArr[0][@"key"],
                          @"working_craftsman_type":self.serviceArr[1][@"key"],
                          @"order_craftsman_type":self.serviceArr[2][@"key"],
                          @"level":self.serviceArr[3][@"key"],
                          @"guestLow":minPrice,
                          @"guestHigh":maxPrice,
                          @"personal":personDetails,
                          @"service":serviceDetails,
                          @"region":areaDic[@"key"]};
    
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    __weak typeof(self) weakSelf = self;
    
    [HttpRequest POSTWithHeader:header url:path parameters:dic success:^(id  _Nullable responseObject) {
        
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        
        if ([responseObject[@"code"] integerValue] == 200) {
            [ViewHelps showHUDWithText:responseObject[@"message"]];
            [weakSelf.navigationController popToRootViewControllerAnimated:YES];
        }
        else{
            
            [ViewHelps showHUDWithText:responseObject[@"message"]];
        }
        
        
    } failure:^(NSError * _Nullable error) {
        
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        [RequestSever showMsgWithError:error];
    }];

    
}

- (void)textViewDidChange:(UITextView *)textView{

    
    if (textView.text.length>100) {
        
        [textView setText:[textView.text substringToIndex:100]];
    }
    
    if (textView.tag == 1001) {
        if (textView.text.length == 0) {
            [_personPlace setHidden:NO];
        }
        else{
            [_personPlace setHidden:YES];
        }
        
        personDetails = textView.text;
    }
    else{
        
        if (textView.text.length == 0) {
            [_servicePlace setHidden:NO];
        }
        else{
            [_servicePlace setHidden:YES];
        }
        serviceDetails = textView.text;
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
