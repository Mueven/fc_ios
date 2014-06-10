//
//  ShopXiangTableViewCell.m
//  Material
//
//  Created by wayne on 14-6-10.
//  Copyright (c) 2014年 brilliantech. All rights reserved.
//

#import "ShopXiangTableViewCell.h"

@implementation ShopXiangTableViewCell

- (void)awakeFromNib
{
    // Initialization code
    self.partNumberLabel.adjustsFontSizeToFitWidth=YES;
    self.keyLabel.adjustsFontSizeToFitWidth=YES;
    self.quantityLabel.adjustsFontSizeToFitWidth=YES;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
