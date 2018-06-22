//
//  FileTools.m
//  anjuyi1
//
//  Created by apple on 2018/6/21.
//  Copyright © 2018年 lsy. All rights reserved.
//

#import "FileTools.h"

@implementation FileTools

+ (BOOL)isFileExit:(NSString *)filePath{
    
    NSFileManager * manager = [NSFileManager defaultManager];
    
    //判断该文件是否存在不存在
    BOOL fileExit = [manager fileExistsAtPath:filePath];
    
    return fileExit;
}

@end
