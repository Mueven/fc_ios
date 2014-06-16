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
        self.number=object[@"part_id"]?object[@"part_id"]:@"";
        self.count=object[@"quantity_str"]?object[@"quantity_str"]:@"";
        self.key=object[@"id"]?object[@"id"]:@"";
        self.position=object[@"position_nr"]?object[@"position_nr"]:@"";
        self.remark=object[@"remark"]?object[@"remark"]:@"";
        self.date=object[@"check_in_time"]?object[@"check_in_time"]:@"";
    }
    return self;
}
@end
