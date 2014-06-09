//
//  YunStore.h
//  Material
//
//  Created by wayne on 14-6-8.
//  Copyright (c) 2014年 brilliantech. All rights reserved.
//

#import <Foundation/Foundation.h>
@class Yun;

@interface YunStore : NSObject
@property (nonatomic,strong) NSMutableArray *yunArray;
+(instancetype)sharedYunStore;
@end
