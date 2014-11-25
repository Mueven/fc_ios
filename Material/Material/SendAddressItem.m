//
//  SendAddressItem.m
//  Material
//
//  Created by wayne on 14-11-25.
//  Copyright (c) 2014年 brilliantech. All rights reserved.
//

#import "SendAddressItem.h"

@implementation SendAddressItem
-(instancetype)initWithObject:(NSDictionary *)object
{
    self=[super init];
    if(self){
        self.name=[object objectForKey:@"name"];
        self.id=[object objectForKey:@"id"];
        self.is_default=[[object objectForKey:@"is_default"] intValue]==0?NO:YES;
    }
    return self;
}
@end
