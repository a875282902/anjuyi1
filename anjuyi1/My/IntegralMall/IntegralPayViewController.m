//
//  IntegralPayViewController.m
//  anjuyi1
//
//  Created by 李 on 2018/6/5.
//  Copyright © 2018年 lsy. All rights reserved.
//

#import "IntegralPayViewController.h"
#import "IntegralPayTableViewCell.h"
#import "AddressViewController.h"

@interface IntegralPayViewController ()<UITableViewDataSource,UITableViewDelegate>
{
    BOOL isShow;
}

@property (nonatomic,strong)UITableView  * tmpTableView;

@end

@implementation IntegralPayViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self setTitle:@"结算中心"];
    
    isShow = NO;
    
    [self baseForDefaultLeftNavButton];
    
    [self.view addSubview:self.tmpTableView];
    
    [self.view addSubview:[Tools setLineView:CGRectMake(0, 0, KScreenWidth, 1.5)]];
    
    [self.view addSubview:[self setUpFootView]];
}


#pragma mark -- tableView
- (UITableView *)tmpTableView{
    
    if (!_tmpTableView) {
        _tmpTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, KScreenWidth, KScreenHeight-KTopHeight - MDXFrom6(55)) style:(UITableViewStyleGrouped)];
        [_tmpTableView setSeparatorStyle:(UITableViewCellSeparatorStyleNone)];
        if (@available(iOS 11.0, *)) {
            [_tmpTableView setContentInsetAdjustmentBehavior:(UIScrollViewContentInsetAdjustmentNever)];
        }
        [_tmpTableView setShowsVerticalScrollIndicator:NO];
        [_tmpTableView setShowsHorizontalScrollIndicator:NO];
        [_tmpTableView setDataSource:self];
        [_tmpTableView setDelegate:self];
    }
    return _tmpTableView;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (isShow) {
        return 5;
    }
    return 3;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    IntegralPayTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"IntegralPayTableViewCell"];
    if (!cell) {
        cell = [[IntegralPayTableViewCell alloc] initWithStyle:(UITableViewCellStyleDefault) reuseIdentifier:@"CollectShopTableViewCell"];
    }
    
    [cell setSelectionStyle:(UITableViewCellSelectionStyleNone)];

    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 100;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return MDXFrom6(85);
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    
    static NSString * identy = @"headView";
    
    UIView * header = [tableView dequeueReusableHeaderFooterViewWithIdentifier:identy];
    
    if (!header) {
        header = [[UIView alloc] initWithFrame:CGRectMake(0, 0, KScreenWidth, MDXFrom6(85))];
        [header addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(selectAddress)]];
        [header setBackgroundColor:[UIColor whiteColor]];
        [header addSubview:[Tools creatAttributedLabel:CGRectMake(MDXFrom6(12), MDXFrom6(14), MDXFrom6(330), MDXFrom6(20)) font:[UIFont systemFontOfSize:16] color:[UIColor colorWithHexString:@"#333333"] title:@"收货人：张美华" image:@"order_user" alignment:(NSTextAlignmentLeft)]];
        
        [header addSubview:[Tools creatAttributedLabel:CGRectMake(MDXFrom6(12), MDXFrom6(14), MDXFrom6(330), MDXFrom6(20)) font:[UIFont systemFontOfSize:16] color:[UIColor colorWithHexString:@"#333333"] title:@"18998772312" image:@"order_phone" alignment:(NSTextAlignmentRight)]];
        
        [header addSubview:[Tools creatAttributedLabel:CGRectMake(MDXFrom6(12), MDXFrom6(44), MDXFrom6(330), MDXFrom6(20)) font:[UIFont systemFontOfSize:16] color:[UIColor colorWithHexString:@"#333333"] title:@"北京市 新城区  青年街34号  大悦城7号" image:@"order_pos" alignment:(NSTextAlignmentLeft)]];
        
        [header addSubview:[Tools setLineView:CGRectMake(0, MDXFrom6(84), KScreenWidth, MDXFrom6(1))]];
        
        [header addSubview:[Tools creatImage:CGRectMake(MDXFrom6(355), MDXFrom6(35), MDXFrom6(9), MDXFrom6(15)) image:@"arrow_dark"]];
        
    }
    
    return header;
}

- (void)selectAddress{
    
    AddressViewController *controller = [[AddressViewController alloc] init];
    [self.navigationController pushViewController:controller animated:YES];
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    
    return MDXFrom6(200);
}


- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    
    static NSString * identy = @"footView";
    
    UIView * foot = [tableView dequeueReusableHeaderFooterViewWithIdentifier:identy];
    if (!foot) {
        foot = [[UIView alloc] initWithFrame:CGRectMake(0, 0, KScreenWidth, MDXFrom6(140))];
        [foot setBackgroundColor:[UIColor whiteColor]];
        UIButton * allLoad = [Tools creatButton:CGRectMake(0, 0, KScreenWidth, MDXFrom6(50)) font:[UIFont systemFontOfSize:12] color:[UIColor colorWithHexString:@"#666666"] title:@"加载全部商品" image:@""];
        [allLoad setTitle:@"收起部分商品" forState:(UIControlStateSelected)];
        [allLoad setSelected:isShow];
        [allLoad addTarget:self action:@selector(showAll:) forControlEvents:(UIControlEventTouchUpInside)];
        [foot addSubview:allLoad];
        
        [foot addSubview:[Tools setLineView:CGRectMake(0, MDXFrom6(50), KScreenWidth, MDXFrom6(10))]];
        
        [foot addSubview:[Tools creatLabel:CGRectMake(MDXFrom6(10), MDXFrom6(60), KScreenWidth - MDXFrom6(20), MDXFrom6(60)) font:[UIFont systemFontOfSize:18] color:[UIColor blackColor] alignment:(NSTextAlignmentLeft) title:@"支付方式"]];
        
        UIView *back = [[UIView alloc] initWithFrame:CGRectMake(MDXFrom6(10), MDXFrom6(120), KScreenWidth - MDXFrom6(20), MDXFrom6(50))];
        [back.layer setCornerRadius:5];
        [back.layer setBorderColor:[UIColor colorWithHexString:@"#eeeeee"].CGColor];
        [back.layer setBorderWidth:1];
        [foot addSubview:back];
        
        [back addSubview:[Tools creatImage:CGRectMake(MDXFrom6(7.5), MDXFrom6(7.5), MDXFrom6(35), MDXFrom6(35)) image:@"pay_jifen"]];
        
        [back addSubview:[Tools creatLabel:CGRectMake(MDXFrom6(50), 0,MDXFrom6(250), MDXFrom6(50)) font:[UIFont systemFontOfSize:15] color:[UIColor blackColor] alignment:(NSTextAlignmentLeft) title:@"积分支付（1000积分）"]];
        
        [back addSubview:[Tools creatImage:CGRectMake(KScreenWidth - MDXFrom6(50), MDXFrom6(15.5), MDXFrom6(19), MDXFrom6(19)) image:@"selected"]];
        
    }
    
    return foot;
}

- (void)showAll:(UIButton *)sender{
    
    [sender setSelected:!sender.selected];
    isShow = sender.selected;
    
    [self.tmpTableView reloadData];
    
}

#pragma mark -- footview
- (UIView *)setUpFootView{
    
    UIView *foot = [[UIView alloc] initWithFrame:CGRectMake(MDXFrom6(10), KScreenHeight - KTopHeight - MDXFrom6(55)  , KScreenWidth, MDXFrom6(55))];
    [foot setBackgroundColor:[UIColor colorWithHexString:@"#f7f7f7"]];
    
    [foot addSubview:[Tools creatLabel:CGRectMake(MDXFrom6(10), 0, MDXFrom6(70), MDXFrom6(55)) font:[UIFont systemFontOfSize:MDXFrom6(17)] color:[UIColor colorWithHexString:@"#333333"] alignment:(NSTextAlignmentRight) title:@"总计："]];
    
    [foot addSubview:[Tools creatLabel:CGRectMake(MDXFrom6(80), 0, MDXFrom6(120), MDXFrom6(55)) font:[UIFont systemFontOfSize:MDXFrom6(17)] color:[UIColor colorWithHexString:@"#333333"] alignment:(NSTextAlignmentLeft) title:@"900积分"]];
    
    UIButton *settlement = [Tools creatButton:CGRectMake(KScreenWidth - MDXFrom6(135), 0, MDXFrom6(135), MDXFrom6(55)) font:[UIFont systemFontOfSize:MDXFrom6(17)] color:[UIColor colorWithHexString:@"#ffffff"] title:@"立即付款" image:@""];
    [settlement setBackgroundColor:[UIColor colorWithHexString:@"#ff5941"]];
    [settlement addTarget:self action:@selector(settlement) forControlEvents:(UIControlEventTouchUpInside)];
    [foot addSubview:settlement];
    
    return foot;
}

//结算
- (void)settlement{
    
    
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
