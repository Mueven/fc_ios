//
//  NewValidate.h
//  Material
//
//  Created by wayne on 14-7-28.
//  Copyright (c) 2014年 brilliantech. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NewValidate : NSObject
+(instancetype)sharedValidate;
-(void)firstSetSource:(NSString *)source;
-(BOOL)sourceValidate:(NSString *)source;
@end
