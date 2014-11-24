//
//  SendAddress.h
//  Material
//
//  Created by wayne on 14-11-24.
//  Copyright (c) 2014年 brilliantech. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SendAddress : NSObject
@property(nonatomic,strong)NSString *defaultAddress;
@property(nonatomic,strong)NSArray *addresses;
+(instancetype)sharedSendAddress;
-(void)updateAddress:(NSString *)address;
@end
