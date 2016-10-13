//
//  Stories.m
//  ZhihuDaily
//
//  Created by 姚乐 on 16/10/8.
//  Copyright © 2016年 yaole. All rights reserved.
//

#import "Stories.h"

@implementation Stories

-(instancetype)initWithDict:(NSDictionary *)dict{
    if(self=[super init]){
        self.title = dict[@"title"];
        self.iid = dict[@"id"];
        self.ga_prefix = dict[@"ga_prefix"];
        self.type = dict[@"type"];
        self.images = dict[@"images"][0];
        self.image = dict[@"image"];
    }
    return self;
}

+(instancetype)StoriesWithDict:(NSDictionary *)dict{
    return [[self alloc]initWithDict:dict];
}

@end
