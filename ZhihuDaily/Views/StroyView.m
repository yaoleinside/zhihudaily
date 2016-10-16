//
//  StroyView.m
//  ZhihuDaily
//
//  Created by 姚乐 on 16/10/10.
//  Copyright © 2016年 yaole. All rights reserved.
//

#import "StroyView.h"

@implementation StroyView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

-(void)setStroy:(Story *)stroy {
    _stroy = stroy;
    self.frame = CGRectMake(self.bounds.size.width, 0, self.bounds.size.width, self.bounds.size.height);

    NSData* data =[NSData dataWithContentsOfURL:[NSURL URLWithString:self.stroy.css]];
    NSString* cssContent =[[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    NSInteger bodyPadding =736 == [[UIScreen mainScreen] bounds].size.height ? 130 : 100;
    NSString* customCss = [NSString stringWithFormat:@"body {padding-top:%ldpx;}", (long)bodyPadding];
    NSString* htmlFormatString = @"<html><head><style>%@</style><style "
    @"type='text/css'>%@</style></head><body>%@</"
    @"body></html>";
    NSString* htmlString =[NSString stringWithFormat:htmlFormatString, cssContent, customCss,
     self.stroy.body];

    dispatch_async(dispatch_get_main_queue(), ^{
        [UIView animateWithDuration:1 animations:^{
            self.frame = CGRectMake(0, 0, self.bounds.size.width, self.bounds.size.height);
        }];
        [self loadHTMLString:htmlString baseURL:nil];
        [self addGestureRecognizer];
    });
    
    self.scrollView.bounces = YES;
    


}

-(void)addGestureRecognizer{
    UISwipeGestureRecognizer *horizontal = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(reportHorizontalGesture)];
    horizontal.direction = UISwipeGestureRecognizerDirectionRight;
    [self addGestureRecognizer:horizontal];
}

-(void)reportHorizontalGesture {
    [UIView animateWithDuration:1 animations:^{
        self.frame = CGRectMake(self.bounds.size.width, 0, self.bounds.size.width, self.bounds.size.height);
    } completion:^(BOOL finished) {
        [self.storyViewDelegate releaseStroyView];
    }];
}

@end
