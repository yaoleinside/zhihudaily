//
//  APIRequest.h
//  zhihudaily
//
//  Created by 姚乐 on 16/10/8.
//  Copyright © 2016年 yaole. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface APIRequest : NSObject

+(void)requestWithURL:(NSString *)URL;
+(void)requestWithURL:(NSString *)URL completion:(void(^)(id data))completion;
+(NSDictionary *)ObjToDic:(id)obj;

@end
