//
//  LEDcolor.h
//  Material
//
//  Created by wayne on 14-8-25.
//  Copyright (c) 2014年 brilliantech. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LEDcolor : NSObject
+(instancetype)sharedLEDColor;
-(UIColor *)getStateColor:(int)state;
@end
