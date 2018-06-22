//
//  AddAddressViewController.m
//  anjuyi1
//
//  Created by 李 on 2018/6/7.
//  Copyright © 2018年 lsy. All rights reserved.
//

#import "EditAddressViewController.h"
#import "SelectCity.h"

@interface EditAddressViewController ()<UIScrollViewDelegate,SelectCityDelegate>
{
    NSDictionary  * provincesDic;//保存省
    NSDictionary  * cityDic;//保存城市
    NSDictionary  * countyDic;//保存区
    UILabel       * selectLabel;//选择城市的label 为了修改文字
}

@property (nonatomic,strong)UIScrollView    * tmpScrollView;
@property (nonatomic,strong)NSMutableArray  * textArr;
@property (nonatomic,strong)SelectCity      * selectCity;
@property (nonatomic,strong)NSMutableArray  * cityArr;

@end

@implementation EditAddressViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self setTitle:@"编辑地址"];
    [self setNavigationLeftBarButtonWithImageNamed:@"ss_back"];
    
    self.textArr = [NSMutableArray arrayWithObjects:@"",@"",@"",@"",@"",@"",@"",@"", nil];
    self.cityArr = [NSMutableArray array];
    
    [self.view addSubview:self.tmpScrollView];
    
    [self.view addSubview:[Tools setLineView:CGRectMake(0, 0, KScreenWidth, 1.5)]];
    
    [self getLocationDetails];
    
    [[UIApplication sharedApplication].keyWindow addSubview:self.selectCity];
}

- (void)getLocationDetails{
    
    NSString *path = [NSString stringWithFormat:@"%@/address/info",KURL];
    
    NSDictionary *dic = @{@"address_id":self.addressID};
    
    NSDictionary *header = @{@"token":UTOKEN};
    
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    [HttpRequest POSTWithHeader:header url:path parameters:dic success:^(id  _Nullable responseObject) {
        
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        
        if ([responseObject[@"code"] integerValue] == 200) {
            
            NSDictionary *dic = responseObject[@"datas"];
            
            self.textArr = [NSMutableArray arrayWithObjects:dic[@"name"],dic[@"phone"],@"",@"",@"",dic[@"detailed"],@"",@"", nil];
            
            self->provincesDic = @{@"key":dic[@"provice_id"],@"value":dic[@"province"]};
            self->cityDic      = @{@"key":dic[@"city_id"],@"value":dic[@"city"]};
            self->countyDic    = @{@"key":dic[@"area_id"],@"value":dic[@"area"]};
            
            [self setUpUI];
            
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
        [_tmpScrollView setShowsVerticalScrollIndicator:NO];
        [_tmpScrollView setShowsHorizontalScrollIndicator:NO];
        [_tmpScrollView setDelegate:self];
    }
    return _tmpScrollView;
}

- (void)setUpUI{
    
    NSArray *iArr = @[@"add_name",@"add_phone",@"add_add",@"",@"",@""];
    
    NSArray *tArr = @[@"请输入您的姓名",@"请输入您的电话",@"请选择您的省份",@"请选择您的城市",@"请选择您所在的区",@"请输入您的详细地址",@""];
    NSArray *dArr = @[self.textArr[0],self.textArr[1],provincesDic[@"value"],cityDic[@"value"],countyDic[@"value"],self.textArr[5],@""];
    
    for (NSInteger i = 0 ; i < 6 ; i ++ ) {
        UIView *backView = [[UIView alloc] initWithFrame:CGRectMake(0, MDXFrom6(20+50*i), KScreenWidth, MDXFrom6(50))];
        [self.tmpScrollView addSubview:backView];
        
        if (i<3) {
            [backView addSubview:[Tools creatImage:CGRectMake(MDXFrom6(15), MDXFrom6(17.5), MDXFrom6(15), MDXFrom6(15)) image:iArr[i]]];
            [backView addSubview:[Tools setLineView:CGRectMake(MDXFrom6(15), MDXFrom6(49), KScreenWidth - MDXFrom6(30), MDXFrom6(1))]];
        }
        else{
            
            [backView addSubview:[Tools setLineView:CGRectMake(MDXFrom6(45), MDXFrom6(49), KScreenWidth - MDXFrom6(60), MDXFrom6(1))]];
        }
        
        if (i != 2&& i!= 3 && i != 4) {
            UITextField *textField = [[UITextField alloc] initWithFrame:CGRectMake(MDXFrom6(45), 0, KScreenWidth - MDXFrom6(60), MDXFrom6(50))];
            [textField setPlaceholder:tArr[i]];
            [textField setText:dArr[i]];
            [textField setFont:[UIFont systemFontOfSize:15]];
            [textField setValue:[UIColor colorWithHexString:@"#999999"] forKeyPath:@"_placeholderLabel.textColor"];
            [textField setTag:i];
            if (i==1) {
                [textField setKeyboardType:(UIKeyboardTypeNumberPad)];
            }
            [textField addTarget:self action:@selector(textValueChange:) forControlEvents:(UIControlEventEditingChanged)];
            [backView addSubview:textField];
        }
        else{
            
            UILabel *label =[Tools creatLabel:CGRectMake(MDXFrom6(45), 0, KScreenWidth - MDXFrom6(60), MDXFrom6(50)) font:[UIFont systemFontOfSize:15] color:[UIColor colorWithHexString:@"#999999"] alignment:(NSTextAlignmentLeft) title:tArr[i]];
            [label addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(selectCity:)]];
            [label setTag:i];
            [backView addSubview:label];
            
            if ([dArr[i] length] != 0) {
                [label setTextColor:[UIColor blackColor]];
                [label setText:dArr[i]];
            }
            
            [backView addSubview:[Tools creatImage:CGRectMake(KScreenWidth - MDXFrom6(35), MDXFrom6(20), MDXFrom6(6), MDXFrom6(10)) image:@"jilu_rili_arrow"]];
            
        }
        
        
    }
    
    
    UIButton *btn = [Tools creatButton:CGRectMake(MDXFrom6(15), MDXFrom6(350), KScreenWidth - MDXFrom6(30), MDXFrom6(50)) font:[UIFont systemFontOfSize:16] color:[UIColor whiteColor] title:@"确定" image:@""];
    [btn setBackgroundColor:MDRGBA(255, 181, 0, 1)];
    [btn.layer setCornerRadius:5];
    [btn setClipsToBounds:YES];
    [btn addTarget:self action:@selector(sureSave) forControlEvents:(UIControlEventTouchUpInside)];
    [self.tmpScrollView addSubview:btn];
    
}


- (void)textValueChange:(UITextField *)textField{
    
    [self.textArr replaceObjectAtIndex:textField.tag withObject:textField.text];
}


- (void)selectCity:(UITapGestureRecognizer *)sender{
    
    [self.view endEditing:YES];
    
    //tag  2为省份 3为城市 4为区
    
    if (sender.view.tag == 3) {
        if (provincesDic.allKeys.count == 0) {
            [ViewHelps showHUDWithText:@"请先选择省份"];
            return;
        }
    }
    
    if (sender.view.tag == 4) {
        if (cityDic.allKeys.count == 0) {
            [ViewHelps showHUDWithText:@"请先选择城市"];
            return;
        }
    }
    
    UILabel *label = (UILabel *)sender.view;
    selectLabel = label;
    
    [self getLocation:sender.view.tag];
}

- (void)sureSave{
    //    @[@"请输入您的姓名",@"请输入您的电话",@"请选择您的省份",@"请选择您的城市",@"请选择您所在的区",@"请输入您的详细地址",@""]
    if ([self.textArr[0] length] == 0) {
        [ViewHelps showHUDWithText:@"请输入您的姓名"];
        return;
    }
    if ([self.textArr[1] length] == 0 || [self.textArr[1] length]>11) {
        [ViewHelps showHUDWithText:@"请输入您的电话"];
        return;
    }
    if (!provincesDic) {
        [ViewHelps showHUDWithText:@"请选择您的省份"];
        return;
    }
    if (!cityDic) {
        [ViewHelps showHUDWithText:@"请选择您的城市"];
        return;
    }
    if (!countyDic) {
        [ViewHelps showHUDWithText:@"请选择您所在的区"];
        return;
    }
    if ([self.textArr[5] length] == 0) {
        [ViewHelps showHUDWithText:@"请输入您的详细地址"];
        return;
    }
    
    NSString *path = [NSString stringWithFormat:@"%@/address/edit",KURL];
    NSDictionary *header = @{@"token":UTOKEN};
    NSDictionary *dic = @{@"id":self.addressID,
                          @"name":self.textArr[0],
                          @"mobile":self.textArr[1],
                          @"provice_id":[provincesDic valueForKey:@"key"],
                          @"city_id":[cityDic valueForKey:@"key"],
                          @"area_id":[countyDic valueForKey:@"key"],
                          @"address":self.textArr[5]};
    
    
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    [HttpRequest POSTWithHeader:header url:path parameters:dic success:^(id  _Nullable responseObject) {
        
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        
        if ([responseObject[@"code"] integerValue] == 200) {
            
            [ViewHelps showHUDWithText:@"编辑成功"];
            [self.navigationController popViewControllerAnimated:YES];
            
        }
        else if ([responseObject[@"code"] integerValue] == 202){
            
            [ViewHelps showHUDWithText:@"编辑失败"];
        }
        else if ([responseObject[@"code"] integerValue] == 201){
            
            if (![responseObject[@"message"] isKindOfClass:[NSNull class]]) {
                [ViewHelps showHUDWithText:responseObject[@"message"]];
            }
            else{
                [ViewHelps showHUDWithText:@"编辑失败"];
            }
        }
        
    } failure:^(NSError * _Nullable error) {
        
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        [RequestSever showMsgWithError:error];
    }];
    
}

#pragma mark --  选择城市的view

- (void)getLocation:(NSInteger)tag{//tag  2为省份 3为城市 4为区
    
    NSString     *path   = [NSString stringWithFormat:@"%@/address/select_city",KURL];
    NSDictionary *header = @{@"token":UTOKEN};
    NSDictionary *dic    = @{@"id":tag==2?@"0":(tag==3?provincesDic[@"key"]:cityDic[@"key"])};
    
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    [HttpRequest POSTWithHeader:header url:path parameters:dic success:^(id  _Nullable responseObject) {
        
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        
        if ([responseObject[@"code"] integerValue] == 200) {
            
            [self.cityArr removeAllObjects];
            
            if (![responseObject[@"datas"] isKindOfClass:[NSNull class]]) {
                
                for (NSDictionary *dic in responseObject[@"datas"]) {
                    [self.cityArr addObject:dic];
                }
                [self.selectCity setDataArr:self.cityArr];
                [self.selectCity setTag:tag];
                [self.selectCity show];
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

- (SelectCity *)selectCity{
    
    if (!_selectCity) {
        
        _selectCity = [[SelectCity alloc] initWithFrame:CGRectMake(0, 0, KScreenWidth, KScreenHeight)];
        [_selectCity setDelegate:self];
    }
    return _selectCity;
}

- (void)selectCityWithInfo:(NSDictionary *)info view:(SelectCity *)selectCity{
    
    [selectLabel setTextColor:[UIColor blackColor]];
    [selectLabel setText:[info valueForKey:@"value"]];
    
    if (selectCity.tag == 2) {
        provincesDic = info;
    }
    if (selectCity.tag == 3) {
        cityDic = info;
    }
    if (selectCity.tag == 4) {
        countyDic = info;
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
