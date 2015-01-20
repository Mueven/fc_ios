//
//  HistoryXiangTableViewController.h
//  Material
//
//  Created by wayne on 14-6-10.
//  Copyright (c) 2014年 brilliantech. All rights reserved.
//

#import <UIKit/UIKit.h>
@class Tuo;
@interface HistoryXiangTableViewController : UITableViewController
@property(nonatomic,strong)NSString *vc_title;
@property(nonatomic,strong)NSArray *xiangArray;
@property(nonatomic,strong)Tuo *tuo;
@end
