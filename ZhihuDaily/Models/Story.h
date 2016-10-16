//
//  Story.h
//  ZhihuDaily
//
//  Created by 姚乐 on 16/10/10.
//  Copyright © 2016年 yaole. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Story : NSObject
@property (assign, nonatomic) NSUInteger iid;
@property (assign, nonatomic) NSInteger type;
@property (copy, nonatomic) NSString* css;
@property (copy, nonatomic) NSString* body;
@property (copy, nonatomic) NSString* title;
@property (copy, nonatomic) NSString* image;
@property (copy, nonatomic) NSString* imageSource;

- (instancetype)initWithDic:(NSDictionary*)dic;
+ (instancetype)storyWithDic:(NSDictionary*)dic;
@end
