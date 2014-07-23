//
//  TuoTableViewCell.m
//  Material
//
//  Created by wayne on 14-6-20.
//  Copyright (c) 2014年 brilliantech. All rights reserved.
//

#import "TuoTableViewCell.h"

@implementation TuoTableViewCell

- (void)awakeFromNib
{
    // Initialization code
    self.idLabel.adjustsFontSizeToFitWidth=YES;
    self.departmentLabel.adjustsFontSizeToFitWidth=YES;
    self.agentLabel.adjustsFontSizeToFitWidth=YES;
    self.sumPackageLabel.adjustsFontSizeToFitWidth=YES;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}

@end
