//
//  BaseModel.m
//  地铁
//
//  Created by 李 on 16/12/5.
//  Copyright © 2016年 李帅营. All rights reserved.
//

#import "BaseModel.h"

@implementation BaseModel

- (instancetype)initWithDictionary:(NSDictionary *)dic{
    
    self = [super init];
    
    if (self) {
        if ([dic isKindOfClass:[NSDictionary class]]) {
            [self setValuesForKeysWithDictionary:dic];
        }
    }
    return self;
}

- (void)setValue:(id)value forKey:(NSString *)key{
    [super setValue:value forKey:key];
}

- (void)setValue:(id)value forUndefinedKey:(NSString *)key{
    
}
@end
