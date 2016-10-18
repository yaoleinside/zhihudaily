//
//  LoadingScreenController.m
//  ZhihuDaily
//
//  Created by 姚乐 on 16/10/17.
//  Copyright © 2016年 yaole. All rights reserved.
//

#import "LoadingScreenController.h"

@interface LoadingScreenController ()

@end

@implementation LoadingScreenController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    UIImageView *im = [[UIImageView alloc]initWithFrame:[[UIScreen mainScreen]bounds]];
    [im sd_setImageWithURL:[NSURL URLWithString:@"http://p2.zhimg.com/10/7b/107bb4894b46d75a892da6fa80ef504a.jpg"]];
    [self.view insertSubview:im belowSubview:_mainImage];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [UIView animateWithDuration:1 animations:^{
            im.transform = CGAffineTransformScale(im.transform, 1.1, 1.1);
        }];
    });
   

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
