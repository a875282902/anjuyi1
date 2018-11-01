//
//  LabelViewController.h
//  anjuyi1
//
//  Created by apple on 2018/7/13.
//  Copyright © 2018年 lsy. All rights reserved.
//

#import "BaseViewController.h"

@interface LabelViewController : BaseViewController

@property (nonatomic,copy)void(^sureSelectLabel)(NSArray * labelArr);

@property (nonatomic,strong) NSArray *sureBtnLabel;

@end
