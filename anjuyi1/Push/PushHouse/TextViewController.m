//
//  TextViewController.m
//  anjuyi1
//
//  Created by apple on 2018/7/18.
//  Copyright © 2018年 lsy. All rights reserved.
//

#import "TextViewController.h"

@interface TextViewController ()<UITextViewDelegate>
{
    UILabel *_placeholdLabel;
    NSString *content;
}

@end

@implementation TextViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self setNavigationLeftBarButtonWithImageNamed:@"my_back"];
    
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor whiteColor],NSFontAttributeName:[UIFont boldSystemFontOfSize:19.0f]}];
    [self setTitle:self.type == 0?@"标题":@"说在前面"];
    
    content = self.text;
    
    [self setUpUI];
}

- (void)setUpUI{
    
    UITextView *textView = [[UITextView alloc] initWithFrame:CGRectMake(15, 20, KScreenWidth - 30,200)];
    [textView setDelegate:self];
    [textView setFont:[UIFont systemFontOfSize:16]];
    [textView setTextColor:[UIColor blackColor]];
    [self.view addSubview:textView];
    
    _placeholdLabel = [[UILabel alloc] initWithFrame:CGRectMake(5, 9 , KScreenWidth, 16)];
    [_placeholdLabel setTextColor:[UIColor colorWithHexString:@"#666666"]];
    [_placeholdLabel setText:self.placeHolder];
    [_placeholdLabel setFont:[UIFont systemFontOfSize:16]];
    [textView addSubview:_placeholdLabel];
    
}

- (void)textViewDidChange:(UITextView *)textView{
    
    if (textView.text.length == 0) {
        [_placeholdLabel setHidden:NO];
    }
    else{
        [_placeholdLabel setHidden:YES];
    }
    
    if (textView.text.length>30) {
        
        [textView setText:[textView.text substringToIndex:30]];
    }
    content = textView.text;
}

-(void)leftButtonTouchUpInside:(id)sender{
    
    [self.delegate textViewInputText:content type:self.type];
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
