//
//  TopicModel.m
//  anjuyi1
//
//  Created by apple on 2018/8/10.
//  Copyright © 2018年 lsy. All rights reserved.
//

#import "TopicModel.h"

@implementation TopicModel

- (instancetype)initWithDictionary:(NSDictionary *)dic{
    
    if (self == [super initWithDictionary:dic]) {
        NSArray *arr = @[[UIColor colorWithHexString:@"#62afd3"],
                         [UIColor colorWithHexString:@"#8f8e94"],
                         [UIColor colorWithHexString:@"#d3a25d"],
                         [UIColor colorWithHexString:@"#ad544b"],
                         [UIColor colorWithHexString:@"#57aa63"]];
        
        self.backColor = arr[arc4random()%5];
    }
    return self;
}

- (void)setValue:(id)value forKey:(NSString *)key{
    
    if ([key isEqualToString:@"id"]) {
        self.ID = value;
    }
    else{
        [super setValue:value forKey:key];
    }
}

@end
