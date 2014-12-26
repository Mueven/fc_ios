//
//  RequireCheckDetailTableViewCell.m
//  Material
//
//  Created by wayne on 14-12-26.
//  Copyright (c) 2014年 brilliantech. All rights reserved.
//

#import "RequireCheckDetailTableViewCell.h"

@implementation RequireCheckDetailTableViewCell

- (void)awakeFromNib {
    // Initialization code
    self.partNumberLabel.adjustsFontSizeToFitWidth=YES;
    self.countLabel.adjustsFontSizeToFitWidth=YES;
    self.prepareStateLabel.adjustsFontSizeToFitWidth=YES;
    self.stockStateLabel.adjustsFontSizeToFitWidth=YES;
    self.emergencyMark.hidden=YES;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    // Configure the view for the selected state
}

@end
