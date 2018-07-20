//
//  PushProjectViewController.m
//  anjuyi1
//
//  Created by 李 on 2018/7/3.
//  Copyright © 2018年 lsy. All rights reserved.
//
//  发布项目

#import "PushProjectViewController.h"
#import "ProjectCollectionViewCell.h"
#import "AddProjectViewController.h"
#import "PushProjectNodeViewController.h"

#import "PullDownView.h"
#import "YZMenuButton.h"
#import "DefaultPullDown.h"

@interface PushProjectViewController ()<UICollectionViewDelegate,UICollectionViewDataSource,DefaultPullDownDelegate>
{
    YZMenuButton * _moreProject;
    NSDictionary * _currentProjectInfo;//项目信息
    NSString     * _projiectNode;//节点信息
    BOOL _isRefre; //判断项目需要刷新不
}

@property (nonatomic,strong)UICollectionView * tmpCollectionView;
@property (nonatomic,strong)NSMutableArray   * dataArr;
@property (nonatomic,strong)PullDownView     * pullDownView;
@property (nonatomic,strong)NSMutableArray   * projectArr;
@property (nonatomic,strong)NSMutableArray   * stautsArr;

@end

@implementation PushProjectViewController

- (void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:animated];
    
    if (_projiectNode) {
        [self getProjectNodeData:_projiectNode];
    }
    
    if (_isRefre) {
        [self getProjectData];
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
    self.dataArr = [NSMutableArray array];
    self.stautsArr = [NSMutableArray array];
    
    [self setUpProjectView];
    [self setUpProgressView];
    
    [self.view addSubview:self.tmpCollectionView];
    
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
    
    UIButton *btn = [Tools creatButton:CGRectMake(MDXFrom6(85), KViewHeight -  MDXFrom6(65), KScreenWidth - MDXFrom6(170), MDXFrom6(45)) font:[UIFont systemFontOfSize:16] color:[UIColor whiteColor] title:@"发布项目" image:@""];
    [btn setBackgroundColor:[UIColor colorWithHexString:@"#3cc6c6"]];
    [btn.layer setCornerRadius:MDXFrom6(22.5)];
    [btn setClipsToBounds:YES];
    [btn addTarget:self action:@selector(addProject) forControlEvents:(UIControlEventTouchUpInside)];
    [self.view addSubview:btn];
}


#pragma mark -tmpCollectionView
-(UICollectionView *)tmpCollectionView{
    
    if (!_tmpCollectionView) {
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
        [layout setItemSize:CGSizeMake(MDXFrom6(167), MDXFrom6(230))];
        [layout setSectionInset:UIEdgeInsetsMake(MDXFrom6(5), MDXFrom6(10), MDXFrom6(5), MDXFrom6(10))];
        
        _tmpCollectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, MDXFrom6(100) + 90, KScreenWidth, KScreenHeight-KTopHeight - MDXFrom6(180) -90 ) collectionViewLayout:layout];
        [_tmpCollectionView setBackgroundColor:[UIColor whiteColor]];
        [_tmpCollectionView setDelegate:self];
        [_tmpCollectionView setDataSource:self];
        [_tmpCollectionView registerClass:[ProjectCollectionViewCell class] forCellWithReuseIdentifier:@"ProjectCollectionViewCell"];
    }
    return _tmpCollectionView;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    
    return self.dataArr.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    ProjectCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"ProjectCollectionViewCell" forIndexPath:indexPath];
    
    if (indexPath.item < self.dataArr.count) {
        [cell bandDataWithDictionary:self.dataArr[indexPath.item]];
    }
    
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    
    
}




#pragma mark -- 下拉
// 下拉选中的
- (void)dafalutPullDownSelect:(NSInteger)index{
    
    if (![_currentProjectInfo isEqual:self.projectArr[index]]) {
        _currentProjectInfo = self.projectArr[index];
        
        [((UIImageView *)self.stautsArr[0]) setImage:[UIImage imageNamed:@"project_process_xz"]];
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
    
    
    [((UIImageView *)self.stautsArr[sender.view.tag]) setImage:[UIImage imageNamed:@"project_process_xz"]];
    
    [self getProjectNodeData:[NSString stringWithFormat:@"%ld",sender.view.tag+1]];
}

- (void)addProject{
    
    PushProjectNodeViewController *vc = [[PushProjectNodeViewController alloc] init];
    vc.project_id = _currentProjectInfo[@"id"];
    vc.type = _projiectNode;
    [self.navigationController pushViewController:vc animated:YES];
   
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
            
            DefaultPullDown *sort1 = [[DefaultPullDown alloc] init];
            sort1.titleArray = weakSelf.projectArr;
            [sort1 setDelegate:weakSelf];
            [weakSelf addChildViewController:sort1];
            
            if (weakSelf.projectArr.count > 0) {
                [self->_moreProject setTitle:weakSelf.projectArr[0][@"name"] forState:(UIControlStateNormal)];
                self->_currentProjectInfo =weakSelf.projectArr[0];
                
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
    
    NSString *path = [NSString stringWithFormat:@"%@/project/get_project_article",KURL];
    
    NSDictionary *header = @{@"token":UTOKEN};
    NSDictionary *paramet = @{@"id":_currentProjectInfo[@"id"],
                              @"type":type};
    
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    __weak typeof(self) weakSelf = self;
    
    [HttpRequest POSTWithHeader:header url:path parameters:paramet success:^(id  _Nullable responseObject) {
        
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        
        [weakSelf.dataArr removeAllObjects];
        
        if ([responseObject[@"code"] integerValue] == 200) {
            
            if ([responseObject[@"datas"] isKindOfClass:[NSArray class]]) {
                
                for (NSDictionary *dic in responseObject[@"datas"]) {
                    [weakSelf.dataArr addObject:dic];
                }
                
            }
        }
        else{
            
            [ViewHelps showHUDWithText:responseObject[@"message"]];
        }
        [weakSelf.tmpCollectionView reloadData];
        
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
