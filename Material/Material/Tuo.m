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
-(instancetype)initExample
{
    self=[super init];
    if(self){
        self.department=@"MB_example";
        self.agent=@"Wayne";
        self.xiang=[[NSMutableArray alloc] init];
        for(int i=0;i<3;i++){
            Xiang *xiang=[[Xiang alloc] initExample];
            [self.xiang addObject:xiang];
        }
    }
    return self;
}
@end
