//
//  StrategyModel.h
//  anjuyi1
//
//  Created by apple on 2018/9/29.
//  Copyright © 2018年 lsy. All rights reserved.
//

#import "BaseModel.h"

@interface StrategyModel : BaseModel
/**
 "id":1,
 "img":"http://image.sundablog.com/e1d7ea695a6e4d43b14ef99eccf759f4.jpg",
 "title":"sad大孙达",
 "door":"两居室",
 "member_info":{
 "nick_name":"马骋",
 "head":"http://image.sundablog.com/e1d7ea695a6e4d43b14ef99eccf759f4.jpg"
 }
 */

@property (nonatomic,copy) NSString *ID;
@property (nonatomic,copy) NSString *title;
@property (nonatomic,copy) NSString *img;
@property (nonatomic,copy) NSString *door;
@property (nonatomic,copy) NSDictionary *member_info;
@end
