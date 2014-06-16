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
        self.department=dictionary[@"whouse_id"]?dictionary[@"whouse_id"]:@"";
        self.agent=dictionary[@"stocker_id"]?dictionary[@"stocker_id"]:@"";
        NSDateFormatter *formatter=[[NSDateFormatter alloc] init];
        [formatter setDateFormat:@"yyyy.MM.dd"];
        self.date=[formatter stringFromDate:[NSDate date]];
        self.xiang=[[NSMutableArray alloc] init];
    }
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
