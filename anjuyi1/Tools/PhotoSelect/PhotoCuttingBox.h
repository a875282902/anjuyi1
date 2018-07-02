//
//  PhotoCuttingBox.h
//  photoSelect
//
//  Created by apple on 2018/6/27.
//  Copyright © 2018年 apple. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Photos/Photos.h>

@interface PhotoCuttingBox : UIView

- (instancetype)initWithFrame:(CGRect)frame withIsClip:(BOOL)isClip WithSize:(CGSize)clipSize;

- (void)changeImage:(UIImage *)image;

@end
