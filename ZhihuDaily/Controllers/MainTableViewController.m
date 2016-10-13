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

static const CGFloat kHeaderViewHeight = 44;//固定headerView高度

@interface MainTableViewController ()

@property (nonatomic,strong)StroyView *storyVC;
@property (nonatomic,strong)YaoleDataSource* tool;

/*
 dataArray保存所有数据模型;
 */
@property (nonatomic,strong)NSMutableArray* dataArray;
@property (nonatomic,strong)NSArray* topStories;
@property (nonatomic,copy)NSString *lastDate;


@end

@implementation MainTableViewController




-(void)initialize {
    _tool = [YaoleDataSource sharedDataSource];
    [_tool getTopStories:^(NSArray *stories, NSArray *topStories, NSString *lastDate) {
        self.topStories = topStories;
        [self.dataArray addObject:stories];
        self.lastDate = lastDate;
        [self.tableView reloadData];

    } failure:^{
        
    }];
    
//    _tool.sqltool = [SQLiteTool sharedSQLiteTool];
//    NSDictionary* dic = @{@"123":@"12331213"};
//    [_tool.sqltool insertStories:dic withDate:@"20161011"];
//    [_tool.sqltool StoriesWithDate:@"20161011"];

}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initialize];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)loadNewdata {

    
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
   

}


#pragma mark - 处理上拉刷新
static bool isNeedUpdate = true;
-(void)scrollViewDidScroll:(UIScrollView *)scrollView {
    CGPoint py =[scrollView contentOffset];
    NSString *date = [YLDate stringFromDate:self.lastDate withIndex:[self.dataArray count]];
    if ((py.y > scrollView.contentSize.height - scrollView.bounds.size.height -30)&& isNeedUpdate && (date != nil)) {
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
}


#pragma mark - 懒加载
- (NSMutableArray *)dataArray {
    if (_dataArray == nil) {
        _dataArray = [NSMutableArray array];
    }
    return _dataArray;
}

@end
