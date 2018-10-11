//
//  AnswerModel.h
//  anjuyi1
//
//  Created by apple on 2018/10/11.
//  Copyright © 2018年 lsy. All rights reserved.
//

#import "BaseModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface AnswerModel : BaseModel
/**d":33,
 "topic_id":13,
 "content":"阿斯达所大所多",
 "add_time":"2018-08-04 15:04:12",
 "topic_title":"阿斯达所大所多",
 "collect_num":1,
 "zan_num":1*/
@property (nonatomic,copy) NSString *ID;
@property (nonatomic,copy) NSString *topic_id;
@property (nonatomic,copy) NSString *content;
@property (nonatomic,copy) NSString *add_time;
@property (nonatomic,copy) NSString *topic_title;
@property (nonatomic,copy) NSString *collect_num;
@property (nonatomic,copy) NSString *zan_num;

@end

NS_ASSUME_NONNULL_END
