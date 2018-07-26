//
//  SelectLocationVC.h
//  anjuyi1
//
//  Created by apple on 2018/6/14.
//  Copyright © 2018年 lsy. All rights reserved.
//

#import "BaseViewController.h"

@protocol SelectLocationVCDelegate <NSObject>

- (void)sureProvince:(NSDictionary *)province city:(NSDictionary *)city area:(NSDictionary *)area;

@end

@interface SelectLocationVC : BaseViewController

@property (nonatomic,weak)id<SelectLocationVCDelegate>delegate;

@end
