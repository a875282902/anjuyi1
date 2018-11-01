//
//  SelectCity.m
//  anjuyi1
//
//  Created by 李 on 2018/6/21.
//  Copyright © 2018年 lsy. All rights reserved.
//

#import "SelectView.h"

static CGFloat vHeight = 250 + KPlaceHeight;

static CGFloat sHeight = 50;

@interface SelectView()<UIPickerViewDelegate,UIPickerViewDataSource>
{
    NSDictionary *currentDic;
}

@property (nonatomic,strong)UIPickerView *tmpPickerView;

@property (nonatomic,strong)UIView *backView;



@end

@implementation SelectView


- (instancetype)initWithFrame:(CGRect)frame{
    
    if (self == [super initWithFrame:frame]) {
        
        [self setBackgroundColor:MDRGBA(0, 0, 0, 0.8)];
        [self setUpUI];
        [self setHidden:YES];
    }
    
    return self;
}

- (void)setUpUI{
    
    self.backView = [[UIView alloc] initWithFrame:CGRectMake(0, KScreenHeight , KScreenWidth, vHeight)];
    [self.backView setBackgroundColor:[UIColor whiteColor]];
    [self addSubview:self.backView];
    
    [self.backView addSubview:self.tmpPickerView];
    
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

- (void)setDataArr:(NSMutableArray *)dataArr{
    currentDic = nil;
    _dataArr = dataArr;
    
    [self.tmpPickerView selectRow:0 inComponent:0 animated:YES];
    [self.tmpPickerView reloadAllComponents];
}

#pragma mark --  tmpPickerView
- (UIPickerView *)tmpPickerView{
    
    if (!_tmpPickerView) {
        _tmpPickerView = [[UIPickerView alloc] initWithFrame:CGRectMake(0, sHeight, KScreenWidth, vHeight-sHeight-KPlaceHeight)];
        [_tmpPickerView setDelegate:self];
        [_tmpPickerView setDataSource:self];
    }
    return _tmpPickerView;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component{
    return self.dataArr.count;
}
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView{
    return 1;
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component{
    
    id obj = self.dataArr[row];
    NSString *str = @"";
    
    if ([obj isKindOfClass:[NSString class]]) {
        str = obj;
    }
    else if ([obj isKindOfClass:[NSDictionary class]]){
        
        str =[self.dataArr[row] valueForKey:@"value"]?[self.dataArr[row] valueForKey:@"value"]:[self.dataArr[row] valueForKey:@"name"];
    }
    
    return str;
}

- (CGFloat)pickerView:(UIPickerView *)pickerView rowHeightForComponent:(NSInteger)component{
    
    return 30;
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component{
    
    currentDic = self.dataArr[row];
}

#pragma mark -- 事件
- (void)cancelDidPress{
    
    [self hidden];
}

- (void)sureDidPress{
    if (!currentDic) {
        currentDic = self.dataArr[0];
    }
    
    [self.delegate selectViewWithInfo:currentDic view:self];
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

@end
