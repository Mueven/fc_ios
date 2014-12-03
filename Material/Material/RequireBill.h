//
//  RequireBill.h
//  Material
//
//  Created by wayne on 14-7-21.
//  Copyright (c) 2014年 brilliantech. All rights reserved.
//

#import <Foundation/Foundation.h>
@class RequireXiang;

@interface RequireBill : NSObject
@property(nonatomic,strong)NSArray *xiangList;
@property(nonatomic,strong)NSString *date;
@property(nonatomic,strong)NSString *department;
@property(nonatomic,strong)NSString *id;
@property(nonatomic,strong)NSString *user_id;
@property(nonatomic)int has_out_of_stock;
@property(nonatomic,strong)NSString *has_out_of_stock_text;
@property(nonatomic)BOOL status;
@property(nonatomic,strong)NSString *remark;
-(instancetype)init;
-(instancetype)initWithObject:(id)object;
@end
