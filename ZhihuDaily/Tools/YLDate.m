//
//  YLDate.m
//  ZhihuDaily
//
//  Created by 姚乐 on 16/10/9.
//  Copyright © 2016年 yaole. All rights reserved.
//

#import "YLDate.h"

@implementation YLDate

+(NSString*)stringFromDate:(NSDate *)date{
    NSDateFormatter *df = [[NSDateFormatter alloc]init];
    df.dateFormat = @"yyyyMMdd";
    return [df stringFromDate:date];
}
+(NSString *)stringFromNowDate:(NSInteger)index {
    NSDateFormatter *df = [[NSDateFormatter alloc]init];
    df.dateFormat = @"yyyyMMdd";
    NSDate *date = [[NSDate date] dateByAddingTimeInterval:-index * 60 * 60 *24];
    return [self stringFromDate:date];
}

@end
