//
//  RequireXiang.h
//  Material
//
//  Created by wayne on 14-7-21.
//  Copyright (c) 2014年 brilliantech. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface RequireXiang : NSObject
@property(nonatomic,strong)NSString *id;
@property(nonatomic,strong)NSString *position;
@property(nonatomic,strong)NSString *partNumber;
@property(nonatomic,strong)NSString *partNumber_origin;
@property(nonatomic,strong)NSString *quantity;
@property(nonatomic,strong)NSString *quantity_int;
@property(nonatomic,strong)NSString *source;
@property(nonatomic,strong)NSString *source_name;
@property(nonatomic,strong)NSString *department;
@property(nonatomic,strong)NSString *department_origin;
@property(nonatomic,strong)NSString *agent;
@property(nonatomic,strong)NSString *uniq_id;
@property(nonatomic)int handled;
@property(nonatomic)int is_finished;
@property(nonatomic)int out_of_stock;
@property(nonatomic,strong)NSString *handled_text;
@property(nonatomic,strong)NSString *is_finished_text;
@property(nonatomic,strong)NSString *out_of_stock_text;
@property(nonatomic)int xiangCount;
@property(nonatomic)BOOL urgent;
@property(nonatomic)BOOL isExisted;
-(instancetype)initWithObject:(id)object;
-(instancetype)copyMe:(RequireXiang *)xiang;
@end
