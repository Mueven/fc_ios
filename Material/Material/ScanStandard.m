//
//  ScanStandard.m
//  Material
//
//  Created by wayne on 14-7-14.
//  Copyright (c) 2014年 brilliantech. All rights reserved.
//

#import "ScanStandard.h"
#import "AFNetOperate.h"

@implementation ScanStandard
+(instancetype)sharedScanStandard
{
    static ScanStandard *scanStandard=nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        scanStandard=[[ScanStandard alloc] initPrivate];
    });
    return scanStandard;
}
-(instancetype)initPrivate
{
    self=[super init];
    if(self){
        NSString *validateString=[[[AFNetOperate alloc] init] scan_validate];
        AFHTTPRequestOperationManager *manager=[AFHTTPRequestOperationManager manager];
        [manager GET:validateString
          parameters:nil
             success:^(AFHTTPRequestOperation *operation, id responseObject) {
                 NSArray *result=responseObject;
                 if([result count]>0){
                     self.rules=[[NSMutableDictionary alloc] init];
                     for(int i=0;i<[result count];i++){
                         NSDictionary *item=result[i];
                         NSString *key=[item objectForKey:@"code"];
                         [self.rules setObject:item forKey:key];
                     }
                 }
             }
             failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                 NSLog(@"%@",[error localizedDescription]);
             }
         ];
    }
    return self;
}
-(NSString *)order_item_part_fix:(NSString *)param
{
    int beginSP=[[[self.rules objectForKey:@"ORDERITEM_PART"] objectForKey:@"prefix_length"] intValue];
    int lastSP=[[[self.rules objectForKey:@"ORDERITEM_PART"] objectForKey:@"suffix_length"] intValue];
    NSString *partNumberPost=[NSString string];
    if([[param copy] substringWithRange:NSMakeRange(beginSP, [param length]-beginSP-lastSP)]){
        partNumberPost=[[param copy] substringWithRange:NSMakeRange(beginSP, [param length]-beginSP-lastSP)];
    }
    else{
        partNumberPost=@"";
    }
    return partNumberPost;
}
-(NSString *)order_item_department_fix:(NSString *)param
{
    int beginSP=[[[self.rules objectForKey:@"ORDERITEM_DEPARTMENT"] objectForKey:@"prefix_length"] intValue];
    int lastSP=[[[self.rules objectForKey:@"ORDERITEM_DEPARTMENT"] objectForKey:@"suffix_length"] intValue];
    NSString *partNumberPost=[NSString string];
    if([[param copy] substringWithRange:NSMakeRange(beginSP, [param length]-beginSP-lastSP)]){
        partNumberPost=[[param copy] substringWithRange:NSMakeRange(beginSP, [param length]-beginSP-lastSP)];
    }
    else{
        partNumberPost=@"";
    }
    return partNumberPost;
}
@end
