//
//  StroyView.h
//  ZhihuDaily
//
//  Created by 姚乐 on 16/10/10.
//  Copyright © 2016年 yaole. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol storyViewDelegate <NSObject>

-(void)releaseStroyView;

@end

@interface StroyView : UIWebView

@property (nonatomic,strong)Story* stroy;
@property (nonatomic,weak) id<storyViewDelegate> storyViewDelegate;
@property (nonatomic,assign)CGFloat offsetY;


@end
