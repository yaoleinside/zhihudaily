//
//  Stories.h
//  ZhihuDaily
//
//  Created by 姚乐 on 16/10/8.
//  Copyright © 2016年 yaole. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Stories : NSObject

@property (nonatomic,assign)NSInteger ga_prefix;
@property (nonatomic,assign)NSInteger id;
@property (nonatomic,assign)NSInteger type;
@property (nonatomic,copy)NSString *title;
@property (nonatomic,strong)NSArray *images;


@end
