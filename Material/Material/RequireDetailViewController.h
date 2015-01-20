//
//  RequireDetailViewController.h
//  Material
//
//  Created by wayne on 14-7-22.
//  Copyright (c) 2014年 brilliantech. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RequireDetailViewController : UIViewController
@property(nonatomic,strong)NSString *billName;
@property(nonatomic,strong)NSString *billDate;
@property(nonatomic,strong)NSArray *xiangArray;
@property(nonatomic)BOOL status;
@property (weak, nonatomic) IBOutlet UILabel *remarkLabel;
@end
