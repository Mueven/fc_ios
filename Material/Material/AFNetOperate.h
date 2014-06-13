//
//  AFNetOperate.h
//  Material
//
//  Created by wayne on 14-6-10.
//  Copyright (c) 2014年 brilliantech. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AFNetOperate : NSObject
@property(strong,nonatomic)UIActivityIndicatorView *activeView;
//method
-(AFHTTPRequestOperationManager *)generateManager:(UIView *)view;
-(void)alert:(NSString *)string;
-(void)getXiangs:(NSMutableArray *)xiangArray view:(UITableView *)view;
-(void)getTuos:(NSMutableArray *)tuoArray view:(UITableView *)view;
-(void)getYuns:(NSMutableArray *)yunArray view:(UITableView *)view;
//get URL
-(NSString *)part_validate;

-(NSString *)xiang_root;
-(NSString *)xiang_edit:(NSString *)id;
-(NSString *)xiang_validate;

-(NSString *)tuo_root;
-(NSString *)tuo_edit:(NSString *)id;
-(NSString *)tuo_single;
-(NSString *)tuo_bundle_add;
-(NSString *)tuo_key_for_bundle;
-(NSString *)tuo_remove_xiang;

-(NSString *)yun_root;
-(NSString *)yun_edit:(NSString *)id;
@end
