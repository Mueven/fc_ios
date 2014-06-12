//
//  XiangTableViewCell.h
//  Material
//
//  Created by wayne on 14-6-12.
//  Copyright (c) 2014年 brilliantech. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface XiangTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *partNumber;
@property (weak, nonatomic) IBOutlet UILabel *quantity;
@property (weak, nonatomic) IBOutlet UILabel *position;
@property (weak, nonatomic) IBOutlet UILabel *date;
@property (weak, nonatomic) IBOutlet UILabel *key;
@end
