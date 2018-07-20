//
//  OrderDetailsVC.m
//  anjuyi1
//
//  Created by 李 on 2018/6/5.
//  Copyright © 2018年 lsy. All rights reserved.
//

#import "OrderDetailsVC.h"
#import "OrderDetailsCell.h"

@interface OrderDetailsVC ()<UITableViewDataSource,UITableViewDelegate>
{
    BOOL isShow;
}

@property (nonatomic,strong)UITableView  * tmpTableView;

@end

@implementation OrderDetailsVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self setTitle:@"订单详情"];
    
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
    
    OrderDetailsCell *cell = [tableView dequeueReusableCellWithIdentifier:@"OrderDetailsCell"];
    if (!cell) {
        cell = [[OrderDetailsCell alloc] initWithStyle:(UITableViewCellStyleDefault) reuseIdentifier:@"OrderDetailsCell"];
    }
    
    [cell setSelectionStyle:(UITableViewCellSelectionStyleNone)];
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 75;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return MDXFrom6(85);
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    
    static NSString * identy = @"headView";
    
    UIView * header = [tableView dequeueReusableHeaderFooterViewWithIdentifier:identy];
    
    if (!header) {
        header = [[UIView alloc] initWithFrame:CGRectMake(0, 0, KScreenWidth, MDXFrom6(85))];
        [header setBackgroundColor:[UIColor whiteColor]];
        [header addSubview:[Tools creatAttributedLabel:CGRectMake(MDXFrom6(12), MDXFrom6(14), MDXFrom6(351), MDXFrom6(20)) font:[UIFont systemFontOfSize:16] color:[UIColor colorWithHexString:@"#333333"] title:@"收货人：张美华" image:@"order_user" alignment:(NSTextAlignmentLeft)]];
        
        [header addSubview:[Tools creatAttributedLabel:CGRectMake(MDXFrom6(12), MDXFrom6(14), MDXFrom6(351), MDXFrom6(20)) font:[UIFont systemFontOfSize:16] color:[UIColor colorWithHexString:@"#333333"] title:@"18998772312" image:@"order_phone" alignment:(NSTextAlignmentRight)]];
        
        [header addSubview:[Tools creatAttributedLabel:CGRectMake(MDXFrom6(12), MDXFrom6(44), MDXFrom6(351), MDXFrom6(20)) font:[UIFont systemFontOfSize:16] color:[UIColor colorWithHexString:@"#333333"] title:@"地址：北京市 新城区  青年街34号  大悦城7号" image:@"order_pos" alignment:(NSTextAlignmentLeft)]];
        
        [header addSubview:[Tools setLineView:CGRectMake(0, MDXFrom6(84), KScreenWidth, MDXFrom6(1))]];
    }

    return header;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    
    return MDXFrom6(65+50*3 + 48*6);
}


- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    
    static NSString * identy = @"footView";
    
    UIView * foot = [tableView dequeueReusableHeaderFooterViewWithIdentifier:identy];
    if (!foot) {
        foot = [[UIView alloc] initWithFrame:CGRectMake(0, 0, KScreenWidth, MDXFrom6(65+50*3 + 48*6))];
        [foot setBackgroundColor:[UIColor whiteColor]];
        UIButton * allLoad = [Tools creatButton:CGRectMake(0, 0, KScreenWidth, MDXFrom6(50)) font:[UIFont systemFontOfSize:12] color:[UIColor colorWithHexString:@"#666666"] title:@"加载全部商品" image:@""];
        [allLoad setTitle:@"收起部分商品" forState:(UIControlStateSelected)];
        [allLoad setSelected:isShow];
        [allLoad addTarget:self action:@selector(showAll:) forControlEvents:(UIControlEventTouchUpInside)];
        [foot addSubview:allLoad];
        
        NSArray *tArr = @[@"运费",@"优惠",@"实付款（含运费）"];
        NSArray *mArr = @[@"￥10.00",@"￥10.00",@"￥10.00"];
        
        for (NSInteger i = 0 ; i < 3 ; i++) {
            
            [foot addSubview:[Tools setLineView:CGRectMake(0, MDXFrom6(50+50*i), KScreenWidth, 1)]];
            
            [foot addSubview:[Tools creatLabel:CGRectMake(MDXFrom6(10), MDXFrom6(50+50*i), KScreenWidth - MDXFrom6(20), MDXFrom6(50)) font:[UIFont systemFontOfSize:16] color:[UIColor colorWithHexString:@"#666666"] alignment:(NSTextAlignmentLeft) title:tArr[i]]];
            [foot addSubview:[Tools creatLabel:CGRectMake(MDXFrom6(10), MDXFrom6(50+50*i), KScreenWidth - MDXFrom6(20), MDXFrom6(50)) font:[UIFont systemFontOfSize:16] color:[UIColor colorWithHexString:i==2?@"#ff5941":@"#000000"] alignment:(NSTextAlignmentRight) title:mArr[i]]];
        }
        [foot addSubview:[Tools setLineView:CGRectMake(0, MDXFrom6(50+50*3), KScreenWidth, 1)]];
        
        for (NSInteger i = 0 ; i < 6 ; i++) {
            
            [foot addSubview:[Tools creatLabel:CGRectMake(MDXFrom6(10), MDXFrom6(60+50*3 + 48*i), KScreenWidth - MDXFrom6(20), MDXFrom6(48)) font:[UIFont systemFontOfSize:16] color:[UIColor colorWithHexString:@"#666666"] alignment:(NSTextAlignmentRight) title:@"交易单号：2018042522314123"]];
        }
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
    
    UIButton *service = [Tools creatButton:CGRectMake(0, 0, MDXFrom6(55), MDXFrom6(55)) font:[UIFont systemFontOfSize:12] color:[UIColor colorWithHexString:@"#666666"] title:@"在线客服" image:@"order_kefu"];
    [service setTitleEdgeInsets:UIEdgeInsetsMake(MDXFrom6(20), -service.imageView.frame.size.width-MDXFrom6(5), 0, 0)];
    [service setImageEdgeInsets:UIEdgeInsetsMake(MDXFrom6(5), MDXFrom6(15), MDXFrom6(25), MDXFrom6(15))];
    [service addTarget:self action:@selector(pullUpCusetomerServise) forControlEvents:(UIControlEventTouchUpInside)];
    [foot addSubview:service];
    
    UIButton *delete1 = [Tools creatButton:CGRectMake(MDXFrom6(100), MDXFrom6(12.5), MDXFrom6(90), MDXFrom6(30)) font:[UIFont systemFontOfSize:12] color:[UIColor colorWithHexString:@"#666666"] title:@"删除订单" image:@""];
    [delete1.layer setCornerRadius:MDXFrom6(15)];
    [delete1.layer setBorderColor:[UIColor colorWithHexString:@"#666666"].CGColor];
    [delete1.layer setBorderWidth:1];
    [delete1 addTarget:self action:@selector(deleteOrder) forControlEvents:(UIControlEventTouchUpInside)];
    [foot addSubview:delete1];
    
    
    
    return foot;
}

//在线客服
- (void)pullUpCusetomerServise{
    
    
}

- (void)deleteOrder{
    
    NSLog(@"%@",@"321");
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
