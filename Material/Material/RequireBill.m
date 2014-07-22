//
//  RequireBill.m
//  Material
//
//  Created by wayne on 14-7-21.
//  Copyright (c) 2014年 brilliantech. All rights reserved.
//

#import "RequireBill.h"
@interface RequireBill()

@end
@implementation RequireBill
-(instancetype)init
{
    self=[super init];
    if(self){
        self.xiangList=[NSArray array];
    }
    return self;
}
-(instancetype)initWithObject:(id)object
{
    self=[super init];
    if(self){
        self.xiangList=[NSArray array];
        self.date=[object objectForKey:@"date"]?[object objectForKey:@"date"]:@"";
        self.department=[object objectForKey:@"department"]?[object objectForKey:@"department"]:@"";
        self.status=[object objectForKey:@"status"]?[object objectForKey:@"status"]:@"";
        self.id=[object objectForKey:@"id"]?[object objectForKey:@"id"]:@"";
    }
    return self;
}
@end
