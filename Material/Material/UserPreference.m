//
//  UserPreference.m
//  Material
//
//  Created by wayne on 14-12-12.
//  Copyright (c) 2014年 brilliantech. All rights reserved.
//

#import "UserPreference.h"
#import "AFNetOperate.h"
@interface UserPreference()
@end
@implementation UserPreference
+(instancetype)userPreferenceShared
{
    static UserPreference *userPreference;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken,^{
        userPreference=[[UserPreference alloc] initPrivate];
    });
    return userPreference;
}
-(instancetype)initPrivate
{
    self=[super init];
    if(self){
        AFNetOperate *AFNet=[[AFNetOperate alloc] init];
        AFHTTPRequestOperationManager *manager=[AFHTTPRequestOperationManager manager];
        [manager GET:nil
          parameters:nil
             success:^(AFHTTPRequestOperation *operation, id responseObject) {;
 
             }
             failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                 [AFNet alert:[NSString stringWithFormat:@"%@",error.localizedDescription]];
             }
         ];
    }
    return  self;
}
@end
