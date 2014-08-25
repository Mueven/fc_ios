//
//  LED.h
//  Material
//
//  Created by wayne on 14-8-25.
//  Copyright (c) 2014年 brilliantech. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LED : NSObject
@property(nonatomic,strong)NSString *position;
@property(nonatomic,strong)NSString *beginDate;
@property(nonatomic,strong)NSString *endDate;
@property(nonatomic)int requirement;
@property(nonatomic)int received;
@property(nonatomic)int absent;
@property(nonatomic)int state;
-(instancetype)initWithObject:(id)object;
@end
