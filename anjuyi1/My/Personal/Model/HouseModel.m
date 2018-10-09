//
//  HouseModel.m
//  anjuyi1
//
//  Created by apple on 2018/7/25.
//  Copyright © 2018年 lsy. All rights reserved.
//

#import "HouseModel.h"

@implementation HouseModel

- (void)setValue:(id)value forKey:(NSString *)key{
    
    if ([key isEqualToString:@"id"]) {
        self.ID = value;
    }
    else if ([key isEqualToString:@"house_own_info"] )
    {
        self.member_info = value;
    }
    else{
        
        [super setValue:value forKey:key];
    }
}

@end
