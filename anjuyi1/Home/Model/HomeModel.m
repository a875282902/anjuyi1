//
//  HomeModel.m
//  anjuyi1
//
//  Created by 李 on 2018/5/29.
//  Copyright © 2018年 lsy. All rights reserved.
//

#import "HomeModel.h"

@implementation HomeModel

- (void)setValue:(id)value forKey:(NSString *)key{
    
    if ([value isKindOfClass:[NSString class]]) {
        [super setValue:value forKey:key];
    }
    else{
        [super setValue:@"" forKey:key];
    }
    
}

@end
