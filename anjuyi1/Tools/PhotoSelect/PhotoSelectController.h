//
//  PhotoSelectController.h
//  photoSelect
//
//  Created by apple on 2018/6/26.
//  Copyright © 2018年 apple. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol PhotoSelectControllerDelegate <NSObject>

- (void)selectImage:(UIImage *)image;

@end

@interface PhotoSelectController : UIViewController

@property (nonatomic,weak)id<PhotoSelectControllerDelegate>delegate;

/*
 * 是否剪切 默认为不剪切
 */
@property (nonatomic,assign)BOOL isClip;

/*
 * 剪切范围 剪切状态下才有效
 */
@property (nonatomic,assign)CGSize clipSize;

@end
