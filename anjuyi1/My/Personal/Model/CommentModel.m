//
//  CommentModel.m
//  anjuyi1
//
//  Created by apple on 2018/7/25.
//  Copyright © 2018年 lsy. All rights reserved.
//

#import "CommentModel.h"

@implementation CommentModel
- (void)setValue:(id)value forKey:(NSString *)key{
    
    if ([key isEqualToString:@"id"]) {
        self.commit_id = value;
    }
    else{
        [super setValue:value forKey:key];
    }
}
@end
