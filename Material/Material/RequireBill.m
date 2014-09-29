//
//  RequireBill.m
//  Material
//
//  Created by wayne on 14-7-21.
//  Copyright (c) 2014年 brilliantech. All rights reserved.
//

#import "RequireBill.h"
@interface RequireBill()

@end
@implementation RequireBill
-(instancetype)init
{
    self=[super init];
    if(self){
        self.xiangList=[NSArray array];
    }
    return self;
}
-(instancetype)initWithObject:(id)object
{
    self=[super init];
    if(self){
        self.xiangList=[NSArray array];
        if([object objectForKey:@"created_at"]){
            NSRange dateRangeBeigin=NSMakeRange(0, 10);
            NSRange dateRangeEnd=NSMakeRange(11, 5);
            NSString *date=[object objectForKey:@"created_at"];
            if([date substringWithRange:dateRangeBeigin] && [date substringWithRange:dateRangeEnd]){
                NSString *begin=[date substringWithRange:dateRangeBeigin];
                NSString *end=[date substringWithRange:dateRangeEnd];
                self.date=[NSString stringWithFormat:@"%@ %@",begin,end];
            }
            else{
                self.date=@"";
            }
            
        }
        else{
            self.date=@"";
        }
        //self.department=[object objectForKey:@"department"]?[object objectForKey:@"department"]:@"";
        self.status=[object objectForKey:@"handled"]?[[object objectForKey:@"handled"] intValue]:0;
        self.has_out_of_stock=[object objectForKey:@"has_out_of_stock"]?[[object objectForKey:@"has_out_of_stock"] intValue]:0;
        self.has_out_of_stock_text=self.has_out_of_stock==1?@"缺货":@"正常";
        self.id=[object objectForKey:@"id"]?[object objectForKey:@"id"]:@"";
        self.user_id=[object objectForKey:@"user_id"]?[object objectForKey:@"user_id"]:@"";
    }
    return self;
}
@end
