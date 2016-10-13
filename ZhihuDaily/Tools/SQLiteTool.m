//
//  SQLiteTool.m
//  ZhihuDaily
//
//  Created by 姚乐 on 16/10/13.
//  Copyright © 2016年 yaole. All rights reserved.
//

#import "SQLiteTool.h"

@implementation SQLiteTool

+(instancetype)sharedSQLiteTool {
    static SQLiteTool *tool = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        tool = [[SQLiteTool alloc]init];
    });
    return tool;
}

static sqlite3 *_db;
+(void)initialize {
    //获取沙盒路径
    NSString* documentPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
    NSString* filePath = [documentPath stringByAppendingString:@"/stories.sqlite"];
    
    sqlite3_open(filePath.UTF8String,&_db);
    NSString* sql = @"CREATE TABLE IF NOT EXISTS t_stories(id INTEGER PRIMARY KEY AUTOINCREMENT,dic BLOB,adate TEXT,datelen INTEGER);";
    sqlite3_exec(_db, sql.UTF8String, NULL, NULL, NULL);
    
}

-(void)insertStories:(NSDictionary*)dic withDate:(NSString*)date {
    
    NSData* data = [NSJSONSerialization dataWithJSONObject:dic options:NSJSONWritingPrettyPrinted error:nil] ;
    NSInteger len = [data length];
    NSString* sql = [NSString stringWithFormat:@"INSERT INTO t_stories(adate,dic,datelen) VALUES(%@,'%@',%ld);",date,[data bytes],(long)len];
    int success = sqlite3_exec(_db, sql.UTF8String, NULL, NULL, NULL);
    if (success != SQLITE_OK) NSLog(@"xxieruerror");
}

-(NSArray *)StoriesWithDate:(NSString *)date{
    sqlite3_stmt *stmt;
    NSString* sql = [NSString stringWithFormat:@"SELECT * FROM t_stories WHERE adate = %@;",date];
    int success = sqlite3_prepare(_db, sql.UTF8String, -1, &stmt, NULL);
    if (success != SQLITE_OK) return nil;
    NSMutableArray *arr = [NSMutableArray array];
    while (sqlite3_step(stmt)==SQLITE_ROW) {
        NSLog(@"有数据");
        NSInteger len = sqlite3_column_int(stmt, 3);
        NSData *adata = [[NSData alloc] initWithBytes:sqlite3_column_blob(stmt, 1) length: len];
        NSError *error;
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:adata options:NSJSONReadingMutableContainers error:&error];
        NSLog(@"%@",error);
        [arr addObject:dic];
    }
    return arr;
}

@end
