//
//  YaoleNetworkingTool.h
//  ZhihuDaily
//
//  Created by 姚乐 on 16/10/13.
//  Copyright © 2016年 yaole. All rights reserved.
//

#import <Foundation/Foundation.h>


static NSString *const lastNewsURL = @"http://news-at.zhihu.com/api/4/news/latest";
static NSString *const NewsURL = @"http://news.at.zhihu.com/api/4/news/before/";

@interface YaoleNetworkingTool : AFHTTPSessionManager




+(instancetype)shardNetworkingTool;

-(void)loadDataWithDate:(NSString*)date success:(void(^)(NSArray* stories))success failure:(void(^)(void))failure;

-(void)loadDataTopStories:(void(^)(NSArray* stories,NSArray* topStories,NSString* lastDate))success failure:(void(^)(void))failure;



@end
