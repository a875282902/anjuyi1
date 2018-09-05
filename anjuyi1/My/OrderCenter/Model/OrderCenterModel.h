//
//  OrderCenterModel.h
//  anjuyi1
//
//  Created by apple on 2018/9/5.
//  Copyright © 2018年 lsy. All rights reserved.
//

#import "BaseModel.h"

@interface OrderCenterModel : BaseModel

/**"id":1,
 "type":"家装",
 "budget":"1010万",
 "room":"两室",
 "hall":"三厅"*/

@property (nonatomic,copy) NSString *type;
@property (nonatomic,copy) NSString *budget;
@property (nonatomic,copy) NSString *room;
@property (nonatomic,copy) NSString *hall;
@property (nonatomic,copy) NSString *ID;

@end
