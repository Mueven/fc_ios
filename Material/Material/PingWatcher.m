//
//  PingWatcher.m
//  Material
//
//  Created by wayne on 14-8-15.
//  Copyright (c) 2014年 brilliantech. All rights reserved.
//

#import "PingWatcher.h"
#import "SimplePingHelper.h"
#import <AudioToolbox/AudioToolbox.h>
@interface PingWatcher()<UIAlertViewDelegate>
@property(nonatomic,strong)NSTimer *timer;
@property(nonatomic,strong)UIAlertView *alert;
@end
@implementation PingWatcher
+(instancetype)sharedPingWtcher
{
    static PingWatcher *pingWatcher=nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken,^{
        pingWatcher=[[PingWatcher alloc] initPrivate];
    });
    return pingWatcher;
}
-(instancetype)initPrivate
{
    self=[super init];
    if(self){
        self.alert=nil;
    }
    return self;
}
-(void)resumePingWatcher
{
    self.timer=[NSTimer scheduledTimerWithTimeInterval:2.0f
                                     target:self
                                   selector:@selector(schedulePing)
                                   userInfo:nil
                                    repeats:YES];
}
-(void)stopPingWtcher
{
    [self.timer invalidate];
    self.timer=nil;
}
-(void)schedulePing
{
    [SimplePingHelper ping:@"121.199.48.53"
                    target:self
                       sel:@selector(pingResult:)];
}

- (void)pingResult:(NSNumber*)success
{
	if (success.boolValue) {
		if(self.timer){
            self.timer=nil;
        }
	}
    else {
        if(!self.alert){
            AudioServicesPlaySystemSound(1051);
            self.alert=[[UIAlertView alloc] initWithTitle:@"错误"
                                                  message:@"与服务器的连接已断开"
                                                 delegate:self
                                        cancelButtonTitle:@"确定"
                                        otherButtonTitles:nil];
            [self.alert show];
        }
	}
}
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if(buttonIndex==0){
        self.alert=nil;
    }
}
@end
