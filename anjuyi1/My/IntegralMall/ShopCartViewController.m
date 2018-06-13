//
//  ShopCartViewController.m
//  anjuyi1
//
//  Created by 李 on 2018/6/5.
//  Copyright © 2018年 lsy. All rights reserved.
//

#import "ShopCartViewController.h"
#import "ShopCartCell.h"
#import "IntegralPayViewController.h"

@interface ShopCartViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic,strong)UITableView     * tmpTableView;
@property (nonatomic,strong)UIView          * footView;

@end

@implementation ShopCartViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.\
    
    [self baseForDefaultLeftNavButton];
    [self.navigationItem setTitleView:[[NavTwoTitle alloc] initWithFrame:CGRectMake(0, 0, MDXFrom6(300), 44) WithTitle1:@"购物车" WithTitle2:@"5件"]];
    
    [self setNavigationRightBarButtonWithTitle:@"清空" color:[UIColor colorWithHexString:@"#ff9500"]];
    
    [self.view addSubview:self.tmpTableView];
    
    [self.view addSubview:[Tools setLineView:CGRectMake(0, 0, KScreenWidth, 1)]];
    
    [self.view addSubview:self.footView];
    
}

#pragma mark -- 底部
- (UIView *)footView{
    
    if (!_footView) {
        _footView = [[UIView alloc] initWithFrame:CGRectMake(0, KScreenHeight - MDXFrom6(50)- KTopHeight, KScreenWidth, MDXFrom6(50))];
        
        [_footView addSubview:[Tools setLineView:CGRectMake(0, 0, KScreenWidth, 1.5)]];
        
        UIButton *service = [Tools creatButton:CGRectMake(0, 0, MDXFrom6(50), MDXFrom6(50)) font:[UIFont systemFontOfSize:12] color:[UIColor colorWithHexString:@"#333333"] title:@"全选" image:@"cart_select_no"];
        [service setTitleEdgeInsets:UIEdgeInsetsMake(MDXFrom6(20), -service.imageView.frame.size.width-MDXFrom6(5), 0, 0)];
        [service setBackgroundColor:[UIColor colorWithHexString:@"#f8f8f8"]];
        [service setImageEdgeInsets:UIEdgeInsetsMake(MDXFrom6(5), MDXFrom6(15), MDXFrom6(25), MDXFrom6(15))];
        [service addTarget:self action:@selector(allSelect) forControlEvents:(UIControlEventTouchUpInside)];
        [_footView addSubview:service];
        
        [_footView addSubview:[Tools creatLabel:CGRectMake(MDXFrom6(50), 0, MDXFrom6(70), MDXFrom6(50)) font:[UIFont systemFontOfSize:MDXFrom6(17)] color:[UIColor colorWithHexString:@"#333333"] alignment:(NSTextAlignmentRight) title:@"总计："]];
        
        [_footView addSubview:[Tools creatLabel:CGRectMake(MDXFrom6(120), 0, MDXFrom6(120), MDXFrom6(50)) font:[UIFont systemFontOfSize:MDXFrom6(17)] color:[UIColor colorWithHexString:@"#333333"] alignment:(NSTextAlignmentLeft) title:@"900积分"]];
        
        UIButton *settlement = [Tools creatButton:CGRectMake(KScreenWidth - MDXFrom6(135), 0, MDXFrom6(135), MDXFrom6(50)) font:[UIFont systemFontOfSize:MDXFrom6(17)] color:[UIColor colorWithHexString:@"#ffffff"] title:@"结算" image:@""];
        [settlement setBackgroundColor:[UIColor colorWithHexString:@"#ff5941"]];
        [settlement addTarget:self action:@selector(settlement) forControlEvents:(UIControlEventTouchUpInside)];
        [_footView addSubview:settlement];
    }
    
    return _footView;
}


#pragma mark -- tableView
- (UITableView *)tmpTableView{
    
    if (!_tmpTableView) {
        _tmpTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, KScreenWidth, KScreenHeight-KTopHeight-MDXFrom6(50)) style:(UITableViewStylePlain)];
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
    return 3;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    ShopCartCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ShopCartCell"];
    if (!cell) {
        cell = [[ShopCartCell alloc] initWithStyle:(UITableViewCellStyleDefault) reuseIdentifier:@"ShopCartCell"];
    }
    
    [cell setSelectionStyle:(UITableViewCellSelectionStyleNone)];
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 100;
}

#pragma mark -- 点击事件
- (void)rightButtonTouchUpInside:(id)sender{
    
    [self creatAlertViewControllerWithMessage:@"确定要清空购物车？"];
    
}

//全选
- (void)allSelect{
    
    
}
//结算
- (void)settlement{
    
    IntegralPayViewController *controller = [[IntegralPayViewController alloc] init];
    [self.navigationController pushViewController:controller animated:YES];
}


#pragma mark --  弹框
- (void)creatAlertViewControllerWithMessage:(NSString *)message{
    
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示" message:message preferredStyle:(UIAlertControllerStyleAlert)];
    
    UIAlertAction *trueA = [UIAlertAction actionWithTitle:@"确定" style:(UIAlertActionStyleCancel) handler:^(UIAlertAction * _Nonnull action) {
        
        
        [self.tmpTableView reloadData];
        
    }];
    
    UIAlertAction *falseA = [UIAlertAction actionWithTitle:@"取消" style:(UIAlertActionStyleDefault) handler:^(UIAlertAction * _Nonnull action) {
        
        
        
    }];
    
    [alert addAction:trueA];
    
    [alert addAction:falseA];
    
    [self presentViewController:alert animated:YES completion:nil];
    
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
