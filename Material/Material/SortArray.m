//
//  SortArray.m
//  Material
//
//  Created by wayne on 14-8-19.
//  Copyright (c) 2014年 brilliantech. All rights reserved.
//

#import "SortArray.h"
#import "Xiang.h"

@implementation SortArray
+(NSArray *)sortByPartNumber:(NSArray *)originArray
{
    NSMutableArray *origin=[originArray mutableCopy];
    NSMutableArray *newArray=[NSMutableArray array];
    NSString *partNumber=[NSString string];
    NSMutableDictionary *currentItem=[NSMutableDictionary dictionary];
    [currentItem setObject:[NSMutableArray array] forKey:@"xiangArray"];
    while(origin.count>0){
        int length=origin.count;
        for(int i=length-1;i>=0;i--){
            if(i==length-1){
                partNumber=[origin[i] objectForKey:@"number"];
                [currentItem setObject:partNumber forKey:@"partNumber"];
                [currentItem[@"xiangArray"] addObject:[origin[i] copy]];
                [origin removeObjectAtIndex:i];
                if(i==0){
                    [newArray addObject:[currentItem copy]];
                    break ;
                }
            }
            else{
                NSString *currentPartNumber=[origin[i] objectForKey:@"number"];
                if([currentPartNumber isEqualToString:partNumber]){
                    [currentItem[@"xiangArray"] addObject:[origin[i] copy]];
                    [origin removeObjectAtIndex:i];
                }
                if(i==0){
                    [newArray addObject:[currentItem copy]];
                    [currentItem setObject:[NSMutableArray array] forKey:@"xiangArray"];
                }
            }
        }
    }
    return [newArray copy];
}
@end
