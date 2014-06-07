//
//  XiangStore.m
//  Material
//
//  Created by wayne on 14-6-6.
//  Copyright (c) 2014年 brilliantech. All rights reserved.
//

#import "XiangStore.h"
#import "Xiang.h"

@interface XiangStore()
@property(nonatomic,strong)NSMutableArray *xiangArray;
@end
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
        self.xiangArray=[[NSMutableArray alloc] init];
    }
    return self;
}
-(Xiang *)addXiang:(NSString *)key partNumber:(NSString *)partNumber quatity:(NSString *)quatity
{
    Xiang *xiang=[[Xiang alloc] init];
    xiang.key=key;
    xiang.number=partNumber;
    xiang.count=quatity;
    //example
    xiang.position=@"12 13 21";
    xiang.remark=@"1";
    [self.xiangArray addObject:xiang];
    return xiang;
}

@end
