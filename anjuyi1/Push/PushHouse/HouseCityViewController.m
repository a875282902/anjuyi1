//
//  HouseCityViewController.m
//  anjuyi1
//
//  Created by apple on 2018/7/16.
//  Copyright © 2018年 lsy. All rights reserved.
//

#import "HouseCityViewController.h"
#import "HousePriceViewController.h"

@interface HouseCityViewController ()<UIPickerViewDelegate,UIPickerViewDataSource>
{
    NSDictionary *provinceDic;
    NSDictionary *cityDic;
    NSDictionary *areaDic;
}

@property (nonatomic,strong)UIButton        * locationLabel;
@property (nonatomic,strong)UIPickerView    * cityPickerView;
@property (nonatomic,strong)NSMutableArray  * provinceArr;
@property (nonatomic,strong)NSMutableArray  * cityArr;
@property (nonatomic,strong)NSMutableArray  * areaArr;

@end

@implementation HouseCityViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self baseForDefaultLeftNavButton];
    
    self.provinceArr = [NSMutableArray array];
    self.cityArr = [NSMutableArray array];
    self.areaArr = [NSMutableArray array];
    
    [self  setUpUI];
    
    [self getCityData:@"0"];
}

-  (void)setUpUI{
    
    UIButton *btn = [Tools creatButton:CGRectMake(15, KViewHeight - 80, KScreenWidth - 30, 50) font:[UIFont systemFontOfSize:16] color:[UIColor whiteColor] title:@"确定" image:@""];
    [btn setBackgroundColor:MDRGBA(255, 181, 0, 1)];
    [btn.layer setCornerRadius:5];
    [btn setClipsToBounds:YES];
    [btn addTarget:self action:@selector(sureHouseCity) forControlEvents:(UIControlEventTouchUpInside)];
    [self.view addSubview:btn];
    
    
    [self.view addSubview:[Tools creatLabel:CGRectMake(0, 25, KScreenWidth, 21) font:[UIFont systemFontOfSize:21] color:[UIColor blackColor] alignment:(NSTextAlignmentCenter) title:@"房子在哪个城市？"]];
    
    UIButton *btn1 = [Tools creatButton:CGRectMake(0, 106, KScreenWidth, 20) font:[UIFont systemFontOfSize:16] color:[UIColor colorWithHexString:@"#47baba"] title:@"北京  北京" image:@"order_pos"];
    [self.view addSubview:btn1];
    
    [self refreButtonLayout:btn1];
    self.locationLabel = btn1;
    
    [self.view addSubview:[Tools setLineView: CGRectMake(KScreenWidth/4, 131, KScreenWidth/2, 1)]];
    
    [self setUpCityView];
}
#pragma mark -- 选择城市的view
- (void)getCityData:(NSString *)cityID{
    
    NSString *path = [NSString stringWithFormat:@"%@/WholeHouse/select_city",KURL];
    
    NSDictionary *header = @{@"token":UTOKEN};
    
    NSDictionary *parameter = @{@"id":cityID};
    
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    __weak typeof(self) weakSelf = self;
    
    [HttpRequest POSTWithHeader:header url:path parameters:parameter success:^(id  _Nullable responseObject) {
        
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        
        if ([responseObject[@"code"] integerValue] == 200) {
            
            if ([responseObject[@"datas"] isKindOfClass:[NSArray class]]) {//datas是否类型相同
                if ([cityID integerValue] == 0) {//添加省数组
                    [weakSelf.provinceArr removeAllObjects];
                    for (NSDictionary *dic in responseObject[@"datas"]) {
                        [weakSelf.provinceArr addObject:dic];
                    }
                    [weakSelf.cityPickerView reloadComponent:0];
                    
                    if (weakSelf.cityArr.count == 0 && weakSelf.provinceArr.count > 0) {
                        self -> provinceDic = weakSelf.provinceArr[0];
                        [weakSelf getCityData:weakSelf.provinceArr[0][@"key"]];
                    }
                    
                }
                else{//添加城市数组
                    if (weakSelf.cityArr.count == 0) {
                    
                        for (NSDictionary *dic in responseObject[@"datas"]) {
                            [weakSelf.cityArr addObject:dic];
                        }
                        [weakSelf.cityPickerView reloadComponent:1];
                        
                        if (weakSelf.cityArr.count > 0 && weakSelf.areaArr.count == 0) {
                            self -> cityDic = weakSelf.cityArr[0];
                            [weakSelf getCityData:weakSelf.cityArr[0][@"key"]];
                        }
                        
                        [weakSelf.cityPickerView selectRow:0 inComponent:1 animated:YES];
                        
                    }
                    
                    else{
                        
                        for (NSDictionary *dic in responseObject[@"datas"]) {
                            [weakSelf.areaArr addObject:dic];
                        }
                        [weakSelf.cityPickerView reloadComponent:2];
                        
                        if (weakSelf.areaArr.count > 0) {
                            self -> areaDic = weakSelf.areaArr[0];
    
                        }
                        
                        [weakSelf.cityPickerView selectRow:0 inComponent:2 animated:YES];
                        
                        [weakSelf.locationLabel setTitle:[NSString stringWithFormat:@"%@  %@ %@",self->provinceDic[@"value"],self->cityDic[@"value"] ,self->areaDic[@"value"]] forState:(UIControlStateNormal)];
                        
                        [weakSelf refreButtonLayout:weakSelf.locationLabel];
                    }
                }
                
            }
            else{
                
                [ViewHelps showHUDWithText:responseObject[@"message"]];
            }
        }

        
    } failure:^(NSError * _Nullable error) {
        
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        [RequestSever showMsgWithError:error];
    }];

}

- (void)setUpCityView{
    
    self.cityPickerView = [[UIPickerView alloc] initWithFrame:CGRectMake(15, 184, KScreenWidth - 30, KViewHeight - 284 )];
    [self.cityPickerView setDelegate:self];
    [self.cityPickerView setDataSource:self];
    [self.view addSubview:self.cityPickerView];
    
}
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView{
    return 3;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component{
    if (component == 0)
    return self.provinceArr.count;

    if (component == 1)
    return self.cityArr.count;
    
    return self.areaArr.count;
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component{
    NSDictionary *dic ;
    if (component == 0) {
        dic = self.provinceArr[row];
        
    }
    if (component == 1) {
        dic = self.cityArr[row];
        
    }
    if (component ==2) {
    
        dic = self.areaArr[row];
    }
 
    return  dic[@"value"];
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component{
    
    if (component == 0) {
        provinceDic = self.provinceArr[row];
        
        [self.cityArr removeAllObjects];
        [self.areaArr removeAllObjects];
        
        [self getCityData:self.provinceArr[row][@"key"]];
    }

    if (component == 1) {
        [self.areaArr removeAllObjects];
        cityDic = self.cityArr[row];
        [self getCityData:self.cityArr[row][@"key"]];
        
    }
    if (component == 2) {
        areaDic = self.areaArr[row];
        
    }
    
    [self.locationLabel setTitle:[NSString stringWithFormat:@"%@  %@ %@",provinceDic[@"value"],cityDic[@"value"],areaDic[@"value"]] forState:(UIControlStateNormal)];
    
    [self refreButtonLayout:self.locationLabel];
    
}

- (void)refreButtonLayout:(UIButton *)button{
    
    CGFloat iWidth = button.imageView.frame.size.width;
    CGFloat tWidth = KHeight(button.titleLabel.text, KScreenWidth, 16, 16).size.width +20;
    CGFloat tTop = button.titleLabel.frame.origin.y;
    CGFloat contentW = iWidth + tWidth + 10;
    CGFloat left = (button.frame.size.width - contentW)/2.0;
    
    [button setTitleEdgeInsets:UIEdgeInsetsMake(tTop, left, tTop, left+iWidth+10)];
    [button setImageEdgeInsets:UIEdgeInsetsMake(tTop, left + tWidth +10, tTop, iWidth)];
    
}

#pragma mark -- 点击事件
- (void)sureHouseCity{
    
    if (self.house_id) {
        [self editHouseInfo];
    }
    else{
        [self.houseDic setValue:provinceDic[@"key"] forKey:@"province"];
        [self.houseDic setValue:cityDic[@"key"] forKey:@"city"];
        [self.houseDic setValue:areaDic[@"key"] forKey:@"area"];
        
        HousePriceViewController *vc = [[HousePriceViewController alloc] init];
        vc.houseDic = self.houseDic;
        [self.navigationController pushViewController:vc animated:YES];
    }
}

#pragma mark -- 修改房屋信息
- (void)editHouseInfo{
    
    
    NSString *path = [NSString stringWithFormat:@"%@/WholeHouse/update_house_info",KURL];
    
    NSDictionary *header = @{@"token":UTOKEN};
    
    NSDictionary *parame = @{@"id":self.house_id,
                             @"province":provinceDic[@"key"],
                             @"city":cityDic[@"key"],
                             @"area":areaDic[@"key"]};
    
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

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
