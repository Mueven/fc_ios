//
//  LED.m
//  Material
//
//  Created by wayne on 14-8-25.
//  Copyright (c) 2014年 brilliantech. All rights reserved.
//

#import "LED.h"

@implementation LED
-(instancetype)initWithObject:(id)object
{
    self=[super init];
    if(self){
        NSDateFormatter *formatter=[[NSDateFormatter alloc] init];
        [formatter setDateFormat:@"yyyy-MM-dd HH:mm"];
        NSDate *lastDate=[[NSDate alloc] initWithTimeInterval:-24*3600 sinceDate:[NSDate date]];
        
        self.position=object[@"position"]?object[@"position"]:@"";
        self.beginDate=object[@"beginDate"]?object[@"beginDate"]:[formatter stringFromDate:[NSDate date]];
        self.endDate=object[@"endDate"]?object[@"endDate"]:[formatter stringFromDate:lastDate];
        self.requirement=object[@"requirement"]?[object[@"requirement"] intValue]:0;
        self.received=object[@"received"]?[object[@"received"] intValue]:0;
        self.absent=object[@"absent"]?[object[@"absent"] intValue]:0;
        self.state=object[@"state"]?[object[@"state"] intValue]:0;
    }
    return self;
}
@end
