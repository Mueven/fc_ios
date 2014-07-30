//
//  MAppDelegate.m
//  Material
//
//  Created by wayne on 14-6-5.
//  Copyright (c) 2014年 brilliantech. All rights reserved.
//

#import "MAppDelegate.h"
#import "Login.h"
#import <AudioToolbox/AudioToolbox.h>
#import "AFNetOperate.h"
@interface MAppDelegate()
@property(nonatomic) BOOL updating;
@end

@implementation MAppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    //霍尼韦尔设备
    [[Captuvo sharedCaptuvoDevice] setDecoderGoodReadBeeperVolume:BeeperVolumeLow persistSetting:YES];
    [UIDevice currentDevice].batteryMonitoringEnabled = YES;
    Reachability *reachability = [Reachability reachabilityWithHostname:@"www.google.com"];
    reachability.reachableBlock = ^(Reachability *reachability) {
        
    };
    reachability.unreachableBlock = ^(Reachability *reachability) {
        dispatch_async(dispatch_get_main_queue(), ^{
            UIAlertView *alert=[[UIAlertView alloc] initWithTitle:@""
                                                          message:@"网络连接已断开"
                                                         delegate:self
                                                cancelButtonTitle:@"确定"
                                                otherButtonTitles:nil];
            AudioServicesPlaySystemSound(1013);
            [alert show];
        });
        
    };
    [reachability startNotifier];
    
    //自动更新
    @try {
        NSString *version = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"];
        
        AFNetOperate *AFNet=[[AFNetOperate alloc] init];
        AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
//        NSLog(@"address:%@",[AFNet version]);
//        @"http://www.cz-tek.com:9000"
        [manager GET:[AFNet version]
           parameters:@{@"version":version}
              success:^(AFHTTPRequestOperation *operation, id responseObject) {
                  UpdatePolicy policy = LATEST;
//                  NSLog(@"update:%@",responseObject);
                  if([responseObject[@"result"] integerValue]==1){
                        //有更新
                      if([responseObject[@"is_force"] integerValue]==1){
                          //强制更新
                          policy = MUST;
                      }
                      else{
                          //可选更新
                          policy = OPTION;
                      }
                      NSString *title = @"有新版本可以使用";
                      NSString *cancelTxt = @"下次再说";
                      NSString *otherTxt = @"立刻升级";
                      if(policy== OPTION){
                          UIAlertView *view = [[UIAlertView alloc ]initWithTitle:title
                                                                         message:nil
                                                                        delegate:self
                                                               cancelButtonTitle:cancelTxt
                                                               otherButtonTitles:otherTxt,nil];
                          [view show ];
                      }
                      else if (policy == MUST){
                          UIAlertView *view = [[UIAlertView alloc ]initWithTitle:title
                                                                         message:@"必须更新版本才能继续使用"
                                                                        delegate:self
                                                               cancelButtonTitle:cancelTxt
                                                               otherButtonTitles:otherTxt, nil];
                          [view show ];
                      }
                  }
  
              }
              failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                 [AFNet alert:[NSString stringWithFormat:@"%@",[error localizedDescription]]];
              }
         ];
    }
    @catch (NSException *exception) {
    }
    @finally {
    }
    
    
    
    return YES;
}
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    NSString *base=@"https://www.cz-tek.com";
    NSString *fileName=@"material";
    NSURL *url=[NSURL URLWithString:[NSString stringWithFormat:@"itms-services://?action=download-manifest&url=%@/%@.plist",base,fileName]];
    if (buttonIndex == 1) {
        [[UIApplication sharedApplication] openURL:url];
    }
}
- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
     [[Captuvo sharedCaptuvoDevice] stopDecoderHardware];
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    [[Captuvo sharedCaptuvoDevice] startDecoderHardware];
    [[Captuvo sharedCaptuvoDevice] enableDecoderPowerUpBeep:YES];
    
    dispatch_queue_t observeBattery=dispatch_queue_create("com.observe.battery.pptalent", NULL);
    dispatch_sync(observeBattery, ^{
        double delayInTime=17.0;
        dispatch_time_t popTime=dispatch_time(DISPATCH_TIME_NOW, (int64_t)delayInTime *NSEC_PER_SEC);
        dispatch_after(popTime, dispatch_get_main_queue(), ^{
            BatteryStatus status=[[Captuvo sharedCaptuvoDevice] getBatteryStatus];
            UIAlertView *alert=[[UIAlertView alloc] initWithTitle:@""
                                                          message:@""
                                                         delegate:self
                                                cancelButtonTitle:@"ok"
                                                otherButtonTitles: nil];
            
            switch (status) {
                case BatteryStatus4Of4Bars:
//                    alert.message=@"40";
//                    [alert show];
                    break;
                case BatteryStatus3Of4Bars:
//                    alert.message=@"30";
//                    [alert show];
                    break;
                case BatteryStatus2Of4Bars:
                    alert.message=@"设备电量低，建议使用完后立刻充电";
                    [alert show];
                    AudioServicesPlaySystemSound(1013);
                    break;
                case BatteryStatus1Of4Bars:
                    alert.message=@"设备电量极低，建议充电后使用";
                    [alert show];
                    AudioServicesPlaySystemSound(1013);
                    break;
                case BatteryStatus0Of4Bars:
                    alert.message=@"设备电量耗尽，请立刻充电";
                    [alert show];
                    AudioServicesPlaySystemSound(1013);
                    break;
                case BatteryStatusPowerSourceConnected:
//                    alert.message=@"BatteryStatusPowerSourceConnected";
//                    [alert show];
                    break;
                case BatteryStatusUndefined:
//                    alert.message=@"BatteryStatusUndefined";
//                    [alert show];
                    break;
                default:
//                    alert.message=@"default";
//                    [alert show];
                    break;
            }
            
        });

    });
    
    
    
//    [self getStatusOfBattery];
//    BatteryStatusPowerSourceConnected,        /**< Device is connected to a power source */
//    BatteryStatus4Of4Bars,                    /**< Battery indicator should read 4 of 4 bars */
//    BatteryStatus3Of4Bars,                    /**< Battery indicator should read 3 of 4 bars */
//    BatteryStatus2Of4Bars,                    /**< Battery indicator should read 2 of 4 bars */
//    BatteryStatus1Of4Bars,                    /**< Battery indicator should read 1 of 4 bars */
//    BatteryStatus0Of4Bars,                    /**< Battery indicator should read 0 of 4 bars */
//    BatteryStatusUndefined
    
    // Restart any tasks that were paused (or not yet started) while  the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}
- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
