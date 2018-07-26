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
#import "MyPhotoModel.h"

@interface MyPhotoViewController ()<UICollectionViewDataSource , LSYCollerctionViewLayoutDelegate,UICollectionViewDelegate>


@property (nonatomic , strong) UICollectionView * tmpCollertionView;
@property (nonatomic , strong) NSMutableArray   * dataArr;
@property (nonatomic , strong) NavTwoTitle      * navTwoTitle;
@end

@implementation MyPhotoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self baseForDefaultLeftNavButton];
    self.navTwoTitle = [[NavTwoTitle alloc] initWithFrame:CGRectMake(0, 0, MDXFrom6(200), 44) WithTitle1:@"我的图片" WithTitle2:@"0张"];
    [self.navigationItem setTitleView:self.navTwoTitle];
    self.dataArr = [NSMutableArray array];
    
    [self.view addSubview:self.tmpCollertionView];
    
    [self.view addSubview:[Tools setLineView:CGRectMake(0, 0, KScreenWidth, 1.5)]];
    
    [self getPhotoListData];
}


- (void)getPhotoListData{

    
    NSString *path = [NSString stringWithFormat:@"%@/member/my_image",KURL];
    
    NSDictionary *header = @{@"token":UTOKEN};
    
    
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    __weak typeof(self) weakSelf = self;
    
    [HttpRequest POSTWithHeader:header url:path parameters:nil success:^(id  _Nullable responseObject) {
        
        [MBProgressHUD hideHUDForView:weakSelf.view animated:YES];
        
        if ([responseObject[@"code"] integerValue] == 200) {
            if ([responseObject[@"datas"] isKindOfClass:[NSArray class]]) {
                
                for (NSDictionary *dic in responseObject[@"datas"]) {
                    MyPhotoModel *model = [[MyPhotoModel alloc] initWithDictionary:dic];
                    [weakSelf.dataArr addObject:model];
                }
            }
            
        }
        else{
            
            [ViewHelps showHUDWithText:responseObject[@"message"]];
        }
        [weakSelf.navTwoTitle refreNum:[NSString stringWithFormat:@"%ld张",weakSelf.dataArr.count]];
        [weakSelf.tmpCollertionView reloadData];
        
    } failure:^(NSError * _Nullable error) {
        
        [MBProgressHUD hideHUDForView:weakSelf.view animated:YES];
        [RequestSever showMsgWithError:error];
    }];

}

#pragma mark -- UI

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
    
    return self.dataArr.count;
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
    if (indexPath.item < self.dataArr.count) {
        [cell bandDataWithModel:self.dataArr[indexPath.item]];
    }
    
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
