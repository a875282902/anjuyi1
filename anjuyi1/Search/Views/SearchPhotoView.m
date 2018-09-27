//
//  PhotoListViewController.m
//  anjuyi1
//
//  Created by 李 on 2018/6/3.
//  Copyright © 2018年 lsy. All rights reserved.
//

#import "SearchPhotoView.h"
#import "LSYCollerctionViewLayout.h"
#import "PhotoCollectionViewCell.h"
#import "MyPhotoModel.h"
#import "PhotoDetailsViewController.h"

@interface SearchPhotoView ()<UICollectionViewDataSource , LSYCollerctionViewLayoutDelegate,UICollectionViewDelegate>


@property (nonatomic , strong) UICollectionView * tmpCollertionView;
@property (nonatomic , strong) NSMutableArray   * dataArr;
@end

@implementation SearchPhotoView

- (instancetype)initWithFrame:(CGRect)frame{
    
    if (self == [super initWithFrame:frame]) {
        
        self.dataArr = [NSMutableArray array];
        
        [self addSubview:self.tmpCollertionView];
        
        [self addSubview:[Tools setLineView:CGRectMake(0, 0, KScreenWidth, 1.5)]];
    }
    return self;
}

- (void)setKeyword:(NSString *)keyword{
    
    _keyword = keyword;
    
    NSString *path = [NSString stringWithFormat:@"%@/search/search",KURL];
    
    
    [MBProgressHUD showHUDAddedTo:self animated:YES];
    
    __weak typeof(self) weakSelf = self;
    
    [HttpRequest POST:path parameters:@{@"type":@"1",@"keyword":keyword} success:^(id  _Nullable responseObject) {
        
        [MBProgressHUD hideHUDForView:weakSelf animated:YES];
        if ([responseObject[@"datas"] isKindOfClass:[NSArray class]]) {
            if ([responseObject[@"code"] integerValue] == 200) {
                
                for (NSDictionary *dic in responseObject[@"datas"]) {
                    MyPhotoModel *model = [[MyPhotoModel alloc] init];
                    model.cover = dic[@"img"];
                    model.text = dic[@"title"];
                    model.head = dic[@"userhead"];
                    model.nick_name = dic[@"username"];
                    model.collect_num = dic[@"collect"];
                    model.ID = dic[@"id"];
                    
                    [self.dataArr addObject:model];
                }
                
                [weakSelf.tmpCollertionView reloadData];
            }
            
            else{
                
                [ViewHelps showHUDWithText:responseObject[@"message"]];
            }
        }
        
        
    } failure:^(NSError * _Nullable error) {
        
        [MBProgressHUD hideHUDForView:weakSelf animated:YES];
        [RequestSever showMsgWithError:error];
    }];

}

#pragma mark -- UI

- (UICollectionView *)tmpCollertionView{
    
    if (!_tmpCollertionView) {
        
        LSYCollerctionViewLayout *layout = [[LSYCollerctionViewLayout alloc] init];
        
        [layout setDelegate:self];
        
        _tmpCollertionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, KScreenWidth, self.frame.size.height) collectionViewLayout:layout];
        [_tmpCollertionView setBackgroundColor:[UIColor whiteColor]];
        [_tmpCollertionView setDataSource:self];
        [_tmpCollertionView setDelegate:self];
        [_tmpCollertionView registerClass:[PhotoCollectionViewCell class] forCellWithReuseIdentifier:@"PhotoListViewController"];
    }
    return _tmpCollertionView;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    
    return self.dataArr.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    PhotoCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"PhotoListViewController" forIndexPath:indexPath];
    
    if (indexPath.item < self.dataArr.count) {
        [cell bandDataWithModel:self.dataArr[indexPath.item]];
    }
    
    return cell;
}

- (CGFloat)waterflowLayout:(LSYCollerctionViewLayout *)waterflowLayout heightForItemAtIndexPath:(NSInteger)index itemWidth:(CGFloat)itemWidth{
    
    return (KScreenWidth-30)/2.0 /( 170/113.0f)+90;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    
    PhotoDetailsViewController *VC = [[PhotoDetailsViewController alloc] init];
    MyPhotoModel *model  = self.dataArr[indexPath.row];
    VC.photo_id = model.ID;
//    [self.navigationController pushViewController:VC animated:YES];
}


@end
