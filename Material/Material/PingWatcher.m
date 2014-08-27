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
@property(nonatomic,strong)NSString *serverAddress;
@property(nonatomic)int maxCount;
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
        NSArray *documentDictionary=NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        NSString *document=[documentDictionary firstObject];
        NSString *pathServer=[document stringByAppendingPathComponent:@"server.address.archive"];
        if([NSKeyedUnarchiver unarchiveObjectWithFile:pathServer]){
            NSDictionary *dictionary=[NSKeyedUnarchiver unarchiveObjectWithFile:pathServer];
            self.serverAddress=[dictionary objectForKey:@"ip"];
        }
        else{
            NSString *plistPath=[[NSBundle mainBundle] pathForResource:@"URL" ofType:@"plist"];
            NSMutableDictionary *URLDictionary=[[NSMutableDictionary alloc] initWithContentsOfFile:plistPath];
            self.serverAddress=[URLDictionary objectForKey:@"server"];
        }
    }
    return self;
}
-(void)resumePingWatcher
{
    self.timer=[NSTimer scheduledTimerWithTimeInterval:60.0f
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
    if(self.serverAddress.length>0){
        [SimplePingHelper ping:self.serverAddress
                        target:self
                           sel:@selector(pingResult:)];
    }
    else{
        [self stopPingWtcher];
    }
}

- (void)pingResult:(NSNumber*)success
{
	if (success.boolValue) {
        self.maxCount=0;
		if(self.timer){
            self.timer=nil;
        }
	}
    else {
        self.maxCount++;
        if(!self.alert && self.maxCount>=3){
            AudioServicesPlaySystemSound(1051);
            self.alert=[[UIAlertView alloc] initWithTitle:@"错误"
                                                  message:@"与同步服务器断开连接"
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
-(void)changeSererAddress:(NSString *)newAddress
{
    self.serverAddress=newAddress;
}
@end
