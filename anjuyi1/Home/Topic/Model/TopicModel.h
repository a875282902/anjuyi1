//
//  TopicModel.h
//  anjuyi1
//
//  Created by apple on 2018/8/10.
//  Copyright © 2018年 lsy. All rights reserved.
//

#import "BaseModel.h"

@interface TopicModel : BaseModel


@property (nonatomic,copy)NSString *ID;
@property (nonatomic,copy)NSString *title;
@property (nonatomic,copy)NSString *content;
@property (nonatomic,copy)NSString *reply_count;
@property (nonatomic,copy)NSArray  *user_list;
@property (nonatomic,copy)UIColor  *backColor;

@end
