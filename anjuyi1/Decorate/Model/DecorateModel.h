//
//  DecorateModel.h
//  anjuyi1
//
//  Created by apple on 2018/8/7.
//  Copyright © 2018年 lsy. All rights reserved.
//

#import "BaseModel.h"

@interface DecorateModel : BaseModel
/**"whole_hosue_id":1,
 "cover":null,
 "title":null,
 "said":null,
 "house_own_info":*/

@property (nonatomic,copy)NSString *whole_hosue_id;
@property (nonatomic,copy)NSString *cover;
@property (nonatomic,copy)NSString *title;
@property (nonatomic,copy)NSString *said;
@property (nonatomic,copy)NSDictionary *house_own_info;
@end
