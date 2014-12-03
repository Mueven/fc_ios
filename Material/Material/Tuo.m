//
//  Tuo.m
//  Material
//
//  Created by wayne on 14-6-6.
//  Copyright (c) 2014年 brilliantech. All rights reserved.
//

#import "Tuo.h"
#import "Xiang.h"

@implementation Tuo
-(instancetype)init{
    self=[super init];
    if(self){
        self.xiang=[[NSMutableArray alloc] init];
    }
    return self;
}
-(instancetype)initExample
{
    self=[super init];
    if(self){
        self.department=[NSString stringWithFormat:@"MB_example%d",arc4random()%99];
        self.agent=[NSString stringWithFormat:@"Wayne%d",arc4random()%99];
        NSDateFormatter *formatter=[[NSDateFormatter alloc] init];
        [formatter setDateFormat:@"yyyy.MM.dd"];
        self.date=[formatter stringFromDate:[NSDate date]];
        self.xiang=[[NSMutableArray alloc] init];
        for(int i=0;i<10;i++){
            Xiang *xiang=[[Xiang alloc] initExample];
            [self.xiang addObject:xiang];
        }
    }
    return self;
}
-(instancetype)initWith:(NSString *)ID department:(NSString *)department agent:(NSString *)agent
{
    self=[super init];
    if(self){
        self.ID=ID?ID:@"";
        self.department=department?department:@"";
        self.agent=agent?agent:@"";
        NSDateFormatter *formatter=[[NSDateFormatter alloc] init];
        [formatter setDateFormat:@"yyyy.MM.dd"];
        self.date=[formatter stringFromDate:[NSDate date]];
        self.xiang=[[NSMutableArray alloc] init];
    }
    return self;
}
-(instancetype)initWithObject:(NSDictionary *)dictionary
{
    self=[super init];
    if(self){
        self.ID=dictionary[@"id"]?dictionary[@"id"]:@"";
        self.container_id=dictionary[@"container_id"]?dictionary[@"container_id"]:@"";
        self.department=dictionary[@"whouse_id"]?dictionary[@"whouse_id"]:@"";
        self.agent=dictionary[@"stocker_id"]?dictionary[@"stocker_id"]:@"";
        self.date=dictionary[@"created_at"]?dictionary[@"created_at"]:@"";
        self.xiang=[[NSMutableArray alloc] init];
        self.accepted_packages=dictionary[@"accepted_packages"]?[dictionary[@"accepted_packages"] intValue]:0;
        self.sum_packages=dictionary[@"sum_packages"]?[dictionary[@"sum_packages"] intValue]:0;
        self.user_id=dictionary[@"user_id"]?dictionary[@"user_id"]:@"";
        self.state=dictionary[@"state"]?[dictionary[@"state"] intValue]:0;
        self.state_display=dictionary[@"state_display"]?dictionary[@"state_display"]:@"";
        self.xiang=[NSMutableArray array];
    }
    return self;
}
-(instancetype)copyMe:(Tuo *)tuo
{
    self.ID=[tuo.ID copy];
    self.container_id=[tuo.container_id copy];
    self.department=[tuo.department copy];
    self.agent=[tuo.agent copy];
    self.date=[tuo.date copy];
    self.accepted_packages=tuo.accepted_packages;
    self.sum_packages=tuo.sum_packages;
    self.state=tuo.state;
    self.state_display=tuo.state_display;
    self.user_id=tuo.user_id;
    return self;
}
-(void)addXiang:(Xiang *)xiang
{
    [self.xiang addObject:xiang];
}
-(NSInteger)xiangAmount
{
    return [self.xiang count];
}
@end
