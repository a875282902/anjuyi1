//
//  CommentUserModel.m
//  anjuyi1
//
//  Created by apple on 2018/7/25.
//  Copyright © 2018年 lsy. All rights reserved.
//

#import "CommentUserModel.h"

@implementation CommentUserModel

- (void)setValue:(id)value forKey:(NSString *)key{
    
    if ([key isEqualToString:@"nickname"]) {
        self.nick_name = value;
    }
    else{
        
        [super setValue:value forKey:key];
    }
    
}

@end
