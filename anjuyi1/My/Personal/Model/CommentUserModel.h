//
//  CommentUserModel.h
//  anjuyi1
//
//  Created by apple on 2018/7/25.
//  Copyright © 2018年 lsy. All rights reserved.
//

#import "BaseModel.h"

@interface CommentUserModel : BaseModel
/** "user_id":23,
 "nick_name":"日常",
 "head":"http://image.sundablog.com/e1d7ea695a6e4d43b14ef99eccf759f4.jpg",
 "level":"名家汇",
 "position":"室内设计师"*/

@property (nonatomic,copy)NSString *user_id;
@property (nonatomic,copy)NSString *nick_name;
@property (nonatomic,copy)NSString *head;
@property (nonatomic,copy)NSString *level;
@property (nonatomic,copy)NSString *position;


@end
