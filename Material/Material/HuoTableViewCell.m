//
//  HuoTableViewCell.m
//  Material
//
//  Created by wayne on 14-6-7.
//  Copyright (c) 2014年 brilliantech. All rights reserved.
//

#import "HuoTableViewCell.h"

@implementation HuoTableViewCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)awakeFromNib
{
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
