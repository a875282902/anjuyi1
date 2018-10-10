//
//  TopicCommentModel.h
//  anjuyi1
//
//  Created by apple on 2018/8/10.
//  Copyright © 2018年 lsy. All rights reserved.
//

#import "BaseModel.h"

@interface TopicCommentModel : BaseModel
/** "id":33,
 "content":"阿斯达所大所多",
 "isBest":1,
 "create_time":"2018年08月04日 15:04",
 "member_info":Object{...},
 "collect_num":0,
 "zan_num":0,
 "is_zan":0,
 "is_collect":0*/
@property (nonatomic,copy)NSString *ID;
@property (nonatomic,copy)NSString *content;
@property (nonatomic,copy)NSString *isBest;
@property (nonatomic,copy)NSString *create_time;
@property (nonatomic,copy)NSDictionary *member_info;
@property (nonatomic,copy)NSString *collect_num;
@property (nonatomic,copy)NSString *zan_num;
@property (nonatomic,copy)NSString *is_zan;
@property (nonatomic,copy)NSString *is_collect;
@property (nonatomic,assign)BOOL   isShow;
@property (nonatomic,assign)BOOL   isShowAllButton;
@property (nonatomic,assign)BOOL   isAuthor;
@end
