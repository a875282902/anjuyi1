//
//  ActivityModel.h
//  anjuyi1
//
//  Created by apple on 2018/8/7.
//  Copyright © 2018年 lsy. All rights reserved.
//

#import "BaseModel.h"

@interface ActivityModel : BaseModel

/**id":1,
 "title":"aaa",
 "img":"http://image.sundablog.com/c6a98a78551540bf842b7d0b430a4fd9.jpg",
 "user_list":*/

@property (nonatomic,copy)NSString *ID;
@property (nonatomic,copy)NSString *title;
@property (nonatomic,copy)NSString *img;
@property (nonatomic,copy)NSString *user_num;
@property (nonatomic,copy)NSArray  *user_list;

@end
