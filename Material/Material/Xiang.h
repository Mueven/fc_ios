//
//  Xiang.h
//  Material
//
//  Created by wayne on 14-6-6.
//  Copyright (c) 2014年 brilliantech. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Xiang : NSObject
@property(nonatomic,strong)NSString *ID;
@property(nonatomic,strong)NSString *container_id;
@property(nonatomic,strong)NSString *number;
@property(nonatomic,strong)NSString *key;
@property(nonatomic,strong)NSString *count;
@property(nonatomic,strong)NSString *position;
@property(nonatomic,strong)NSString *remark;
@property(nonatomic,strong)NSString *date;
@property(nonatomic,strong)NSString *user_id;
@property(nonatomic,strong)NSString *state_display;
@property(nonatomic) int state ;
@property(nonatomic)BOOL checked;
-(instancetype)initExample;
-(instancetype)initWith:(NSString *)ID partNumber:(NSString *)partNumber key:(NSString *)key count:(NSString *)count position:(NSString *)position remark:(NSString *)remark date:(NSString *)date;
-(instancetype)initWithObject:(NSDictionary *)object;
-(instancetype)copyMe:(Xiang *)xiang;
@end

