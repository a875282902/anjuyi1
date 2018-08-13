//
//  AddTopicCommentViewController.m
//  anjuyi1
//
//  Created by apple on 2018/8/12.
//  Copyright © 2018年 lsy. All rights reserved.
//

#import "AddTopicCommentViewController.h"

@interface AddTopicCommentViewController ()<UITextViewDelegate>
{
    UILabel *_placeholdLabel;
    NSString *_content;
}

@end

@implementation AddTopicCommentViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    UIView *navView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, KScreenWidth, KTopHeight)];
    [navView setBackgroundColor:GCOLOR];
    [self.view addSubview:navView];
    
    UIButton *btn = [Tools creatButton:CGRectMake(10, KStatusBarHeight , 100, 44) font:[UIFont systemFontOfSize:16] color:[UIColor whiteColor] title:@"  添加回答" image:@"my_back"];
    [btn addTarget:self action:@selector(back) forControlEvents:(UIControlEventTouchUpInside)];
    [navView addSubview:btn];
    
    [self setUpInputView];
    
}
- (void)setUpInputView{
    
    UITextView *textView = [[UITextView alloc] initWithFrame:CGRectMake(15, KTopHeight +20, KScreenWidth - 15,130)];
    [textView setDelegate:self];
    [textView setFont:[UIFont systemFontOfSize:14]];
    [textView setTextColor:[UIColor blackColor]];
    [self.view addSubview:textView];
    
    _placeholdLabel = [[UILabel alloc] initWithFrame:CGRectMake(5, 8 , KScreenWidth, 14)];
    [_placeholdLabel setTextColor:[UIColor colorWithHexString:@"#999999"]];
    [_placeholdLabel setText:@"想说的话"];
    [_placeholdLabel setFont:[UIFont systemFontOfSize:14]];
    [textView addSubview:_placeholdLabel];
    
    [self.view addSubview:[Tools setLineView:CGRectMake(15, KTopHeight +170, KScreenWidth - 30, 1)]];
    
    UIButton *btn = [Tools creatButton:CGRectMake(15,  KTopHeight +190, KScreenWidth - 30, 45) font:[UIFont systemFontOfSize:16] color:[UIColor whiteColor] title:@"提交" image:@""];
    [btn setBackgroundColor:MDRGBA(255, 181, 0, 1)];
    [btn.layer setCornerRadius:5];
    [btn setClipsToBounds:YES];
    [btn addTarget:self action:@selector(push) forControlEvents:(UIControlEventTouchUpInside)];
    [self.view addSubview:btn];
    
}
- (void)textViewDidChange:(UITextView *)textView{
    
    if (textView.text.length == 0) {
        [_placeholdLabel setHidden:NO];
    }
    else{
        [_placeholdLabel setHidden:YES];
    }

    _content = textView.text;
    
}
- (void)back{
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)push{
    if (_content.length == 0) {
        [ViewHelps showHUDWithText:@"请输入想说的话"];
        return;
    }
    
    NSString *path = [NSString stringWithFormat:@"%@/topic/add_topic_answer",KURL];
    
    NSDictionary *header = @{@"token":UTOKEN};
    NSDictionary *dic = @{@"topic_id":self.topic_id,@"content":_content};
    
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    __weak typeof(self) weakSelf = self;
    
    [HttpRequest POSTWithHeader:header url:path parameters:dic success:^(id  _Nullable responseObject) {
        
        [MBProgressHUD hideHUDForView:weakSelf.view animated:YES];
        
        if ([responseObject[@"code"] integerValue] == 200) {
            [ViewHelps showHUDWithText:@"提交成功"];
            [weakSelf.navigationController popViewControllerAnimated:YES];
            
        }
        else{
            
            [ViewHelps showHUDWithText:responseObject[@"message"]];
        }
        
        
    } failure:^(NSError * _Nullable error) {
        
        [MBProgressHUD hideHUDForView:weakSelf.view animated:YES];
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
