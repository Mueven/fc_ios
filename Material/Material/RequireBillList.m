//
//  RequireBillList.m
//  Material
//
//  Created by wayne on 14-7-21.
//  Copyright (c) 2014年 brilliantech. All rights reserved.
//

#import "RequireBillList.h"
#import "RequireBill.h"
#import "AFNetOperate.h"
#import "RequireBill.h"
@implementation RequireBillList
+(void)getBillList:(NSArray *)array tableView:(UITableView *)tableView type:(NSString *)type
{
    __block NSMutableArray *billList=[[NSMutableArray alloc] init];
    __block NSArray *arrayBlock=array;
    __block UITableView *tableViewBlock=tableView;
//    AFNetOperate *AFNet=[[AFNetOperate alloc] init];
//    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    dispatch_queue_t bill_list_queue=dispatch_queue_create("com.bill.list.pptalent", NULL);
    if([type isEqualToString:@"today"]){
        dispatch_async(bill_list_queue, ^{
//            [manager GET:[AFNet yun_root]
//              parameters:nil
//                 success:^(AFHTTPRequestOperation *operation, id responseObject) {
//                     [tableView reloadData];
//                 }
//                 failure:^(AFHTTPRequestOperation *operation, NSError *error) {
//                     [AFNet alert:[NSString stringWithFormat:@"%@",[error localizedDescription]]];
//                 }
//             ];
        
            //example
            for(int i=0;i<3;i++){
                NSDictionary *dic=@{@"date":[NSString stringWithFormat:@"2014-08-0%d",i],@"department":@"MB",@"status":@"在途"};
                RequireBill *bill=[[RequireBill alloc] initWithObject:dic];
                [billList addObject:bill];
                arrayBlock=[billList copy];
               
            }
            dispatch_async(dispatch_get_main_queue(), ^{
                [tableViewBlock reloadData];
            });
        });
    }
}
@end
