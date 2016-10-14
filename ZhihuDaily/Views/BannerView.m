//
//  BannerView.m
//  ZhihuDaily
//
//  Created by 姚乐 on 16/10/14.
//  Copyright © 2016年 yaole. All rights reserved.
//

#import "BannerView.h"

@interface BannerView()<UIScrollViewDelegate>
@property (nonatomic,weak)UIScrollView* scrollView;
@property (nonatomic,weak)UIPageControl* pageControl;


@end

@implementation BannerView

#pragma mark - 设置UI
-(instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self setupScrollView];
        [self setupPageControll];
    }
    return self;
}

-(void)setupScrollView {
    UIScrollView* scrollView = [[UIScrollView alloc]initWithFrame:self.bounds];
    scrollView.pagingEnabled = YES;
    scrollView.showsHorizontalScrollIndicator = false;
    [self addSubview:scrollView];
    self.scrollView = scrollView;
    scrollView.delegate = self;
}

-(void)setupPageControll {
    UIPageControl* pageControl = [[UIPageControl alloc]init];
    pageControl.center = CGPointMake(self.frame.size.width / 2 , self.frame.size.height * 0.9);
    [self addSubview:pageControl];
    self.pageControl = pageControl;
}

#pragma mark - 重写set方法加载数据调整frame
-(void)setStories:(NSArray<Stories *> *)stories {
    _stories = stories;
    CGFloat kWidth = self.frame.size.width;
    CGFloat kHeight = self.frame.size.height;

    NSInteger i = 0;
    for (Stories* st in stories) {
        
        UIImageView *imV = [[UIImageView alloc]initWithFrame:CGRectMake(kWidth * i, 0, kWidth, kHeight)];
        NSURL *urlString = [NSURL URLWithString:st.image];
        [imV sd_setImageWithURL:urlString];
        [_scrollView addSubview:imV];
        
        UIButton* btn = [[UIButton alloc]initWithFrame:self.frame];
        [btn setBackgroundColor: [UIColor grayColor]];
        btn.alpha = 0.3;
        [btn addTarget:self action:@selector(loadStory) forControlEvents:UIControlEventTouchUpInside];
        imV.userInteractionEnabled = YES;
        [imV addSubview:btn];

        
        UILabel *tLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, 215, kWidth-20  , 0)];
        tLabel.text = st.title;
        tLabel.numberOfLines = 0;
        tLabel.textAlignment = NSTextAlignmentLeft;
        tLabel.textColor = [UIColor whiteColor];
        tLabel.font = [UIFont systemFontOfSize:20 weight:0.3];
        [tLabel sizeToFit];
        tLabel.shadowColor = [UIColor blackColor];
        [imV addSubview:tLabel];
        
        i++;
    }

    
    _scrollView.contentSize = CGSizeMake(i * kWidth, kHeight);
    _pageControl.numberOfPages = i;
//    [_pageControl sizeToFit];
}

-(void)loadStory {
    if ([self.BannerViewDelegate respondsToSelector:@selector(sendCurrentPageIndex:)]) {
        [self.BannerViewDelegate sendCurrentPageIndex:self.pageControl.currentPage];
    }
}

-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    _pageControl.currentPage = (NSInteger)(scrollView.contentOffset.x + 0.000001) / self.frame.size.width;
}

-(void)scrollViewDidScroll:(UIScrollView *)scrollView {
}


@end
