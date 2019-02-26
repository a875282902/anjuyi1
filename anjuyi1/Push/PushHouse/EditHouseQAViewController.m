//
//  EditHouseQAViewController.m
//  anjuyi1
//
//  Created by apple on 2018/7/24.
//  Copyright © 2018年 lsy. All rights reserved.
//

#import "EditHouseQAViewController.h"

@interface EditHouseQAViewController ()<UITextViewDelegate>
{
    UILabel *_personPlace;
    NSString *_content;
    NSString *_title;
}

@property (nonatomic,strong)UILabel *numLabel;

@property (nonatomic,strong)NSMutableDictionary *data;

@end

@implementation EditHouseQAViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    _content = @"";
     [self setUpBackButton];
    if (self.name) {
       
        [self setUpUI];
    }
    else{

        [self getQAData];
    }
}


#pragma mark --  获取信息
- (void)getQAData{
    
    
    NSString *path = [NSString stringWithFormat:@"%@/WholeHouse/get_QA_info",KURL];
    
    NSDictionary *header = @{@"token":UTOKEN};
    NSDictionary *parameter = @{@"id":self.QADic[@"id"]};
    
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    __weak typeof(self) weakSelf = self;
    
    [HttpRequest POSTWithHeader:header url:path parameters:parameter success:^(id  _Nullable responseObject) {
        
        [MBProgressHUD hideHUDForView:weakSelf.view animated:YES];
        
        if ([responseObject[@"code"] integerValue] == 200) {
            
            if ([responseObject[@"datas"] isKindOfClass:[NSDictionary class]]) {
                weakSelf.data = [NSMutableDictionary dictionaryWithDictionary:responseObject[@"datas"]];
                
                [weakSelf setUpUI];
            }
            else{
               [ViewHelps showHUDWithText:responseObject[@"message"]];
            }
        }
        else{
            
            [ViewHelps showHUDWithText:responseObject[@"message"]];
        }
        
        
    } failure:^(NSError * _Nullable error) {
        
        [MBProgressHUD hideHUDForView:weakSelf.view animated:YES];
        [RequestSever showMsgWithError:error];
    }];
    
}
#pragma mark -- nav
- (void)setUpBackButton{
    
    UIButton *btn = [Tools creatButton:CGRectMake(0, 0 , 70, 44) font:[UIFont systemFontOfSize:15] color:[UIColor whiteColor] title:[NSString stringWithFormat:@"    %@",@"回答"] image:@"my_back"];
    [btn addTarget:self action:@selector(back) forControlEvents:(UIControlEventTouchUpInside)];
    
    UIBarButtonItem *bt = [[UIBarButtonItem alloc] initWithCustomView:btn];
    [self.navigationItem setLeftBarButtonItem:bt];
    
}

- (void)back{
    
  
    if ([_content length] != 0 ) {
        
        if (self.name) {
            [self creatQA];
        }
        else{
            
            if (![_content isEqual:self.data[@"text"]]) {
                [self editQA];
            }
            else{
                
                [self.navigationController popViewControllerAnimated:YES];
            }
            
        }
    }
    else{
        
        [self.navigationController popViewControllerAnimated:YES];
    }
}


#pragma mark --  UI
- (void)setUpUI{
    
    [self.view addSubview:[Tools creatLabel:CGRectMake(10, 0, KScreenWidth  -20, 50) font:[UIFont systemFontOfSize:16] color:TCOLOR alignment:(NSTextAlignmentLeft) title:self.name?self.name:self.data[@"title"]]];
    
    [self.view addSubview:[Tools setLineView:CGRectMake(0, 50, KScreenWidth, 3)]];
    
    UITextView *textView = [[UITextView alloc] initWithFrame:CGRectMake(10, 53, KScreenWidth - 20,210)];
    [textView setDelegate:self];
    [textView setFont:[UIFont systemFontOfSize:14]];
    [textView setTextColor:[UIColor blackColor]];
    [textView setTag:1001];
    [self.view addSubview:textView];
    
    _personPlace = [[UILabel alloc] initWithFrame:CGRectMake(5, 9 , KScreenWidth, 14)];
    [_personPlace setTextColor:[UIColor colorWithHexString:@"#999999"]];
    [_personPlace setText:@"写下您想说的吧~"];
    [_personPlace setFont:[UIFont systemFontOfSize:14]];
    [textView addSubview:_personPlace];
    
    self.numLabel = [Tools creatLabel:CGRectMake(10, 270, KScreenWidth - 20, 15) font:[UIFont systemFontOfSize:15] color:[UIColor colorWithHexString:@"#999999"] alignment:(NSTextAlignmentRight) title:@"0/300"];
    [self.view addSubview:self.numLabel];
 
    if (self.data) {
        if ([self.data[@"text"] isKindOfClass:[NSString class]]) {
            _content = self.data[@"text"];
            [_personPlace setHidden:YES];
            [textView setText:_content];
            [self.numLabel setText:[NSString stringWithFormat:@"%ld/300",(long)[_content length]]];
        }
    }
    
}


- (void)textViewDidChange:(UITextView *)textView{
    
    if (textView.tag == 1001) {
        if (textView.text.length == 0) {
            [_personPlace setHidden:NO];
        }
        else{
            [_personPlace setHidden:YES];
        }
    }
    
    if (textView.text.length>300) {
        
        [textView setText:[textView.text substringToIndex:300]];
    }
    [self.numLabel setText:[NSString stringWithFormat:@"%ld/300",(long)textView.text.length]];
    _content = textView.text;
}


- (void)creatQA{
    
    NSString *path = [NSString stringWithFormat:@"%@/WholeHouse/insert_QA",KURL];
    
    NSDictionary *header = @{@"token":UTOKEN};
    NSDictionary *paramet = @{@"house_id":self.house_id,@"title":self.name,@"text":_content};
    
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    __weak typeof(self) weakSelf = self;
    
    [HttpRequest POSTWithHeader:header url:path parameters:paramet success:^(id  _Nullable responseObject) {
        
        [MBProgressHUD hideHUDForView:weakSelf.view animated:YES];
        
        if ([responseObject[@"code"] integerValue] == 200) {
            
            [ViewHelps showHUDWithText:@"添加成功"];
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

- (void)editQA{
    
    NSString *path = [NSString stringWithFormat:@"%@/WholeHouse/update_QA",KURL];
    
    NSDictionary *header = @{@"token":UTOKEN};
    NSDictionary *paramet = @{@"id":self.QADic[@"id"],@"text":_content};
    
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    __weak typeof(self) weakSelf = self;
    
    [HttpRequest POSTWithHeader:header url:path parameters:paramet success:^(id  _Nullable responseObject) {
        
        [MBProgressHUD hideHUDForView:weakSelf.view animated:YES];
        
        if ([responseObject[@"code"] integerValue] == 200) {
            
            [ViewHelps showHUDWithText:@"修改成功"];
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
