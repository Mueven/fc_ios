//
//  RequireCheckBill.h
//  Material
//
//  Created by wayne on 14-8-1.
//  Copyright (c) 2014年 brilliantech. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface RequireCheckBill : NSObject
@property(nonatomic,strong)NSString *yunDate;
@property(nonatomic,strong)NSString *xiangCount;
@property(nonatomic,strong)NSString *partAmount;
@property(nonatomic)BOOL urgent;
-(instancetype)initWithObject:(NSDictionary *)dic;
@end
