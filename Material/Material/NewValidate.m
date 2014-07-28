//
//  NewValidate.m
//  Material
//
//  Created by wayne on 14-7-28.
//  Copyright (c) 2014年 brilliantech. All rights reserved.
//

#import "NewValidate.h"
@interface NewValidate()
@property(nonatomic,strong)NSString *initialSource;
@end

@implementation NewValidate
+(instancetype)sharedValidate
{
    static NewValidate *validate=nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        validate=[[NewValidate alloc] initPrivate];
    });
    //    YunStore *list=[[YunStore alloc] initPrivate:view];
    return validate;
}
-(instancetype)initPrivate
{
    self=[super init];
    if(self){
        self.initialSource=[NSString string];
    }
    return self;
}
-(void)firstSetSource:(NSString *)source
{
    self.initialSource=source;
}
-(BOOL)sourceValidate:(NSString *)source
{
    BOOL result=[source isEqualToString:self.initialSource];
    return result;
}
@end
