//
//  SelectCityView.m
//  anjuyi1
//
//  Created by apple on 2018/8/29.
//  Copyright © 2018年 lsy. All rights reserved.
//

#import "SelectCityView.h"
#import "DBManager.h"

static CGFloat const vHeight = 250;

static CGFloat const sHeight = 50;

@interface SelectCityView ()<UIPickerViewDelegate,UIPickerViewDataSource>
{
    NSDictionary *provinceDic;
    NSDictionary *cityDic;
    NSDictionary *areaDic;
}
@property (nonatomic,strong)UIPickerView    * cityPickerView;
@property (nonatomic,strong)NSMutableArray  * provinceArr;
@property (nonatomic,strong)NSMutableArray  * cityArr;
@property (nonatomic,strong)NSMutableArray  * areaArr;
@property (nonatomic,strong)DBManager       * dbManager;

@property (nonatomic,strong)UIView *backView;

@end

@implementation SelectCityView

- (instancetype)initWithFrame:(CGRect)frame{
    
    if (self == [super initWithFrame:frame]) {
        self.provinceArr = [NSMutableArray array];
        self.cityArr = [NSMutableArray array];
        self.areaArr = [NSMutableArray array];
        [self setBackgroundColor:MDRGBA(0, 0, 0, 0.8)];
        [self setUpUI];
        [self setHidden:YES];
        [self getCityData:@"0"];
        [self setUpCityView];
        
    }
    
    return self;
}

- (void)setUpUI{
    
    self.backView = [[UIView alloc] initWithFrame:CGRectMake(0, KScreenHeight , KScreenWidth, vHeight)];
    [self.backView setBackgroundColor:[UIColor whiteColor]];
    [self addSubview:self.backView];
    
    UIButton *cancel = [UIButton buttonWithType:(UIButtonTypeCustom)];
    [cancel setFrame:CGRectMake(0, 0 , 60, sHeight)];
    [cancel addTarget:self action:@selector(cancelDidPress) forControlEvents:(UIControlEventTouchUpInside)];
    [cancel setTitleColor:[UIColor blackColor] forState:(UIControlStateNormal)];
    [cancel setTitle:@"取消" forState:(UIControlStateNormal)];
    [self.backView addSubview:cancel];
    
    UIButton *sure = [UIButton buttonWithType:(UIButtonTypeCustom)];
    [sure setFrame:CGRectMake(KScreenWidth - 60, 0 , 60, sHeight)];
    [sure addTarget:self action:@selector(sureDidPress) forControlEvents:(UIControlEventTouchUpInside)];
    [sure setTitleColor:[UIColor blackColor] forState:(UIControlStateNormal)];
    [sure setTitle:@"确定" forState:(UIControlStateNormal)];
    [self.backView addSubview:sure];
    
    
    [self.backView addSubview:[Tools setLineView:CGRectMake(0, sHeight, KScreenWidth, 1)]];
}

-(DBManager *)dbManager{
    
    if (!_dbManager ) {
        _dbManager = [DBManager new];
    }
    return _dbManager;
}

#pragma mark -- 选择城市的view
- (void)getCityData:(NSString *)cityID{
    
    NSArray *arr = [self.dbManager searchDataBaseWithSuperId:cityID];
    
    __weak typeof(self) weakSelf = self;
    
    
    if ([cityID integerValue] == 0) {//添加省数组
        [weakSelf.provinceArr removeAllObjects];
        for (NSDictionary *dic in arr) {
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
            
            for (NSDictionary *dic in arr) {
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
            
            for (NSDictionary *dic in arr) {
                [weakSelf.areaArr addObject:dic];
            }
            [weakSelf.cityPickerView reloadComponent:2];
            
            if (weakSelf.areaArr.count > 0) {
                self -> areaDic = weakSelf.areaArr[0];
                
            }
            
            [weakSelf.cityPickerView selectRow:0 inComponent:2 animated:YES];

        }
    }
}

- (void)setUpCityView{
    
    self.cityPickerView = [[UIPickerView alloc] initWithFrame:CGRectMake(0, sHeight, KScreenWidth, vHeight-sHeight)];
    [self.cityPickerView setDelegate:self];
    [self.cityPickerView setDataSource:self];
    [self.backView addSubview:self.cityPickerView];
    
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

    
}

#pragma mark -- 事件
- (void)cancelDidPress{
    
    [self hidden];
}

- (void)sureDidPress{
    [self.delegate sureProvince:provinceDic city:cityDic area:areaDic];
    [self hidden];
}


- (void)show{
    
    [self setHidden:NO];
    
    [UIView animateWithDuration:.3 animations:^{
        [self.backView setFrame:CGRectMake(0, self.frame.size.height - vHeight, KScreenWidth, vHeight)];
    }];
}

- (void)hidden{
    
    [UIView animateWithDuration:.3 animations:^{
        [self.backView setFrame:CGRectMake(0, KScreenHeight , KScreenWidth, vHeight)];
    } completion:^(BOOL finished) {
        
        if (finished) {
            [self setHidden:YES];
        }
    }];
    
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    
    UITouch *touc = [touches anyObject];
    
    CGPoint p =  [touc locationInView:self];
    
    if (p.y < KScreenHeight - vHeight) {
        [self hidden];
    }
    
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
