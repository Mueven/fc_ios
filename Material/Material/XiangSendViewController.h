//
//  XiangSendViewController.h
//  Material
//
//  Created by wayne on 14-11-20.
//  Copyright (c) 2014年 brilliantech. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Xiang.h"
@class Tuo;
@interface XiangSendViewController : UIViewController
@property(nonatomic,strong)Xiang *xiang;
@property(nonatomic,strong)NSMutableArray *xiangArray;
@property(nonatomic)int xiangIndex;
@end
