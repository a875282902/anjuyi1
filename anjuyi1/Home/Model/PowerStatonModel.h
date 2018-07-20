//
//  PowerStatonModel.h
//  anjuyi1
//
//  Created by apple on 2018/7/20.
//  Copyright © 2018年 lsy. All rights reserved.
//

#import "BaseModel.h"

@interface PowerStatonModel : BaseModel
/**       "id":3,
 "name":"1234",
 "address":"北京市北七家修正大厦",
 "business":"1234",
 "phone":"1234",
 "ctime":1527073890000,
 "lng":116.37352271692,
 "lat":40.1102308442,
 "distance":"772米",
 "distance_num":772*/

@property (nonatomic,copy)NSString *ID;
@property (nonatomic,copy)NSString *name;
@property (nonatomic,copy)NSString *address;
@property (nonatomic,copy)NSString *business;
@property (nonatomic,copy)NSString *phone;
@property (nonatomic,copy)NSString *ctime;
@property (nonatomic,copy)NSString *lng;
@property (nonatomic,copy)NSString *lat;
@property (nonatomic,copy)NSString *distance;
@property (nonatomic,copy)NSString *distance_num;

@end
