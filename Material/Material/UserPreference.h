//
//  UserPreference.h
//  Material
//
//  Created by wayne on 14-12-12.
//  Copyright (c) 2014年 brilliantech. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UserPreference : NSObject
@property(nonatomic,strong)NSString *location_id;
@property(nonatomic,strong)NSString *location_name;
@property(nonatomic,strong)NSString *role_id;
+(instancetype)sharedUserPreference;
+(instancetype)generateUserPreference:(id)object;
@end
