//
//  AFNetOperate.h
//  Material
//
//  Created by wayne on 14-6-10.
//  Copyright (c) 2014年 brilliantech. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "XiangStore.h"

@interface AFNetOperate : NSObject
@property(strong,nonatomic)UIActivityIndicatorView *activeView;
//method
-(AFHTTPRequestOperationManager *)generateManager:(UIView *)view;
-(void)alert:(NSString *)string;
-(void)getXiangs:(NSMutableArray *)xiangArray view:(UIView *)view;
//get URL
-(NSString *)xiang_root;
//-(NSString *)xiang_edit:(NSString *)id;
@end
