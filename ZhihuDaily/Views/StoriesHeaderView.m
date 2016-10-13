//
//  StoriesHeaderView.m
//  ZhihuDaily
//
//  Created by 姚乐 on 16/10/13.
//  Copyright © 2016年 yaole. All rights reserved.
//

#import "StoriesHeaderView.h"
@interface StoriesHeaderView ()

@property (strong, nonatomic) UILabel* label;

@end
@implementation StoriesHeaderView

- (UILabel*)label
{
    if (_label == nil) {
        _label = [[UILabel alloc] init];
    }
    return _label;
}

- (void)setText:(NSString*)text
{
    if (_text != text) {
        _text = [text copy];
        [self buildHeaderView];
    }
}

- (void)buildHeaderView
{
    self.backgroundColor = themeColor;
    self.label.frame = self.frame;
    self.label.text = self.text;
    self.label.textAlignment = NSTextAlignmentCenter;
    self.label.textColor = [UIColor whiteColor];
    
    [self addSubview:self.label];
}

@end
