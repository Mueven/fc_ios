//
//  RequireCheckDetailTableViewCell.h
//  Material
//
//  Created by wayne on 14-12-26.
//  Copyright (c) 2014年 brilliantech. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RequireCheckDetailTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *partNumberLabel;
@property (weak, nonatomic) IBOutlet UILabel *countLabel;
@property (weak, nonatomic) IBOutlet UILabel *prepareStateLabel;
@property (weak, nonatomic) IBOutlet UILabel *stockStateLabel;
@property (weak, nonatomic) IBOutlet UILabel *emergencyMark;
@end
