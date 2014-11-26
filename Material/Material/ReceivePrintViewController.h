//
//  ReceivePrintViewController.h
//  Material
//
//  Created by wayne on 14-6-19.
//  Copyright (c) 2014年 brilliantech. All rights reserved.
//

#import <UIKit/UIKit.h>
@class Yun;
@interface ReceivePrintViewController : UIViewController
@property(nonatomic,strong)Yun *yun;
@property(nonatomic,strong)id container;
@property(nonatomic,strong)NSString *type;
@property(nonatomic)BOOL wetherBackToRoot;
@end
