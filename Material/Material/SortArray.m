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
    NSMutableArray *newArray=[[NSMutableArray alloc] init];
    NSString *partNumber=[NSString string];
    NSMutableDictionary *currentItem=[[NSMutableDictionary alloc] init];
    NSMutableArray *tempArray=[[NSMutableArray alloc] init];
    [currentItem setObject:tempArray forKey:@"xiangArray"];
    
    while(origin.count>0){
        int length=origin.count;
        for(int i=length-1;i>=0;i--){
            Xiang *xiang=origin[i];
            if(i==length-1){
                partNumber=xiang.number;
                [currentItem setObject:partNumber forKey:@"partNumber"];
                [currentItem[@"xiangArray"] addObject:[[Xiang alloc] copyMe:xiang]];
                [origin removeObjectAtIndex:i];
                if(i==0){
                    [newArray addObject:[currentItem copy]];
                }
            }
            else{
                NSString *currentPartNumber=xiang.number;
                if([currentPartNumber isEqualToString:partNumber]){
                    [currentItem[@"xiangArray"] addObject:[[Xiang alloc] copyMe:xiang]];
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
