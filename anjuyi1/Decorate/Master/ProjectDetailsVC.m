//
//  ProjectDetailsVC.m
//  anjuyi1
//
//  Created by 李 on 2018/6/1.
//  Copyright © 2018年 lsy. All rights reserved.
//
// 项目详情

#import "ProjectDetailsVC.h"
#import "NodeDetailsViewController.h"

#import "ProjectView.h"//项目

@interface ProjectDetailsVC ()<UIScrollViewDelegate,ProjectViewDelegate>
{
    NSString *_projiectNode;
}

@property (nonatomic,strong)UIScrollView     * tmpScrollView;

@property (nonatomic,strong)NSMutableArray   * projectViewArr;
@property (nonatomic,strong)NSMutableArray   * stautsArr;//状态view的数组

@end

@implementation ProjectDetailsVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setNavigationLeftBarButtonWithImageNamed:@"ss_back"];
    [self setNavigationRightBarButtonWithImageNamed:@"fw"];
    
    [self setTitle:@"项目详情"];
    
    self.projectViewArr = [NSMutableArray array];
    self.stautsArr = [NSMutableArray array];
    
    [self.view addSubview:self.tmpScrollView];
    
    [self setUpProgressView];
    
    [self setContentView];
    
    [self getProjectNodeData:@"1"];
    
    [self.view addSubview:[Tools setLineView:CGRectMake(0, 0, KScreenWidth, 1)]];
}
#pragma mark --  UI
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
-(UIScrollView *)tmpScrollView{
    
    if (!_tmpScrollView) {
        _tmpScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, MDXFrom6(100), KScreenWidth, KViewHeight - MDXFrom6(100) )];
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
    
    NodeDetailsViewController *vc = [[NodeDetailsViewController alloc] init];
    vc.nodeID = nodeID;
    [self.navigationController pushViewController:vc animated:YES];
    
}
#pragma mark -- 数据
- (void)getProjectNodeData:(NSString *)type{
    
    
    _projiectNode = type;
    //项目类型 1 施工准备 2、水电工程 3、泥木工程 4、油漆工程 5、竣工
    
    ProjectView *v = self.projectViewArr[[type integerValue]-1];
    [v refreDataWithID:self.projectID andType:type cate:2];
    
    [self.tmpScrollView setContentOffset:CGPointMake(KScreenWidth *([type integerValue]-1), 0)];
}

#pragma mark -- 点击事件
- (void)selectPhase:(UITapGestureRecognizer *)sender{
    
    for (UIImageView *imgev in self.stautsArr) {
        [imgev setImage:[UIImage imageNamed:@"project_process"]];
    }
    
    [((UIImageView *)self.stautsArr[sender.view.tag]) setImage:[UIImage imageNamed:@"project_process_xz"]];
    
    [self getProjectNodeData:[NSString stringWithFormat:@"%ld",sender.view.tag+1]];
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
