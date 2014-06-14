//
//  Yun.m
//  Material
//
//  Created by wayne on 14-6-8.
//  Copyright (c) 2014年 brilliantech. All rights reserved.
//

#import "Yun.h"
#import "Tuo.h"

@implementation Yun
-(instancetype)init
{
    self=[super init];
    if(self){
       self.tuoArray=[[NSMutableArray alloc] init]; 
    }
    return self;
}
-(instancetype)initExample
{
    self=[super init];
    if(self){
        self.name=[NSString stringWithFormat:@"Yun%d",arc4random()%100];
        NSDateFormatter *formatter=[[NSDateFormatter alloc] init];
        [formatter setDateFormat:@"yyyy-MM-dd'T'HH:mm:ssZZZZZ"];
        self.date=[formatter stringFromDate:[NSDate date]];
        self.tuoArray=[[NSMutableArray alloc] init];
        self.sended=1;
    }
    return self;
}
-(instancetype)initWith:(NSString *)ID name:(NSString *)name remark:(NSString *)remark
{
    self=[super init];
    if(self){
        self.ID=ID?ID:@"";
        self.name=name?name:@"";
        self.remark=remark?remark:@"";
        NSDateFormatter *formatter=[[NSDateFormatter alloc] init];
        [formatter setDateFormat:@"yyyy.MM.dd"];
        self.date=[formatter stringFromDate:[NSDate date]];
        self.tuoArray=[[NSMutableArray alloc] init];
    }
    return self;
}
-(instancetype)initWithObject:(NSDictionary *)dictionary
{
    self=[super init];
    if(self){
        self.ID=dictionary[@"id"]?dictionary[@"id"]:@"";
        self.name=dictionary[@"id"]?dictionary[@"id"]:@"";
        self.sended=(int)dictionary[@"state"]?(int)dictionary[@"state"]:0;
        NSDateFormatter *formatter=[[NSDateFormatter alloc] init];
        [formatter setDateFormat:@"yyyy.MM.dd"];
        self.date=[formatter stringFromDate:[NSDate date]];
        self.tuoArray=[[NSMutableArray alloc] init];
    }
    return self;
}
@end
