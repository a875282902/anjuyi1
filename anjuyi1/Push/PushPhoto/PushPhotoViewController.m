//
//  PushPhotoViewController.m
//  anjuyi1
//
//  Created by apple on 2018/7/2.
//  Copyright © 2018年 lsy. All rights reserved.
//

#import "PushPhotoViewController.h"

#define padding MDXFrom6(10)

@interface PushPhotoViewController ()<UIScrollViewDelegate,UITextViewDelegate>
{
    UILabel *_personPlace;
}

@property (nonatomic,strong) UIScrollView  * tmpScrollView;//承载视图的view
@property (nonatomic,strong) NSDictionary  * member_info;//

@end

@implementation PushPhotoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self setTitle:@"发布图片"];
    [self baseForDefaultLeftNavButton];
    
    [self.view addSubview:self.tmpScrollView];
    
    [self.view addSubview:[Tools setLineView:CGRectMake(0, 0, KScreenWidth, 1)]];
    
    [self getData];
    
    [self createPushButton];
}

- (void)getData{
    
    
    NSString *path = [NSString stringWithFormat:@"%@/MemberImage/get_info",KURL];
    
    NSDictionary *header = @{@"token":UTOKEN};
    
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    __weak typeof(self) weakSelf = self;
    
    [HttpRequest POSTWithHeader:header url:path parameters:nil success:^(id  _Nullable responseObject) {
        
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        
        if ([responseObject[@"code"] integerValue] == 200) {
            
            weakSelf.member_info = responseObject[@"datas"][@"member_info"];
            [weakSelf setUpUI];
        }
        else{
            
            [ViewHelps showHUDWithText:responseObject[@"message"]];
        }
        
        
    } failure:^(NSError * _Nullable error) {
        
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        [RequestSever showMsgWithError:error];
    }];

    
}

#pragma mark -- scrollview
-(UIScrollView *)tmpScrollView{
    
    if (!_tmpScrollView) {
        _tmpScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, KScreenWidth, KViewHeight - 80)];
        [_tmpScrollView setShowsVerticalScrollIndicator:NO];
        [_tmpScrollView setShowsHorizontalScrollIndicator:NO];
        [_tmpScrollView setDelegate:self];
    }
    return _tmpScrollView;
}

- (void)setUpUI{
    
    CGFloat height = 20;
    
    UIImageView *header = [Tools creatImage:CGRectMake(padding, height, 43, 43) url:self.member_info[@"head"] image:@""];
    [header.layer setCornerRadius:21.5];
    [self.tmpScrollView addSubview:header];
    
    NSString *name = self.member_info[@"nickname"];
    CGFloat nameW = KHeight(name, 10000, 20, 18).size.width + padding;
    
    [self.tmpScrollView addSubview:[Tools creatLabel:CGRectMake(65, 20,nameW , 25) font:[UIFont systemFontOfSize:18] color:[UIColor blackColor] alignment:(NSTextAlignmentLeft) title:name]];
    
    UILabel *typeLabel = [Tools creatLabel:CGRectMake(65+ nameW, 22.5 , 50, 20) font:[UIFont systemFontOfSize:12] color:[UIColor colorWithHexString:@"#fffefe"] alignment:(NSTextAlignmentCenter) title:self.member_info[@"level"]];
    [typeLabel.layer setCornerRadius:5];
    [typeLabel setBackgroundColor:[UIColor colorWithHexString:@"#5cc6c6"]];
    [self.tmpScrollView addSubview:typeLabel];
    
    [self.tmpScrollView addSubview:[Tools creatLabel:CGRectMake(65, 45 ,KScreenWidth - 75 , 20) font:[UIFont systemFontOfSize:12] color:[UIColor colorWithHexString:@"#999999"] alignment:(NSTextAlignmentLeft) title:self.member_info[@"position"]]];
    
    [self.tmpScrollView addSubview:[Tools creatLabel:CGRectMake(65, 45 ,KScreenWidth - 75 , 20) font:[UIFont systemFontOfSize:12] color:[UIColor colorWithHexString:@"#999999"] alignment:(NSTextAlignmentRight) title:[Tools getCurrentTimes]]];
    
    height += 83;
    
    [self.tmpScrollView addSubview:[Tools setLineView:CGRectMake(padding, height, KScreenWidth - 20, 1)]];
    
    height = [self createDynamicTextView:height];
    
    height = [self createAddLabel:height];
    
    height = [self createImageView:height];
    
    [self.tmpScrollView setContentSize:CGSizeMake(KScreenWidth, height)];
    
}

//输入工地状态
- (CGFloat)createDynamicTextView:(CGFloat)height{
    
    UITextView *textView = [[UITextView alloc] initWithFrame:CGRectMake(padding, height+10, KScreenWidth - 2*padding,120)];
    [textView setDelegate:self];
    [textView setFont:[UIFont systemFontOfSize:14]];
    [textView setTextColor:[UIColor blackColor]];
    [textView setTag:1001];
    [self.tmpScrollView addSubview:textView];
    
    _personPlace = [[UILabel alloc] initWithFrame:CGRectMake(5, 9 , KScreenWidth, 14)];
    [_personPlace setTextColor:[UIColor colorWithHexString:@"#999999"]];
    [_personPlace setText:@"记录今天工地动态"];
    [_personPlace setFont:[UIFont systemFontOfSize:14]];
    [textView addSubview:_personPlace];
    
    [self.tmpScrollView addSubview:[Tools setLineView:CGRectMake(padding, height + 140, KScreenWidth - 20, 1)]];
    
    return height + 141;
}

- (void)textViewDidChangeSelection:(UITextView *)textView{
    
    if (textView.tag == 1001) {
        if (textView.text.length == 0) {
            [_personPlace setHidden:NO];
        }
        else{
            [_personPlace setHidden:YES];
        }
    }

    if (textView.text.length>1000) {
        
        [textView setText:[textView.text substringToIndex:1000]];
    }
}

// 添加标签
- (CGFloat)createAddLabel:(CGFloat)height{
    
    height += 20;
    
    UILabel *addLable = [Tools creatLabel:CGRectMake(padding, height, 80 , 30) font:[UIFont systemFontOfSize:14] color:[UIColor colorWithHexString:@"#3b3b3b"] alignment:(NSTextAlignmentCenter) title:@"#添加标签"];
    [addLable setBackgroundColor:[UIColor colorWithHexString:@"#efefef"]];
    [addLable.layer setCornerRadius:2.5];
    [self.tmpScrollView addSubview:addLable];
    
    return height + 45 ;
}

// 添加图片
- (CGFloat)createImageView:(CGFloat)height{
    
    UIImageView *imageView = [Tools creatImage:CGRectMake(padding, height, 80, 80) image:@"tpxq_img"];
    [imageView.layer setCornerRadius:5];
    [self.tmpScrollView addSubview:imageView];
    
    return height + 100;
}

- (void)createPushButton{
    
    UIButton *btn = [Tools creatButton:CGRectMake(padding, KViewHeight -  65, KScreenWidth - 2*padding, 50) font:[UIFont systemFontOfSize:16] color:[UIColor whiteColor] title:@"发布" image:@""];
    [btn setBackgroundColor:BTNCOLOR];
    [btn.layer setCornerRadius:5];
    [btn setClipsToBounds:YES];
    [btn addTarget:self action:@selector(push) forControlEvents:(UIControlEventTouchUpInside)];
    [self.view addSubview:btn];
}

- (void)push{
    
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)leftButtonTouchUpInside:(id)sender{
    [self dismissViewControllerAnimated:YES completion:nil];
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
