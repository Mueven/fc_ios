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
        [formatter setDateFormat:@"yyyy-MM-dd"];
        self.date=[formatter stringFromDate:[NSDate date]];
        self.tuoArray=[[NSMutableArray alloc] init];
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
@end
