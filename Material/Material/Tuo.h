//
//  Tuo.h
//  Material
//
//  Created by wayne on 14-6-6.
//  Copyright (c) 2014年 brilliantech. All rights reserved.
//

#import <Foundation/Foundation.h>
@class Xiang;

@interface Tuo : NSObject
@property(nonatomic,strong)NSString *ID;
@property(nonatomic,strong)NSString *container_id;
@property(nonatomic,strong) NSString *department;
@property(nonatomic,strong) NSString *agent;
@property(nonatomic,strong) NSString *date;
@property(nonatomic,strong) NSMutableArray *xiang;
@property(nonatomic)int accepted_packages;
@property(nonatomic)int sum_packages;

-(instancetype)initExample;
-(instancetype)initWith:(NSString *)ID department:(NSString *)department agent:(NSString *)agent;
-(instancetype)initWithObject:(NSDictionary *)dictionary;
-(void)addXiang:(Xiang *)xiang;
-(NSInteger)xiangAmount;
-(instancetype)copyMe:(Tuo *)tuo;
@end
