//
//  MyCollectView.h
//  anjuyi1
//
//  Created by apple on 2018/8/6.
//  Copyright © 2018年 lsy. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseViewController.h"

@interface MyCollectView : UIView

@property (nonatomic,assign)NSInteger index;
@property (nonatomic,copy) void (^push)(BaseViewController *vc);
@end
