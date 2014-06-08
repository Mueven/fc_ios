//
//  Tuo.m
//  Material
//
//  Created by wayne on 14-6-6.
//  Copyright (c) 2014年 brilliantech. All rights reserved.
//

#import "Tuo.h"
#import "Xiang.h"

@implementation Tuo
-(instancetype)init{
    self=[super init];
    if(self){
        self.xiang=[[NSMutableArray alloc] init];
    }
    return self;
}
-(instancetype)initExample
{
    self=[super init];
    if(self){
        self.department=[NSString stringWithFormat:@"MB_example%d",arc4random()%99];
        self.agent=[NSString stringWithFormat:@"Wayne%d",arc4random()%99];
        self.xiang=[[NSMutableArray alloc] init];
        for(int i=0;i<3;i++){
            Xiang *xiang=[[Xiang alloc] initExample];
            [self.xiang addObject:xiang];
        }
    }
    return self;
}
-(void)addXiang:(Xiang *)xiang
{
    [self.xiang addObject:xiang];
}
-(NSInteger)xiangAmount
{
    return [self.xiang count];
}
@end
