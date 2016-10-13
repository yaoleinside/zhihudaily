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
    
    if ([[NSFileManager defaultManager]fileExistsAtPath:[self filePath]]) {
        NSDictionary *dic = [NSDictionary dictionaryWithContentsOfFile:[self filePath]];
        if (dic[date]) {
            NSDictionary* dayDic = dic[date];
            success([self storiesWithArr:dayDic[@"stories"]]);
            return;
        }
    }

    NSString* urlString = [NewsURL stringByAppendingString:date];
    [self GET:urlString parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
         {
            success([self storiesWithArr:responseObject[@"stories"]]);
             [self writeToFile:responseObject forKeyPath:date];
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
        /*
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
         */
        NSString* lastDate = responseObject[@"date"];
        success([self storiesWithArr:responseObject[@"stories"]],[self storiesWithArr:responseObject[@"top_stories"]],lastDate);
        [self writeToFile:lastDate forKeyPath:@"lastDate"];
        [self writeToFile:responseObject[@"stories"] forKeyPath:@"stories"];
        [self writeToFile:responseObject[@"top_stories"] forKeyPath:@"top_stories"];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        if ([[NSFileManager defaultManager]fileExistsAtPath:[self filePath]]) {
            NSDictionary *responseObject = [NSDictionary dictionaryWithContentsOfFile:[self filePath]];
            success([self storiesWithArr:responseObject[@"stories"]],[self storiesWithArr:responseObject[@"top_stories"]],responseObject[@"lastDate"]);
            }
        
        failure();
    }];

}

-(NSMutableArray*)storiesWithArr:(NSArray*)arr{
    NSMutableArray* tempArr = [NSMutableArray array];
    for (NSDictionary* dic in arr) {
        Stories* st = [Stories StoriesWithDict:dic];
        [tempArr addObject:st];
    }
    return tempArr;
}

#pragma mark - 获取沙盒路径
-(NSString*)filePath {
    NSString *docPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)lastObject];
    return [docPath stringByAppendingString:@"/data.plist"];
}

-(void)writeToFile:(NSDictionary*)responseObject forKeyPath:(NSString*)KeyPath {
    if (![[NSFileManager defaultManager]fileExistsAtPath:[self filePath]]) {
        NSMutableDictionary* dic = [NSMutableDictionary dictionary];
        [dic setValue:responseObject forKeyPath:KeyPath];
        [dic writeToFile:[self filePath] atomically:YES];
    } else {
        NSDictionary *dic = [NSDictionary dictionaryWithContentsOfFile:[self filePath]];
        [dic setValue:responseObject forKeyPath:KeyPath];
        [dic writeToFile:[self filePath] atomically:YES];

    }
}


@end
