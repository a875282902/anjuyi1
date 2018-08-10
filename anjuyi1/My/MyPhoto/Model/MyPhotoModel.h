//
//  MyPhotoModel.h
//  anjuyi1
//
//  Created by apple on 2018/7/26.
//  Copyright © 2018年 lsy. All rights reserved.
//

#import "BaseModel.h"

@interface MyPhotoModel : BaseModel
/**"id": 1713,
 "cover": "http://image.sundablog.com/18a25baddf154aae82b2ef79475db9f5.jpg",
 "text": "Fuj",
 "head": "http://image.sundablog.com/d247760d63c643b98885558dc7859860.jpg",
 "nick_name": "123",
 "collect_num": "0"*/

@property (nonatomic,copy)NSString *ID;
@property (nonatomic,copy)NSString *cover;
@property (nonatomic,copy)NSString *text;
@property (nonatomic,copy)NSString *head;
@property (nonatomic,copy)NSString *nick_name;
@property (nonatomic,copy)NSString *collect_num;
@property (nonatomic,copy)NSString *userId;

@end
