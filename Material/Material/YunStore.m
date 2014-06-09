//
//  YunStore.m
//  Material
//
//  Created by wayne on 14-6-8.
//  Copyright (c) 2014年 brilliantech. All rights reserved.
//

#import "YunStore.h"
#import "Yun.h"

@interface YunStore()

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
        for(int i=0;i<3;i++){
            Yun *yun=[[Yun alloc] initExample];
            [self.yunArray addObject:yun];
        }
    }
    return self;
}
@end
