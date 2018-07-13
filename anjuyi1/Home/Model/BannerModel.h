//
//  BannerModel.h
//  anjuyi1
//
//  Created by apple on 2018/7/12.
//  Copyright © 2018年 lsy. All rights reserved.
//

#import "BaseModel.h"

@interface BannerModel : BaseModel

/*id: 7,
 advertisingPositionId: 7,
 picture: "http://image.sundablog.com/90b14607becf49b89922b12a93d996b2.jpg",
 url: ""*/

@property (nonatomic,copy)NSString *ID;
@property (nonatomic,copy)NSString *advertisingPositionId;
@property (nonatomic,copy)NSString *picture;
@property (nonatomic,copy)NSString *url;

@end
