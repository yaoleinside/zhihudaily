//
//  YaoleDataSource.m
//  ZhihuDaily
//
//  Created by 姚乐 on 16/10/14.
//  Copyright © 2016年 yaole. All rights reserved.
//

#import "YaoleDataSource.h"
#import "YaoleNetworkingTool.h"

@interface YaoleDataSource()
@property (nonatomic,strong)YaoleNetworkingTool *tool;

@end

@implementation YaoleDataSource

+(instancetype)sharedDataSource {
    static YaoleDataSource *ds = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        ds = [[YaoleDataSource alloc]init];
        ds.tool = [YaoleNetworkingTool shardNetworkingTool];
    });
    return ds;
}


-(void)getStoriesWithDate:(NSString*)date success:(void(^)(NSArray* stories))success failure:(void(^)(void))failure {
    if ([[NSFileManager defaultManager]fileExistsAtPath:[self filePath]]) {
        NSDictionary *dic = [NSDictionary dictionaryWithContentsOfFile:[self filePath]];
        if (dic[date]) {
            NSDictionary* dayDic = dic[date];
            success([self storiesWithArr:dayDic[@"stories"]]);
            return;
        }
    }
    
    [_tool loadDataWithDate:date success:^(id  _Nullable responseObject) {
        success([self storiesWithArr:responseObject[@"stories"]]);
        [self writeToFile:responseObject forKeyPath:date];

    } failure:^{
        failure();
    }];

}

-(void)getTopStories:(void(^)(NSArray* stories,NSArray* topStories,NSString* lastDate))success failure:(void(^)(void))failure {
    
    [_tool loadDataTopStories:^(id  _Nullable responseObject) {
        NSString* lastDate = responseObject[@"date"];
        success([self storiesWithArr:responseObject[@"stories"]],[self storiesWithArr:responseObject[@"top_stories"]],lastDate);
        [self writeToFile:lastDate forKeyPath:@"lastDate"];
        [self writeToFile:responseObject[@"stories"] forKeyPath:@"stories"];
        [self writeToFile:responseObject[@"top_stories"] forKeyPath:@"top_stories"];

    } failure:^{
        if ([[NSFileManager defaultManager]fileExistsAtPath:[self filePath]]) {
            NSDictionary *responseObject = [NSDictionary dictionaryWithContentsOfFile:[self filePath]];
            success([self storiesWithArr:responseObject[@"stories"]],[self storiesWithArr:responseObject[@"top_stories"]],responseObject[@"lastDate"]);
        }
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

-(void)writeToFile:(id)responseObject forKeyPath:(NSString*)KeyPath {
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
