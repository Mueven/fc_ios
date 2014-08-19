//
//  PingWatcher.h
//  Material
//
//  Created by wayne on 14-8-15.
//  Copyright (c) 2014年 brilliantech. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PingWatcher : NSObject
+(instancetype)sharedPingWtcher;
-(void)resumePingWatcher;
-(void)stopPingWtcher;
-(void)changeSererAddress:(NSString *)newAddress;
@end
