//
//  YunStore.m
//  Material
//
//  Created by wayne on 14-6-8.
//  Copyright (c) 2014年 brilliantech. All rights reserved.
//

#import "YunStore.h"

@interface YunStore()
@property (nonatomic,strong) NSMutableArray *yunArray;
@end

@implementation YunStore
+(instancetype)sharedYunStore
{
    static YunStore *list=nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        list=[[YunStore alloc] initPrivate];
    });
    return list;
}
-(instancetype)initPrivate
{
    self=[super init];
    if(self){
        self.yunArray=[[NSMutableArray alloc] init];
    }
    return self;
}
@end
