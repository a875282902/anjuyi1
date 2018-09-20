//
//  ProjectModel.h
//  anjuyi1
//
//  Created by apple on 2018/9/18.
//  Copyright © 2018年 lsy. All rights reserved.
//

#import "BaseModel.h"

@interface ProjectModel : BaseModel

/* "id":2,
 "picture":"http://image.sundablog.com/3fd0dced0ae64e2f9abb904ecc772016.jpg",
 "nameregister":"白庙村西街",
 "foreman":{
 "id":23,
 "head":"http://image.sundablog.com/e1d7ea695a6e4d43b14ef99eccf759f4.jpg",
 "nickname":"马骋"
 },
 "room_hall":"一室二厅",
 "areaop":"100",
 "visits":0,
 "zan":"0",
 "complete":2**/


@property (nonatomic,copy) NSString * ID;
@property (nonatomic,copy) NSString * picture;
@property (nonatomic,copy) NSString * nameregister;
@property (nonatomic,copy) NSDictionary * foreman;
@property (nonatomic,copy) NSString * room_hall;
@property (nonatomic,copy) NSArray  * areaop;
@property (nonatomic,copy) NSString * visits;
@property (nonatomic,copy) NSString * zan;
@property (nonatomic,copy) NSString * complete;

@end
