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
        //state
        //0:备货
        //1:在途
        //2:到达
        //3:已接受
        //4:被拒收
        self.ID=dictionary[@"id"]?dictionary[@"id"]:@"";
        self.container_id=dictionary[@"container_id"]?dictionary[@"container_id"]:@"";
        self.remark=dictionary[@"remark"]?dictionary[@"remark"]:@"";
        self.name=dictionary[@"container_id"]?dictionary[@"container_id"]:@"";
        self.sended=[dictionary[@"state"] intValue]?[dictionary[@"state"] intValue]:0;
        self.delivery_date=dictionary[@"delivery_date"]?dictionary[@"delivery_date"]:@"";
        self.received_date=dictionary[@"received_date"]?dictionary[@"received_date"]:@"";
        self.state=dictionary[@"state"]?[dictionary[@"state"] intValue]:0;
        self.state_display=dictionary[@"state_display"]?dictionary[@"state_display"]:@"";
        self.user_id=dictionary[@"user_id"]?dictionary[@"user_id"]:@"";
        self.source_id=dictionary[@"source_id"]?dictionary[@"source_id"]:@"";
        self.source=dictionary[@"source"]?dictionary[@"source"]:@"";
        self.destination_id=dictionary[@"destination_id"]?dictionary[@"destination_id"]:@"";
        self.destination=dictionary[@"destination"]?dictionary[@"destination"]:@"";
        if(dictionary[@"delivery_date"]){
            @try {
                if([dictionary[@"delivery_date"] substringWithRange:NSMakeRange(0, 10)] && [dictionary[@"delivery_date"] substringWithRange:NSMakeRange(11,5)]){
                    NSString *date=[dictionary[@"delivery_date"] substringWithRange:NSMakeRange(0, 10)];
                    NSString *time=[dictionary[@"delivery_date"] substringWithRange:NSMakeRange(11,5)];
                    self.date=[NSString stringWithFormat:@"%@ %@",date,time];
                }
                else{
                   self.date=@"";
                }
                
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
    self.container_id=[yun.container_id copy];
    self.remark=[yun.remark copy];
    self.name=[yun.name copy];
    self.date=[yun.date copy];
    self.sended=yun.sended;
    self.delivery_date=yun.delivery_date;
    self.received_date=yun.received_date;
    self.state=yun.state;
    self.state_display=yun.state_display;
    self.user_id=yun.user_id;
    self.source_id=yun.source_id;
    self.source=yun.source;
    self.destination_id=yun.destination_id;
    self.destination=yun.destination;
    return self;
}
@end
