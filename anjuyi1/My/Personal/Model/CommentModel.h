//
//  CommentModel.h
//  anjuyi1
//
//  Created by apple on 2018/7/25.
//  Copyright © 2018年 lsy. All rights reserved.
//

#import "BaseModel.h"

@interface CommentModel : BaseModel
/**"commit_id":1,
 "member_info":{
 "user_id":23,
 "nick_name":"日常",
 "head":"http://image.sundablog.com/e1d7ea695a6e4d43b14ef99eccf759f4.jpg",
 "level":"名家汇",
 "position":"室内设计师"
 },
 "content":"大萨达撒多撒",
 "create_time":"2018年07月16日 13:41",
 "reply_name":null*/

@property (nonatomic,copy)NSString *commit_id;
@property (nonatomic,copy)NSDictionary *member_info;
@property (nonatomic,copy)NSString *content;
@property (nonatomic,copy)NSString *create_time;
@property (nonatomic,copy)NSString *reply_name;

@end
