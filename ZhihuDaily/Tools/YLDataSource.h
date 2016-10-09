//
//  YLDataSource.h
//  ZhihuDaily
//
//  Created by 姚乐 on 16/10/9.
//  Copyright © 2016年 yaole. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface YLDataSource : NSObject

+(void)initializeDS;
+(NSString *)dataPath;
+(NSString*)filePath;


@property (nonatomic,strong)NSDictionary* lastData;
@property (nonatomic,strong)NSArray *lastStories;
@property (nonatomic,strong)NSArray* dataArray;




@end
