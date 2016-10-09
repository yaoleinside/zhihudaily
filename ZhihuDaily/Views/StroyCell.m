//
//  StroyCell.m
//  ZhihuDaily
//
//  Created by 姚乐 on 16/10/8.
//  Copyright © 2016年 yaole. All rights reserved.
//

#import "StroyCell.h"


@implementation StroyCell

-(void)setStories:(Stories *)stories{
    NSDictionary *dic = stories;
    [self setValuesForKeysWithDictionary:dic];
    
    self.contentLabel.text = _stories.title;
//    self.mainImageView.image = [UIImage]
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
