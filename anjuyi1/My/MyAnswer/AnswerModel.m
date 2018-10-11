//
//  AnswerModel.m
//  anjuyi1
//
//  Created by apple on 2018/10/11.
//  Copyright © 2018年 lsy. All rights reserved.
//

#import "AnswerModel.h"

@implementation AnswerModel

- (void)setValue:(id)value forKey:(NSString *)key{
    if ([key isEqualToString:@"id"]) {
        self.ID = value;
    }
    else{
        [super setValue:value forKey:key];
    }
}

@end
