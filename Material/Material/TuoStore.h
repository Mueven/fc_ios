//
//  TuoStore.h
//  Material
//
//  Created by wayne on 14-6-6.
//  Copyright (c) 2014年 brilliantech. All rights reserved.
//

#import <Foundation/Foundation.h>
@class Tuo;

@interface TuoStore : NSObject
+(instancetype)sharedTuoStore;
-(NSArray *)tuoList;
-(int)tuoCount;
-(void)addTuo:(Tuo *)tuo;
@end
