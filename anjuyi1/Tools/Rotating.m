//
//  Rotating.m
//  mingtu
//
//  Created by 李 on 17/3/4.
//  Copyright © 2017年 李帅营. All rights reserved.
//

#import "Rotating.h"

@implementation Rotating

static Rotating *loginInstance = nil;

+(Rotating *)shareRotating{

    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        loginInstance = [[Rotating alloc] init];
        loginInstance.isflag = NO;
    });
    return loginInstance;
}

@end
