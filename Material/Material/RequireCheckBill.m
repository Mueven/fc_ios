//
//  RequireCheckBill.m
//  Material
//
//  Created by wayne on 14-8-1.
//  Copyright (c) 2014年 brilliantech. All rights reserved.
//

#import "RequireCheckBill.h"

@implementation RequireCheckBill
-(instancetype)initWithObject:(NSDictionary *)dic
{
    self=[super init];
    if(self){
        self.yunDate=dic[@"created_at"]?dic[@"created_at"]:@"";
        self.xiangCount=dic[@"box_quantity"]?[NSString stringWithFormat:@"%d",[dic[@"box_quantity"] intValue]]:@"0";
        self.partAmount=dic[@"quantity"]?[NSString stringWithFormat:@"%0.1f",[dic[@"quantity"] floatValue]]:@"0";
        self.urgent=[dic[@"is_emergency"] intValue]==1?1:0;
    }
    return self;
}
@end
