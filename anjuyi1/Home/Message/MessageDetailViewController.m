//
//  MessageDetailViewController.m
//  anjuyi1
//
//  Created by apple on 2018/10/10.
//  Copyright © 2018年 lsy. All rights reserved.
//

#import "MessageDetailViewController.h"

@interface MessageDetailViewController ()<UIScrollViewDelegate>

@property (nonatomic,strong) UIScrollView *tmpScrollView;
@property (nonatomic,strong) NSDictionary *data;

@end

@implementation MessageDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self baseForDefaultLeftNavButton];
    [self setTitle:@"消息详情"];
    
    [self.view addSubview:self.tmpScrollView];
    [self.view addSubview:[Tools setLineView:CGRectMake(0, 0, KScreenWidth, 1)]];
    [self getMessageInfo];
}

- (void)getMessageInfo{
    
    
    NSString *path = [NSString stringWithFormat:@"%@/message/set_read",KURL];
    
    NSDictionary *header = @{@"token":UTOKEN};
    
    
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    __weak typeof(self) weakSelf = self;
    
    [HttpRequest POSTWithHeader:header url:path parameters:@{@"id":self.message_id} success:^(id  _Nullable responseObject) {
        
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        
        if ([responseObject[@"code"] integerValue] == 200) {
            
            weakSelf.data = responseObject[@"datas"];
            [weakSelf setUpScrollViewContent];
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

- (void)setUpScrollViewContent{
    
    NSString * str = self.data[@"title"];
    
    CGFloat h = [str boundingRectWithSize:CGSizeMake(KScreenWidth - 30, 1000) options:(NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading) attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:16]} context:nil].size.height;
    
    CGFloat w = [str boundingRectWithSize:CGSizeMake(1000000, 16) options:(NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading) attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:16]} context:nil].size.width+MDXFrom6(10);
    
    NSInteger num = h/(KScreenWidth - 30);
    
    CGFloat wid = w -  (KScreenWidth - 30)*num;
    
    UILabel * typeLabel = [Tools creatLabel:CGRectMake(MDXFrom6(15), MDXFrom6(15), MDXFrom6(40), MDXFrom6(20)) font:[UIFont systemFontOfSize:12] color:[UIColor whiteColor] alignment:(NSTextAlignmentCenter) title:@"风格"];
    NSArray *arr = @[@"",@"系统",@"评论",@"点赞",@"收藏"];
    [typeLabel setText:arr[[self.data[@"type"] integerValue]]];
    [typeLabel setBackgroundColor:GCOLOR];
    [typeLabel.layer setCornerRadius:2];
    [typeLabel setClipsToBounds:YES];
    [self.tmpScrollView addSubview:typeLabel];

    if (wid > (KScreenWidth - 30 - 60)) {
        [self.view addSubview:[Tools creatLabel:CGRectMake(15, 15, KScreenWidth - 30, h) font:[UIFont systemFontOfSize:16] color:[UIColor blackColor] alignment:(NSTextAlignmentLeft) title:self.data[@"title"]]];
        
         [typeLabel setFrame:CGRectMake(MDXFrom6(15), h , MDXFrom6(40),16)];
        
        h += 16+20;
    
    }
    else{
        
        [self.view addSubview:[Tools creatLabel:CGRectMake(15, 15, KScreenWidth - 30, h) font:[UIFont systemFontOfSize:16] color:[UIColor blackColor] alignment:(NSTextAlignmentLeft) title:self.data[@"title"]]];
        
        [typeLabel setFrame:CGRectMake(MDXFrom6(15)+wid,h-16+MDXFrom6(15), MDXFrom6(40),16)];
        
        h = h-16+MDXFrom6(15) +20;
    }
    
    [self.view addSubview:[Tools creatLabel:CGRectMake(15, h , KScreenWidth - 30, 20) font:[UIFont systemFontOfSize:12] color:[UIColor colorWithHexString:@"#999999"] alignment:(NSTextAlignmentLeft) title:self.data[@"pdate"]]];
    
    h += 20+10;
    
    [self.view addSubview:[Tools setLineView:CGRectMake(0, h, KScreenWidth, 1)]];
    h += 10;
    CGFloat detailh = [self.data[@"detail"] boundingRectWithSize:CGSizeMake(KScreenWidth - 30, 1000) options:(NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading) attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:16]} context:nil].size.height;
    
    [self.view addSubview:[Tools creatLabel:CGRectMake(15, h, KScreenWidth - 30, detailh) font:[UIFont systemFontOfSize:16] color:[UIColor blackColor] alignment:(NSTextAlignmentLeft) title:self.data[@"detail"]]];
    
    
    h+= detailh +10;
    
    [self.tmpScrollView setContentSize:CGSizeMake(KScreenWidth, h)];
}

@end
