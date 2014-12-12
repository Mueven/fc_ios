//
//  UserPreference.h
//  Material
//
//  Created by wayne on 14-12-12.
//  Copyright (c) 2014年 brilliantech. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UserPreference : NSObject
@property(nonatomic,strong)NSString *type;
+(instancetype)userPreferenceShared;

@end
