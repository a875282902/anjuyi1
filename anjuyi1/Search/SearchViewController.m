//
//  LabelViewController.m
//  anjuyi1
//
//  Created by apple on 2018/7/13.
//  Copyright © 2018年 lsy. All rights reserved.
//

#import "SearchViewController.h"
#import <IQKeyboardManager.h>
#import "SearchResultsViewController.h"
#import "SearchPromptTableViewController.h"
#import "RecognizerView.h"
#import "RecognizerShowView.h"

@interface SearchViewController ()<UIScrollViewDelegate,UITextFieldDelegate,RecognizerViewDelegate>
{
    UITextField * _textField;
}

@property (nonatomic,strong)NSMutableArray                    * dataArr;
@property (nonatomic,strong)UIScrollView                      * tmpScrollView;
@property (nonatomic,strong)SearchPromptTableViewController   * promptController;

/*--------- 语音识别 ---------*/
@property (nonatomic,strong)RecognizerShowView    *recognizerShowView;
@property (nonatomic,strong)RecognizerView                            * speechView;

@end

@implementation SearchViewController

- (void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:animated];
    
    [IQKeyboardManager sharedManager].enableAutoToolbar = NO;
}

- (void)viewWillDisappear:(BOOL)animated{
    
    [super viewWillDisappear:animated];
    [IQKeyboardManager sharedManager].enableAutoToolbar = YES;
}

-  (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer{
    return NO;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self baseForDefaultLeftNavButton];
    [self setNavSearch];
    
    self.dataArr = [NSMutableArray array];
    
    [self.view addSubview:[Tools setLineView:CGRectMake(0, 0, KScreenWidth, 1)]];
    
    [self getData];
    
    self.promptController = [[SearchPromptTableViewController alloc] init];
    [self addChildViewController:self.promptController];
    
    /* ----  语音识别  ----- */
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
}
//获取数据
- (void)getData{
    
    
    NSString *path = [NSString stringWithFormat:@"%@/search/get_us_search",KURL];
    
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    __weak typeof(self) weakSelf = self;
    
    [HttpRequest POST:path parameters:nil success:^(id  _Nullable responseObject) {
        
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        
        [weakSelf.dataArr removeAllObjects];
        
        if ([responseObject[@"code"] integerValue] == 200) {
            if ([responseObject[@"datas"] isKindOfClass:[NSArray class]]) {
                for (NSDictionary *dic in responseObject[@"datas"]) {
                    [weakSelf.dataArr addObject:dic];
                }
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
    _textField = [[UITextField alloc] initWithFrame:CGRectMake(0, 0, KScreenWidth, 30)];
    [_textField setBorderStyle:(UITextBorderStyleRoundedRect)];
    [_textField setFont:[UIFont systemFontOfSize:15]];
    [_textField setDelegate:self];
    [_textField setReturnKeyType:(UIReturnKeySearch)];
    [_textField setPlaceholder:@"请输入搜索内容"];
    [_textField addTarget:self action:@selector(textValueChange:) forControlEvents:(UIControlEventEditingChanged)];
    [self.navigationItem setTitleView:_textField];
}

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField{
    [self.promptController.view setFrame:CGRectMake(0, 0, KScreenWidth, KViewHeight)];
    [self.view addSubview:self.promptController.view];
    [self.promptController.view setHidden:YES];
    return YES;
}

- (void)textValueChange:(UITextField *)sender{

    if (sender.text.length == 0) {
        [self.promptController.view setHidden:YES];
    }
    else{
        [self.promptController.view setHidden:NO];
        [self.promptController setKeyWord:sender.text];
    }
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];
    
    NSMutableArray *searchArr = [NSMutableArray arrayWithArray:[[NSUserDefaults standardUserDefaults] valueForKey:SEARCHARR]];
    BOOL isbool = [searchArr containsObject: textField.text];
    if (!isbool) {
        [searchArr addObject:textField.text];
        [[NSUserDefaults standardUserDefaults] setValue:searchArr forKey:SEARCHARR];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
    return YES;
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
        
        NSString *str = [NSString stringWithFormat:@"%@",self.dataArr[i][@"name"]];
        
        NSMutableParagraphStyle *style = [[NSParagraphStyle defaultParagraphStyle] mutableCopy];
        style.lineBreakMode = NSLineBreakByWordWrapping;
        style.alignment = NSTextAlignmentLeft;
        
        NSAttributedString *atts = [[NSAttributedString alloc] initWithString:str attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:14],NSParagraphStyleAttributeName:style}];
        
        CGRect rext = [atts boundingRectWithSize:CGSizeMake(10000, 30) options:(NSStringDrawingUsesFontLeading|NSStringDrawingUsesLineFragmentOrigin) context:nil];
        
        w = rext.size.width + 15.0f;
        if (w < 40) {
            w = 40.0f;
        }
        
        if (w+x > KScreenWidth-15) {
            y += 40.f;
            x = 15.0f;
        }
        
        UIButton *btn = [Tools creatButton:CGRectMake(x, y, w, h) font:[UIFont systemFontOfSize:14] color:[UIColor colorWithHexString:@"#2cb7b5"] title:str image:@""];
        [btn setBackgroundColor:[UIColor colorWithHexString:@"#eaf8f8"]];
        [btn.layer setBorderWidth:1];
        [btn.layer setBorderColor:[UIColor colorWithHexString:@"#34bab8"].CGColor];
        [btn.layer setCornerRadius:5];
        [btn setClipsToBounds:YES];
        [btn setTag:i];
        [btn addTarget:self action:@selector(hotSearch:) forControlEvents:(UIControlEventTouchUpInside)];
        [self.tmpScrollView addSubview:btn];
        
        x += w+ 10.0f;
        
    }
    
    y += 70.0f;
    
    [self.tmpScrollView addSubview:[Tools creatLabel:CGRectMake(15, y, 200, 30) font:[UIFont systemFontOfSize:14] color:[UIColor blackColor] alignment:(NSTextAlignmentLeft) title:@"搜索历史"]];
    
    UIButton *btn = [Tools creatButton:CGRectMake(KScreenWidth - 75 , y, 60, 30) font:[UIFont systemFontOfSize:14] color:[UIColor colorWithHexString:@"#999999"] title:@"清除全部" image:@""];
    [btn addTarget:self action:@selector(clearAll) forControlEvents:(UIControlEventTouchUpInside)];
    [self.tmpScrollView addSubview:btn];
    
    [self setUpHistoryView:y+70.0f];
    
}

- (void)setUpHistoryView:(CGFloat)y{
    
    NSArray *searchArr = [[NSUserDefaults standardUserDefaults] valueForKey:SEARCHARR];
    
    CGFloat x = 15.0f;
    CGFloat w = 0;
    CGFloat h = 30.0f;
    
    for (NSInteger i = 0 ; i < searchArr.count ; i ++) {
        
        NSString *str = [NSString stringWithFormat:@"%@",searchArr[i]];
        
        NSMutableParagraphStyle *style = [[NSParagraphStyle defaultParagraphStyle] mutableCopy];
        style.lineBreakMode = NSLineBreakByWordWrapping;
        style.alignment = NSTextAlignmentLeft;
        
        NSAttributedString *atts = [[NSAttributedString alloc] initWithString:str attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:14],NSParagraphStyleAttributeName:style}];
        
        CGRect rext = [atts boundingRectWithSize:CGSizeMake(10000, 30) options:(NSStringDrawingUsesFontLeading|NSStringDrawingUsesLineFragmentOrigin) context:nil];
        
        w = rext.size.width + 15.0f;
        if (w < 40) {
            w = 40.0f;
        }
        
        if (w+x > KScreenWidth-15) {
            y += 40.f;
            x = 15.0f;
        }
        
        UIButton *btn = [Tools creatButton:CGRectMake(x, y, w, h) font:[UIFont systemFontOfSize:14] color:[UIColor colorWithHexString:@"#2cb7b5"] title:str image:@""];
        [btn setBackgroundColor:[UIColor colorWithHexString:@"#eaf8f8"]];
        [btn.layer setBorderWidth:1];
        [btn.layer setBorderColor:[UIColor colorWithHexString:@"#34bab8"].CGColor];
        [btn.layer setCornerRadius:5];
        [btn setClipsToBounds:YES];
        [btn setTag:i];
        [btn addTarget:self action:@selector(histotySearch:) forControlEvents:(UIControlEventTouchUpInside)];
        [self.tmpScrollView addSubview:btn];
        
        x += w+ 10.0f;
        
    }
    
    [self.tmpScrollView setContentSize:CGSizeMake(KScreenWidth, y+60.0f)];
}

- (void)hotSearch:(UIButton *)sender{
    
    [self.view endEditing:YES];
    
    NSMutableArray *searchArr = [NSMutableArray arrayWithArray:[[NSUserDefaults standardUserDefaults] valueForKey:SEARCHARR]];
    
    BOOL isbool = [searchArr containsObject: self.dataArr[sender.tag][@"name"]];
    if (!isbool) {
        [searchArr addObject:self.dataArr[sender.tag][@"name"]];
        [[NSUserDefaults standardUserDefaults] setValue:searchArr forKey:SEARCHARR];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
    
    SearchResultsViewController *vc = [[SearchResultsViewController alloc] init];
    vc.keyword = self.dataArr[sender.tag][@"name"];
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)histotySearch:(UIButton *)sender{
    
    NSMutableArray *searchArr = [NSMutableArray arrayWithArray:[[NSUserDefaults standardUserDefaults] valueForKey:SEARCHARR]];
    
    SearchResultsViewController *vc = [[SearchResultsViewController alloc] init];
    vc.keyword = searchArr[sender.tag];
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)clearAll{
    
    [self.tmpScrollView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:SEARCHARR];
    
    [self setUpUI];
}

#pragma mark -- 语音识别

- (RecognizerView *)speechView{
    
    if (!_speechView) {
        _speechView = [[RecognizerView alloc] initWithFrame:CGRectMake(0, KScreenHeight, KScreenWidth, 60)];
        [_speechView setDelegate:self];
        [_speechView setBackgroundColor:[UIColor whiteColor]];
        [self.view addSubview:_speechView];
    }
    return _speechView;
}

- (RecognizerShowView *)recognizerShowView{
    
    if (!_recognizerShowView) {
        _recognizerShowView = [[RecognizerShowView alloc] init];
        [_recognizerShowView setBackgroundColor:[UIColor whiteColor]];
        [_recognizerShowView setHidden:YES];
        [self.view addSubview:_recognizerShowView];
    }
    return _recognizerShowView;
}
/**
 语音识别转换
 *
 *  @param isSuccess  是否成功
 *  @param result  转换结果
 */
- (void)speechRecognitionWithSuccess:(BOOL)isSuccess withString:(NSString *)result{
    if (isSuccess) {
        [_textField setText:result];
        [self textValueChange:_textField];
    }
    else{
        dispatch_async(dispatch_get_main_queue(), ^{
            // UI更新代码
            [ViewHelps showHUDWithText:result];
        });
        
    }
}
/**
 获取语音页面
 *
 *  @param isShow  是否显示
 */
- (void)speechRecognitionIsShow:(BOOL)isShow{
    
    if (isShow) {
        [self.recognizerShowView setHidden:NO];
        [self.recognizerShowView start];
    }
    else{
        [self.recognizerShowView setHidden:YES];
        [self.recognizerShowView stop];
    }
}

- (void)keyboardWillShow:(NSNotification *)aNotification{
    //获取键盘的高度
    NSDictionary *userInfo = [aNotification userInfo];
    NSValue *aValue = [userInfo objectForKey:UIKeyboardFrameEndUserInfoKey];
    CGRect keyboardRect = [aValue CGRectValue];
    [self.speechView setHidden:NO];
    [self.speechView setFrame:CGRectMake(0, keyboardRect.origin.y-60-KTopHeight, KScreenWidth, 60)];
    [self.recognizerShowView setFrame:CGRectMake(0, 0, KScreenWidth, KScreenHeight - KTopHeight -keyboardRect.size.height - 60 )];
}

// 键盘消失不用做什么
- (void)keyboardWillHide:(NSNotification *)aNotification{
    [self.speechView setHidden:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
