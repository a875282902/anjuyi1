//
//  AddTopicViewController.m
//  anjuyi1
//
//  Created by apple on 2018/8/12.
//  Copyright © 2018年 lsy. All rights reserved.
//

#import "AddTopicViewController.h"
#import "SelectCity.h"

@interface AddTopicViewController ()<UITextViewDelegate,SelectCityDelegate>
{
    NSString *_titie;
    NSString *_content;
    NSString *_tag_id;
    
    UILabel *_titleNum;
    UILabel *_contentNum;
    
    UILabel *_tagLabel;
    
    UILabel *_placeholdLabel;
}

@property (nonatomic,strong) SelectCity *selectCity;

@end

@implementation AddTopicViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self baseForDefaultLeftNavButton];
    [self setTitle:@"发布话题"];
    
    [self setNavigationRightBarButtonWithTitle:@"发布" color:GCOLOR];

    
    [self setUpUI];
    
    [self.view addSubview:[Tools setLineView:CGRectMake(0, 0, KScreenWidth, 1)]];
    
    [self.view addSubview:self.selectCity];
    
}

- (void)setUpUI{
    
    UITextField *textFiled = [[UITextField alloc] initWithFrame:CGRectMake(15, 20, KScreenWidth - 75, 40)];
    [textFiled addTarget:self action:@selector(textFieldValueChange:) forControlEvents:(UIControlEventEditingChanged)];
    [textFiled setPlaceholder:@"你遇到的问题"];
    [textFiled setValue:GRAYCOLOR forKeyPath:@"_placeholderLabel.textColor"];
    [textFiled setFont:[UIFont systemFontOfSize:14]];
    [self.view addSubview:textFiled];
    
    [self.view addSubview:[Tools setLineView:CGRectMake(15, 60, KScreenWidth - 30, 1)]];
    
    _titleNum = [Tools creatLabel:CGRectMake(KScreenWidth - 60, 20, 45, 40) font:[UIFont systemFontOfSize:12] color:GRAYCOLOR alignment:(NSTextAlignmentCenter) title:@"0/15"];
    [self.view addSubview:_titleNum];
    
    [self setUpInputView];
    
    [self setUpLabelView];
    
}
- (void)setUpInputView{
    
    UITextView *textView = [[UITextView alloc] initWithFrame:CGRectMake(15, 80, KScreenWidth - 15,130)];
    [textView setDelegate:self];
    [textView setFont:[UIFont systemFontOfSize:14]];
    [textView setTextColor:[UIColor blackColor]];
    [self.view addSubview:textView];
    
    _placeholdLabel = [[UILabel alloc] initWithFrame:CGRectMake(5, 8 , KScreenWidth, 14)];
    [_placeholdLabel setTextColor:[UIColor colorWithHexString:@"#999999"]];
    [_placeholdLabel setText:@"问题的详细描述"];
    [_placeholdLabel setFont:[UIFont systemFontOfSize:14]];
    [textView addSubview:_placeholdLabel];
    
    _contentNum = [Tools creatLabel:CGRectMake(KScreenWidth - 70, 210, 55, 40) font:[UIFont systemFontOfSize:12] color:GRAYCOLOR alignment:(NSTextAlignmentCenter) title:@"0/100"];
    [self.view addSubview:_contentNum];
    
    [self.view addSubview:[Tools setLineView:CGRectMake(15, 250, KScreenWidth - 30, 1)]];
}

- (void)setUpLabelView{
    
    UIView *backView = [[UIView alloc] initWithFrame:CGRectMake(0, 250, KScreenWidth , 45)];
    [self.view addSubview:backView];
    
    [backView addSubview:[Tools creatLabel:CGRectMake(15, 0, 200, 45) font:[UIFont systemFontOfSize:14] color:TCOLOR alignment:(NSTextAlignmentLeft) title:@"选择分类"]];
    
    [backView addSubview:[Tools creatImage:CGRectMake(KScreenWidth - 30, 15.5, 7, 14) image:@"sy_arrow"]];
    
    
    
    _tagLabel = [Tools creatLabel:CGRectMake(15, 0, KScreenWidth - 55, 45) font:[UIFont systemFontOfSize:14] color:TCOLOR alignment:(NSTextAlignmentRight) title:@""];
    [backView addSubview:_tagLabel];
    
    [backView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(selectTagLabel)]];
    
    [backView addSubview:[Tools setLineView:CGRectMake(15, 44, KScreenWidth - 30, 1)]];
}


- (SelectCity *)selectCity{
    
    if (!_selectCity) {
        
        _selectCity = [[SelectCity alloc] initWithFrame:CGRectMake(0, 0 , KScreenWidth, KViewHeight)];
        [_selectCity setDataArr:self.cateArr];
        [_selectCity setDelegate:self];
    }
    return _selectCity;
}
- (void)textFieldValueChange:(UITextField *)sender{
    if (sender.text.length>15) {
        
        [sender setText:[sender.text substringToIndex:15]];
    }
    [_titleNum setText:[NSString stringWithFormat:@"%ld/15",sender.text.length]];
    _titie = sender.text;
}

- (void)textViewDidChange:(UITextView *)textView{
    
    if (textView.text.length == 0) {
        [_placeholdLabel setHidden:NO];
    }
    else{
        [_placeholdLabel setHidden:YES];
    }
    if (textView.text.length>100) {
        
        [textView setText:[textView.text substringToIndex:100]];
    }
    [_contentNum setText:[NSString stringWithFormat:@"%ld/100",textView.text.length]];
    _content = textView.text;
    
}

- (void)selectTagLabel{
    [self.view endEditing:YES];
    [self.selectCity show];
}

- (void)selectCityWithInfo:(NSDictionary *)info view:(SelectCity *)selectCity{
    
    [_tagLabel setText:info[@"name"]];
    
    _tag_id =[NSString stringWithFormat:@"%@", info[@"id"]];
}

- (void)rightButtonTouchUpInside:(id)sender{
    
    if (_titie.length == 0) {
        [ViewHelps showHUDWithText:@"请输入问题"];
    }
    
    if (_content.length == 0) {
        [ViewHelps showHUDWithText:@"请输入问题的详细描述"];
    }
    if ( _tag_id.length == 0) {
        [ViewHelps showHUDWithText:@"请选择问题的分类"];
    }
    
    
    NSString *path = [NSString stringWithFormat:@"%@/topic/add_topic",KURL];
    
    NSDictionary *header = @{@"token":UTOKEN};
    NSDictionary *dic = @{@"title":_titie,@"content":_content,@"tag_id":_tag_id};
    
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    __weak typeof(self) weakSelf = self;
    
    [HttpRequest POSTWithHeader:header url:path parameters:dic success:^(id  _Nullable responseObject) {
        
        [MBProgressHUD hideHUDForView:weakSelf.view animated:YES];
        
        if ([responseObject[@"code"] integerValue] == 200) {
            
            [ViewHelps showHUDWithText:@"发布成功"];
            
            [weakSelf.navigationController popViewControllerAnimated:YES];
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
