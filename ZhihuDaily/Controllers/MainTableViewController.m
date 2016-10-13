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


@interface MainTableViewController ()<storyViewDelegate>

@property (nonatomic,strong)YLDataSource *YLDS;
@property (nonatomic,strong)StroyView *storyVC;




@end

@implementation MainTableViewController




-(void) demo {

}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _YLDS = [[YLDataSource alloc]init];
    _YLDS.delegate = self;
    [_YLDS initializeDS];
//    NSArray *ta =_YLDS.dataArray;
//    Stories *st = _YLDS.dataArray[0][0];
//    NSLog(@"%@",[NSString stringToMd5:st.title]);
//    NSLog(@"%@",[_YLDS.topStories[0] valueForKeyPath:@"title"]);
//    NSLog(@"%@",[YLDate stringFromNowDate:1]);
    [self demo];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)loadNewdata {
    if (_YLDS.isUpdated){
        _YLDS.isUpdated = false;

        NSString *st = [YLDate stringFromNowDate:[_YLDS.dataArray count]];
        NSLog(@"%@",st);
        [_YLDS loadNewDataWithDate:st];
    }
    
}

#pragma mark - Table view data source

-(void)DateUpdated{
//    NSLog(@"%@",_YLDS.dataArray);
    _YLDS.isUpdated = YES;
    NSArray *arr =_YLDS.dataArray ;
//    [NSKeyedArchiver archiveRootObject:@(arr) toFile:[YLDataSource filePath]];
    
    
    [self.tableView reloadData];
}


-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 90;
}

-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    return [YLDate stringFromNowDate:section];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return _YLDS.dataArray.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [_YLDS.dataArray[section] count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    StroyCell *cell = [tableView dequeueReusableCellWithIdentifier:@"reuseIdentifier"];
    if (cell==nil) {
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"StroyCell" owner:nil options:nil];
        cell = nib[0];
    }
    Stories *stories = _YLDS.dataArray[indexPath.section][indexPath.row];
    cell.stories = stories;
    return cell;
}

-(void)scrollViewDidScroll:(UIScrollView *)scrollView {
    CGPoint py =[scrollView contentOffset];
//    NSLog(@"%f %f %f",py.y,scrollView.bounds.size.height,scrollView.contentSize.height);
    if (py.y > scrollView.contentSize.height - scrollView.bounds.size.height -30) {
        if (_storyVC == nil) {[self loadNewdata];}
    }
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (_storyVC==nil) {
    Stories *st = _YLDS.dataArray[indexPath.section][indexPath.row];
    NSString *urlString = [NSString stringWithFormat:@"http://news-at.zhihu.com/api/4/news/%@",st.iid];
//    NSLog(@"%@",urlString);
    CGSize si = [[UIScreen mainScreen] bounds].size;
    self.storyVC = [[StroyView alloc]initWithFrame:CGRectMake(0, 0, si.width, si.height)];
    _storyVC.storyViewDelegate = self;
    _storyVC.offsetY = self.tableView.contentOffset.y;
    
    AFHTTPSessionManager *AFN = [[AFHTTPSessionManager alloc]init];
    [AFN GET:urlString parameters:nil progress:^(NSProgress * _Nonnull downloadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        Story *st = [Story storyWithDic:responseObject];
        _storyVC.stroy = st;
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
    }];
    
    
    [self.view.window addSubview:self.storyVC];
    }

}

-(void)releaseStroyView{
    [self.storyVC removeFromSuperview];
    self.storyVC = nil;
}

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
