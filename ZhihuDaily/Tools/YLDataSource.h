//
//  YLDataSource.h
//  ZhihuDaily
//
//  Created by 姚乐 on 16/10/9.
//  Copyright © 2016年 yaole. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol YLDateDelegate <NSObject>

-(void)DateUpdated;

@end

@interface YLDataSource : NSObject

-(void)initializeDS;
+(NSString *)dataPath;
+(NSString*)filePath;
-(void)loadNewDataWithDate:(NSString*)dateString;

@property (nonatomic,strong)NSDictionary* lastData;
@property (nonatomic,strong)NSArray *lastStories;
@property (nonatomic,strong)NSArray *topStories;
@property (nonatomic,strong)NSMutableArray* dataArray;
@property (nonatomic,assign)BOOL isUpdated;


@property (nonatomic,weak)id<YLDateDelegate> delegate;



@end
