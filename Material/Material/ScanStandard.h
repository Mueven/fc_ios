//
//  ScanStandard.h
//  Material
//
//  Created by wayne on 14-7-14.
//  Copyright (c) 2014年 brilliantech. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ScanStandard : NSObject
@property(strong,nonatomic)NSMutableDictionary *rules;
+(instancetype)sharedScanStandard;
-(NSString *)order_item_part_fix:(NSString *)param;
-(NSString *)order_item_department_fix:(NSString *)param;
@end
