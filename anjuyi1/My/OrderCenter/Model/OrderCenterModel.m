//
//  OrderCenterModel.m
//  anjuyi1
//
//  Created by apple on 2018/9/5.
//  Copyright © 2018年 lsy. All rights reserved.
//

#import "OrderCenterModel.h"

@implementation OrderCenterModel

- (void)setValue:(id)value forKey:(NSString *)key{
    if ([key isEqualToString:@"id"]) {
        self.ID = value;
    }
    else{
        
        [super setValue:value forKey:key];
    }
}

@end
