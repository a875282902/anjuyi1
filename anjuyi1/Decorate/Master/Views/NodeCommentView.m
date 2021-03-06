//
//  HouseCommentView.m
//  anjuyi1
//
//  Created by apple on 2018/7/25.
//  Copyright © 2018年 lsy. All rights reserved.
//

#import "NodeCommentView.h"
#import "CommentModel.h"
#import "HouseCommentTableViewCell.h"
#import "PersonalViewController.h"

@interface NodeCommentView () <UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate>

@property (nonatomic,strong)UITableView      * tmpTableView;
@property (nonatomic,strong)NSMutableArray   * dataArr;
@property (nonatomic,strong)UILabel          * numLabel;
@property (nonatomic,strong)UIView           * backView;
@property (nonatomic,strong)UIView           * inputView;
@property (nonatomic,strong)UITextField      * inputTextFoeld;

@end

@implementation NodeCommentView

- (instancetype)initWithFrame:(CGRect)frame{
    
    if (self == [super initWithFrame:frame]) {
        [self setBackgroundColor:MDRGBA(0, 0, 0, 0.5)];
        [self setHidden:YES];
        self.backView = [[UIView alloc] initWithFrame:CGRectMake(0, KScreenHeight, KScreenWidth, self.frame.size.height- 140)];
        [self.backView setBackgroundColor:[UIColor whiteColor]];
        [self.backView setClipsToBounds:YES];
        [self.backView.layer setMasksToBounds:YES];
        [self addSubview:self.backView];
        
        
        UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:self.backView.bounds byRoundingCorners:UIRectCornerTopLeft | UIRectCornerTopRight cornerRadii:CGSizeMake(30, 30)];
        CAShapeLayer *maskLayer = [[CAShapeLayer alloc] init];
        maskLayer.frame = self.backView.bounds;
        maskLayer.path = maskPath.CGPath;
        self.backView.layer.mask = maskLayer;
        
        [self setUpHeaderView];
        [self.backView addSubview:self.tmpTableView];
        
        [self setUpInputView];
        
    }
    return self;
}

- (void)setUpHeaderView{
    
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, KScreenWidth, 55)];
    [headerView setBackgroundColor:[UIColor whiteColor]];
    [self.backView addSubview:headerView];
    
    
    self.numLabel = [Tools creatLabel:CGRectMake(0, 0, KScreenWidth, 55) font:[UIFont systemFontOfSize:16] color:TCOLOR alignment:(NSTextAlignmentCenter) title:@"0条评论"];
    [headerView addSubview:self.numLabel];
    
    
    UIButton *btn = [Tools creatButton:CGRectMake(KScreenWidth - 55,0,55, 55) font:[UIFont systemFontOfSize:16] color:[UIColor whiteColor] title:@"" image:@"yhq_close"];
    [btn addTarget:self action:@selector(closeDisplay) forControlEvents:(UIControlEventTouchUpInside)];
    [headerView addSubview:btn];
    
    [headerView addSubview:[Tools setLineView:CGRectMake(0, 54, KScreenWidth, 1)]];
    
}

- (void)setUpInputView{
    
    self.inputView = [[UIView alloc] initWithFrame:CGRectMake(0, self.frame.size.height - 140 - 65 - KPlaceHeight, KScreenWidth, 65)];
    [self.inputView setBackgroundColor:[UIColor whiteColor]];
    [self.backView addSubview:self.inputView];
    
    UITextField *inputText = [[UITextField alloc] initWithFrame:CGRectMake(15, 15, KScreenWidth - 30, 37)];
    [inputText setBorderStyle:(UITextBorderStyleRoundedRect)];
    [inputText setBackgroundColor:MDRGBA(242, 242, 242, 1)];
    [inputText setPlaceholder:@"留下你的意见，让房子更加美丽"];
    [inputText setFont:[UIFont systemFontOfSize:14]];
    [inputText setReturnKeyType:(UIReturnKeySend)];
    [inputText setDelegate:self];
    [self.inputView addSubview:inputText];
    
    self.inputTextFoeld = inputText;
    
}

- (void)setNodeid:(NSString *)nodeid{
    
    _nodeid = nodeid;
    
    [self getHouseCommentListData];
}

- (void)getHouseCommentListData{
    
    
    self.dataArr = [NSMutableArray array];
    
    NSString *path = [NSString stringWithFormat:@"%@/project_info/get_all_comment_list",KURL];
    
    NSDictionary *parameter = @{@"article_id":self.nodeid};
    
    [MBProgressHUD showHUDAddedTo:self animated:YES];
    
    __weak typeof(self) weakSelf = self;
    
    [HttpRequest POST:path parameters:parameter success:^(id  _Nullable responseObject) {
        
        [MBProgressHUD hideHUDForView:weakSelf animated:YES];
        
        if ([responseObject[@"code"] integerValue] == 200) {
            if ([responseObject[@"datas"] isKindOfClass:[NSArray class]]) {
                for (NSDictionary *dic in responseObject[@"datas"]) {
                    CommentModel *model = [[CommentModel alloc] initWithDictionary:dic];
                    [weakSelf.dataArr addObject:model];
                }
            }
            [weakSelf.numLabel setText:[NSString stringWithFormat:@"%ld条评论",(long)weakSelf.dataArr.count]];
        }
        else{
            
            [ViewHelps showHUDWithText:responseObject[@"message"]];
        }
        
        [weakSelf.tmpTableView reloadData];
        
    } failure:^(NSError * _Nullable error) {
        
        [MBProgressHUD hideHUDForView:weakSelf animated:YES];
        [RequestSever showMsgWithError:error];
    }];
    
}

#pragma mark -- tableView
- (UITableView *)tmpTableView{
    
    if (!_tmpTableView) {
        _tmpTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 55, KScreenWidth, self.frame.size.height - 195 - 65 - KPlaceHeight) style:(UITableViewStylePlain)];
        [_tmpTableView setEstimatedRowHeight:UITableViewAutomaticDimension];
        [_tmpTableView setBackgroundColor:[UIColor whiteColor]];
        [_tmpTableView setSeparatorStyle:(UITableViewCellSeparatorStyleNone)];
        if (@available(iOS 11.0, *)) {
            [_tmpTableView setContentInsetAdjustmentBehavior:(UIScrollViewContentInsetAdjustmentNever)];
        }
        [_tmpTableView setRowHeight:UITableViewAutomaticDimension];
        [_tmpTableView setEstimatedRowHeight:100.0f];
        [_tmpTableView setShowsVerticalScrollIndicator:NO];
        [_tmpTableView setShowsHorizontalScrollIndicator:NO];
        [_tmpTableView setDataSource:self];
        [_tmpTableView setDelegate:self];
    }
    return _tmpTableView;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataArr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    HouseCommentTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"HouseCommentTableViewCell"];
    if (!cell) {
        cell = [[HouseCommentTableViewCell alloc] initWithStyle:(UITableViewCellStyleDefault) reuseIdentifier:@"HouseCommentTableViewCell"];
    }
    
    if (indexPath.row < self.dataArr.count) {
        CommentModel *model = self.dataArr[indexPath.row];
        [cell bandDataWith: model];
        [cell setShowPresonDetail:^{
            PersonalViewController *vc = [[PersonalViewController alloc] init];
            vc.user_id = model.member_info[@"user_id"];
            self.showReviewerDetail(vc);
        }];
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    CommentModel *model =self.dataArr[indexPath.row];
    
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示" message:@"评论操作" preferredStyle:(UIAlertControllerStyleActionSheet)];
    
    [alert addAction:[UIAlertAction actionWithTitle:@"回复" style:(UIAlertActionStyleDefault) handler:^(UIAlertAction * _Nonnull action) {
        
        self.commit_id = model.commit_id;
        [self addComment];
    }]];
    
    [alert addAction:[UIAlertAction actionWithTitle:@"详情" style:(UIAlertActionStyleDefault) handler:^(UIAlertAction * _Nonnull action) {
        [self closeDisplay];
        self.showCommentDetali(model.commit_id);
    }]];
    
    [alert addAction:[UIAlertAction actionWithTitle:@"取消" style:(UIAlertActionStyleCancel) handler:nil]];
    
    [[Tools getCurrentVC] presentViewController:alert animated:YES completion:nil];
}

#pragma mark -- 事件

- (void)closeDisplay{
    [self endEditing:YES];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillHideNotification object:nil];
    
    [UIView animateWithDuration:.2 animations:^{
        
        [self.backView setFrame:CGRectMake(0, KScreenHeight, KScreenWidth, self.frame.size.height- 140)];
        
    } completion:^(BOOL finished) {
        
        if (finished) {
            [self setHidden:YES];
        }
        
    }];
}

- (void)openDisplay{
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWasShown:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillBeHidden:) name:UIKeyboardWillHideNotification object:nil];
    
    [self setHidden:NO];
    
    [UIView animateWithDuration:.2 animations:^{
        
        [self.backView setFrame:CGRectMake(0, 140, KScreenWidth, self.frame.size.height- 140)];
    }];
}

- (void)addComment{
    
    [self openDisplay];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(.2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self.inputTextFoeld becomeFirstResponder];
    });
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    [self sendComment:textField.text];
    [textField setText:@""];
    [textField resignFirstResponder];
    return YES;
}

- (void)sendComment:(NSString *)text{
    LOGIN
    NSString *path = [NSString stringWithFormat:@"%@/Project/add_evaluate",KURL];
    
    NSDictionary *header = @{@"token":UTOKEN};
    NSDictionary *parameter = @{@"article_id":self.nodeid,@"content":text,@"commit_id":self.commit_id};
    
    [MBProgressHUD showHUDAddedTo:self animated:YES];
    
    __weak typeof(self) weakSelf = self;
    
    [HttpRequest POSTWithHeader:header url:path parameters:parameter success:^(id  _Nullable responseObject) {
        
        [MBProgressHUD hideHUDForView:weakSelf animated:YES];
        
        if ([responseObject[@"code"] integerValue] == 200) {
            
            [ViewHelps showHUDWithText:@"发送成功"];
            [self getHouseCommentListData];
        }
        else{
            
            [ViewHelps showHUDWithText:responseObject[@"message"]];
        }
        
        
    } failure:^(NSError * _Nullable error) {
        
        [MBProgressHUD hideHUDForView:weakSelf animated:YES];
        [RequestSever showMsgWithError:error];
    }];
    
    
}

- (void)keyboardWasShown:(NSNotification *)aNotification{
    
    //键盘高度
    CGRect keyBoardFrame = [[[aNotification userInfo] objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue];
    
    [UIView animateWithDuration:.2 animations:^{
        [self.inputView setFrame:CGRectMake(0,self.backView.frame.size.height- keyBoardFrame.size.height - 65 , KScreenWidth, 65)];
    }];
}
-(void)keyboardWillBeHidden:(NSNotification*)aNotification{
    
    [UIView animateWithDuration:.2 animations:^{
        [self.inputView setFrame:CGRectMake(0,self.backView.frame.size.height - 65-KPlaceHeight , KScreenWidth, 65)];
    }];
    
}

@end
