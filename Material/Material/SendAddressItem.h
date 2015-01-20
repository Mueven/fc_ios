//
//  SendAddressItem.h
//  Material
//
//  Created by wayne on 14-11-25.
//  Copyright (c) 2014年 brilliantech. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SendAddressItem : NSObject
@property(nonatomic,strong)NSString *name;
@property(nonatomic,strong)NSString *id;
@property(nonatomic)int is_default;
-(instancetype)initWithObject:(NSDictionary *)object;
@end
