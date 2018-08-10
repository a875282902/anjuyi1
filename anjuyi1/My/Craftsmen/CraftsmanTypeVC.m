//
//  CraftsmanTypeVC.m
//  anjuyi1
//
//  Created by 李 on 2018/6/8.
//  Copyright © 2018年 lsy. All rights reserved.
//

#import "CraftsmanTypeVC.h"
#import "CraftSmenDetailsVC.h"

@interface CraftsmanTypeVC ()<UIScrollViewDelegate>

@property (nonatomic,strong)UIScrollView *tmpScrollView;

@end

@implementation CraftsmanTypeVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setTitle:@"工匠汇"];
    [self baseForDefaultLeftNavButton];
    
    [self.view addSubview:self.tmpScrollView];
    
    [self.view addSubview:[Tools setLineView:CGRectMake(0, 0, KScreenWidth, 1)]];
    
    [self setUpUI];
}

-(UIScrollView *)tmpScrollView{
    
    if (!_tmpScrollView) {
        _tmpScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, KScreenWidth, KScreenHeight - KTopHeight)];
        if (@available(iOS 11.0, *)) {
            [_tmpScrollView setContentInsetAdjustmentBehavior:(UIScrollViewContentInsetAdjustmentNever)];
        }
        [_tmpScrollView setShowsVerticalScrollIndicator:NO];
        [_tmpScrollView setShowsHorizontalScrollIndicator:NO];
        [_tmpScrollView setContentSize:CGSizeMake(KScreenWidth , MDXFrom6(551))];
        [_tmpScrollView setDelegate:self];
    }
    return _tmpScrollView;
}

- (void)setUpUI{
    
    NSArray * bArr = @[@"gjh_bg1",@"gjh_bg2",@"gjh_bg3"];
    NSArray * iArr = @[@"gjh_designer",@"gjh_gongzhang",@"gjh_jianli"];
    NSArray * tArr = @[@"我是设计师！",@"我是工长！",@"我是监理"];
    
    for (NSInteger i = 0 ; i < 3 ; i++) {
        
        UIImageView * backImage = [Tools creatImage:CGRectMake(MDXFrom6(32.5), MDXFrom6(50+167*i), MDXFrom6(310), MDXFrom6(127)) image:bArr[i]];
        [backImage addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(selectCraftsmanType:)]];
        [backImage setTag:i];
        [self.tmpScrollView addSubview:backImage];
        
        [backImage addSubview:[Tools creatImage:CGRectMake(MDXFrom6(132.5), MDXFrom6(25), MDXFrom6(45), MDXFrom6(45)) image:iArr[i]]];
        
        [backImage addSubview:[Tools creatLabel:CGRectMake(0, MDXFrom6(85), MDXFrom6(310), MDXFrom6(20)) font:[UIFont systemFontOfSize:MDXFrom6(18)] color:[UIColor whiteColor] alignment:(NSTextAlignmentCenter) title:tArr[i]]];
        
    }
}

- (void)selectCraftsmanType:(UITapGestureRecognizer *)sender{
    
    CraftSmenDetailsVC *vc = [[CraftSmenDetailsVC alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
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
