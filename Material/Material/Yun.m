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
        self.ID=[NSString stringWithFormat:@"%d",arc4random()%100];
        for(int i=0;i<5;i++){
            Tuo *tuo=[[Tuo alloc] initExample];
            [self.tuoArray addObject:tuo];
        }
        self.sended=0;
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
        self.remark=dictionary[@"remark"]?dictionary[@"remark"]:@"";
        self.name=dictionary[@"id"]?dictionary[@"id"]:@"";
        self.sended=[dictionary[@"state"] intValue]?[dictionary[@"state"] intValue]:0;
        if(dictionary[@"delivery_date"]){
            @try {
                NSString *date=[dictionary[@"delivery_date"] substringWithRange:NSMakeRange(0, 10)];
                NSString *time=[dictionary[@"delivery_date"] substringWithRange:NSMakeRange(11,5)];
                self.date=[NSString stringWithFormat:@"%@ %@",date,time];
            }
            @catch (NSException *exception) {
                self.date=@"";
            }
           
        }
        else{
            self.date=@"";
        }
        self.tuoArray=[[NSMutableArray alloc] init];
    }
    return self;
}
-(instancetype)copyMe:(Yun *)yun
{
    self.ID=[yun.ID copy];
    self.remark=[yun.remark copy];
    self.name=[yun.name copy];
    self.date=[yun.date copy];
    self.sended=yun.sended;
//    NSDateFormatter *formatter=[[NSDateFormatter alloc] init];
//    [formatter setDateFormat:@"yyyy.MM.dd"];
//    self.date=[formatter stringFromDate:[NSDate date]];
    return self;
}
@end
