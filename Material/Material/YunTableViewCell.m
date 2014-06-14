//
//  YunTableViewCell.m
//  Material
//
//  Created by wayne on 14-6-14.
//  Copyright (c) 2014年 brilliantech. All rights reserved.
//

#import "YunTableViewCell.h"

@implementation YunTableViewCell

- (void)awakeFromNib
{
    // Initialization code
    self.nameLabel.adjustsFontSizeToFitWidth=YES;
    self.dateLabel.adjustsFontSizeToFitWidth=YES;
    self.statusLabel.adjustsFontSizeToFitWidth=YES;
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
