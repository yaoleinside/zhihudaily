//
//  YLDataSource.m
//  ZhihuDaily
//
//  Created by 姚乐 on 16/10/9.
//  Copyright © 2016年 yaole. All rights reserved.
//

#import "YLDataSource.h"

@interface YLDataSource()
@property (nonatomic,strong)NSDictionary* tempDic;
@property (nonatomic,copy)NSString *lastDate;


@end

@implementation YLDataSource

-(instancetype)init{
    self = [super init];
    self.isUpdated = YES;
    return self;
}

-(NSDictionary *)lastData{
    
    if (_lastData==nil){
        _lastData=_tempDic;
    }
    
    if (_lastData==nil){
        NSString *path = [YLDataSource filePath];
        if ([[NSFileManager defaultManager] fileExistsAtPath:path]) {
            _lastData = [NSDictionary dictionaryWithContentsOfFile:path];
            [_lastData enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, id  _Nonnull obj, BOOL * _Nonnull stop) {
                _lastDate = key;
            }];
            _lastData = _lastData[_lastDate];
        }
    }
    return _lastData;
}

-(NSMutableArray *)dataArray{
    if (_dataArray==nil && self.lastStories != nil){
        _dataArray = [NSMutableArray arrayWithObject:self.lastStories];
    }
    return _dataArray;
}

-(NSArray *)lastStories {
    if (_lastStories == nil && self.lastData != nil) {
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

-(NSArray *)topStories {
    if (_topStories == nil) {
        NSMutableArray *arr = [NSMutableArray array];
        for (NSDictionary* dic in self.lastData[@"top_stories"]) {
            Stories *st = [[Stories alloc]initWithDict:dic];
            [arr addObject:st];
            //            NSLog(@"!11");
        }
        _topStories = arr;
    }
    return _topStories;
}



-(void)initializeDS{
    AFHTTPSessionManager *AFN = [[AFHTTPSessionManager alloc]init];
    [AFN GET:lastNewsURL parameters:nil progress:^(NSProgress * _Nonnull downloadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSString *path = [YLDataSource filePath];
        _tempDic = (NSDictionary *)responseObject;
        NSMutableDictionary* dic1 = [NSMutableDictionary dictionary];
        self.lastDate = _tempDic[@"date"];
        [dic1 setValue:_tempDic forKeyPath:_tempDic[@"date"]];
        [dic1 writeToFile:path atomically:YES];
        [self.delegate DateUpdated];
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
    }];

}

-(void)loadNewDataWithDate:(NSString *)dateString {
    AFHTTPSessionManager *AFN = [[AFHTTPSessionManager alloc]init];
    NSString *url = [NewsURL stringByAppendingString:dateString];
    [AFN GET:url parameters:nil progress:^(NSProgress * _Nonnull downloadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        _tempDic =(NSDictionary *)responseObject;
        NSMutableArray *arr = [NSMutableArray array];
        for (NSDictionary* dic in _tempDic[@"stories"]) {
            Stories *st = [[Stories alloc]initWithDict:dic];
            [arr addObject:st];
        }
        [self.dataArray addObject:arr];
        NSString *path = [YLDataSource filePath];
        [self.delegate DateUpdated];
        
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
