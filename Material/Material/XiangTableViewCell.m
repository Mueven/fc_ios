//
//  XiangTableViewCell.m
//  Material
//
//  Created by wayne on 14-6-12.
//  Copyright (c) 2014年 brilliantech. All rights reserved.
//

#import "XiangTableViewCell.h"

@implementation XiangTableViewCell

- (void)awakeFromNib
{
    // Initialization code
    self.partNumber.adjustsFontSizeToFitWidth=YES;
    self.quantity.adjustsFontSizeToFitWidth=YES;
    self.key.adjustsFontSizeToFitWidth=YES;
    self.position.adjustsFontSizeToFitWidth=YES;
    self.date.adjustsFontSizeToFitWidth=YES;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
