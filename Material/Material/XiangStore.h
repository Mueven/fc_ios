//
//  XiangStore.h
//  Material
//
//  Created by wayne on 14-6-6.
//  Copyright (c) 2014年 brilliantech. All rights reserved.
//

#import <Foundation/Foundation.h>
@class Xiang;

@interface XiangStore : NSObject
@property(nonatomic,strong)NSMutableArray *xiangArray;
+(instancetype)sharedXiangStore:(UIView *)view;
-(Xiang *)addXiang:(NSString *)key partNumber:(NSString *)partNumber quatity:(NSString *)quatity;
-(NSInteger)xiangCount;
-(NSArray *)xiangList;
-(void)removeXiang:(NSInteger)index;
@end
