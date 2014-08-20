//
//  AFNetOperate.h
//  Material
//
//  Created by wayne on 14-6-10.
//  Copyright (c) 2014年 brilliantech. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AFNetOperate : NSObject
@property(strong,nonatomic)UIActivityIndicatorView *activeView;
//method
-(AFHTTPRequestOperationManager *)generateManager:(UIView *)view;
-(void)alert:(NSString *)string;
-(void)alertSuccess:(NSString *)string;
-(void)getXiangs:(NSMutableArray *)xiangArray view:(UITableView *)view;
-(void)getTuos:(NSMutableArray *)tuoArray view:(UITableView *)view;
-(void)getYuns:(NSMutableArray *)yunArray view:(UITableView *)view;
//get URL
-(NSString *)part_validate;
-(NSString *)part_quantity_validate;

-(NSString *)xiang_index;
-(NSString *)xiang_root;
-(NSString *)xiang_edit:(NSString *)id;
-(NSString *)xiang_validate;
-(NSString *)xiang_check;
-(NSString *)xiang_uncheck;

-(NSString *)tuo_index;
-(NSString *)tuo_root;
-(NSString *)tuo_edit:(NSString *)id;
-(NSString *)tuo_single;
-(NSString *)tuo_bundle_add;
-(NSString *)tuo_key_for_bundle;
-(NSString *)tuo_remove_xiang;

-(NSString *)yun_index;
-(NSString *)yun_root;
-(NSString *)yun_edit:(NSString *)id;
-(NSString *)yun_single;
-(NSString *)yun_add_tuo_by_scan;
-(NSString *)yun_remove_tuo;
-(NSString *)yun_add_tuo;
-(NSString *)yun_send;
-(NSString *)yun_receive;
-(NSString *)yun_received;
-(NSString *)yun_confirm_receive;

-(NSString *)log_in;
-(NSString *)log_out;


-(NSString *)print_stock_tuo:(NSString *)ID printer_name:(NSString *)printer copies:(NSString *)copies;
-(NSString *)print_stock_yun:(NSString *)ID printer_name:(NSString *)printer copies:(NSString *)copies;
-(NSString *)print_shop_receive:(NSString *)ID printer_name:(NSString *)printer copies:(NSString *)copies;
-(NSString *)print_shop_unreceive:(NSString *)ID printer_name:(NSString *)printer copies:(NSString *)copies;
-(NSString *)print_transfer_note:(NSString *)ID printer_name:(NSString *)printer copies:(NSString *)copies;

-(NSString *)print_model_list;
-(NSString *)get_current_print_model;
-(void)set_tuo_copy:(NSString *)copy;
-(void)set_yun_copy:(NSString *)copy;
-(void)set_yun_uncheck_copy:(NSString *)copy;
-(void)set_transfer_note_copy:(NSString *)copy;
-(NSString *)get_tuo_copy;
-(NSString *)get_yun_copy;
-(NSString *)get_yun_uncheck_copy;
-(NSString *)get_transfer_note_copy;

-(NSString *)scan_validate;


-(NSString *)version;


-(NSString *)order_root;
-(NSString *)order_history;
-(NSString *)order_check_part;

-(NSString *)order_item_root;
-(NSString *)order_item_verify;

-(NSString *)baseURLWithoutPort;
@end
