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
static NSString *const StoryURL = @"http://news-at.zhihu.com/api/4/news/";

@interface YaoleNetworkingTool : AFHTTPSessionManager




+(instancetype)shardNetworkingTool;

-(void)loadDataWithDate:(NSString*)date success:(void(^)(id   responseObject))success failure:(void(^)(void))failure;

-(void)loadDataTopStories:(void(^)(id   responseObject))success failure:(void(^)(void))failure;

-(void)loadStoryData:(NSString*)iid success:(void(^)(id responseObject))success failure:(void(^)(void))failure;

@end
