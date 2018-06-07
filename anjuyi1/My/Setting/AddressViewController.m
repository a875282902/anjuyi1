//
//  AddressViewController.m
//  anjuyi1
//
//  Created by 李 on 2018/6/7.
//  Copyright © 2018年 lsy. All rights reserved.
//

#import "AddressViewController.h"
#import "AddressTableViewCell.h"
#import "AddAddressViewController.h"

static AddressTableViewCell * defaultCell;

@interface AddressViewController ()<UITableViewDelegate,UITableViewDataSource,AddressTableViewCellDelegate>

@property (nonatomic,strong) UITableView * tmpTableView;

@end

@implementation AddressViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self setTitle:@"地址管理"];
    [self setNavigationLeftBarButtonWithImageNamed:@"ss_back"];
    
    [self.view addSubview:self.tmpTableView];
    
    [self.view addSubview:[Tools setLineView:CGRectMake(0, 0, KScreenWidth, 1.5)]];
}

#pragma mark -- tableView
- (UITableView *)tmpTableView{
    
    if (!_tmpTableView) {
        _tmpTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, KScreenWidth, KScreenHeight-KTopHeight) style:(UITableViewStylePlain)];
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
    
    AddressTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"AddressTableViewCell"];
    if (!cell) {
        cell = [[AddressTableViewCell alloc] initWithStyle:(UITableViewCellStyleDefault) reuseIdentifier:@"AddressTableViewCell"];
    }
    
    [cell setSelectionStyle:(UITableViewCellSelectionStyleNone)];
    [cell setDelegate:self];
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 170;
}

#pragma mark -- addressTableViewCellDelegate
- (void)setDefaultTableViewWithCell:(AddressTableViewCell *)cell{
    
    if (defaultCell&& defaultCell != cell) {
        [defaultCell.defaultButton setSelected:NO];
    }
    
    defaultCell = cell;
    
    NSIndexPath *indexpath = [self.tmpTableView indexPathForCell:cell];
    
    NSLog(@"%ld",indexpath.row);
    
    
}

- (void)deleteTableViewWithCell:(AddressTableViewCell *)cell{
    
    NSIndexPath *indexpath = [self.tmpTableView indexPathForCell:cell];

    [self creatAlertViewControllerWithMessage:@"确定要删除该条地址吗？" location:indexpath.row];
}

- (void)editTableViewWithCell:(AddressTableViewCell *)cell{
    
    NSIndexPath *indexpath = [self.tmpTableView indexPathForCell:cell];

    AddAddressViewController *controller = [[AddAddressViewController alloc] init];
    [self.navigationController pushViewController:controller animated:YES];
    
}

#pragma mark -- alertView
- (void)creatAlertViewControllerWithMessage:(NSString *)message location:(NSInteger)index{
    
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示" message:message preferredStyle:(UIAlertControllerStyleAlert)];
    
    UIAlertAction *trueA = [UIAlertAction actionWithTitle:@"确定" style:(UIAlertActionStyleCancel) handler:^(UIAlertAction * _Nonnull action) {
        
        
        
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
