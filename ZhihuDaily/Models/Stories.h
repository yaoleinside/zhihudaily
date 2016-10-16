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
@property (nonatomic,assign)NSInteger iid;
@property (nonatomic,copy)NSString *type;
@property (nonatomic,copy)NSString *title;
@property (nonatomic,copy)NSString *images;
@property (nonatomic,copy)NSString *image;

-(instancetype)initWithDict:(NSDictionary*)dict ;
+(instancetype)StoriesWithDict:(NSDictionary*)dict;

@end
