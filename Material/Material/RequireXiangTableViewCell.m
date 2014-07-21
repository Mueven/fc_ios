//
//  RequireXiangTableViewCell.m
//  Material
//
//  Created by wayne on 14-7-21.
//  Copyright (c) 2014年 brilliantech. All rights reserved.
//

#import "RequireXiangTableViewCell.h"

@implementation RequireXiangTableViewCell

- (void)awakeFromNib
{
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
    self.partNumberTextField.adjustsFontSizeToFitWidth=YES;
    self.positionTextField.adjustsFontSizeToFitWidth=YES;
    self.quantityTextField.adjustsFontSizeToFitWidth=YES;
    // Configure the view for the selected state
}

@end
