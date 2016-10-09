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
#import <AFNetworking.h>
#import <UIImageView+WebCache.h>
static NSString *const lastNewsURL = @"http://news-at.zhihu.com/api/4/news/latest";

@interface MainTableViewController ()
@property (nonatomic,strong)NSData *jsonData;
@property (nonatomic,strong)Stories *storyData;
@property (nonatomic,strong)NSArray *dataArray;
@property (nonatomic,strong)NSDictionary *dic;




@end

@implementation MainTableViewController

-(NSArray *)dataArray{
    if (_dataArray==nil) {
        _dataArray = self.dic[@"stories"];
    }
    return _dataArray;
}

-(NSString *)dataPath {
    NSString *dataPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)lastObject];
    return [dataPath stringByAppendingString:@"/"];
}

-(NSString*)filePath {
    NSString *filePath = [self dataPath];
    return [filePath stringByAppendingString:@"data.plist"];
}

-(void)initializeDS {
    AFHTTPSessionManager *AFN = [[AFHTTPSessionManager alloc]init];
    [AFN GET:lastNewsURL parameters:nil progress:^(NSProgress * _Nonnull downloadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSString *path = [self filePath];
        _dic = (NSDictionary *)responseObject;
        [_dic writeToFile:path atomically:YES];
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
    }];
}

-(void) demo {
    NSString *path = [self filePath];
    _dic = [NSDictionary dictionaryWithContentsOfFile:path];
    NSLog(@"%@",self.dataArray);
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initializeDS];
    [self demo];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 90;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
#warning Incomplete implementation, return the number of sections
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
#warning Incomplete implementation, return the number of rows
    return self.dataArray.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    StroyCell *cell = [tableView dequeueReusableCellWithIdentifier:@"reuseIdentifier"];
    if (cell==nil) {
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"StroyCell" owner:nil options:nil];
        cell = nib[0];
    }
    cell.contentLabel.text =self.dataArray[indexPath.row][@"title"];
    NSString *url = self.dataArray[indexPath.row][@"images"][0];
//    NSLog(@"%@",url);
    [cell.mainImageView sd_setImageWithURL:[NSURL URLWithString:url]];
    
    
    return cell;
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
