//
//  PushProjectViewController.m
//  anjuyi1
//
//  Created by 李 on 2018/7/3.
//  Copyright © 2018年 lsy. All rights reserved.
//
//  发布项目

#import "EditProjiecViewController.h"
#import "PushProjectNodeViewController.h"

#import "ProjectView.h"

#import "EditProjectNodeViewController.h"

@interface EditProjiecViewController ()<UIScrollViewDelegate,ProjectViewDelegate>
{
    NSString     * _projiectNode;//节点信息
}


@property (nonatomic,strong)UIScrollView     * tmpScrollView;
@property (nonatomic,strong)NSMutableArray   * projectViewArr;

@property (nonatomic,strong)NSMutableArray   * projectArr;//项目的数组
@property (nonatomic,strong)NSMutableArray   * stautsArr;//状态view的数组
@property (nonatomic,strong)UIButton         * finishButton;//完成按钮（仅在竣工下面出现）

@end

@implementation EditProjiecViewController

- (void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:animated];
    
    if (_projiectNode) {
        [self getProjectNodeData:_projiectNode];
    }

}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self baseForDefaultLeftNavButton];
    
    [self setTitle:@"编辑项目"];
    _projiectNode = @"-1";
    
    self.projectArr = [NSMutableArray array];
    self.stautsArr = [NSMutableArray array];
    self.projectViewArr = [NSMutableArray array];
    
    [self setUpProgressView];
    
    [self.view addSubview:self.tmpScrollView];
    
    [self setContentView];
    
    [self.view addSubview:[Tools setLineView:CGRectMake(0, 0, KScreenWidth, 1)]];
    
    [self createPushButton];
    
    [self getProjectNodeData:@"1"];
}


//显示阶段的view
- (void)setUpProgressView{
    
    UIView *progressView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, KScreenWidth, MDXFrom6(100))];
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
        _tmpScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, MDXFrom6(100) , KScreenWidth, KViewHeight - MDXFrom6(180))];
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
        [v setDelegate:self];
        [self.tmpScrollView addSubview:v];
        
        [self.projectViewArr addObject:v];
    }
}

- (void)selectProjectNode:(NSString *)nodeID{
    
    EditProjectNodeViewController *vc = [[EditProjectNodeViewController alloc] init];
    vc.article_id = nodeID;
    [self.navigationController pushViewController:vc animated:YES];
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
    vc.project_id = self.projectID;
    vc.type = _projiectNode;
    [self.navigationController pushViewController:vc animated:YES];
    
}

- (void)finishProject{
    
    [self creatAlertViewControllerWithMessage:@"确定完成该项目吗？"];
}



#pragma mark -- 获取数据
- (void)getProjectNodeData:(NSString *)type{
    
    if ([_projiectNode isEqualToString:type]) {
        
        return;
    }
    
    _projiectNode = type;
    //项目类型 1 施工准备 2、水电工程 3、泥木工程 4、油漆工程 5、竣工
    
    ProjectView *v = self.projectViewArr[[type integerValue]-1];
    [v refreDataWithID:self.projectID andType:type cate:1];
    
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
    NSDictionary *dic = @{@"project_id":self.projectID};
    
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
