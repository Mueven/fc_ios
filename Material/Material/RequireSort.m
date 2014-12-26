//
//  RequireSort.m
//  Material
//
//  Created by wayne on 14-12-26.
//  Copyright (c) 2014年 brilliantech. All rights reserved.
//

#import "RequireSort.h"
#import "RequireXiang.h"
@implementation RequireSort
+(NSArray *)sortByPartNumber:(NSArray *)originArray
{
    NSMutableArray *origin=[originArray mutableCopy];
    NSMutableArray *newArray=[[NSMutableArray alloc] init];
    NSString *partNumber=[NSString string];
    NSMutableDictionary *currentItem=[[NSMutableDictionary alloc] init];
    NSMutableArray *tempArray=[[NSMutableArray alloc] init];
    [currentItem setObject:tempArray forKey:@"xiangArray"];
    while(origin.count>0){
        int length=origin.count;
        for(int i=length-1;i>=0;i--){
            RequireXiang *xiang=origin[i];
            if(i==length-1){
                //the first to add
                partNumber=xiang.partNumber;
                [currentItem setObject:partNumber forKey:@"partNumber"];
                [currentItem[@"xiangArray"] addObject:[[RequireXiang alloc] copyMe:xiang]];
                [currentItem setObject:xiang.quantity_int forKey:@"partCount"];
                [currentItem setObject:[NSString stringWithFormat:@"%d",1] forKey:@"xiangCount"];
                [origin removeObjectAtIndex:i];
                if(i==0){
                    //only one first=last
                    [newArray addObject:[currentItem copy]];
                }
            }
            else{
                NSString *currentPartNumber=xiang.partNumber;
                if([currentPartNumber isEqualToString:partNumber]){
                    [currentItem[@"xiangArray"] addObject:[[RequireXiang alloc] copyMe:xiang]];
                    //part sum count
                    int current_quantity=[currentItem[@"partCount"] intValue]+[xiang.quantity_int intValue];
                    [currentItem setObject:[NSString stringWithFormat:@"%d",current_quantity] forKey:@"partCount"];
                    //xiang count sum
                    int current_xiang_count=[currentItem[@"xiangCount"] intValue]+1;
                    [currentItem setObject:[NSString stringWithFormat:@"%d",current_xiang_count] forKey:@"xiangCount"];
                    [origin removeObjectAtIndex:i];
                }
                if(i==0){
                    //the last
                    [newArray addObject:[currentItem copy]];
                    [currentItem setObject:[NSMutableArray array] forKey:@"xiangArray"];
                }
            }
        }
    }
    //item:{xiangArray:,partNumber:,xiangCount:,partCount}
    return [newArray copy];
}
@end
