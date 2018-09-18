//
//  PhotoOrderInfoViewController.m
//  anjuyi1
//
//  Created by apple on 2018/9/14.
//  Copyright © 2018年 lsy. All rights reserved.
//

#import "PhotoOrderInfoViewController.h"

@interface PhotoOrderInfoViewController ()<UIScrollViewDelegate>

@property (nonatomic,strong) UIScrollView       * tmpScrollView;

@end

@implementation PhotoOrderInfoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self baseForDefaultLeftNavButton];
    [self setTitle:@"添加收货信息"];
    
    [self setUpUI];
}

#pragma mark -- scrollview
-(UIScrollView *)tmpScrollView{
    
    if (!_tmpScrollView) {
        _tmpScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, KScreenWidth, KViewHeight)];
        [_tmpScrollView setShowsVerticalScrollIndicator:NO];
        [_tmpScrollView setShowsHorizontalScrollIndicator:NO];
        if (@available(iOS 11.0, *)) {
            [_tmpScrollView setContentInsetAdjustmentBehavior:(UIScrollViewContentInsetAdjustmentNever)];
        }
        [_tmpScrollView setDelegate:self];
    }
    return _tmpScrollView;
}

- (void)setUpUI{
    
    CGFloat height = 15;
    
    for (NSInteger i = 0 ; i < 4; i++) {
        
        [self.tmpScrollView addSubview:[Tools creatLabel:CGRectMake(15, height, KScreenWidth - 30, 14) font:[UIFont systemFontOfSize:14] color:[UIColor colorWithHexString:@"#666666"] alignment:(NSTextAlignmentLeft) title:@[@"收货人姓名",@"收货人手机号",@"工地详细地址",@"收货所在电梯"][i]]];
        
        height += 15+14;
        
        UITextField *textField = [[UITextField alloc] initWithFrame:CGRectMake(15, height, KScreenWidth - 30, 40)];
        [textField setBorderStyle:(UITextBorderStyleRoundedRect)];
        [self.tmpScrollView addSubview:textField];
        height += 40+15;
    
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
