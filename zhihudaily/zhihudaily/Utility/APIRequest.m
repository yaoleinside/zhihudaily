//
//  APIRequest.m
//  zhihudaily
//
//  Created by 姚乐 on 16/10/8.
//  Copyright © 2016年 yaole. All rights reserved.
//

#import "APIRequest.h"

@implementation APIRequest

+(void)requestWithURL:(NSString *)URL {
    [self requestWithURL:URL completion:nil];
}

+(void)requestWithURL:(NSString *)URL completion:(void (^)(id))completion {
    NSURLSession *session = [NSURLSession sharedSession];
    NSURL *requestURL = [NSURL URLWithString:URL];
    [session dataTaskWithURL:requestURL completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            NSHTTPURLResponse * responseFromServer = (NSHTTPURLResponse *)response;
            if (data != nil && error != nil && responseFromServer.statusCode ==200) {
                NSError *parseError = nil;
                id result = [NSJSONSerialization JSONObjectWithData:data options:0 error:&parseError];
                NSString *json =[[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];
                if (parseError) {
                    return ;
                }
                if (completion != nil) {
                    dispatch_async(dispatch_get_main_queue(), ^{
                        completion(result);
                    });
                }
            }
        });
    }];
}

+(NSDictionary *)ObjToDic:(id)obj {
    return (NSDictionary *)obj;
}

@end
