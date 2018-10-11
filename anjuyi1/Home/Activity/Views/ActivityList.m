//
//  ActivityList.m
//  anjuyi1
//
//  Created by apple on 2018/8/7.
//  Copyright © 2018年 lsy. All rights reserved.
//

#import "ActivityList.h"
#import "PhotoCollectionViewCell.h"
#import "LSYCollerctionViewLayout.h"
#import "MyPhotoModel.h"

@interface ActivityList ()<UICollectionViewDelegate,UICollectionViewDataSource,LSYCollerctionViewLayoutDelegate>

@property (nonatomic,strong) UICollectionView    * tmpCollectionView;
@property (nonatomic,strong) NSMutableArray      * dataArr;
@property (nonatomic,assign) NSInteger             type;
@property (nonatomic,strong) NSString            * activity_id;
@end
@implementation ActivityList

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self == [super initWithFrame:frame]) {
        [self addSubview:self.tmpCollectionView];
        
//        [self load];
    }
    return self;
}
- (void)setDataWitIndex:(NSInteger)index withActivityid:(NSString *)activity_id{
    self.type = index;
    self.activity_id = activity_id;
    [self.dataArr removeAllObjects];
    [self getData];
    
}


- (NSMutableArray *)dataArr{
    
    if (!_dataArr) {
        _dataArr = [NSMutableArray array];
    }
    return _dataArr;
}

- (void)getData{
    
    NSString *path = [NSString stringWithFormat:@"%@/Activity/get_image_list",KURL];
    
    NSDictionary *dic = @{@"type":[NSString stringWithFormat:@"%ld",(long)self.type],@"activity_id":self.activity_id};
    
    __weak typeof(self) weakSelf = self;
    
    [HttpRequest POST:path parameters:dic success:^(id  _Nullable responseObject) {
        
        if ([responseObject[@"code"] integerValue] == 200) {
            if ([responseObject[@"datas"] isKindOfClass:[NSArray class]]) {
                for (NSDictionary *dic in responseObject[@"datas"]) {
                    
                    MyPhotoModel *model = [[MyPhotoModel alloc] initWithDictionary:dic];
                    model.nick_name =dic[@"member_info"][@"nickname"];
                    model.head =dic[@"member_info"][@"head"];
                    [weakSelf.dataArr addObject:model];
                    
                    
                }
            }
            [weakSelf.tmpCollectionView reloadData];
        }
        else{
            
            [ViewHelps showHUDWithText:responseObject[@"message"]];
        }
        
        [weakSelf.tmpCollectionView reloadData];
    } failure:^(NSError * _Nullable error) {
        
        [RequestSever showMsgWithError:error];
    }];
    
}

#pragma mark -tmpCollectionView
-(UICollectionView *)tmpCollectionView{
    
    if (!_tmpCollectionView) {
        LSYCollerctionViewLayout *layout = [[LSYCollerctionViewLayout alloc] init];
        
        [layout setDelegate:self];
        
        _tmpCollectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, KScreenWidth, self.frame.size.height) collectionViewLayout:layout];
        [_tmpCollectionView setBackgroundColor:[UIColor whiteColor]];
        [_tmpCollectionView setDelegate:self];
        [_tmpCollectionView setDataSource:self];
        [_tmpCollectionView registerClass:[PhotoCollectionViewCell class] forCellWithReuseIdentifier:@"ActivityList"];
    }
    return _tmpCollectionView;
}
- (CGFloat)waterflowLayout:(LSYCollerctionViewLayout *)waterflowLayout heightForItemAtIndexPath:(NSInteger)index itemWidth:(CGFloat)itemWidth{
    
    return (KScreenWidth-30)/2.0 /( 170/113.0f)+90;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    
    return self.dataArr.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    PhotoCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"ActivityList" forIndexPath:indexPath];
    
    if (indexPath.row <self.dataArr.count) {
    
        [cell bandDataWithModel:self.dataArr[indexPath.row]];
    }

    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    
    if (indexPath.row < self.dataArr.count) {
    
        MyPhotoModel *model = self.dataArr[indexPath.row];
        
        [self.delegate selectPhotoToShow:model.ID];
    }
    
    
}

- (void)refreFrame{
    
    [self.tmpCollectionView setFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];
}


-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    
    [self.delegate backViewScroll:scrollView.contentOffset.y];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
