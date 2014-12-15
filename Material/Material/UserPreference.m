//
//  UserPreference.m
//  Material
//
//  Created by wayne on 14-12-12.
//  Copyright (c) 2014年 brilliantech. All rights reserved.
//

#import "UserPreference.h"
#import "AFNetOperate.h"
// role:
// 100: 管理员
// 200: 经理
// 300: 发货员
// 400: 收货员
// 500: 要货员
// location:
// FG 成品仓库
// l001 原材料
// l002 外库
// l003 工厂仓库
@interface UserPreference()
@end

@implementation UserPreference
+(instancetype)generateUserPreference:(id)object
{
    UserPreference *userPref=[UserPreference sharedUserPreference];
    userPref.role_id=object[@"role_id"]?[NSString stringWithFormat:@"%@",object[@"role_id"]]:@"";
    userPref.location_id=object[@"location_id"]?object[@"location_id"]:@"";
    userPref.location_name=object[@"location_name"]?object[@"location_name"]:@"";
    return userPref;
}
+(instancetype)sharedUserPreference
{
    static UserPreference *userPreference;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken,^{
        userPreference=[[UserPreference alloc] init];
    });
    return userPreference;
}

@end
