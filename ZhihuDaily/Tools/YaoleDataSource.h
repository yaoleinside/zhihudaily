//
//  YaoleDataSource.h
//  ZhihuDaily
//
//  Created by 姚乐 on 16/10/14.
//  Copyright © 2016年 yaole. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Story.h"

@interface YaoleDataSource : NSObject

+(instancetype)sharedDataSource;

-(void)getStoriesWithDate:(NSString*)date success:(void(^)(NSArray* stories))success failure:(void(^)(void))failure;

-(void)getTopStories:(void(^)(NSArray* stories,NSArray* topStories,NSString* lastDate))success failure:(void(^)(void))failure;

-(void)getStory:(NSString *)iid success:(void(^)(Story* Story))success failure:(void(^)(void))failure;

@end
