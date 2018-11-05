//
//  MyPushHouseDetailsViewController.h
//  anjuyi1
//
//  Created by apple on 2018/7/25.
//  Copyright © 2018年 lsy. All rights reserved.
//

#import "BaseViewController.h"

@interface MyPushHouseDetailsViewController : BaseViewController
/**
 *  该页面是否存在编辑
 **/
@property (nonatomic,assign)BOOL isEdit;
@property (nonatomic,strong)NSString *house_id;

@end
