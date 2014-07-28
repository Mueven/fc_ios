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
        NSRange dateRange=NSMakeRange(0, 10);
        self.date=[object objectForKey:@"created_at"]? [[object objectForKey:@"created_at"] substringWithRange:dateRange]:@"";
        //self.department=[object objectForKey:@"department"]?[object objectForKey:@"department"]:@"";
        self.status=[object objectForKey:@"handled"]?[[object objectForKey:@"handled"] intValue]:0;
        self.id=[object objectForKey:@"id"]?[object objectForKey:@"id"]:@"";
        self.user_id=[object objectForKey:@"user_id"]?[object objectForKey:@"user_id"]:@"";
    }
    return self;
}
@end
