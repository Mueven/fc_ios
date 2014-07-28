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
        @try {
            self.id=[object objectForKey:@"id"]?[object objectForKey:@"id"]:@"";
        }
        @catch (NSException *exception) {
            self.id=@"";
        }
        @try {
            self.quantity=[object objectForKey:@"quantity"]?[NSString stringWithFormat:@"%@",[object objectForKey:@"quantity"]]:@"";
        }
        @catch (NSException *exception) {
            self.quantity=@"0";
        }
        @try {
            self.source=[object objectForKey:@"source_id"]?[object objectForKey:@"source_id"]:@"";
            self.source_name=[object objectForKey:@"source"]?[object objectForKey:@"source"]:@"";
        }
        @catch (NSException *exception) {
            self.source=@"";
            self.source_name=@"";
        }
        self.position=[object objectForKey:@"position"]?[object objectForKey:@"position"]:@"";
        self.partNumber=[object objectForKey:@"part_id"]?[object objectForKey:@"part_id"]:@"";
        self.department=[object objectForKey:@"whouse_id"]?[object objectForKey:@"whouse_id"]:@"";
        self.agent=[object objectForKey:@"user_id"]?[object objectForKey:@"user_id"]:@"";
        self.urgent=[object objectForKey:@"is_emergency"]?[[object objectForKey:@"is_emergency"] intValue]:0;
        self.uniq_id=[object objectForKey:@"uniq_id"]?[object objectForKey:@"uniq_id"]:@"";
        self.xiangCount=1;
    }
    return self;
}
@end
