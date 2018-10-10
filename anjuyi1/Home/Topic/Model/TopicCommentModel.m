//
//  TopicCommentModel.m
//  anjuyi1
//
//  Created by apple on 2018/8/10.
//  Copyright © 2018年 lsy. All rights reserved.
//

#import "TopicCommentModel.h"

@implementation TopicCommentModel

- (instancetype)initWithDictionary:(NSDictionary *)dic{
    
    if (self == [super initWithDictionary:dic]) {
        
        self.isShow = NO;
        self.isAuthor = NO;
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
