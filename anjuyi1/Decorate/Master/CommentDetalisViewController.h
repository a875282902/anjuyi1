//
//  CommentDetalisViewController.h
//  anjuyi1
//
//  Created by apple on 2018/9/19.
//  Copyright © 2018年 lsy. All rights reserved.
//

#import "BaseViewController.h"

@interface CommentDetalisViewController : BaseViewController
@property (nonatomic,strong)NSString * eva_id;

/**
 * 1 图片 2 整屋 3 项目
 **/
@property (nonatomic,assign)NSInteger  type;
@end
