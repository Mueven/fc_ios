//
//  RequireListTableViewCell.h
//  Material
//
//  Created by wayne on 14-7-21.
//  Copyright (c) 2014年 brilliantech. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RequireListTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *dateLabel;
@property (weak, nonatomic) IBOutlet UILabel *out_of_stock_label;

@property (weak, nonatomic) IBOutlet UILabel *statusLabel;
@end
