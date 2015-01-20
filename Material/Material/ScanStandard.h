//
//  ScanStandard.h
//  Material
//
//  Created by wayne on 14-7-14.
//  Copyright (c) 2014年 brilliantech. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ScanStandard : NSObject
+(instancetype)sharedScanStandard;
-(void)updateRule:(NSString *)id type:(NSString *)type regex:(NSArray *)regexArray;
-(NSString *)filterQuantity:(NSString *)data;
-(NSString *)filterPartNumber:(NSString *)data;
-(NSString *)filterDate:(NSString *)data;
-(NSString *)filterKey:(NSString *)data;
-(NSString *)filterDepartment:(NSString *)data;
-(BOOL)checkQuantity:(NSString *)data;
-(BOOL)checkPartNumber:(NSString *)data;
-(BOOL)checkDate:(NSString *)data;
-(BOOL)checkKey:(NSString *)data;
-(BOOL)checkDepartment:(NSString *)data;
//@property(strong,nonatomic)NSMutableDictionary *rules;

//-(NSString *)order_item_part_fix:(NSString *)param;
//-(NSString *)order_item_department_fix:(NSString *)param;
@end
