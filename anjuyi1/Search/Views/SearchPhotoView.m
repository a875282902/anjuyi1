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
                    model.is_collect = dic[@"is_collect"];
                    model.ID = dic[@"image_id"];
                    
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
        
        MyPhotoModel *model = self.dataArr[indexPath.item];
        
        [cell bandDataWithModel:model];
        
        [cell setSelectPhotoToCollect:^(UIButton *collectButotn) {
           
            [self collectPhoto:collectButotn photo_id:model.ID];
            
        }];
    }
    
    return cell;
}

//收藏
- (void)collectPhoto:(UIButton *)sender photo_id:(NSString *)photo_id {
    LOGIN
    NSString *path = [NSString stringWithFormat:@"%@/MemberImage/member_collect",KURL];
    NSDictionary *header = @{@"token":UTOKEN};
    NSDictionary *dic = @{@"id":photo_id};
    
    [MBProgressHUD showHUDAddedTo:self animated:YES];
    
    __weak typeof(self) weakSelf = self;
    
    [HttpRequest POSTWithHeader:header url:path parameters:dic success:^(id  _Nullable responseObject) {
        
        [MBProgressHUD hideHUDForView:weakSelf animated:YES];
        
        if ([responseObject[@"code"] integerValue] == 200) {
            [ViewHelps showHUDWithText:@"收藏成功"];
            [sender setTitle:[NSString stringWithFormat:@" %ld",[sender.titleLabel.text integerValue] + 1] forState:(UIControlStateNormal)];
            [sender setSelected:YES];
        }
        else if ([responseObject[@"code"] integerValue] == 201){
            [sender setTitle:[NSString stringWithFormat:@" %ld",[sender.titleLabel.text integerValue] - 1] forState:(UIControlStateNormal)];
            [sender setSelected:NO];
        }
        else{
            
            [ViewHelps showHUDWithText:responseObject[@"message"]];
        }
        
        
    } failure:^(NSError * _Nullable error) {
        
        [MBProgressHUD hideHUDForView:weakSelf animated:YES];
        [RequestSever showMsgWithError:error];
    }];
}


- (CGFloat)waterflowLayout:(LSYCollerctionViewLayout *)waterflowLayout heightForItemAtIndexPath:(NSInteger)index itemWidth:(CGFloat)itemWidth{
    
    return (KScreenWidth-30)/2.0 /( 170/113.0f)+90;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    
    PhotoDetailsViewController *VC = [[PhotoDetailsViewController alloc] init];
    MyPhotoModel *model  = self.dataArr[indexPath.row];
    VC.photo_id = model.ID;
//    [self.navigationController pushViewController:VC animated:YES];
    self.selectPhotoToShowDetalis(VC);
}


@end
