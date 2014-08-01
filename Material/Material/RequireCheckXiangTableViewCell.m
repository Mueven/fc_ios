//
//  RequireCheckXiangTableViewCell.m
//  Material
//
//  Created by wayne on 14-8-1.
//  Copyright (c) 2014年 brilliantech. All rights reserved.
//

#import "RequireCheckXiangTableViewCell.h"

@implementation RequireCheckXiangTableViewCell

- (void)awakeFromNib
{
    // Initialization code
    self.yunDateLabel.adjustsFontSizeToFitWidth=YES;
    self.xiangCountLabel.adjustsFontSizeToFitWidth=YES;
    self.partCountLabel.adjustsFontSizeToFitWidth=YES;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
