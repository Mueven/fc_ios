//
//  TuoCheckTableViewCell.m
//  Material
//
//  Created by wayne on 14-8-19.
//  Copyright (c) 2014年 brilliantech. All rights reserved.
//

#import "TuoCheckTableViewCell.h"

@implementation TuoCheckTableViewCell

- (void)awakeFromNib
{
    // Initialization code
    self.partNumberLabel.adjustsFontSizeToFitWidth=YES;
    self.countLabel.adjustsFontSizeToFitWidth=YES;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
