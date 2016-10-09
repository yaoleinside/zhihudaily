//
//  Stories.h
//  ZhihuDaily
//
//  Created by 姚乐 on 16/10/8.
//  Copyright © 2016年 yaole. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Stories : NSObject

@property (nonatomic,copy)NSString *ga_prefix;
@property (nonatomic,copy)NSString *iid;
@property (nonatomic,copy)NSString *type;
@property (nonatomic,copy)NSString *title;
@property (nonatomic,copy)NSString *images;

-(instancetype)initWithDict:(NSDictionary*)dict ;
+(instancetype)StoriesWithDict:(NSDictionary*)dict;

@end
