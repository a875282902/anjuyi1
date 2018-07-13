//
//  ProjectAddressViewController.h
//  anjuyi1
//
//  Created by apple on 2018/7/13.
//  Copyright © 2018年 lsy. All rights reserved.
//

#import "BaseViewController.h"

@protocol ProjectAddressViewControllerDelegate <NSObject>

- (void)sureProvince:(NSDictionary *)province city:(NSDictionary *)city area:(NSDictionary *)area;

@end

@interface ProjectAddressViewController : BaseViewController

@property (nonatomic,weak)id<ProjectAddressViewControllerDelegate>delegate;

@end
