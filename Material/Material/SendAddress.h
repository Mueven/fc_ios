//
//  SendAddress.h
//  Material
//
//  Created by wayne on 14-11-24.
//  Copyright (c) 2014年 brilliantech. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SendAddressItem.h"
@interface SendAddress : NSObject
@property(nonatomic,strong)SendAddressItem *defaultAddress;
@property(nonatomic,strong)NSMutableArray *addresses;
+(instancetype)sharedSendAddress;
@end
