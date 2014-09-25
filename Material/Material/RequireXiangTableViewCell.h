//
//  RequireXiangTableViewCell.h
//  Material
//
//  Created by wayne on 14-7-21.
//  Copyright (c) 2014年 brilliantech. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RequireXiangTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *partNumberTextField;
@property (weak, nonatomic) IBOutlet UILabel *quantityTextField;
@property (weak, nonatomic) IBOutlet UILabel *positionTextField;
@property (weak, nonatomic) IBOutlet UILabel *is_finished_label;
@property (weak, nonatomic) IBOutlet UILabel *out_of_stock_label;
@property (weak, nonatomic) IBOutlet UIButton *urgentButton;
@property (strong , nonatomic) void (^clickCell)();
- (IBAction)setUrgent:(id)sender;
-(void)urgentState;
-(void)normalState;
@end
