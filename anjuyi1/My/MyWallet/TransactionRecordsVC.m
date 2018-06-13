//
//  TransactionRecordsVC.m
//  anjuyi1
//
//  Created by 李 on 2018/6/3.
//  Copyright © 2018年 lsy. All rights reserved.
//
// 交易记录

#import "TransactionRecordsVC.h"
#import "RecordsTableView.h"
#import "SelectTime.h"

@interface TransactionRecordsVC ()<UIScrollViewDelegate>

@property (nonatomic,strong) UIScrollView    * tmpScrollView;
@property (nonatomic,strong) NSMutableArray  * channelArr;
@property (nonatomic,strong) NSMutableArray  * viewArr;
@property (nonatomic,strong) SelectTime      * selectTime;

@end

@implementation TransactionRecordsVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self setTitle:@"交易记录"];
    
    [self baseForDefaultLeftNavButton];
    
    [self setNavigationRightBarButtonWithImageNamed:@"riliico"];
    
    self.channelArr = [NSMutableArray array];
    self.viewArr = [NSMutableArray array];
    
    [self.view addSubview:[Tools setLineView:CGRectMake(0, 0, KScreenWidth, 1.5)]];

    [self setUpChannelView];
    
    [self.view addSubview:self.tmpScrollView];
    
    [self setUpChildView];
    
    [self.view addSubview:self.selectTime];
}

#pragma mark -- UI
- (void)setUpChannelView{
    
    NSArray *tArr = @[@"全部",@"收入",@"消费",@"充值"];
    
    for (NSInteger i = 0 ; i < 4; i++) {
        UIButton *btn = [Tools creatButton:CGRectMake(MDXFrom6(85+45*i), 0, MDXFrom6(45), MDXFrom6(60)) font:[UIFont systemFontOfSize:16] color:[UIColor blackColor] title:tArr[i] image:@""];
        [btn setTitleColor:[UIColor colorWithHexString:@"#5cc6c6"] forState:(UIControlStateSelected)];
        [btn setSelected:NO];
        [btn addTarget:self action:@selector(buttonDidPress:) forControlEvents:(UIControlEventTouchUpInside)];
        [btn setTag:i];
        [self.view addSubview:btn];
        
        if (i==0) {
            [btn setSelected:YES];
        }
        
        [self.channelArr addObject:btn];
    }
}

- (UIScrollView *)tmpScrollView{
    
    if (!_tmpScrollView) {
        _tmpScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, MDXFrom6(60), KScreenWidth, KScreenHeight - MDXFrom6(60)- KTopHeight)];
        [_tmpScrollView setDelegate:self];
        [_tmpScrollView setShowsVerticalScrollIndicator:NO];
        [_tmpScrollView setShowsHorizontalScrollIndicator:NO];
        [_tmpScrollView setPagingEnabled:YES];
        [_tmpScrollView setContentSize:CGSizeMake(KScreenWidth*4, _tmpScrollView.frame.size.height)];
    }
    return _tmpScrollView;
}


- (void)setUpChildView{
    
    for (NSInteger i = 0 ; i < 4 ; i++) {
        RecordsTableView *view = [[RecordsTableView alloc] initWithFrame:CGRectMake(KScreenWidth *i, 0, KScreenWidth, self.tmpScrollView.frame.size.height)];
        [view autoRefresh];
        [self.tmpScrollView addSubview:view];
        
        [self.viewArr addObject:view];
    }
}

#pragma mark -- 点击事件

- (void)rightButtonTouchUpInside:(id)sender{
    
    if (self.selectTime.hidden) {
        [self.selectTime show];
    }else{
        [self.selectTime hidden];
    }
    
}

- (SelectTime *)selectTime{
    
    if (!_selectTime) {
        _selectTime = [[SelectTime alloc] initWithFrame:CGRectMake(0, 0, KScreenWidth, KScreenHeight - KTopHeight)];
    }
    return _selectTime;
}

- (void)buttonDidPress:(UIButton *)sender{
    
    if (!sender.selected) {
        
        for (UIButton *btn in self.channelArr) {
            [btn setSelected:NO];
        }
        
        [sender setSelected:YES];
        
        [self.tmpScrollView setContentOffset:CGPointMake(KScreenWidth*sender.tag, 0) animated:YES];
        RecordsTableView *v = self.viewArr[sender.tag];
        [v autoRefresh];
    }
}


#pragma mark -- scrollViewdelegate
- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate{
    
    if (!decelerate) {
        NSInteger n = scrollView.contentOffset.x/KScreenWidth;
        
        [self buttonDidPress:self.channelArr[n]];
    }
    
}
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    if (scrollView == self.tmpScrollView) {
        NSInteger n = scrollView.contentOffset.x/KScreenWidth;
        
        [self buttonDidPress:self.channelArr[n]];
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
