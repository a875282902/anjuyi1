//
//  MyPhotoViewController.m
//  anjuyi1
//
//  Created by 李 on 2018/6/3.
//  Copyright © 2018年 lsy. All rights reserved.
//

#import "MyPhotoViewController.h"
#import "LSYCollerctionViewLayout.h"
#import "PhotoCollectionViewCell.h"

@interface MyPhotoViewController ()<UICollectionViewDataSource , LSYCollerctionViewLayoutDelegate,UICollectionViewDelegate>


@property (nonatomic , strong) UICollectionView *tmpCollertionView;

@property (nonatomic , strong) NSMutableArray *dataArr;

@end

@implementation MyPhotoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self baseForDefaultLeftNavButton];
    [self.navigationItem setTitleView:[[NavTwoTitle alloc] initWithFrame:CGRectMake(0, 0, MDXFrom6(300), 44) WithTitle1:@"我的图片" WithTitle2:@"35张"]];
    
    [self.view addSubview:self.tmpCollertionView];
    
    [self.view addSubview:[Tools setLineView:CGRectMake(0, 0, KScreenWidth, 1.5)]];
    
}

- (UICollectionView *)tmpCollertionView{
    
    if (!_tmpCollertionView) {
        
        LSYCollerctionViewLayout *layout = [[LSYCollerctionViewLayout alloc] init];
        
        [layout setDelegate:self];
        
        _tmpCollertionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, KScreenWidth, KScreenHeight - KTopHeight) collectionViewLayout:layout];
        [_tmpCollertionView setBackgroundColor:[UIColor whiteColor]];
        [_tmpCollertionView setDataSource:self];
        [_tmpCollertionView setDelegate:self];
        [_tmpCollertionView registerClass:[PhotoCollectionViewCell class] forCellWithReuseIdentifier:@"MyPhotoViewController"];
    }
    return _tmpCollertionView;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    
    return 10;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    PhotoCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"MyPhotoViewController" forIndexPath:indexPath];
    
//    [cell setBackgroundColor:[UIColor redColor]];
//
//    NSInteger tag = 10;
//
//    UILabel *label = (UILabel *)[cell.contentView viewWithTag:tag];
//
//    if (!label) {
//
//        label = [[UILabel alloc] init];
//
//        label.tag = tag;
//
//        [cell.contentView addSubview:label];
//    }
//
//    [label setText:[NSString stringWithFormat:@"%@12312",self.dataArr[indexPath.item]]];
//
//    [label sizeToFit];
    
    return cell;
}

- (CGFloat)waterflowLayout:(LSYCollerctionViewLayout *)waterflowLayout heightForItemAtIndexPath:(NSInteger)index itemWidth:(CGFloat)itemWidth{
    
    return (KScreenWidth-30)/2.0 /( 170/113.0f)+90;
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
