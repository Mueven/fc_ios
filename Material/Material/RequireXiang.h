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
@property(nonatomic,strong)NSString *agent;
@property(nonatomic,strong)NSString *uniq_id;
@property(nonatomic)int xiangCount;
@property(nonatomic)BOOL urgent;
-(instancetype)initWithObject:(id)object;
@end
