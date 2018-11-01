//
//  PowerStationList.m
//  anjuyi1
//
//  Created by apple on 2018/7/20.
//  Copyright © 2018年 lsy. All rights reserved.
//

#import "PowerStationList.h"
#import "PowerStationListTableViewCell.h"

@interface PowerStationList ()<UITableViewDelegate,UITableViewDataSource>
{
    UIButton *_selectBtn;
    NSString *_seletType;
}

@property (nonatomic,strong)UITableView     * tmpTableView;
@property (nonatomic,strong)NSMutableArray  * dataArr;

@end

@implementation PowerStationList

- (instancetype)initWithFrame:(CGRect)frame{
    
    if (self == [super initWithFrame:frame]) {
        [self addSubview:self.tmpTableView];
    }
    return self;
}

- (void)setDataArr:(NSMutableArray *)dataArr type:(NSString *)type{
    
    self.dataArr = dataArr;
    
    _seletType = type;
    [self.tmpTableView reloadData];
}

#pragma mark -- tableView
- (UITableView *)tmpTableView{
    
    if (!_tmpTableView) {
        _tmpTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height) style:(UITableViewStylePlain)];
        [_tmpTableView setSeparatorStyle:(UITableViewCellSeparatorStyleNone)];
        if (@available(iOS 11.0, *)) {
            [_tmpTableView setContentInsetAdjustmentBehavior:(UIScrollViewContentInsetAdjustmentNever)];
        }
        [_tmpTableView setRowHeight:UITableViewAutomaticDimension];
        [_tmpTableView setEstimatedRowHeight:105.0f];
        [_tmpTableView setShowsVerticalScrollIndicator:NO];
        [_tmpTableView setShowsHorizontalScrollIndicator:NO];
        [_tmpTableView setDataSource:self];
        [_tmpTableView setDelegate:self];
    }
    return _tmpTableView;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataArr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    PowerStationListTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"PowerStationListTableViewCell"];
    if (!cell) {
        cell = [[PowerStationListTableViewCell alloc] initWithStyle:(UITableViewCellStyleDefault) reuseIdentifier:@"PowerStationListTableViewCell"];
    }
    
    if (indexPath.row < self.dataArr.count) {
        [cell bandDataWithModel:self.dataArr[indexPath.row]];
    }
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    
    return 45.0f;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    
    UIView *backView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, KScreenWidth, 45.0)];
    [backView setBackgroundColor:[UIColor whiteColor]];
    
    NSArray *tArr = @[@"离我最近",@"默认"];
    
    for (NSInteger i = 0 ; i < 2 ; i++) {
        UIButton *btn = [Tools creatButton:CGRectMake(80*i, 0, 80, 45) font:[UIFont systemFontOfSize:15] color:[UIColor colorWithHexString:@"#999999"] title:tArr[i] image:@""];
        [btn setTag:i];
        [btn setTitleColor:[UIColor colorWithHexString:@"#5cc6c6"] forState:(UIControlStateSelected)];
        [btn addTarget:self action:@selector(selectType:) forControlEvents:(UIControlEventTouchUpInside)];
        [backView addSubview:btn];
        
        if (i == 1-[_seletType integerValue]) {
            [btn setSelected:YES];
            _selectBtn = btn;
        }
    }
    
    [backView addSubview:[Tools setLineView:CGRectMake(0, 44, KScreenWidth, 1)]];
    
    return backView;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    self.selectStaionToShowDetails(self.dataArr[indexPath.row]);
}

- (void)selectType:(UIButton *)sender{
    
    if (![sender isEqual:_selectBtn]) {
        [_selectBtn setSelected:NO];
        [sender setSelected:YES];
        _selectBtn = sender;
        
        self.selectStaionListType(sender.tag);
    }
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    
    if (scrollView.contentOffset.y > 0 ) {
        [UIView animateWithDuration:.2 animations:^{
            [self setFrame:CGRectMake(0, 0, KScreenWidth, KViewHeight)];
            [self.tmpTableView setFrame:CGRectMake(0, 0, KScreenWidth, KViewHeight)];
        }];
    }
    
    if (scrollView.contentOffset.y < 0 ) {
        [UIView animateWithDuration:.2 animations:^{
            [self setFrame:CGRectMake(0, KViewHeight - 290, KScreenWidth, 290)];
            [self.tmpTableView setFrame:CGRectMake(0, 0, KScreenWidth, 290)];
        }];
    }
}

@end
