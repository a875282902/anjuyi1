//
//  MyPhotoModel.m
//  anjuyi1
//
//  Created by apple on 2018/7/26.
//  Copyright © 2018年 lsy. All rights reserved.
//

#import "MyPhotoModel.h"

@implementation MyPhotoModel

- (void)setValue:(id)value forKey:(NSString *)key{
 
    if ([key isEqualToString:@"id"]) {
        self.ID = value;
    }
    else{
        
        [super setValue:value forKey:key];
    }
}

@end
