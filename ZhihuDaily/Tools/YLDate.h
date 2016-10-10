//
//  YLDate.h
//  ZhihuDaily
//
//  Created by 姚乐 on 16/10/9.
//  Copyright © 2016年 yaole. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface YLDate : NSObject

+(NSString*)stringFromDate:(NSDate*)date;
+(NSString*)stringFromNowDate:(NSInteger)index;
+(NSDate*)dateFromString:(NSString*)aString;

@end
