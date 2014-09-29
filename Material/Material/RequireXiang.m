//
//  RequireXiang.m
//  Material
//
//  Created by wayne on 14-7-21.
//  Copyright (c) 2014年 brilliantech. All rights reserved.
//

#import "RequireXiang.h"
#import "ScanStandard.h"
@interface RequireXiang()
@property (strong,nonatomic)ScanStandard *scanStandard;
@end

@implementation RequireXiang
-(instancetype)initWithObject:(id)object
{
    self=[super init];
    if(self){
        self.scanStandard=[ScanStandard sharedScanStandard];
        @try {
            self.id=[object objectForKey:@"id"]?[object objectForKey:@"id"]:@"";
        }
        @catch (NSException *exception) {
            self.id=@"";
        }
        @try {
            self.quantity=[object objectForKey:@"quantity"]?[NSString stringWithFormat:@"%@",[object objectForKey:@"quantity"]]:@"";
            //after regex quantity
            int beginQ=[[[self.scanStandard.rules objectForKey:@"ORDERITEM_QTY"] objectForKey:@"prefix_length"] intValue];
            int lastQ=[[[self.scanStandard.rules objectForKey:@"ORDERITEM_QTY"] objectForKey:@"suffix_length"] intValue];
            if([self.quantity substringWithRange:NSMakeRange(beginQ, [self.quantity length]-beginQ-lastQ)]){
                self.quantity_int=[self.quantity substringWithRange:NSMakeRange(beginQ, [self.quantity length]-beginQ-lastQ)];
            }
            else{
                self.quantity=@"0";
                self.quantity_int=@"0";
            }
        }
        @catch (NSException *exception) {
            self.quantity=@"0";
            self.quantity_int=@"0";
        }
        @try {
            self.source=[object objectForKey:@"source_id"]?[object objectForKey:@"source_id"]:@"";
            self.source_name=[object objectForKey:@"source"]?[object objectForKey:@"source"]:@"";
        }
        @catch (NSException *exception) {
            self.source=@"";
            self.source_name=@"";
        }
        self.position=[object objectForKey:@"position"]?[object objectForKey:@"position"]:@"";
        
        self.partNumber=[object objectForKey:@"part_id"]?[object objectForKey:@"part_id"]:@"";
        int beginP=[[[self.scanStandard.rules objectForKey:@"ORDERITEM_PART"] objectForKey:@"prefix_length"] intValue];
        int lastP=[[[self.scanStandard.rules objectForKey:@"ORDERITEM_PART"] objectForKey:@"suffix_length"] intValue];
        @try {
            if([self.partNumber substringWithRange:NSMakeRange(beginP, [self.partNumber length]-beginP-lastP)]){
                 self.partNumber_origin=[self.partNumber substringWithRange:NSMakeRange(beginP, [self.partNumber length]-beginP-lastP)];
            }
            else{
               self.partNumber_origin=@"";
            }
        }
        @catch (NSException *exception) {
            self.partNumber_origin=@"";
        }
        self.department=[object objectForKey:@"whouse_id"]?[object objectForKey:@"whouse_id"]:@"";
        
        int beginD=[[[self.scanStandard.rules objectForKey:@"ORDERITEM_DEPARTMENT"] objectForKey:@"prefix_length"] intValue];
        int lastD=[[[self.scanStandard.rules objectForKey:@"ORDERITEM_DEPARTMENT"] objectForKey:@"suffix_length"] intValue];
        @try {
            if([self.department substringWithRange:NSMakeRange(beginD, [self.department length]-beginD-lastD)]){
                self.department_origin=[self.department substringWithRange:NSMakeRange(beginD, [self.department length]-beginD-lastD)];
            }
            else{
                self.department_origin=@"";
            }
        }
        @catch (NSException *exception) {
            self.department_origin=@"";
        }
        
        
        self.agent=[object objectForKey:@"user_id"]?[object objectForKey:@"user_id"]:@"";
        self.urgent=[object objectForKey:@"is_emergency"]?[[object objectForKey:@"is_emergency"] intValue]:0;
        self.uniq_id=[object objectForKey:@"uniq_id"]?[object objectForKey:@"uniq_id"]:@"";
        self.xiangCount=[object objectForKey:@"box_quantity"]?[[object objectForKey:@"box_quantity"] intValue]:1;
        
        self.handled=[object objectForKey:@"handled"]?[[object objectForKey:@"handled"] intValue]:0;
        self.is_finished=[object objectForKey:@"is_finished"]?[[object objectForKey:@"is_finished"] intValue]:0;
        self.out_of_stock=[object objectForKey:@"out_of_stock"]?[[object objectForKey:@"out_of_stock"] intValue]:0;
        
        self.handled_text=self.handled==0?@"尚未处理":@"处理完成";
        self.is_finished_text=self.is_finished==0?@"尚未备货":@"完成备货";
        self.out_of_stock_text=self.out_of_stock==0?@"正常":@"缺货";
    }
    return self;
}
@end
