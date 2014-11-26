//
//  SendAddress.m
//  Material
//
//  Created by wayne on 14-11-24.
//  Copyright (c) 2014年 brilliantech. All rights reserved.
//

#import "SendAddress.h"
#import "AFNetOperate.h"

@implementation SendAddress
+(instancetype)sharedSendAddress
{
    static SendAddress *address=nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        address=[[SendAddress alloc] initPrivate];
    });
    return address;
}
-(instancetype)initPrivate
{
    self=[super init];
    if(self){
        //从网络上取下默认地址和地址列表
        self.addresses=[[NSMutableArray alloc] init];
        self.defaultAddress=[[SendAddressItem alloc] init];
        AFHTTPRequestOperationManager *manager=[AFHTTPRequestOperationManager manager];
        [manager GET:[[[AFNetOperate alloc] init] send_address]
          parameters:nil
             success:^(AFHTTPRequestOperation *operation, id responseObject) {
                 NSArray *result=responseObject;
                 for(int i=0;i<result.count;i++){
                     SendAddressItem *item=[[SendAddressItem alloc] initWithObject:(NSDictionary *)result[i]];
                     [self.addresses addObject:item];
                     if(item.is_default){
                         self.defaultAddress.name=item.name;
                         self.defaultAddress.id=item.id;
                         self.defaultAddress.is_default=item.is_default;
                     }
                 }
                 if(!self.defaultAddress.name){
                     self.defaultAddress.name=@"";
                     self.defaultAddress.id=@"";
                     self.defaultAddress.is_default=NO;
                 }
             }
             failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                 NSLog(@"%@",[error localizedDescription]);
             }
         ];

    }
    return self;
}

@end
