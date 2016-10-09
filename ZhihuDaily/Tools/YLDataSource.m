//
//  YLDataSource.m
//  ZhihuDaily
//
//  Created by 姚乐 on 16/10/9.
//  Copyright © 2016年 yaole. All rights reserved.
//

#import "YLDataSource.h"

@interface YLDataSource()
@property (nonatomic,strong)NSDictionary* dic;

@end

@implementation YLDataSource

-(NSDictionary *)lastData{
    if (_lastData==nil){
        NSString *path = [YLDataSource filePath];
        if ([[NSFileManager defaultManager] fileExistsAtPath:path]) {
            _lastData = [NSDictionary dictionaryWithContentsOfFile:path];
            NSString *dateString = [YLDate stringFromDate:[NSDate date]];
            _lastData = _lastData[dateString];
        }
    }
    return _lastData;
}

-(NSArray *)dataArray{
    if (_dataArray==nil){
        _dataArray = [NSArray arrayWithObject:self.lastStories];
    }
    return _dataArray;
}

-(NSArray *)lastStories {
    if (_lastStories == nil) {
        NSMutableArray *arr = [NSMutableArray array];
        for (NSDictionary* dic in self.lastData[@"stories"]) {
            Stories *st = [[Stories alloc]initWithDict:dic];
            [arr addObject:st];
//            NSLog(@"!11");
        }
        _lastStories = arr;
    }
//    NSMutableArray *temArr = [NSMutableArray arrayWithArray:self.dataArray];
//    [temArr addObject:_lastStories];
//    _dataArray = temArr;
    return _lastStories;
}

+(void)initializeDS{
    AFHTTPSessionManager *AFN = [[AFHTTPSessionManager alloc]init];
    [AFN GET:lastNewsURL parameters:nil progress:^(NSProgress * _Nonnull downloadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSString *path = [YLDataSource filePath];
        NSDictionary* tempDic = (NSDictionary *)responseObject;
        NSMutableDictionary* dic1 = [NSMutableDictionary dictionary];
        [dic1 setValue:tempDic forKeyPath:tempDic[@"date"]];
        [dic1 writeToFile:path atomically:YES];
        
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
    }];

}




+(NSString *)dataPath {
    NSString *dataPath1 = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)lastObject];
    return [dataPath1 stringByAppendingString:@"/"];
}

+(NSString*)filePath {
    NSString *filePath1 = [self dataPath];
    return [filePath1 stringByAppendingString:@"data.plist"];
}


@end
