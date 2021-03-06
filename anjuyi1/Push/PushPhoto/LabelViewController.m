//
//  LabelViewController.m
//  anjuyi1
//
//  Created by apple on 2018/7/13.
//  Copyright © 2018年 lsy. All rights reserved.
//

#import "LabelViewController.h"

@interface LabelViewController ()<UIScrollViewDelegate>

@property (nonatomic,strong)NSMutableArray *dataArr;
@property (nonatomic,strong)NSMutableArray *sureArr;
@property (nonatomic,strong)UIScrollView *tmpScrollView;

@end

@implementation LabelViewController

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self.navigationController setNavigationBarHidden:NO animated:YES];
    
    [self baseForDefaultLeftNavButton];
    [self setNavSearch];
 
    self.dataArr = [NSMutableArray array];
    self.sureArr = [NSMutableArray arrayWithArray:self.sureBtnLabel];
    
    [self.view addSubview:[Tools setLineView:CGRectMake(0, 0, KScreenWidth, 1)]];
    
    [self getData];
}

- (void)getData{
    
    
    NSString *path = [NSString stringWithFormat:@"%@/MemberImage/get_tag_list",KURL];
    
    NSDictionary *header = @{@"token":UTOKEN};
    
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    __weak typeof(self) weakSelf = self;
    
    [HttpRequest POSTWithHeader:header url:path parameters:nil success:^(id  _Nullable responseObject) {
        
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        
        [weakSelf.dataArr removeAllObjects];
        
        if ([responseObject[@"code"] integerValue] == 200) {
            
            for (NSDictionary *dic in responseObject[@"datas"][@"list"]) {
                [weakSelf.dataArr addObject:dic];
            }
            
            [self setUpUI];
        }
        else{
            
            [ViewHelps showHUDWithText:responseObject[@"message"]];
        }
        
        
    } failure:^(NSError * _Nullable error) {
        
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        [RequestSever showMsgWithError:error];
    }];

}

- (void)setNavSearch{
    UITextField *textFeild = [[UITextField alloc] initWithFrame:CGRectMake(0, 0, KScreenWidth, 30)];
    [textFeild setBorderStyle:(UITextBorderStyleRoundedRect)];
    [textFeild setFont:[UIFont systemFontOfSize:15]];
    [textFeild setPlaceholder:@"请输入您想要添加的标签"];
    [self.navigationItem setTitleView:textFeild];
}

#pragma mark -- scrollview
-(UIScrollView *)tmpScrollView{
    
    if (!_tmpScrollView) {
        _tmpScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, KScreenWidth, KViewHeight)];
        if (@available(iOS 11.0, *)) {
            [_tmpScrollView setContentInsetAdjustmentBehavior:(UIScrollViewContentInsetAdjustmentNever)];
        }
        [_tmpScrollView setShowsVerticalScrollIndicator:NO];
        [_tmpScrollView setShowsHorizontalScrollIndicator:NO];
        [_tmpScrollView setDelegate:self];
    }
    return _tmpScrollView;
}

- (void)setUpUI{
    
    [self.view addSubview:self.tmpScrollView];
    
    CGFloat x = 15.0f;
    CGFloat y = 20.0f;
    CGFloat w = 0;
    CGFloat h = 30.0f;
    
    for (NSInteger i = 0 ; i < self.dataArr.count ; i ++) {
     
        NSString *str = [NSString stringWithFormat:@"#%@",self.dataArr[i][@"name"]];
        
        NSMutableParagraphStyle *style = [[NSParagraphStyle defaultParagraphStyle] mutableCopy];
        style.lineBreakMode = NSLineBreakByWordWrapping;
        style.alignment = NSTextAlignmentLeft;
        
        NSAttributedString *atts = [[NSAttributedString alloc] initWithString:str attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:14],NSParagraphStyleAttributeName:style}];
        
        CGRect rext = [atts boundingRectWithSize:CGSizeMake(10000, 30) options:(NSStringDrawingUsesFontLeading|NSStringDrawingUsesLineFragmentOrigin) context:nil];
        
        w = rext.size.width + 20.0f;
        
        if (w+x > KScreenWidth) {
            y += 40.f;
            x = 15.0f;
        }
        
        UIButton *btn = [Tools creatButton:CGRectMake(x, y, w, h) font:[UIFont systemFontOfSize:14] color:[UIColor colorWithHexString:@"#2cb7b5"] title:str image:@""];
        [btn setBackgroundColor:[UIColor colorWithHexString:@"#eaf8f8"]];
        [btn setTitleColor:[UIColor blackColor] forState:(UIControlStateSelected)];
        [btn.layer setBorderWidth:1];
        [btn.layer setBorderColor:[UIColor colorWithHexString:@"#34bab8"].CGColor];
        [btn.layer setCornerRadius:5];
        [btn setClipsToBounds:YES];
        [btn setTag:i];
        [btn addTarget:self action:@selector(selectLabel:) forControlEvents:(UIControlEventTouchUpInside)];
        [self.tmpScrollView addSubview:btn];
        
        for (NSDictionary *dic in self.sureArr) {
            if ([[NSString stringWithFormat:@"#%@",dic[@"name"]] isEqualToString:str]) {
                [btn setSelected:YES];
                [btn setBackgroundColor:[UIColor colorWithHexString:@"#efefef"]];
            }
        }
        
        x += w+ 10.0f;
        
    }

}

- (void)selectLabel:(UIButton *)sender{
    
    if (sender.selected) {
        [sender setSelected:NO];
        [sender setBackgroundColor:[UIColor colorWithHexString:@"#eaf8f8"]];
        [self.sureArr removeObject:self.dataArr[sender.tag]];
    }
    else{
        [sender setSelected:YES];
        [sender setBackgroundColor:[UIColor colorWithHexString:@"#efefef"]];
        [self.sureArr addObject:self.dataArr[sender.tag]];
    }
    self.sureSelectLabel(self.sureArr);
    
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)leftButtonTouchUpInside:(id)sender{
    
    [self.navigationController popViewControllerAnimated:YES];
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
