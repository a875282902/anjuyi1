//
//  MyCollectPhotoView.h
//  anjuyi1
//
//  Created by apple on 2018/10/9.
//  Copyright © 2018年 lsy. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseViewController.h"
NS_ASSUME_NONNULL_BEGIN

@interface MyCollectPhotoView : UIView

@property (nonatomic,copy) void (^push)(BaseViewController *vc);

@property (nonatomic,assign)NSInteger index;

@end

NS_ASSUME_NONNULL_END
