//
//  BrandListView.m
//  anjuyi1
//
//  Created by apple on 2018/6/14.
//  Copyright © 2018年 lsy. All rights reserved.
//

#import "BrandListView.h"

@interface BrandListView ()<UICollectionViewDataSource,UICollectionViewDelegate>

@property (nonatomic,strong)UICollectionView *tmpCollectionView;

@end

@implementation BrandListView

- (instancetype)initWithFrame:(CGRect)frame{
    
    if (self == [super initWithFrame:frame]) {
        
        [self addSubview:self.tmpCollectionView];
    }
    return self;
}

#pragma mark -tmpCollectionView
-(UICollectionView *)tmpCollectionView{
    
    if (!_tmpCollectionView) {
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
        [layout setItemSize:CGSizeMake(50, 70)];
        [layout setSectionInset:UIEdgeInsetsMake(10, 10, 10, 10)];
        
        _tmpCollectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height) collectionViewLayout:layout];
        [_tmpCollectionView setBackgroundColor:[UIColor whiteColor]];
        [_tmpCollectionView setDelegate:self];
        [_tmpCollectionView setDataSource:self];
        [_tmpCollectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:@"BrandListViewCell"];
        [_tmpCollectionView registerClass:[UICollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"BrandListViewHeader"];

    }
    return _tmpCollectionView;
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    
    return 2;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    
    return 15;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"BrandListViewCell" forIndexPath:indexPath];
    
    [cell setBackgroundColor:[UIColor redColor]];
    
    return cell;
}


-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section{
    
    return CGSizeMake(self.frame.size.width, 40);
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath{
    
    NSString *CellIdentifier = @"BrandListViewHeader";
    //从缓存中获取 Headercell
    UICollectionReusableView *header = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:CellIdentifier forIndexPath:indexPath];
    
    [header addSubview:[Tools setLineView:CGRectMake(0, 0, self.frame.size.width, 1)]];
    
    [header addSubview:[Tools creatLabel:CGRectMake(10, 0, self.frame.size.width, 40) font:[UIFont systemFontOfSize:12] color:[UIColor colorWithHexString:@"#3b3b3b"] alignment:(NSTextAlignmentLeft) title:@"分类名字"]];
    
    return header;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    
    [self.delegate selectBrandWithIndex:indexPath.item];
}


/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
