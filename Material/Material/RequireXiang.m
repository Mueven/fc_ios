//
//  RequireXiang.m
//  Material
//
//  Created by wayne on 14-7-21.
//  Copyright (c) 2014年 brilliantech. All rights reserved.
//

#import "RequireXiang.h"

@implementation RequireXiang
-(instancetype)initWithObject:(id)object
{
    self=[super init];
    if(self){
        self.department=[object objectForKey:@"department"]?[object objectForKey:@"department"]:@"";
        self.position=[object objectForKey:@"location_id"]?[object objectForKey:@"location_id"]:@"";
        self.partNumber=[object objectForKey:@"part_id"]?[object objectForKey:@"part_id"]:@"";
        self.quantity=[object objectForKey:@"quantity"]?[object objectForKey:@"quantity"]:@"";
        self.urgent=0;
    }
    return self;
}
@end
