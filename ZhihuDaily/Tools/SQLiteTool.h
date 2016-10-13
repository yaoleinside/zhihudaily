//
//  SQLiteTool.h
//  ZhihuDaily
//
//  Created by 姚乐 on 16/10/13.
//  Copyright © 2016年 yaole. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <sqlite3.h>

@interface SQLiteTool : NSObject

+(instancetype)sharedSQLiteTool;

-(void)insertStories:(NSDictionary*)dic withDate:(NSString*)date;

-(NSArray*)StoriesWithDate:(NSString*)date;

@end
