//
//  PhotoOrderInfoViewController.m
//  anjuyi1
//
//  Created by apple on 2018/9/14.
//  Copyright © 2018年 lsy. All rights reserved.
//

#import "PhotoOrderInfoViewController.h"

@interface PhotoOrderInfoViewController ()<UIScrollViewDelegate>
{
    UIButton * _selectTypeBtn;
}

@property (nonatomic,strong) UIScrollView       * tmpScrollView;
@property (nonatomic,strong) NSMutableArray     * textArr;

@end

@implementation PhotoOrderInfoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self baseForDefaultLeftNavButton];
    [self setTitle:@"添加收货信息"];
    
    [self.view addSubview:self.tmpScrollView];
    
    self.textArr = [NSMutableArray array];
    
    [self.view addSubview:[Tools setLineView:CGRectMake(0, 0, KScreenWidth, 1)]];
    
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
        [textField setTag:i];
        [textField addTarget:self action:@selector(textFieldValueChange:) forControlEvents:(UIControlEventEditingChanged)];
        [textField setBorderStyle:(UITextBorderStyleRoundedRect)];
        [self.tmpScrollView addSubview:textField];
        height += 40+15;
        
        [self.textArr addObject:@""];
    }
    
    
    [self.tmpScrollView addSubview:[Tools creatLabel:CGRectMake(15, height, KScreenWidth - 30, 14) font:[UIFont systemFontOfSize:14] color:[UIColor colorWithHexString:@"#666666"] alignment:(NSTextAlignmentLeft) title:@"收货所在楼层"]];
    
    height += 15+14;
    
    for (NSInteger i = 0 ; i < 2 ; i++) {
        
        UIButton *btn = [Tools creatButton:CGRectMake(15, height, KScreenWidth - MDXFrom6(40), MDXFrom6(50)) font:[UIFont systemFontOfSize:16] color:[UIColor colorWithHexString:@"#999999"] title:@[@" 有电梯",@" 无电梯"][i] image:@"cart_select_no"];
        [btn setImage:[UIImage imageNamed:@"cart_selected"] forState:(UIControlStateSelected)];
        [btn addTarget:self action:@selector(selectRoomType:) forControlEvents:(UIControlEventTouchUpInside)];
        [btn setFrame:CGRectMake(i==0?15:125, height, 100, 30)];
        [btn setTag:i];
        if (i==0) {
            _selectTypeBtn = btn;
            [btn setSelected:YES];
        }
        
        [self.tmpScrollView addSubview:btn];
    }
    
    height += 30+15;
    
    [self.tmpScrollView addSubview:[Tools creatLabel:CGRectMake(15, height, KScreenWidth - 30, 14) font:[UIFont systemFontOfSize:14] color:[UIColor colorWithHexString:@"#666666"] alignment:(NSTextAlignmentLeft) title:@"备注"]];
    
    height += 15+14;
    
    UITextField *textField = [[UITextField alloc] initWithFrame:CGRectMake(15, height, KScreenWidth - 30, 40)];
    [textField setTag:4];
    [textField addTarget:self action:@selector(textFieldValueChange:) forControlEvents:(UIControlEventEditingChanged)];
    [textField setBorderStyle:(UITextBorderStyleRoundedRect)];
    [self.tmpScrollView addSubview:textField];
    
    [self.textArr addObject:@""];
    
    height += 40+15;
    
    UIButton *btn = [Tools creatButton:CGRectMake(15, height, KScreenWidth - 30, MDXFrom6(50)) font:[UIFont systemFontOfSize:16] color:[UIColor whiteColor] title:@"确认" image:@""];
    [btn setBackgroundColor:MDRGBA(255, 181, 0, 1)];
    [btn.layer setCornerRadius:5];
    [btn setClipsToBounds:YES];
    [btn addTarget:self action:@selector(sureOrder) forControlEvents:(UIControlEventTouchUpInside)];
    [self.tmpScrollView addSubview:btn];
    
    height += MDXFrom6(70);
    
    [self.tmpScrollView setContentSize:CGSizeMake(KScreenWidth, height)];
}

#pragma mark -- 点击事件

- (void)textFieldValueChange:(UITextField *)sender{
    
    [self.textArr replaceObjectAtIndex:sender.tag withObject:sender.text];
}

- (void)selectRoomType:(UIButton *)sender{
    
    [_selectTypeBtn setSelected:NO];
    
    [sender setSelected:YES];
    _selectTypeBtn = sender;
}

- (void)sureOrder{
    
    NSArray *arr = @[@"收货人姓名",@"收货人手机号",@"工地详细地址",@"收货所在电梯",@"备注"];
    for (NSInteger i = 0 ; i < arr.count; i++) {
        if ([self.textArr[i] length]==0) {
            [ViewHelps showHUDWithText:[NSString stringWithFormat:@"请输入%@",arr[i]]];
            return;
        }
    }
    
    
    NSString *path = [NSString stringWithFormat:@"%@/auxiliary_order/add_order",KURL];
    
    NSDictionary *header = @{@"token":UTOKEN};
    NSDictionary *dic = @{@"image_id":self.image_id,@"name":self.textArr[0],@"phone":self.textArr[1],@"address":self.textArr[2],@"floor":self.textArr[3],@"note":self.textArr[4],@"elevator":_selectTypeBtn.tag==0?@"1":@"0"};
    
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    __weak typeof(self) weakSelf = self;
    
    [HttpRequest POSTWithHeader:header url:path parameters:dic success:^(id  _Nullable responseObject) {
        
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        
        if ([responseObject[@"code"] integerValue] == 200) {
            
            
        }
        else{
            
            [ViewHelps showHUDWithText:responseObject[@"message"]];
        }
        
        
    } failure:^(NSError * _Nullable error) {
        
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        [RequestSever showMsgWithError:error];
    }];

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
