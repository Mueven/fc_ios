//
//  ScanStandard.h
//  Material
//
//  Created by wayne on 14-7-14.
//  Copyright (c) 2014年 brilliantech. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ScanStandard : NSObject
@property(strong,nonatomic)NSMutableDictionary *rules;
+(instancetype)sharedScanStandard;
@end
