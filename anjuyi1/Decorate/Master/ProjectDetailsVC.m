//
//  ProjectDetailsVC.m
//  anjuyi1
//
//  Created by 李 on 2018/6/1.
//  Copyright © 2018年 lsy. All rights reserved.
//
// 项目详情

#import "ProjectDetailsVC.h"
#import "ProjectCollectionViewCell.h"

@interface ProjectDetailsVC ()<UICollectionViewDelegate,UICollectionViewDataSource>

@property (nonatomic,strong)UICollectionView * tmpCollectionView;

@property (nonatomic,strong)NSMutableArray   * dataArr;

@end

@implementation ProjectDetailsVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setNavigationLeftBarButtonWithImageNamed:@"ss_back"];
    [self setNavigationRightBarButtonWithImageNamed:@"fw"];
    
    [self setTitle:@"张建德的项目"];
    
    [self setUpProgressView];
    
    [self.view addSubview:self.tmpCollectionView];
    
    [self.view addSubview:[Tools setLineView:CGRectMake(0, 0, KScreenWidth, 1)]];
}

//显示阶段的view
- (void)setUpProgressView{
    
    UIView *progressView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, KScreenWidth, MDXFrom6(100))];
    [progressView setBackgroundColor:[UIColor colorWithHexString:@"#eeeeee"]];
    [self.view addSubview:progressView];
    
    NSArray *tArr = @[@"施工准备",@"水电工程",@"泥木工程",@"油漆工程",@"竣工"];
    
    for (NSInteger i = 0 ; i < 5 ;  i++) {
        
        UIView *back = [[UIView alloc] initWithFrame:CGRectMake(KScreenWidth*i/5, 0, KScreenWidth/5, MDXFrom6(100))];
        
        [back addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(selectPhase:)]];
        [back setTag:i];
        [progressView addSubview:back];
        
        [back addSubview:[Tools creatImage:CGRectMake(MDXFrom6(27.5), MDXFrom6(25), MDXFrom6(20), MDXFrom6(20)) image:@"project_process_xz"]];
        
        [back addSubview:[Tools creatLabel:CGRectMake(0, MDXFrom6(55), KScreenWidth/5, MDXFrom6(20)) font:[UIFont systemFontOfSize:MDXFrom6(14)] color:[UIColor colorWithHexString:@"#3b3b3b"] alignment:(NSTextAlignmentCenter) title:tArr[i]]];
        
        if (i != 0) {
             [back addSubview:[Tools creatImage:CGRectMake(0, MDXFrom6(33), MDXFrom6(27.5), MDXFrom6(4)) image:@"project_process_line"]];
        }
        
        if (i != 4) {
            [back addSubview:[Tools creatImage:CGRectMake(MDXFrom6(47.5), MDXFrom6(33), MDXFrom6(27.5), MDXFrom6(4)) image:@"project_process_line"]];
        }
        
    }
}


#pragma mark -tmpCollectionView
-(UICollectionView *)tmpCollectionView{
    
    if (!_tmpCollectionView) {
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
        [layout setItemSize:CGSizeMake(MDXFrom6(167), MDXFrom6(230))];
        [layout setSectionInset:UIEdgeInsetsMake(MDXFrom6(5), MDXFrom6(10), MDXFrom6(5), MDXFrom6(10))];
        
        _tmpCollectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, MDXFrom6(100), KScreenWidth, KScreenHeight-KTopHeight - MDXFrom6(100)) collectionViewLayout:layout];
        [_tmpCollectionView setBackgroundColor:[UIColor whiteColor]];
        [_tmpCollectionView setDelegate:self];
        [_tmpCollectionView setDataSource:self];
        [_tmpCollectionView registerClass:[ProjectCollectionViewCell class] forCellWithReuseIdentifier:@"ProjectCollectionViewCell"];
    }
    return _tmpCollectionView;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    
    return 10;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    ProjectCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"ProjectCollectionViewCell" forIndexPath:indexPath];

    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    
    
}


#pragma mark -- 点击事件
- (void)selectPhase:(UITapGestureRecognizer *)sender{
    
    
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
