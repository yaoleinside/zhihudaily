//
//  BannerView.h
//  ZhihuDaily
//
//  Created by 姚乐 on 16/10/14.
//  Copyright © 2016年 yaole. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol BannerViewDelegate <NSObject>

@optional
-(void)sendCurrentPageIndex:(NSInteger)index;

@end

@interface BannerView : UIView

@property (nonatomic,strong)NSArray<Stories*>* stories;
@property (nonatomic,weak)id<BannerViewDelegate> BannerViewDelegate;


@end
