//
//  DBManager.m
//  anjuyi1
//
//  Created by apple on 2018/7/26.
//  Copyright © 2018年 lsy. All rights reserved.
//

#import "DBManager.h"
#import <FMDatabase.h>

@interface DBManager ()
@property (nonatomic,strong) FMDatabase *db;
@end

@implementation DBManager

-(FMDatabase *)db{
    
    if (!_db) {
        //FMDB数据是创建在Document文件夹里
        NSString *filePath = [[NSBundle mainBundle] pathForResource:@"city" ofType:@"db"];
        
        //获取数据库对象并创建数据库文件
        _db = [FMDatabase databaseWithPath:filePath];
        
        [_db open];
        
    }
    return _db;
}

//查询数据
- (NSArray *)searchDataBaseWithSuperId:(NSString *)upid{
   
    FMResultSet *resultSet = [self.db executeQuery:@"select * from ajy_ocenter_district where upid = (?)",upid];
    
    NSMutableArray *dataArr = [NSMutableArray array];
    
    while ([resultSet next]) {
        
        NSString *key = [resultSet stringForColumn:@"id"];
        NSString *value = [resultSet stringForColumn:@"name"];
        
        [dataArr addObject:@{@"key":key,@"value":value}];
        
    }
    
    return dataArr;
}



@end
