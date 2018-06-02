//
//  SettingViewController.m
//  anjuyi1
//
//  Created by 李 on 2018/6/2.
//  Copyright © 2018年 lsy. All rights reserved.
//

#import "SettingViewController.h"

@interface SettingViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic,strong)UITableView *tmpTableView;

@end

@implementation SettingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self setTitle:@"设置"];
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
        [_tmpTableView setTableFooterView:[self setUpFootView]];
        [_tmpTableView setDelegate:self];
    }
    return _tmpTableView;
}

- (UIView *)setUpFootView{
    
    UIView *footView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, KScreenWidth, MDXFrom6(150))];
    
    UIButton *btn = [Tools creatButton:CGRectMake(MDXFrom6(20), MDXFrom6(60), KScreenWidth - MDXFrom6(40), MDXFrom6(50)) font:[UIFont systemFontOfSize:16] color:[UIColor whiteColor] title:@"退出登录" image:@""];
    [btn setBackgroundColor:MDRGBA(255, 181, 0, 1)];
    [btn.layer setCornerRadius:5];
    [btn setClipsToBounds:YES];
    [btn addTarget:self action:@selector(backLogin) forControlEvents:(UIControlEventTouchUpInside)];
    [footView addSubview:btn];
    
    return footView;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 5;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"SettingViewControllerCell"];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:(UITableViewCellStyleDefault) reuseIdentifier:@"SettingViewControllerCell"];
    }
    
    [cell setSelectionStyle:(UITableViewCellSelectionStyleNone)];
    
    for (UIView *v in cell.contentView.subviews) {
        [v removeFromSuperview];
    }
    
    NSArray *tArr = @[@"编辑个人资料",@"账号与安全",@"地址管理",@"清除缓存",@"关于我们"];
    [cell.contentView addSubview:[Tools creatLabel:CGRectMake(MDXFrom6(20), 0, KScreenWidth - MDXFrom6(40), MDXFrom6(50)) font:[UIFont systemFontOfSize:16] color:[UIColor blackColor] alignment:(NSTextAlignmentLeft) title:tArr[indexPath.row]]];
    if (indexPath.row != 3) {
        [cell.contentView addSubview:[Tools creatImage:CGRectMake(MDXFrom6(340), MDXFrom6(16.5), MDXFrom6(8), MDXFrom6(17)) image:@"sy_arrow"]];
    }
    else{
        
        SDImageCache *tmpCache = [SDImageCache sharedImageCache];
        
        // 拿到文件的总大小
        NSUInteger imageSize = [tmpCache getSize];
        
        [cell.contentView addSubview:[Tools creatLabel:CGRectMake(MDXFrom6(20), 0, KScreenWidth - MDXFrom6(40), MDXFrom6(50)) font:[UIFont systemFontOfSize:16] color:[UIColor colorWithHexString:@"#999999"] alignment:(NSTextAlignmentRight) title:[NSString stringWithFormat:@"%.2fM",imageSize/1024.0/1024.0]]];
    }
   
    [cell.contentView addSubview:[Tools setLineView:CGRectMake(MDXFrom6(20), MDXFrom6(49), KScreenWidth - MDXFrom6(40), MDXFrom6(1))]];

    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return MDXFrom6(50);
}


#pragma mark - 清除缓存
- (void) clearCache{
    
    [self creatAlertClearCacheWithMessage:@"是否要清理缓存"];
}

- (void)creatAlertClearCacheWithMessage:(NSString *)message{
    
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示" message:message preferredStyle:(UIAlertControllerStyleAlert)];
    
    UIAlertAction *trueA = [UIAlertAction actionWithTitle:@"确定" style:(UIAlertActionStyleCancel) handler:^(UIAlertAction * _Nonnull action) {
        
        
        SDImageCache *tmpCache = [SDImageCache sharedImageCache];
        
        // 拿到文件的数量
        NSUInteger numberOfImages = [tmpCache getDiskCount];
        
        // 拿到文件的总大小
        NSUInteger imageSize = [tmpCache getSize];
        
        //清空缓存
        [tmpCache clearDiskOnCompletion:^{
            
            [ViewHelps showHUDWithText:[NSString stringWithFormat:@"已经成功清理%.2fMB缓存", imageSize/1024.0/1024.0]];
        }];
        
        [self.tmpTableView reloadData];
    }];
    
    UIAlertAction *falseA = [UIAlertAction actionWithTitle:@"取消" style:(UIAlertActionStyleDefault) handler:^(UIAlertAction * _Nonnull action) {
        
        
        
    }];
    
    [alert addAction:trueA];
    
    [alert addAction:falseA];
    
    [self presentViewController:alert animated:YES completion:nil];
    
}

#pragma mark -- 退出登录
- (void)backLogin{
    
    [self creatAlertViewControllerWithMessage:@"确定退出登录？"];
}

- (void)creatAlertViewControllerWithMessage:(NSString *)message{
    
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
