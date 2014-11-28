//
//  Yun.h
//  Material
//
//  Created by wayne on 14-6-8.
//  Copyright (c) 2014年 brilliantech. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Yun : NSObject
@property(nonatomic,strong)NSString *ID;
@property(nonatomic,strong)NSString *container_id;
@property(nonatomic,strong)NSString *name;
@property(nonatomic,strong)NSString *date;
@property(nonatomic,strong)NSString *remark;
@property(nonatomic,strong)NSMutableArray *tuoArray;
@property(nonatomic)int sended;
@property(nonatomic,strong)NSString *delivery_date;
@property(nonatomic,strong)NSString *received_date;
@property(nonatomic)int state;
@property(nonatomic,strong)NSString *state_display;
@property(nonatomic,strong)NSString *user_id;
@property(nonatomic,strong)NSString *source_id;
@property(nonatomic,strong)NSString *source;
@property(nonatomic,strong)NSString *destination_id;
@property(nonatomic,strong)NSString *destination;
-(instancetype)initExample;
-(instancetype)initWithObject:(NSDictionary *)dictionary;
-(instancetype)initWith:(NSString *)ID name:(NSString *)name remark:(NSString *)remark;
-(instancetype)copyMe:(Yun *)yun;
@end
