//
//  AddressModel.h
//  anjuyi1
//
//  Created by apple on 2018/6/21.
//  Copyright © 2018年 lsy. All rights reserved.
//

#import "BaseModel.h"

@interface AddressModel : BaseModel
/*"id":"20",
 "userName":"马骋",
 "phone":"17600739244",
 "is_default":"1",
 "province":"北京市",
 "city":"北京市",
 "area":"东城区",
 "detail":"阿斯达所多"*/

@property (nonatomic,copy)NSString *ID;
@property (nonatomic,copy)NSString *userName;
@property (nonatomic,copy)NSString *phone;
@property (nonatomic,copy)NSString *is_default;
@property (nonatomic,copy)NSString *province;
@property (nonatomic,copy)NSString *city;
@property (nonatomic,copy)NSString *area;
@property (nonatomic,copy)NSString *detail;

@end
