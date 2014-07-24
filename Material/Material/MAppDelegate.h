//
//  MAppDelegate.h
//  Material
//
//  Created by wayne on 14-6-5.
//  Copyright (c) 2014年 brilliantech. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef enum {
    LATEST = 0,    //无更新
    OPTION = 1,    //有更新，但可选
    MUST = 2,      //必须更新
    
} UpdatePolicy;
@interface MAppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

@end
