//
//  HomeModel.h
//  anjuyi1
//
//  Created by 李 on 2018/5/29.
//  Copyright © 2018年 lsy. All rights reserved.
//

#import "BaseModel.h"

@interface HomeModel : BaseModel

/**
 house_case: "http://image.sundablog.com/e1d7ea695a6e4d43b14ef99eccf759f4.jpg",
 topic_img: "http://image.sundablog.com/5a4d221911eb4bbca470107234fcf9df.jpg",
 activity_img: "http://image.sundablog.com/0177c47ec51c4c278b86575345682e07.png",
 warehouse_img: "http://image.sundablog.com/d6cc38cf1eab4237bc4033e319a6954d.png",
 charging_pile: "http://image.sundablog.com/1d57a7e3382b4716bc83ef6241b9f697.png",
 owned_store: "http://image.sundablog.com/11610e6cb83d4deab00ed7dcb1b73a13.png",
 */

@property (nonatomic,copy)NSString *house_case;
@property (nonatomic,copy)NSString *topic_img;
@property (nonatomic,copy)NSString *activity_img;
@property (nonatomic,copy)NSString *warehouse_img;
@property (nonatomic,copy)NSString *charging_pile;
@property (nonatomic,copy)NSString *owned_store;


@end
