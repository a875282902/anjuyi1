//
//  HouseInfoViewController.h
//  anjuyi1
//
//  Created by apple on 2018/7/17.
//  Copyright © 2018年 lsy. All rights reserved.
//

#import "BaseViewController.h"

@interface HouseInfoViewController : BaseViewController

//type == 2 为从个人中心过来的
@property (nonatomic,assign)NSInteger type;

@property (nonatomic,strong)NSString *house_id;

@end
