//
//  OrderCenterDatailsVC.m
//  anjuyi1
//
//  Created by 李 on 2018/6/8.
//  Copyright © 2018年 lsy. All rights reserved.
//

#import "OrderCenterDatailsVC.h"

@interface OrderCenterDatailsVC ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic,strong)UITableView *tmpTableView;

@end

@implementation OrderCenterDatailsVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setTitle:@"订单详情"];
    [self baseForDefaultLeftNavButton];
    [self.view addSubview:self.tmpTableView];
    
    [self.view addSubview:[Tools setLineView:CGRectMake(0, 0, KScreenWidth, 1)]];
}

#pragma mark -- tableView
- (UITableView *)tmpTableView{
    
    if (!_tmpTableView) {
        _tmpTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, KScreenWidth, KScreenHeight-KTopHeight) style:(UITableViewStylePlain)];
        
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
    return 8;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"OrderCenterDatailsVCCell"];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:(UITableViewCellStyleValue1) reuseIdentifier:@"OrderCenterDatailsVCCell"];
    }
    
    [cell setSelectionStyle:(UITableViewCellSelectionStyleNone)];
    
    NSArray *tArr = @[@"地区",@"类型",@"户型",@"预算",@"户主名字",@"户型面积",@"户型图",@"备注"];
    
    [cell.textLabel setText:tArr[indexPath.row]];
    [cell.textLabel setFont:[UIFont systemFontOfSize:16]];
    [cell.textLabel setTextColor:[UIColor colorWithHexString:@"#666666"]];
    
    NSTextAttachment *attchImage = [[NSTextAttachment alloc] init];
    // 表情图片
    attchImage.image = [UIImage imageNamed:@"js_center_img"];
    // 设置图片大小
    attchImage.bounds = CGRectMake(0, 0, 100, 100);
    
    

    [cell.detailTextLabel setAttributedText:[[NSAttributedString alloc] initWithString:tArr[indexPath.row]]];
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    
    return 90;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    
    UIView *v = [[UIView alloc] initWithFrame:CGRectMake(0, 0, KScreenWidth, 90)];
    [v setBackgroundColor:[UIColor whiteColor]];
    
    UIButton *btn = [Tools creatButton:CGRectMake(10,20, KScreenWidth -20, 50) font:[UIFont systemFontOfSize:16] color:[UIColor whiteColor] title:@"接受订单" image:@""];
    [btn setBackgroundColor:MDRGBA(255, 181, 0, 1)];
    [btn.layer setCornerRadius:5];
    [btn setClipsToBounds:YES];
    [btn addTarget:self action:@selector(acceptOrders) forControlEvents:(UIControlEventTouchUpInside)];
    [v addSubview:btn];
    
    
    return v;
}

- (void)acceptOrders{
    
    
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
