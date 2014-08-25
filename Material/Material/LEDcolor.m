//
//  LEDcolor.m
//  Material
//
//  Created by wayne on 14-8-25.
//  Copyright (c) 2014年 brilliantech. All rights reserved.
//

#import "LEDcolor.h"
#import "AFNetOperate.h"
@interface LEDcolor()
@property(nonatomic,strong)NSDictionary *stateDic;
@end
@implementation LEDcolor
+(instancetype)sharedLEDColor{
    static LEDcolor *ledColor=nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken,^{
        ledColor=[[LEDcolor alloc] initPrivate];
    });
    return ledColor;
}
-(instancetype)initPrivate
{
    self=[super init];
    if(self){
        AFNetOperate *AFNet=[[AFNetOperate alloc] init];
        AFHTTPRequestOperationManager *manager=[AFHTTPRequestOperationManager manager];
        [manager GET:[AFNet order_led_state_list]
          parameters:nil
             success:^(AFHTTPRequestOperation *operation, id responseObject) {
                 if([responseObject[@"result"] integerValue]==1){
                     NSMutableDictionary *tempDic=[NSMutableDictionary dictionary];
                     NSString *key=[NSString string];
                     for(int i=0;i<[responseObject[@"content"] count];i++){
                         NSDictionary *item=[responseObject[@"content"] objectAtIndex:i];
                         key=[NSString stringWithFormat:@"%@",item[@"state"]];
                         NSMutableArray *colorArray=[NSMutableArray array];
                         [colorArray addObject:item[@"R"]];
                         [colorArray addObject:item[@"G"]];
                         [colorArray addObject:item[@"B"]];
                         [tempDic setObject:colorArray forKey:key];
                     }
                     self.stateDic=[tempDic copy];
                 }
                 else{
                     
                 }
             }
             failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                 
             }
         ];
    }
    return self;
}
-(UIColor *)getStateColor:(int)state
{
    NSString *stateString=[NSString stringWithFormat:@"%d",state];
    if([self.stateDic objectForKey:stateString]){
       NSArray *colorArray=[self.stateDic objectForKey:stateString];
       UIColor *color=[UIColor colorWithRed:[colorArray[0] floatValue]/255.0 green:[colorArray[1] floatValue]/255.0 blue:[colorArray[2] floatValue]/255.0 alpha:1.0];
       return color;
    }
    else{
        UIAlertView *alert=[[UIAlertView alloc] initWithTitle:@""
                                                      message:@"没有找到这个状态的颜色"
                                                     delegate:self
                                            cancelButtonTitle:@"确定"
                                            otherButtonTitles:nil];
        [alert show];
        return NULL;
    }
}
@end
