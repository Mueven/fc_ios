//
//  Xiang.m
//  Material
//
//  Created by wayne on 14-6-6.
//  Copyright (c) 2014年 brilliantech. All rights reserved.
//

#import "Xiang.h"

@implementation Xiang
-(instancetype)initExample
{
    self=[super init];
    if(self){
        self.number=[NSString stringWithFormat:@"leoni%d",arc4random() %100];
        self.count=[NSString stringWithFormat:@"%d",arc4random() %1000];
        self.key=[NSString stringWithFormat:@"CZ%d",arc4random() %50];
        self.position=@"03 21 09";
        self.remark=@"1";
        self.date=@"05.13";
    }
    return self;
}
-(instancetype)initWith:(NSString *)ID partNumber:(NSString *)partNumber key:(NSString *)key count:(NSString *)count position:(NSString *)position remark:(NSString *)remark date:(NSString *)date
{
    self=[super init];
    if(self){
        self.number=partNumber?partNumber:@"";
        self.count=count?count:@"";
        self.key=key?key:@"";
        self.position=position?position:@"";
        self.remark=remark?remark:@"";
        self.date=date?date:@"";
    }
    return self;
}
-(instancetype)initWithObject:(NSDictionary *)object
{
    self=[super init];
    if(self){
        self.ID=object[@"id"]?object[@"id"]:@"";
        self.container_id=object[@"container_id"]?object[@"container_id"]:@"";
        self.number=object[@"part_id_display"]?object[@"part_id_display"]:@"";
        self.count=object[@"quantity"]?[NSString stringWithFormat:@"%@",object[@"quantity"]]:@"";
        self.key=object[@"container_id"]?object[@"container_id"]:@"";
        self.position=object[@"position_nr"]?object[@"position_nr"]:@"";
        self.remark=object[@"remark"]?object[@"remark"]:@"";
        self.date=object[@"fifo_time_display"]?object[@"fifo_time_display"]:@"";
        self.checked=[object[@"state"] integerValue]==3?YES:NO;
        self.user_id=object[@"user_id"]?object[@"user_id"]:@"";
        self.state_display=object[@"state_display"]?object[@"state_display"]:@"";
        self.state=object[@"state"]?[object[@"state"] intValue]:0 ;
    }
    return self;
}
-(instancetype)copyMe:(Xiang *)xiang
{
    self.ID=[xiang.ID copy];
    self.container_id=[xiang.container_id copy];
    self.number=[xiang.number copy];
    self.count=[xiang.count copy];
    self.key=[xiang.key copy];
    self.position=[xiang.position copy];
    self.remark=[xiang.remark copy];
    self.date=[xiang.date copy];
    self.checked=xiang.checked?YES:NO;
    return self;
}
@end
