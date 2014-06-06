//
//  XiangStore.m
//  Material
//
//  Created by wayne on 14-6-6.
//  Copyright (c) 2014年 brilliantech. All rights reserved.
//

#import "XiangStore.h"

@implementation XiangStore
+(instancetype)sharedXiangStore
{
    static XiangStore *xiangList=nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        xiangList=[[XiangStore alloc] initPrivate];
    });
    return xiangList;
}
-(instancetype)initPrivate
{
    self=[super init];
    if(self){
        
    }
    return self;
}
@end
