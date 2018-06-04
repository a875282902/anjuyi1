//
//  LSYCollerctionViewLayout.m
//  collectionView
//
//  Created by 李 on 16/10/27.
//  Copyright © 2016年 李. All rights reserved.
//

#import "LSYCollerctionViewLayout.h"

/** 默认列数 **/
static const NSInteger LSYDefaultColumCount = 2;
/** 每一列间距 **/
static const CGFloat LSYDefaultColumMargin = 10;
/** 每一行间距 **/
static const CGFloat LSYDefaultRowMargin = 10;
/** 边缘间距 **/
static const UIEdgeInsets  LSYDefaultEdgeInsets = {10,10,10,10};


@interface LSYCollerctionViewLayout()<UITableViewDelegate>
/** 存放所有cell的布局 **/
@property (nonatomic , strong) NSMutableArray *attsArr;
/** 存放所有列的最大值 **/
@property (nonatomic , strong) NSMutableArray *maxY;

- (CGFloat)rowMargin;
- (CGFloat)columCount;
- (CGFloat)columMargin;
- (UIEdgeInsets)edgeInsetst;

@end

@implementation LSYCollerctionViewLayout

#pragma mark -- 代理方法
- (CGFloat)rowMargin{

    if ([self.delegate respondsToSelector:@selector(rowMarginInWaterfolwLayout:)]) {
        
        return [self.delegate rowMarginInWaterfolwLayout:self];
    }
    else{
    
        return LSYDefaultRowMargin;
    }
}

- (CGFloat)columMargin{
    
    if ([self.delegate respondsToSelector:@selector(columMarginInWaterfolwLayout:)]) {
        
        return [self.delegate columMarginInWaterfolwLayout:self];
    }
    else{
        
        return LSYDefaultColumMargin;
    }
}

- (CGFloat)columCount{
    
    if ([self.delegate respondsToSelector:@selector(columCountInWaterfolwLayout:)]) {
        
        return [self.delegate columCountInWaterfolwLayout:self];
    }
    else{
        
        return LSYDefaultColumCount;
    }
}

- (UIEdgeInsets)edgeInsetst{
    
    if ([self.delegate respondsToSelector:@selector(edgeInsetstInWaterfolwLayout:)]) {
        
        return [self.delegate edgeInsetstInWaterfolwLayout:self];
    }
    else{
        
        return LSYDefaultEdgeInsets;
    }
}


#pragma mark -- 懒加载初始化

- (NSMutableArray *)attsArr{

    if (!_attsArr) {
        
        _attsArr = [NSMutableArray array];
    }
    return _attsArr;
}

- (NSMutableArray *)maxY{

    if (!_maxY) {
        
        _maxY = [NSMutableArray array];
    }
    
    return _maxY;
}

//初始化
-(void)prepareLayout{

    [super prepareLayout];
    
    [self.attsArr removeAllObjects];
    
    [self.maxY removeAllObjects];
    
    for (NSInteger i = 0; i < self.columCount; i ++) {
        
        [self.maxY addObject:@(self.edgeInsetst.top)];
    }
    
    NSInteger count = [self.collectionView numberOfItemsInSection:0];
    
    for (NSInteger i = 0; i < count ; i ++) {
        
        NSIndexPath *indexPath = [NSIndexPath indexPathForItem:i inSection:0];
        //获取indexpath对应的cell的属性
        UICollectionViewLayoutAttributes *att = [self layoutAttributesForItemAtIndexPath:indexPath];
        
        [self.attsArr addObject:att];
    }

}


//决定cell的排布
- (nullable NSArray<__kindof UICollectionViewLayoutAttributes *> *)layoutAttributesForElementsInRect:(CGRect)rect{

    
    return self.attsArr;
    
}

//对应indexpath的cell的布局属性
- (nullable UICollectionViewLayoutAttributes *)layoutAttributesForItemAtIndexPath:(NSIndexPath *)indexPath{

    //创建cell属性
    UICollectionViewLayoutAttributes *atts = [UICollectionViewLayoutAttributes layoutAttributesForCellWithIndexPath:indexPath];
    
    CGFloat collectionW = self.collectionView.frame.size.width;
    
    CGFloat w = (collectionW - self.rowMargin *(self.columCount -1) - self.edgeInsetst.left - self.edgeInsetst.right)/self.columCount;
    
    __block NSInteger minColum = 0;
    
    __block CGFloat minColumHeight = [self.maxY[0] floatValue];
    
    for (NSInteger i = 1; i < self.columCount; i ++) {
        
        if (minColumHeight > [self.maxY[i] floatValue]) {
            
            minColumHeight = [self.maxY[i] floatValue];
            
            minColum = i;
        }
    }
    
    CGFloat x = minColum * (w + self.columMargin) + self.edgeInsetst.left;
    
    CGFloat y = minColumHeight;
    
    if (y != self.edgeInsetst.top) {
        
        y += self.rowMargin;
    }
    
    CGFloat h = [self.delegate waterflowLayout:self heightForItemAtIndexPath:indexPath.item itemWidth:w];
    
    //设置Cell 位置
    atts.frame = CGRectMake(x, y, w, h);
    
    CGFloat getMaxY = CGRectGetMaxY(atts.frame);
    
    self.maxY[minColum] = [NSNumber numberWithFloat:getMaxY];
    
    return atts;
}

- (CGSize)collectionViewContentSize{

    CGFloat max = [self.maxY[0] floatValue];
    
    for (NSInteger i = 1; i < self.columCount; i ++) {
        
        if (max < [self.maxY[i] floatValue]) {
            
            max = [self.maxY[i] floatValue];
        }
    }
    
    return CGSizeMake(0, max + self.edgeInsetst.bottom);
}

@end
