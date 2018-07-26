//
//  SelectLocationVC.m
//  anjuyi1
//
//  Created by 李 on 2018/6/14.
//  Copyright © 2018年 lsy. All rights reserved.
//
//  录入地址

#import "SelectLocationVC.h"
#import "SelectCity.h"
#import "DBManager.h"

@interface SelectLocationVC ()<UIScrollViewDelegate,SelectCityDelegate>
{
    NSDictionary  * provincesDic;//保存省
    NSDictionary  * cityDic;//保存城市
    NSDictionary  * countyDic;//保存区
    UILabel       * selectLabel;//选择城市的label 为了修改文字
}

@property (nonatomic,strong)UIScrollView   * tmpScrollView;
@property (nonatomic,strong)NSMutableArray * textArr;
@property (nonatomic,strong)SelectCity     * selectCity;
@property (nonatomic,strong)NSMutableArray * cityArr;
@property (nonatomic,strong)DBManager      * dbManager;

@end

@implementation SelectLocationVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self setTitle:@"录入地址"];
    [self setNavigationLeftBarButtonWithImageNamed:@"ss_back"];
    
    self.textArr = [NSMutableArray arrayWithObjects:@"",@"",@"",@"",@"",@"",@"",@"", nil];
    self.cityArr = [NSMutableArray array];
    
    [self.view addSubview:self.tmpScrollView];
    
    [self.view addSubview:[Tools setLineView:CGRectMake(0, 0, KScreenWidth, 1.5)]];
    
    [self.view addSubview:self.tmpScrollView];
    
    [self setUpUI];
    
    [self.view addSubview:self.selectCity];
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

-(DBManager *)dbManager{
    if (!_dbManager) {
        _dbManager = [DBManager new];
    }
    return _dbManager;
}

- (void)setUpUI{
    
    NSArray *iArr = @[@"add_add",@"add_add",@"add_add",@"",@"",@"",@""];
    NSArray *tArr = @[@"请选择您的城市",@"请选择您的所在地",@"请选择您的所在范围",@"请输入您的小区名字",@"请输入您的楼号/单元/门牌号",@""];
    
    for (NSInteger i = 0 ; i < 3 ; i ++ ) {
        UIView *backView = [[UIView alloc] initWithFrame:CGRectMake(0, MDXFrom6(20+50*i), KScreenWidth, MDXFrom6(50))];
        [self.tmpScrollView addSubview:backView];
        
        if (i<1) {
            [backView addSubview:[Tools creatImage:CGRectMake(MDXFrom6(15), MDXFrom6(17.5), MDXFrom6(15), MDXFrom6(15)) image:iArr[i]]];
            [backView addSubview:[Tools setLineView:CGRectMake(MDXFrom6(15), MDXFrom6(49), KScreenWidth - MDXFrom6(30), MDXFrom6(1))]];
        }
        else{
            
            [backView addSubview:[Tools setLineView:CGRectMake(MDXFrom6(45), MDXFrom6(49), KScreenWidth - MDXFrom6(60), MDXFrom6(1))]];
        }
        
        if (i >= 3) {
            UITextField *textField = [[UITextField alloc] initWithFrame:CGRectMake(MDXFrom6(45), 0, KScreenWidth - MDXFrom6(60), MDXFrom6(50))];
            [textField setPlaceholder:tArr[i]];
            [textField setFont:[UIFont systemFontOfSize:15]];
            [textField setValue:[UIColor colorWithHexString:@"#999999"] forKeyPath:@"_placeholderLabel.textColor"];
            [textField setTag:i];
            [textField addTarget:self action:@selector(textValueChange:) forControlEvents:(UIControlEventTouchUpInside)];
            [backView addSubview:textField];
        }
        else{
            
            UILabel *label =[Tools creatLabel:CGRectMake(MDXFrom6(45), 0, KScreenWidth - MDXFrom6(60), MDXFrom6(50)) font:[UIFont systemFontOfSize:15] color:[UIColor colorWithHexString:@"#999999"] alignment:(NSTextAlignmentLeft) title:tArr[i]];
            [label addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(selectCity:)]];
            [label setTag:i];
            [backView addSubview:label];
            
            [backView addSubview:[Tools creatImage:CGRectMake(KScreenWidth - MDXFrom6(35), MDXFrom6(20), MDXFrom6(6), MDXFrom6(10)) image:@"jilu_rili_arrow"]];
            
        }
        
        
    }
    
    
    UIButton *btn = [Tools creatButton:CGRectMake(MDXFrom6(15), MDXFrom6(300), KScreenWidth - MDXFrom6(30), MDXFrom6(50)) font:[UIFont systemFontOfSize:16] color:[UIColor whiteColor] title:@"确定" image:@""];
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
    
    //tag  1为城市 2为区
    
    UILabel *label = (UILabel *)sender.view;
    
    selectLabel = label;
    
    [self getLocation:sender.view.tag];
    
}

- (void)sureSave{
    
    if (provincesDic == nil ||cityDic == nil ||countyDic == nil ) {
        [ViewHelps showHUDWithText:@"请选择匹配的省市区"];
        return;
    }
    
    [self.delegate sureProvince:provincesDic city:cityDic area:countyDic];
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark --  选择城市的view
- (void)getLocation:(NSInteger)tag{//tag  2为省份 3为城市 4为区
    
    
    NSDictionary *dic;
    
    if (tag == 0) {
        dic = @{@"id":@"0"};
    }
    
    if (tag == 1 && provincesDic) {
        dic = @{@"id":provincesDic[@"key"]};
    }
    
    if (tag == 2 && cityDic) {
        dic = @{@"id":cityDic[@"key"]};
    }
    
    if (!dic) {
        return;
    }
    
     NSArray *arr = [self.dbManager searchDataBaseWithSuperId:dic[@"id"]];
    
     [self.cityArr removeAllObjects];
    
     for (NSDictionary *dic in arr) {
         [self.cityArr addObject:dic];
     }
     [self.selectCity setDataArr:self.cityArr];
     [self.selectCity setTag:tag];
     [self.selectCity show];



}

- (SelectCity *)selectCity{
    
    if (!_selectCity) {
        
        _selectCity = [[SelectCity alloc] initWithFrame:CGRectMake(0, 0 , KScreenWidth, KViewHeight)];
        [_selectCity setDelegate:self];
    }
    return _selectCity;
}

- (void)selectCityWithInfo:(NSDictionary *)info view:(SelectCity *)selectCity{
    
    [selectLabel setTextColor:[UIColor blackColor]];
    [selectLabel setText:[info valueForKey:@"value"]];
    
    if (selectCity.tag == 0) {
        provincesDic = info;
        cityDic = nil;
        countyDic = nil;
    }
    if (selectCity.tag == 1) {
        cityDic = info;
        countyDic = nil;
    }
    if (selectCity.tag == 2) {
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
