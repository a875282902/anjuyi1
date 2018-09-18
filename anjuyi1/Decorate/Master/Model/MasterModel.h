//
//  MasterModel.h
//  anjuyi1
//
//  Created by apple on 2018/9/17.
//  Copyright © 2018年 lsy. All rights reserved.
//

#import "BaseModel.h"

@interface MasterModel : BaseModel
/* "user_id":25,
 "head":"http://image.sundablog.com/17aea44023054e6b925da4c47e0eba42.jpg",
 "nickname":"哈哈几个咯",
 "guestLow":11,
 "guestHigh":25,
 "image_list":[*/

@property (nonatomic,copy) NSString * user_id;
@property (nonatomic,copy) NSString * head;
@property (nonatomic,copy) NSString * nickname;
@property (nonatomic,copy) NSString * guestLow;
@property (nonatomic,copy) NSString * guestHigh;
@property (nonatomic,copy) NSArray  * image_list;
@property (nonatomic,copy) NSString * type;

@end
