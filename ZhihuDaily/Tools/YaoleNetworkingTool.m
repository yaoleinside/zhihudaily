//
//  YaoleNetworkingTool.m
//  ZhihuDaily
//
//  Created by 姚乐 on 16/10/13.
//  Copyright © 2016年 yaole. All rights reserved.
//

#import "YaoleNetworkingTool.h"

@implementation YaoleNetworkingTool

+(instancetype)shardNetworkingTool {
    static YaoleNetworkingTool* tool = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        tool = [[YaoleNetworkingTool alloc]init];
        tool.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"text/plain" ,@"application/json", @"text/json", @"text/javascript", nil];
    });
    return tool;
}

/*
    取出date这天的stories
 */
-(void)loadDataWithDate:(NSString *)date success:(void (^)(NSArray *))success failure:(void (^)(void))failure {
    

    NSString* urlString = [NewsURL stringByAppendingString:date];
    [self GET:urlString parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
         {
            NSArray* arr = responseObject[@"stories"];
            NSMutableArray* tempArr = [NSMutableArray array];
            for (NSDictionary* dic in arr) {
                Stories* st = [Stories StoriesWithDict:dic];
                [tempArr addObject:st];
            }
            success(tempArr);
        }
   
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        failure();
    }];
    
}

/*
 取出last和TopStoreis
 */
-(void)loadDataTopStories:(void(^)(NSArray* stories,NSArray* topStories,NSString* lastDate))success failure:(void(^)(void))failure; {
    [self GET:lastNewsURL parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSMutableArray* stories = [NSMutableArray array];
        NSMutableArray* topStories = [NSMutableArray array];
        NSArray* arr = responseObject[@"stories"];
        for (NSDictionary* dic in arr) {
            Stories* st = [Stories StoriesWithDict:dic];
            [stories addObject:st];
        }
        arr = responseObject[@"top_stories"];
        for (NSDictionary* dic in arr) {
            Stories* st = [Stories StoriesWithDict:dic];
            [topStories addObject:st];
        }
        NSString* lastDate = responseObject[@"date"];
        success(stories,topStories,lastDate);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        failure();
    }];

}

@end
