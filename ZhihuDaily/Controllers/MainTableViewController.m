//
//  MainTableViewController.m
//  ZhihuDaily
//
//  Created by 姚乐 on 16/10/8.
//  Copyright © 2016年 yaole. All rights reserved.
//

#import "MainTableViewController.h"
#import "Stories.h"
#import "StroyCell.h"
#import "YaoleDataSource.h"
#import "StoriesHeaderView.h"
#import "BannerView.h"
#import "StroyView.h"

static const CGFloat kHeaderViewHeight = 44;//固定headerView高度

@interface MainTableViewController ()<BannerViewDelegate>

@property (nonatomic,strong)StroyView *storyVC;
@property (nonatomic,strong)YaoleDataSource* tool;

/*
 dataArray保存所有数据模型;
 */
@property (nonatomic,strong)NSMutableArray* dataArray;
@property (nonatomic,strong)NSArray<Stories*>* topStories;
@property (nonatomic,copy)NSString *lastDate;

@property (nonatomic,strong)BannerView* bannerView;



@end

@implementation MainTableViewController


-(instancetype)initWithCoder:(NSCoder *)aDecoder{
    if (self = [super initWithCoder:aDecoder]){
        [self initialize];
    }
    return self;
}

-(void)initialize {
    _tool = [YaoleDataSource sharedDataSource];
    [_tool getTopStories:^(NSArray *stories, NSArray *topStories, NSString *lastDate) {
        self.topStories = topStories;
        [self.dataArray addObject:stories];
        self.lastDate = lastDate;
        [self.tableView reloadData];
        self.bannerView.stories = self.topStories;
    } failure:^{
        
    }];

}


-(void)loadView {
    [super loadView];
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
//    [self initialize];
    [self.tableView reloadData];
    self.bannerView.stories = self.topStories;
    [self setupTopExhibitonView];
    [self setNavigationBarTranslucent];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - 添加顶部展示板



-(void)setupTopExhibitonView {
    CGFloat kWidth = self.view.frame.size.width;
    CGFloat kHeight = 300;
    
    self.bannerView = [[BannerView alloc]initWithFrame:CGRectMake(0, 0, kWidth, kHeight)];
    self.bannerView.BannerViewDelegate = self;
    self.tableView.tableHeaderView = _bannerView;
    self.tableView.contentInset = UIEdgeInsetsMake(-64, 0, 0, 0);

}


#pragma mark - Table view data source

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 90;
}

//-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
//    return [YLDate stringFromDate:self.lastDate withIndex:section];
//}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    StoriesHeaderView *HeaderView = [[StoriesHeaderView alloc]initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, kHeaderViewHeight)];
    HeaderView.text =[YLDate stringFromDate:self.lastDate withIndex:section];
    return HeaderView;
}

/*
 开头section高度设置为0;
 */
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (section == 0) return 0;
    return kHeaderViewHeight;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    if  (self.dataArray.count) return self.dataArray.count;
    return 0;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if  (self.dataArray.count) {
        return [self.dataArray[section] count];
    }
    return 0;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    StroyCell *cell = [tableView dequeueReusableCellWithIdentifier:@"reuseIdentifier"];
    if (cell==nil) {
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"StroyCell" owner:nil options:nil];
        cell = nib[0];
    }
    Stories *stories  = self.dataArray[indexPath.section][indexPath.row];
    cell.stories = stories;
    return cell;
}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    Stories* st = self.dataArray[indexPath.section][indexPath.row];
    NSString* iid =[NSString stringWithFormat:@"%d", (int)st.iid];
    [_tool getStory:iid success:^(Story *Story) {
        [self loadStoryView:Story];
    } failure:^{
        
    }];


}

static StroyView *webView;
static UIImageView *webImageView;
-(void)loadStoryView:(Story *)story {
    
    webView = [[StroyView alloc]initWithFrame:[UIScreen mainScreen] .bounds];
    webView.stroy = story;
    webView.scrollView.delegate = self;
    
    webImageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 375, 300)];
    [webImageView sd_setImageWithURL:[NSURL URLWithString:story.image]];
    
    [webView addSubview:webImageView];

    [self.view.window insertSubview:webView aboveSubview:self.view.window];
}



#pragma mark - 实现BannerViewDelegate
-(void)sendCurrentPageIndex:(NSInteger)index {
    NSLog(@"%tu",index);
    NSString* iid =[NSString stringWithFormat:@"%d", (int)self.topStories[index].iid];
    [_tool getStory:iid success:^(Story *Story) {
        [self loadStoryView:Story];
    } failure:^{
        
    }];
}

#pragma mark - 处理上拉刷新
static bool isNeedUpdate = true;
-(void)scrollViewDidScroll:(UIScrollView *)scrollView {
    
    if (self.lastDate == nil) return;
    CGPoint py =[scrollView contentOffset];
    
    if ((py.y > scrollView.contentSize.height - scrollView.bounds.size.height -30)&& isNeedUpdate)
    {
        [self loadMoreData];
     }
    if (py.y<0) {
        py.y = 0;
        [scrollView setContentOffset:py];
    }
    CGFloat alpha = (py.y-66) / (235- 66);
    [navV setAlpha:alpha];
    NSInteger lastDayCount = [self.dataArray[0] count];
    CGFloat dist = py.y-lastDayCount * 90 -280;
    if (dist >0) {
        navV.frame = CGRectMake(0, -20, self.navigationController.navigationBar.frame.size.width, 20);
        self.navigationItem.title = @"";
        self.tableView.contentInset = UIEdgeInsetsMake(20, 0, 0, 0);
    } else {
        navV.frame = CGRectMake(0, -20, self.navigationController.navigationBar.frame.size.width, 64);
        self.navigationItem.title = @"今日热闻";
        self.tableView.contentInset = UIEdgeInsetsMake(-64, 0, 0, 0);
    }
    
    webImageView.frame = CGRectMake(0, -webView.scrollView.contentOffset.y, 375, 300);
    
}


-(void)loadMoreData {
    NSString *date = [YLDate stringFromDate:self.lastDate withIndex:[self.dataArray count]];
    isNeedUpdate = false;
    yaoLogTestDebug
    [_tool getStoriesWithDate:date success:^(NSArray *stories) {
        [self.dataArray addObject:stories];
        [self.tableView reloadData];
        isNeedUpdate = true;
    } failure:^{
        isNeedUpdate = true;
    }];

}


-(void)setNavigationBarTranslucent {
    self.navigationController.navigationBar.translucent = true;

    UIColor* color = [UIColor clearColor];
    CGRect rect = CGRectMake(0, 0, 1, 1);
    
    /*
     绘制一个1*1的透明图片设置为NaviBar的背景图片;
     */
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef ref = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(ref, color.CGColor);
    CGContextFillRect(ref, rect);
    UIImage* image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    [self.navigationController.navigationBar setBackgroundImage:image forBarMetrics:UIBarMetricsDefault];
    [[[self.navigationController.navigationBar subviews] objectAtIndex:0]setAlpha:0];
    
    
    UIImageView* imV = [[UIImageView alloc]initWithFrame:CGRectMake(0, -20, self.navigationController.navigationBar.frame.size.width, 64)];
    imV.backgroundColor = themeColor;
    imV.alpha = 0;
    [self.navigationController.navigationBar insertSubview:imV atIndex:1];
    navV = imV;
    self.tableView.contentOffset = CGPointMake(0, 128);

}
static UIImageView* navV;

#pragma mark - 懒加载
- (NSMutableArray *)dataArray {
    if (_dataArray == nil) {
        _dataArray = [NSMutableArray array];
    }
    return _dataArray;
}

@end
