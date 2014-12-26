//
//  RequireCheckGeneralTableViewCell.m
//  Material
//
//  Created by wayne on 14-12-26.
//  Copyright (c) 2014年 brilliantech. All rights reserved.
//

#import "RequireCheckGeneralTableViewCell.h"

@implementation RequireCheckGeneralTableViewCell

- (void)awakeFromNib {
    // Initialization code
    self.partCountLabel.adjustsFontSizeToFitWidth=YES;
    self.xiangCountLabel.adjustsFontSizeToFitWidth=YES;
    self.partCountLabel.adjustsFontSizeToFitWidth=YES;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
