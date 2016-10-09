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


@interface MainTableViewController ()
@property (nonatomic,strong)NSData *jsonData;
@property (nonatomic,strong)Stories *storyData;
@property (nonatomic,strong)NSArray *dataArray;
@property (nonatomic,strong)NSDictionary *dic;
@property (nonatomic,strong)YLDataSource *YLDS;




@end

@implementation MainTableViewController

-(NSArray *)dataArray{
    if (_dataArray==nil) {
        _dataArray = self.dic[@"stories"];
    }
    return _dataArray;
}



-(void) demo {

}

- (void)viewDidLoad {
    [super viewDidLoad];
    [YLDataSource initializeDS];
    _YLDS = [[YLDataSource alloc]init];
//    NSArray *ta =_YLDS.dataArray;
//    Stories *st = _YLDS.dataArray[0][0];
//    NSLog(@"%@",[NSString stringToMd5:st.title]);
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
    return _YLDS.dataArray.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
#warning Incomplete implementation, return the number of rows
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
