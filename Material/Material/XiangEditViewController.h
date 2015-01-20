//
//  XiangEditViewController.h
//  Material
//
//  Created by wayne on 14-6-8.
//  Copyright (c) 2014年 brilliantech. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Xiang.h"

@interface XiangEditViewController : UIViewController
@property(nonatomic,strong)Xiang *xiang;
@property(nonatomic)BOOL enableSend;
@property(nonatomic,strong)NSMutableArray *xiangArray;
@property(nonatomic)int xiangIndex;
@end
