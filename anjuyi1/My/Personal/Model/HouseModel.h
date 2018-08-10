//
//  HouseModel.h
//  anjuyi1
//
//  Created by apple on 2018/7/25.
//  Copyright © 2018年 lsy. All rights reserved.
//

#import "BaseModel.h"

@interface HouseModel : BaseModel

/**"id":1,
 "door":"一室",
 "proportion":1,
 "head":"http://image.sundablog.com/e1d7ea695a6e4d43b14ef99eccf759f4.jpg",
 "nick_name":"马骋",
 "title":null,
 "cover":null*/

@property (nonatomic,copy)NSString *ID;
@property (nonatomic,copy)NSString *door;
@property (nonatomic,copy)NSString *proportion;
@property (nonatomic,copy)NSString *head;
@property (nonatomic,copy)NSString *nick_name;
@property (nonatomic,copy)NSString *title;
@property (nonatomic,copy)NSString *cover;
@property (nonatomic,copy)NSDictionary *member_info;

@end
