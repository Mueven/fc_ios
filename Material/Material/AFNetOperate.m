//
//  AFNetOperate.m
//  Material
//
//  Created by wayne on 14-6-10.
//  Copyright (c) 2014年 brilliantech. All rights reserved.
//

#import "AFNetOperate.h"
#import "Xiang.h"
#import "Tuo.h"
#import "Yun.h"
#import <AudioToolbox/AudioToolbox.h>
@interface AFNetOperate()
@property(nonatomic,strong)UIAlertView *alert;
@end

@implementation AFNetOperate
-(instancetype)init
{
    self=[super init];
    if(self){
        self.activeView=[[UIActivityIndicatorView alloc]
                         initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    }
    return  self;
}
-(AFHTTPRequestOperationManager *)generateManager:(UIView *)view
{
    self.activeView.center=CGPointMake(view.bounds.size.width/2, view.bounds.size.width/2-21.0);
    self.activeView.hidesWhenStopped=YES;
    [view addSubview:self.activeView];
    [self.activeView startAnimating];
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    return manager;
}
-(void)alert:(NSString *)string
{
    self.alert = [[UIAlertView alloc]initWithTitle:@"出现错误"
                                                  message:string
                                                 delegate:self
                                        cancelButtonTitle:@"确定"
                                        otherButtonTitles:nil];
    [NSTimer scheduledTimerWithTimeInterval:2.1f
                                     target:self
                                   selector:@selector(dissmissAlert:)
                                   userInfo:nil
                                    repeats:NO];
    AudioServicesPlaySystemSound(1051);
    [self.alert show];
  
}
-(void)dissmissAlert:(NSTimer *)timer
{
    [self.alert dismissWithClickedButtonIndex:0 animated:YES];
}
//-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
//{
//    self.alert=nil;
//}
#pragma url method
-(NSMutableDictionary *)URLDictionary
{
    NSString *plistPath=[[NSBundle mainBundle] pathForResource:@"URL" ofType:@"plist"];
    NSMutableDictionary *URLDictionary=[[NSMutableDictionary alloc] initWithContentsOfFile:plistPath];
    return URLDictionary;
}
-(NSString *)baseURL
{
    NSArray *documentDictionary=NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *document=[documentDictionary firstObject];
    NSString *path=[document stringByAppendingPathComponent:@"ip.address.archive"];
    if([NSKeyedUnarchiver unarchiveObjectWithFile:path]){
        NSDictionary *dictionary=[NSKeyedUnarchiver unarchiveObjectWithFile:path];
        NSString *base=[dictionary objectForKey:@"ip"];
        NSString *port=[dictionary objectForKey:@"port"];
        return [base stringByAppendingString:port];
    }
    else{
        NSString *base=[[self URLDictionary] objectForKey:@"base"];
        NSString *port=[[self URLDictionary] objectForKey:@"port"];
        return [base stringByAppendingString:port];
    }
    
}
//resource part
-(NSString *)part_index
{
    NSString *base=[self baseURL];
    NSString *part=[[[self URLDictionary] objectForKey:@"part"] objectForKey:@"root"];
    return [base stringByAppendingString:part];
}
-(NSString *)part_validate{
    NSString *bind=[[[self URLDictionary] objectForKey:@"part"] objectForKey:@"validate"];
    return [[self part_index] stringByAppendingString:bind];
}
-(NSString *)part_quantity_validate
{
    NSString *bind=[[[self URLDictionary] objectForKey:@"xiang"] objectForKey:@"validate_quantity"];
    return [[self xiang_index] stringByAppendingString:bind];
}
//resource xiang
-(NSString *)xiang_index
{
    NSString *base=[self baseURL];
    NSString *xiang=[[[self URLDictionary] objectForKey:@"xiang"] objectForKey:@"root"];
    return [base stringByAppendingString:xiang];
}
-(NSString *)xiang_root
{
    NSString *bind=[[[self URLDictionary] objectForKey:@"xiang"] objectForKey:@"index"];
    return [[self xiang_index] stringByAppendingString:bind];
}
-(NSString *)xiang_validate
{
    NSString *bind=[[[self URLDictionary] objectForKey:@"xiang"] objectForKey:@"validate"];
    return [[self xiang_index] stringByAppendingString:bind];
}
-(NSString *)xiang_check
{
    NSString *bind=[[[self URLDictionary] objectForKey:@"xiang"] objectForKey:@"check"];
    return [[self xiang_index] stringByAppendingString:bind];
}
-(NSString *)xiang_uncheck{
    NSString *bind=[[[self URLDictionary] objectForKey:@"xiang"] objectForKey:@"uncheck"];
    return [[self xiang_index] stringByAppendingString:bind];
}
-(NSString *)xiang_edit:(NSString *)id{
    NSString *xiangRoot=[self xiang_index];
    return [NSString stringWithFormat:@"%@%@",xiangRoot,id];
}
-(void)getXiangs:(NSMutableArray *)xiangArray view:(UITableView *)view
{
    [self.activeView stopAnimating];
    AFHTTPRequestOperationManager *manager=[self generateManager:view];
    [manager GET:[self xiang_root]
      parameters:nil
         success:^(AFHTTPRequestOperation *operation, id responseObject) {
             [self.activeView stopAnimating];
             NSArray *xiangArrayResult=responseObject;
             for(int i=0;i<xiangArrayResult.count;i++){
                 Xiang *xiang=[[Xiang alloc] initWithObject:xiangArrayResult[i]];
                 [xiangArray addObject:xiang];
             }
             [view reloadData];
         }
         failure:^(AFHTTPRequestOperation *operation, NSError *error) {
             [self.activeView stopAnimating];
             [self alert:@"something wrong"];
         }
    ];
}
//resource Tuo
-(NSString *)tuo_index
{
    NSString *base=[self baseURL];
    NSString *tuo=[[[self URLDictionary] objectForKey:@"tuo"] objectForKey:@"root"];
    return [base stringByAppendingString:tuo];
}
-(NSString *)tuo_root
{
    NSString *bind=[[[self URLDictionary] objectForKey:@"tuo"] objectForKey:@"index"];
    return [[self tuo_index] stringByAppendingString:bind];
}
-(NSString *)tuo_single
{
    NSString *bind=[[[self URLDictionary] objectForKey:@"tuo"] objectForKey:@"single"];
    return [[self tuo_index] stringByAppendingString:bind];
}
-(NSString *)tuo_bundle_add
{
    NSString *bind=[[[self URLDictionary] objectForKey:@"tuo"] objectForKey:@"bundle_add"];
    return [[self tuo_index] stringByAppendingString:bind];
}
-(NSString *)tuo_key_for_bundle{
    NSString *bind=[[[self URLDictionary] objectForKey:@"tuo"] objectForKey:@"key_for_bundle"];
    return [[self tuo_index] stringByAppendingString:bind];
}
-(NSString *)tuo_remove_xiang{
    NSString *bind=[[[self URLDictionary] objectForKey:@"tuo"] objectForKey:@"remove_xiang"];
    return [[self tuo_index] stringByAppendingString:bind];
}
-(NSString *)tuo_edit:(NSString *)id{
    NSString *tuoRoot=[self tuo_root];
    return [NSString stringWithFormat:@"%@%@",tuoRoot,id];
}
-(void)getTuos:(NSMutableArray *)tuoArray view:(UITableView *)view{
    [self.activeView stopAnimating];
    AFHTTPRequestOperationManager *manager=[self generateManager:view];
    [manager GET:[self tuo_root]
      parameters:nil
         success:^(AFHTTPRequestOperation *operation, id responseObject) {
             [self.activeView stopAnimating];
             NSArray *resultArray=responseObject;
             for(int i=0;i<[resultArray count];i++){
                 Tuo *tuo=[[Tuo alloc] initWithObject:resultArray[i]];
                 [tuoArray addObject:tuo];
             }
             [view reloadData];
         }
         failure:^(AFHTTPRequestOperation *operation, NSError *error) {
             [self.activeView stopAnimating];
         }
     ];
}
//resource Yun
-(NSString *)yun_index
{
    NSString *base=[self baseURL];
    NSString *yun=[[[self URLDictionary] objectForKey:@"yun"] objectForKey:@"root"];
    return [base stringByAppendingString:yun];
}
-(NSString *)yun_root
{
    NSString *bind=[[[self URLDictionary] objectForKey:@"yun"] objectForKey:@"index"];
    return [[self yun_index] stringByAppendingString:bind];
}
-(NSString *)yun_single
{
    NSString *bind=[[[self URLDictionary] objectForKey:@"yun"] objectForKey:@"single"];
    return [[self yun_index] stringByAppendingString:bind];
}
-(NSString *)yun_add_tuo_by_scan{
    NSString *bind=[[[self URLDictionary] objectForKey:@"yun"] objectForKey:@"add_tuo_by_scan"];
    return [[self yun_index] stringByAppendingString:bind];
}
-(NSString *)yun_remove_tuo{
    NSString *bind=[[[self URLDictionary] objectForKey:@"yun"] objectForKey:@"remove_tuo"];
    return [[self yun_index] stringByAppendingString:bind];
}
-(NSString *)yun_add_tuo{
    NSString *bind=[[[self URLDictionary] objectForKey:@"yun"] objectForKey:@"add_tuo"];
    return [[self yun_index] stringByAppendingString:bind];
}
-(NSString *)yun_send{
    NSString *bind=[[[self URLDictionary] objectForKey:@"yun"] objectForKey:@"send"];
    return [[self yun_index] stringByAppendingString:bind];
}
-(NSString *)yun_edit:(NSString *)id{
    NSString *yunRoot=[self yun_root];
    return [NSString stringWithFormat:@"%@%@",yunRoot,id];
}
-(NSString *)yun_receive
{
    NSString *bind=[[[self URLDictionary] objectForKey:@"yun"] objectForKey:@"receive"];
    return [[self yun_index] stringByAppendingString:bind];
}
-(NSString *)yun_confirm_receive
{
    NSString *bind=[[[self URLDictionary] objectForKey:@"yun"] objectForKey:@"confirm_receive"];
    return [[self yun_index] stringByAppendingString:bind];
}
-(NSString *)yun_received
{
    NSString *bind=[[[self URLDictionary] objectForKey:@"yun"] objectForKey:@"received"];
    return [[self yun_index] stringByAppendingString:bind];
}
-(void)getYuns:(NSMutableArray *)yunArray view:(UITableView *)view{
    [self.activeView stopAnimating];
    NSDateFormatter *formatter=[[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-MM-dd'T'HH:mm:ssZZZZZ"];
    NSString *questDate=[formatter stringFromDate:[NSDate date]];
    AFHTTPRequestOperationManager *manager=[self generateManager:view];
    [manager GET:[self yun_root]
      parameters:@{@"delivery_date":questDate}
         success:^(AFHTTPRequestOperation *operation, id responseObject) {
             [self.activeView stopAnimating];
             NSArray *resultArray=responseObject;
             for(int i=0;i<[resultArray count];i++){
                 Yun *yun=[[Yun alloc] initWithObject:resultArray[i]];
                 [yunArray addObject:yun];
             }
             [view reloadData];
         }
         failure:^(AFHTTPRequestOperation *operation, NSError *error) {
             [self.activeView stopAnimating];
         }
     ];
}

//打印
-(NSString *)baseURL_print
{
    NSArray *documentDictionary=NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *document=[documentDictionary firstObject];
    NSString *path=[document stringByAppendingPathComponent:@"print.ip.address.archive"];
    NSString *file=[[[self URLDictionary] objectForKey:@"print"] objectForKey:@"file"];
    if([NSKeyedUnarchiver unarchiveObjectWithFile:path]){
        NSDictionary *dictionary=[NSKeyedUnarchiver unarchiveObjectWithFile:path];
        NSString *base=[dictionary objectForKey:@"print_ip"];
        NSString *port=[dictionary objectForKey:@"print_port"];
        return [[base stringByAppendingString:port] stringByAppendingString:file];
    }
    else{
        NSString *base=[[[self URLDictionary] objectForKey:@"print"] objectForKey:@"base"];
        NSString *port=[[[self URLDictionary] objectForKey:@"print"] objectForKey:@"port"];
        return [[base stringByAppendingString:port] stringByAppendingString:file];
    }
}


-(NSString *)print_stock_tuo:(NSString *)ID
{
    NSDictionary *printDictionary=[[self URLDictionary] objectForKey:@"print"];
    NSString *base=[self baseURL_print];
    NSString *bind=[printDictionary objectForKey:@"stock_tuo"];
    NSString *joint=[base stringByAppendingString:bind];
    return [NSString stringWithFormat:@"%@%@",joint,ID];
}
-(NSString *)print_stock_yun:(NSString *)ID
{
    NSDictionary *printDictionary=[[self URLDictionary] objectForKey:@"print"];
     NSString *base=[self baseURL_print];
    NSString *bind=[printDictionary objectForKey:@"stock_yun"];
    NSString *joint=[base stringByAppendingString:bind];
    return [NSString stringWithFormat:@"%@%@",joint,ID];
}
-(NSString *)print_shop_receive:(NSString *)ID
{
    NSDictionary *printDictionary=[[self URLDictionary] objectForKey:@"print"];
    NSString *base=[self baseURL_print];
    NSString *bind=[printDictionary objectForKey:@"shop_receive"];
    NSString *joint=[base stringByAppendingString:bind];
    return [NSString stringWithFormat:@"%@%@",joint,ID];
}
-(NSString *)print_shop_unreceive:(NSString *)ID
{
    NSDictionary *printDictionary=[[self URLDictionary] objectForKey:@"print"];
    NSString *base=[self baseURL_print];
    NSString *bind=[printDictionary objectForKey:@"shop_unreceive"];
    NSString *joint=[base stringByAppendingString:bind];
    return [NSString stringWithFormat:@"%@%@",joint,ID];
}

//login and logout
-(NSString *)log_in
{
    NSString *base=[self baseURL];
    return [base stringByAppendingString:[[self URLDictionary] objectForKey:@"log_in"]];
}
-(NSString *)log_out
{
    NSString *base=[self baseURL];
    return [base stringByAppendingString:[[self URLDictionary] objectForKey:@"log_out"]];
}
@end
