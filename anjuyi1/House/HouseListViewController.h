//
//  HouseListViewController.h
//  anjuyi1
//
//  Created by apple on 2018/9/27.
//  Copyright © 2018年 lsy. All rights reserved.
//

#import "BaseViewController.h"

@interface HouseListViewController : BaseViewController
@property (nonatomic,strong)NSString *user_id;
/**
 怎么进来的 YES是 模态窗口  NO push
 */
@property (nonatomic,assign)BOOL isPresent;
@end
