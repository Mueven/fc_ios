//
//  XiangStore.m
//  Material
//
//  Created by wayne on 14-6-6.
//  Copyright (c) 2014年 brilliantech. All rights reserved.
//

#import "XiangStore.h"
#import "Xiang.h"
#import "AFNetOperate.h"

@interface XiangStore()

@end
@implementation XiangStore
+(instancetype)sharedXiangStore:(UITableView *)view
{
    static XiangStore *xiangList=nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        xiangList=[[XiangStore alloc] initPrivate:view];
    });
    return xiangList;
}
-(instancetype)initPrivate:(UITableView *)view
{
    self=[super init];
    if(self){
        self.xiangArray=[[NSMutableArray alloc] init];
        [[[AFNetOperate alloc] init] getXiangs:self.xiangArray view:view];
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
    xiang.date=@"05.13";
    [self.xiangArray addObject:xiang];
    return xiang;
}
-(NSInteger)xiangCount
{
    return [self.xiangArray count];
}
-(NSArray *)xiangList
{
    return [self.xiangArray copy];
}
-(void)removeXiang:(NSInteger)index
{
    [self.xiangArray removeObjectAtIndex:index];
}
@end
