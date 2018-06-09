//
//  PersonalProfileVC.m
//  anjuyi1
//
//  Created by 李 on 2018/6/8.
//  Copyright © 2018年 lsy. All rights reserved.
//

#import "PersonalProfileVC.h"

@interface PersonalProfileVC ()<UITextViewDelegate>
{
    UILabel *_placeholdLabel;
    UILabel *_numLabel;
}

@end

@implementation PersonalProfileVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self setTitle:@"个人简介"];
    [self setNavigationLeftBarButtonWithTitle:@"取消" color:[UIColor blackColor]];
    [self setNavigationRightBarButtonWithTitle:@"完成" color:[UIColor colorWithHexString:@"#47BABA"]];
    
    [self.view addSubview:[Tools setLineView:CGRectMake(0, 0, KScreenWidth , 1.5)]];
    
   
    
    UITextView *textView = [[UITextView alloc] initWithFrame:CGRectMake(15, 20, KScreenWidth - 15,200)];
    [textView setDelegate:self];
    [textView setFont:[UIFont systemFontOfSize:16]];
    [textView setTextColor:[UIColor blackColor]];
    [self.view addSubview:textView];
    
    _placeholdLabel = [[UILabel alloc] initWithFrame:CGRectMake(5, 9 , KScreenWidth, 16)];
    [_placeholdLabel setTextColor:[UIColor colorWithHexString:@"#666666"]];
    [_placeholdLabel setText:@"请输入您的个人简介"];
    [_placeholdLabel setFont:[UIFont systemFontOfSize:16]];
    [textView addSubview:_placeholdLabel];
    
    [self.view addSubview:[Tools setLineView:CGRectMake(15, 300, KScreenWidth - 30, 1)]];
 
    _numLabel = [Tools creatLabel:CGRectMake(15, 310, KScreenWidth - 30, 20) font:[UIFont systemFontOfSize:12] color:[UIColor colorWithHexString:@"#999999"] alignment:(NSTextAlignmentRight) title:@"0/45"];
    [self.view addSubview:_numLabel];
    
}

- (void)textViewDidChange:(UITextView *)textView{
    
    if (textView.text.length == 0) {
        [_placeholdLabel setHidden:NO];
    }
    else{
        [_placeholdLabel setHidden:YES];
    }
    
    if (textView.text.length>45) {
        
        [textView setText:[textView.text substringToIndex:45]];
    }
    
    [_numLabel setText:[NSString stringWithFormat:@"%ld/45",textView.text.length]];
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
