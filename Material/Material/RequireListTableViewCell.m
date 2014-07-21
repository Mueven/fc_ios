//
//  RequireListTableViewCell.m
//  Material
//
//  Created by wayne on 14-7-21.
//  Copyright (c) 2014年 brilliantech. All rights reserved.
//

#import "RequireListTableViewCell.h"

@implementation RequireListTableViewCell

- (void)awakeFromNib
{
    // Initialization code
    self.dateLabel.adjustsFontSizeToFitWidth=YES;
    self.departmentLabel.adjustsFontSizeToFitWidth=YES;
    self.statusLabel.adjustsFontSizeToFitWidth=YES;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
    // Configure the view for the selected state
}

@end
