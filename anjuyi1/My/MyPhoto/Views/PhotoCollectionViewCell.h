//
//  PhotoCollectionViewCell.h
//  anjuyi1
//
//  Created by 李 on 2018/6/3.
//  Copyright © 2018年 lsy. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MyPhotoModel.h"

@interface PhotoCollectionViewCell : UICollectionViewCell
@property (nonatomic,strong)UIButton       *   collectButton;
@property (nonatomic,copy)void(^selectPhotoToCollect)(UIButton *collectButotn);
- (void)bandDataWithModel:(MyPhotoModel *)model;

@end
