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
-(void)loadDataWithDate:(NSString *)date success:(void (^)(id  _Nullable responseObject))success failure:(void (^)(void))failure {
    

    NSString* urlString = [NewsURL stringByAppendingString:date];
    [self GET:urlString parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
         {
            success(responseObject);
        }
   
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        failure();
    }];
    
}

/*
 取出last和TopStoreis
 */
-(void)loadDataTopStories:(void(^)(id  _Nullable responseObject))success failure:(void(^)(void))failure; {
    [self GET:lastNewsURL parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {

        success(responseObject);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        failure();
    }];

}


-(void)loadStoryData:(NSString *)iid success:(void (^)(id))success failure:(void (^)(void))failure {
//    iid = [NSString stringWithFormat:@"%d",iid];
    
    NSString* urlString = [StoryURL stringByAppendingString:iid];
    [self GET:urlString parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        success(responseObject);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"%@",error);
    }];
}


@end
