//
//  PushProjectViewController.m
//  anjuyi1
//
//  Created by 李 on 2018/7/3.
//  Copyright © 2018年 lsy. All rights reserved.
//
//  发布项目

#import "PushProjectViewController.h"
#import "AddProjectViewController.h"
#import "PushProjectNodeViewController.h"

#import "PullDownView.h"
#import "YZMenuButton.h"
#import "DefaultPullDown.h"

#import "ProjectView.h"

@interface PushProjectViewController ()<DefaultPullDownDelegate,UIScrollViewDelegate>
{
    YZMenuButton * _moreProject;
    NSDictionary * _currentProjectInfo;//项目信息
    NSString     * _projiectNode;//节点信息
    BOOL _isRefre; //判断项目需要刷新不
    BOOL _isFirst; //判断第一次进入该页面
}


@property (nonatomic,strong)UIScrollView     * tmpScrollView;
@property (nonatomic,strong)NSMutableArray   * projectViewArr;

@property (nonatomic,strong)PullDownView     * pullDownView;//下拉view
@property (nonatomic,strong)NSMutableArray   * projectArr;//项目的数组
@property (nonatomic,strong)NSMutableArray   * stautsArr;//状态view的数组
@property (nonatomic,strong)UIButton         * finishButton;//完成按钮（仅在竣工下面出现）

@end

@implementation PushProjectViewController

- (void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:animated];
    
    
    if (_isRefre) {
        [self getProjectData];
    }
    else{
        
        if (_projiectNode) {
            [self getProjectNodeData:_projiectNode];
        }
    }
    
    _isRefre = NO;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setNavigationLeftBarButtonWithImageNamed:@"ss_back"];
    
    [self setNavigationRightBarButtonWithImageNamed:@"add_xm_icon"];
    
    [self setTitle:@"发布项目"];
    
    self.projectArr = [NSMutableArray array];
    self.stautsArr = [NSMutableArray array];
    self.projectViewArr = [NSMutableArray array];
    
    _isFirst = YES;
    
    [self setUpProjectView];
    [self setUpProgressView];
    
    [self.view addSubview:self.tmpScrollView];
    
    [self setContentView];
    
    [self.view addSubview:[Tools setLineView:CGRectMake(0, 0, KScreenWidth, 1)]];
    
    [self createPushButton];
    
    [self getProjectData];
}

#pragma mark -- UI
- (void)setUpProjectView{
    
    [self.view addSubview:[Tools creatLabel:CGRectMake(0, 0, KScreenWidth/3, 90) font:[UIFont systemFontOfSize:14] color:[UIColor colorWithHexString:@"#3b3b3b"] alignment:(NSTextAlignmentRight) title:@"项目选择："]];
    
    YZMenuButton *button = [YZMenuButton buttonWithType:UIButtonTypeCustom];
    [button.titleLabel setFont:[UIFont systemFontOfSize:15]];
    [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [button setTitleColor:[UIColor colorWithRed:25 /255.0 green:143/255.0 blue:238/255.0 alpha:1] forState:UIControlStateSelected];
    [button setImage:[UIImage imageNamed:@"标签-向下箭头"] forState:UIControlStateNormal];
    [button setImage:[UIImage imageNamed:@"标签-向上箭头"] forState:UIControlStateSelected];
    [button.layer setBorderWidth:1];
    [button.layer setCornerRadius:5];
    [button.layer setBorderColor:[UIColor colorWithHexString:@"#d1d1d1"].CGColor];
    [button setFrame:CGRectMake(KScreenWidth/3 + 15, 25, KScreenWidth/2, 40)];
    [button addTarget:self action:@selector(selectProject:) forControlEvents:(UIControlEventTouchUpInside)];
    [self.view addSubview:button];
    
    _moreProject = button;
}

//显示阶段的view
- (void)setUpProgressView{
    
    UIView *progressView = [[UIView alloc] initWithFrame:CGRectMake(0, 90, KScreenWidth, MDXFrom6(100))];
    [self.view addSubview:progressView];
    
    NSArray *tArr = @[@"施工准备",@"水电工程",@"泥木工程",@"油漆工程",@"竣工"];
    
    for (NSInteger i = 0 ; i < 5 ;  i++) {
        
        UIView *back = [[UIView alloc] initWithFrame:CGRectMake(KScreenWidth*i/5, 0, KScreenWidth/5, MDXFrom6(100))];
        
        [back addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(selectPhase:)]];
        [back setTag:i];
        [progressView addSubview:back];
        
        UIImageView * imageView = [Tools creatImage:CGRectMake(MDXFrom6(27.5), MDXFrom6(25), MDXFrom6(20), MDXFrom6(20)) image:i==0 ?@"project_process_xz":@"project_process"];
        
        [back addSubview:imageView];
        
        [self.stautsArr addObject:imageView];
        
        [back addSubview:[Tools creatLabel:CGRectMake(0, MDXFrom6(55), KScreenWidth/5, MDXFrom6(20)) font:[UIFont systemFontOfSize:MDXFrom6(14)] color:[UIColor colorWithHexString:@"#3b3b3b"] alignment:(NSTextAlignmentCenter) title:tArr[i]]];
        
        if (i != 0) {
            [back addSubview:[Tools creatImage:CGRectMake(0, MDXFrom6(33), MDXFrom6(27.5), MDXFrom6(4)) image:@"project_process_line"]];
        }
        
        if (i != 4) {
            [back addSubview:[Tools creatImage:CGRectMake(MDXFrom6(47.5), MDXFrom6(33), MDXFrom6(27.5), MDXFrom6(4)) image:@"project_process_line"]];
        }
        
    }
}


- (void)createPushButton{
    
    self.finishButton = [Tools creatButton:CGRectMake(MDXFrom6(85), KViewHeight -  MDXFrom6(65*2), KScreenWidth - MDXFrom6(170), MDXFrom6(45)) font:[UIFont systemFontOfSize:16] color:[UIColor whiteColor] title:@"完成项目" image:@""];
    [self.finishButton setBackgroundColor:[UIColor colorWithHexString:@"#3cc6c6"]];
    [self.finishButton.layer setCornerRadius:MDXFrom6(22.5)];
    [self.finishButton setClipsToBounds:YES];
    [self.finishButton setHidden:YES];
    [self.finishButton addTarget:self action:@selector(finishProject) forControlEvents:(UIControlEventTouchUpInside)];
    [self.view addSubview:self.finishButton];
    
    UIButton *btn = [Tools creatButton:CGRectMake(MDXFrom6(85), KViewHeight -  MDXFrom6(65), KScreenWidth - MDXFrom6(170), MDXFrom6(45)) font:[UIFont systemFontOfSize:16] color:[UIColor whiteColor] title:@"发布项目" image:@""];
    [btn setBackgroundColor:[UIColor colorWithHexString:@"#3cc6c6"]];
    [btn.layer setCornerRadius:MDXFrom6(22.5)];
    [btn setClipsToBounds:YES];
    [btn addTarget:self action:@selector(addProject) forControlEvents:(UIControlEventTouchUpInside)];
    [self.view addSubview:btn];

}

#pragma mark -- scrollview
-(UIScrollView *)tmpScrollView{
    
    if (!_tmpScrollView) {
        _tmpScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, MDXFrom6(100) + 90, KScreenWidth, KViewHeight - MDXFrom6(180) -90 )];
        [_tmpScrollView setShowsVerticalScrollIndicator:NO];
        [_tmpScrollView setShowsHorizontalScrollIndicator:NO];
        if (@available(iOS 11.0, *)) {
            [_tmpScrollView setContentInsetAdjustmentBehavior:(UIScrollViewContentInsetAdjustmentNever)];
        }
        [_tmpScrollView setPagingEnabled:YES];
        [_tmpScrollView setContentSize:CGSizeMake(KScreenWidth*5, self.tmpScrollView.frame.size.height)];
        [_tmpScrollView setDelegate:self];
    }
    return _tmpScrollView;
}

- (void)setContentView{
    
    for (NSInteger i = 0 ; i < 5 ; i ++) {
        ProjectView *v = [[ProjectView alloc] initWithFrame:CGRectMake(KScreenWidth*i, 0, KScreenWidth, i==4?self.tmpScrollView.frame.size.height-MDXFrom6(65): self.tmpScrollView.frame.size.height)];
        
        [self.tmpScrollView addSubview:v];
        
        [self.projectViewArr addObject:v];
    }
}

#pragma mark -- 下拉
// 下拉选中的
- (void)dafalutPullDownSelect:(NSInteger)index{
    
    if (![_currentProjectInfo isEqual:self.projectArr[index]]) {
        _currentProjectInfo = self.projectArr[index];
        [self hiddenFinishButton];
        _projiectNode = @"-1";
        [self getProjectNodeData:@"1"];
    }
    
}

- (PullDownView *)pullDownView{
    
    if (!_pullDownView) {
        _pullDownView  = [[PullDownView alloc] init];
        [self.view addSubview:_pullDownView];
    }
    return _pullDownView;
}

// 选择项目
- (void)selectProject:(UIButton *)sender{
    
    sender.selected = !sender.selected;
    
    CGRect rext = [sender convertRect:sender.bounds toView:self.view];
    
    CGRect frame;
    frame.origin.x = rext.origin.x;
    frame.origin.y = rext.origin.y + rext.size.height;
    frame.size.width = rext.size.width;
    frame.size.height = 150;
    
    [self.pullDownView showOrHidden:NO withFrame:frame button:sender view:((DefaultPullDown *)self.childViewControllers[sender.tag]).view];
}


#pragma mark -- 点击事件

- (void)selectPhase:(UITapGestureRecognizer *)sender{

    for (UIImageView *imgev in self.stautsArr) {
        [imgev setImage:[UIImage imageNamed:@"project_process"]];
    }
    if (sender.view.tag == 4) {
        [self.finishButton setHidden:NO];
        
    }
    else{
        [self.finishButton setHidden:YES];

    }
    [((UIImageView *)self.stautsArr[sender.view.tag]) setImage:[UIImage imageNamed:@"project_process_xz"]];
    
    [self getProjectNodeData:[NSString stringWithFormat:@"%ld",sender.view.tag+1]];
}

- (void)addProject{
    
    PushProjectNodeViewController *vc = [[PushProjectNodeViewController alloc] init];
    vc.project_id = _currentProjectInfo[@"id"];
    vc.type = _projiectNode;
    [self.navigationController pushViewController:vc animated:YES];
   
}

- (void)finishProject{
    
    [self creatAlertViewControllerWithMessage:@"确定完成该项目吗？"];
}

- (void)rightButtonTouchUpInside:(id)sender{
    _isRefre = YES;
    AddProjectViewController *vc = [[AddProjectViewController alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)leftButtonTouchUpInside:(id)sender{
    
    [self dismissViewControllerAnimated:YES completion:nil];
}


#pragma mark -- 获取数据  项目
- (void)getProjectData{
    
    NSString *path = [NSString stringWithFormat:@"%@/Project/insert_member_project",KURL];
    
    NSDictionary *header = @{@"token":UTOKEN};
    
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    __weak typeof(self) weakSelf = self;
    
    [HttpRequest POSTWithHeader:header url:path parameters:nil success:^(id  _Nullable responseObject) {
        
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        
        if ([responseObject[@"code"] integerValue] == 200) {
            
            [weakSelf.childViewControllers makeObjectsPerformSelector:@selector(removeFromParentViewController)];
            
            if ([responseObject[@"datas"] isKindOfClass:[NSArray class]]) {
                
                [weakSelf.projectArr removeAllObjects];
                
                for (NSDictionary *dic in responseObject[@"datas"]) {
                    [weakSelf.projectArr addObject:dic];
                }
            }
            
            if (self->_isFirst && self.projectArr.count == 0) {
                self->_isFirst = NO;
                [self rightButtonTouchUpInside:nil];
            }
            
            DefaultPullDown *sort1 = [[DefaultPullDown alloc] init];
            sort1.titleArray = weakSelf.projectArr;
            [sort1 setDelegate:weakSelf];
            [weakSelf addChildViewController:sort1];
            
            if (weakSelf.projectArr.count > 0) {
                [self->_moreProject setTitle:weakSelf.projectArr[0][@"name"] forState:(UIControlStateNormal)];
                self->_currentProjectInfo =weakSelf.projectArr[0];
                [weakSelf hiddenFinishButton];
                [weakSelf getProjectNodeData:@"1"];
            }
        }
        else{
            
            [ViewHelps showHUDWithText:responseObject[@"message"]];
        }
        
        
    } failure:^(NSError * _Nullable error) {
        
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        [RequestSever showMsgWithError:error];
    }];
    
}

- (void)getProjectNodeData:(NSString *)type{
    
    if ([_projiectNode isEqualToString:type]) {
        
        return;
    }
    
    if (!_currentProjectInfo) {
        return;
    }
    
    _projiectNode = type;
    //项目类型 1 施工准备 2、水电工程 3、泥木工程 4、油漆工程 5、竣工
    
    ProjectView *v = self.projectViewArr[[type integerValue]-1];
    [v refreDataWithID:_currentProjectInfo[@"id"] andType:type cate:1];
    
    [self.tmpScrollView setContentOffset:CGPointMake(KScreenWidth *([type integerValue]-1), 0)];
}

#pragma mark -- scrollVIew 协议 、、 数据刷新
- (void) scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate{
    if (scrollView == self.tmpScrollView) {
        
        // 如果在拖动结束的时候，没有减速的过程
        if (!decelerate){
            
            NSInteger page = scrollView.contentOffset.x/KScreenWidth;
            
            UIView *v = ((UIImageView *)self.stautsArr[page]).superview;
            [self selectPhase:[v.gestureRecognizers firstObject]];
        }
    }
    
}
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    if (scrollView == self.tmpScrollView) {
        NSInteger page = scrollView.contentOffset.x/KScreenWidth;
        
        UIView *v = ((UIImageView *)self.stautsArr[page]).superview;
        [self selectPhase:[v.gestureRecognizers firstObject]];
    }
}


- (void)creatAlertViewControllerWithMessage:(NSString *)message{
    
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示" message:message preferredStyle:(UIAlertControllerStyleAlert)];
    
    [alert addAction:[UIAlertAction actionWithTitle:@"确定" style:(UIAlertActionStyleCancel) handler:^(UIAlertAction * _Nonnull action) {
        [self uploadProjectStatus];
    }]];
    
    [alert addAction:[UIAlertAction actionWithTitle:@"取消" style:(UIAlertActionStyleDefault) handler:^(UIAlertAction * _Nonnull action) {
        
    }]];
    
    [self presentViewController:alert animated:YES completion:nil];
    
}

- (void)uploadProjectStatus{
    NSString *path = [NSString stringWithFormat:@"%@/Project/complate_project",KURL];
    
    NSDictionary *header = @{@"token":UTOKEN};
    NSDictionary *dic = @{@"project_id":_currentProjectInfo[@"id"]};
    
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    __weak typeof(self) weakSelf = self;
    
    [HttpRequest POSTWithHeader:header url:path parameters:dic success:^(id  _Nullable responseObject) {
        
        [MBProgressHUD hideHUDForView:weakSelf.view animated:YES];
        
        if ([responseObject[@"code"] integerValue] == 200) {
            [ViewHelps showHUDWithText:@"提交成功"];
           
            [weakSelf hiddenFinishButton];
            
            [weakSelf getProjectData];
        }
        else{
            
            [ViewHelps showHUDWithText:responseObject[@"message"]];
        }
        
        
    } failure:^(NSError * _Nullable error) {
        
        [MBProgressHUD hideHUDForView:weakSelf.view animated:YES];
        [RequestSever showMsgWithError:error];
    }];

}

- (void)hiddenFinishButton{
    
    for (UIImageView *image in self.stautsArr) {

        [image setImage:[UIImage imageNamed:@"project_process"]];
    }
    [((UIImageView *)self.stautsArr[0]) setImage:[UIImage imageNamed:@"project_process_xz"]];
    [self.finishButton setHidden:YES];
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
