//
//  LSYCollerctionViewLayout.h
//  collectionView
//
//  Created by 李 on 16/10/27.
//  Copyright © 2016年 李. All rights reserved.
//

#import <UIKit/UIKit.h>

@class LSYCollerctionViewLayout;

@protocol LSYCollerctionViewLayoutDelegate <NSObject>

@required
/**
 *cell高度
 **/
- (CGFloat)waterflowLayout:(LSYCollerctionViewLayout *)waterflowLayout heightForItemAtIndexPath:(NSInteger)index itemWidth:(CGFloat)itemWidth;

@optional
/**
 *列数
 **/
- (CGFloat)columCountInWaterfolwLayout:(LSYCollerctionViewLayout *)waterflowLayout;
/**
 *列间距
 **/
- (CGFloat)columMarginInWaterfolwLayout:(LSYCollerctionViewLayout *)waterflowLayout;
/**
 *行间距
 **/
- (CGFloat)rowMarginInWaterfolwLayout:(LSYCollerctionViewLayout *)waterflowLayout;
/**
 *边缘间距
 **/
- (UIEdgeInsets)edgeInsetstInWaterfolwLayout:(LSYCollerctionViewLayout *)waterflowLayout;


@end



@interface LSYCollerctionViewLayout : UICollectionViewLayout

@property (nonatomic , weak) id<LSYCollerctionViewLayoutDelegate>delegate;

@end
