//
//  MyCollectView.m
//  anjuyi1
//
//  Created by apple on 2018/8/6.
//  Copyright © 2018年 lsy. All rights reserved.
//

#import "MyCollectPhotoView.h"
#import "LSYCollerctionViewLayout.h"
#import "PhotoCollectionViewCell.h"
#import "PhotoDetailsViewController.h"
#import "MyPhotoModel.h"

@interface MyCollectPhotoView ()<UICollectionViewDataSource , LSYCollerctionViewLayoutDelegate,UICollectionViewDelegate>

@property (nonatomic,strong) UICollectionView * tmpCollertionView;

@property (nonatomic,strong) NSMutableArray   * dataArr;

@property (nonatomic,assign) NSInteger          page;

@end

@implementation MyCollectPhotoView

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self == [super initWithFrame:frame]) {
        [self addSubview:self.tmpCollertionView];
    }
    return self;
}

- (void)setIndex:(NSInteger)index{
    
    _index = index;
    [self.dataArr removeAllObjects];
    self.page = 1;
    [self load];
    [self.tmpCollertionView.mj_header beginRefreshing];
}

- (NSMutableArray *)dataArr{
    
    if (!_dataArr) {
        _dataArr = [NSMutableArray array];
    }
    return _dataArr;
}

#pragma mark -- refresh
- (void)load{
    __weak typeof(self) weakSelf = self;
    
    self.tmpCollertionView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        weakSelf.page = 1;
        [weakSelf.dataArr removeAllObjects];
        [weakSelf.tmpCollertionView.mj_footer resetNoMoreData];
        [weakSelf pullDownRefresh];
    }];
    
    self.tmpCollertionView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        weakSelf.page ++;
        [weakSelf pullUpLoadMore];
    }];
    
}
//下拉刷新
- (void)pullDownRefresh{
    
    NSString *path = [NSString stringWithFormat:@"%@/member/my_collect",KURL];
    
    NSDictionary *header = @{@"token":UTOKEN};
    NSDictionary *dic = @{@"type":[NSString stringWithFormat:@"%ld",self.index+1],
                          @"page":[NSString stringWithFormat:@"%ld",self.page]};
    
    __weak typeof(self) weakSelf = self;
    
    [MBProgressHUD showHUDAddedTo:self animated:YES];
    
    [HttpRequest POSTWithHeader:header url:path parameters:dic success:^(id  _Nullable responseObject) {
        [MBProgressHUD hideHUDForView:self animated:YES];
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
        
        if (weakSelf.dataArr.count < weakSelf.page *10) {
            [weakSelf.tmpCollertionView.mj_footer endRefreshingWithNoMoreData];
        }
        [weakSelf.tmpCollertionView.mj_header endRefreshing];
        [weakSelf.tmpCollertionView reloadData];
    } failure:^(NSError * _Nullable error) {
        [weakSelf.tmpCollertionView.mj_header endRefreshing];
        [MBProgressHUD hideHUDForView:self animated:YES];
        [RequestSever showMsgWithError:error];
    }];
    
}
//上拉加载
- (void)pullUpLoadMore{
    
    NSString *path = [NSString stringWithFormat:@"%@/member/my_collect",KURL];
    
    NSDictionary *header = @{@"token":UTOKEN};
    NSDictionary *dic = @{@"type":[NSString stringWithFormat:@"%ld",self.index+1]};
    
    __weak typeof(self) weakSelf = self;
    
    [MBProgressHUD showHUDAddedTo:self animated:YES];
    
    [HttpRequest POSTWithHeader:header url:path parameters:dic success:^(id  _Nullable responseObject) {
        [MBProgressHUD hideHUDForView:self animated:YES];
        if ([responseObject[@"code"] integerValue] == 200) {
            if ([responseObject[@"datas"] isKindOfClass:[NSArray class]]) {
                for (NSDictionary *dic in responseObject[@"datas"]) {
                    [weakSelf.dataArr addObject:dic];
                }
            }
            
        }
        else{
            [weakSelf.tmpCollertionView.mj_footer endRefreshing];
            weakSelf.page--;
            [ViewHelps showHUDWithText:responseObject[@"message"]];
        }
        if (weakSelf.dataArr.count < weakSelf.page *10) {
            [weakSelf.tmpCollertionView.mj_footer endRefreshingWithNoMoreData];
        }
        else{
            [weakSelf.tmpCollertionView.mj_footer endRefreshing];
        }
        [weakSelf.tmpCollertionView reloadData];
    } failure:^(NSError * _Nullable error) {
        [weakSelf.tmpCollertionView.mj_footer endRefreshing];
        weakSelf.page--;
        [MBProgressHUD hideHUDForView:self animated:YES];
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
        [_tmpCollertionView registerClass:[PhotoCollectionViewCell class] forCellWithReuseIdentifier:@"MyCollectPhotoView"];
    }
    return _tmpCollertionView;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    
    return self.dataArr.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    PhotoCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"MyCollectPhotoView" forIndexPath:indexPath];
    
    if (indexPath.item < self.dataArr.count) {
        MyPhotoModel *model  = self.dataArr[indexPath.item];
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
    self.push(VC);
}

/*
 // Only override drawRect: if you perform custom drawing.
 // An empty implementation adversely affects performance during animation.
 - (void)drawRect:(CGRect)rect {
 // Drawing code
 }
 */

@end
