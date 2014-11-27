//
//  HistoryTuoTableViewController.h
//  Material
//
//  Created by wayne on 14-6-10.
//  Copyright (c) 2014年 brilliantech. All rights reserved.
//

#import <UIKit/UIKit.h>
@class Yun;
@interface HistoryTuoTableViewController : UITableViewController
@property(nonatomic,strong)NSArray *tuoArray;
@property(nonatomic,strong)NSString *vc_title;
@property(nonatomic,strong)Yun *yun;
@end
