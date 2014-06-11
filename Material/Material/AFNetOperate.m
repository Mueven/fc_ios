//
//  AFNetOperate.m
//  Material
//
//  Created by wayne on 14-6-10.
//  Copyright (c) 2014年 brilliantech. All rights reserved.
//

#import "AFNetOperate.h"
#import "Xiang.h"

@interface AFNetOperate()

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
    UIAlertView*alert = [[UIAlertView alloc]initWithTitle:@"出现错误"
                                                  message:string
                                                 delegate:self
                                        cancelButtonTitle:@"确定"
                                        otherButtonTitles:nil];
    [alert show];
    
}
#pragma url method
-(NSMutableDictionary *)URLDictionary
{
    NSString *plistPath=[[NSBundle mainBundle] pathForResource:@"URL" ofType:@"plist"];
    NSMutableDictionary *URLDictionary=[[NSMutableDictionary alloc] initWithContentsOfFile:plistPath];
    return URLDictionary;
}
-(NSString *)baseURL
{
    NSString *base=[[self URLDictionary] objectForKey:@"base"];
    NSString *port=[[self URLDictionary] objectForKey:@"port"];
    return [base stringByAppendingString:port];
}
//resource xiang
-(NSString *)xiang_root
{
    NSString *base=[self baseURL];
    NSString *xiang=[[[self URLDictionary] objectForKey:@"xiang"] objectForKey:@"root"];
    return [base stringByAppendingString:xiang];
}
//-(NSString *)xiang_edit:(NSString *)id{
//    
//}
-(void)getXiangs:(NSMutableArray *)xiangArray view:(UIView *)view
{
    [self.activeView stopAnimating];
//    AFHTTPRequestOperationManager *manager=[self generateManager:view];
//    [manager GET:[self xiang_root]
//      parameters:nil
//         success:^(AFHTTPRequestOperation *operation, id responseObject) {
//             [self.activeView stopAnimating];
//             Xiang *xiang=[[Xiang alloc] init];
//             xiang.key=@"123";
//             xiang.number=@"123";
//             xiang.count=@"123";
//             xiang.position=@"12 13 21";
//             xiang.remark=@"1";
//             [xiangArray addObject:xiang];
//         }
//         failure:^(AFHTTPRequestOperation *operation, NSError *error) {
//             [self.activeView stopAnimating];
//         }
//    ];
    
        Xiang *xiang=[[Xiang alloc] init];
           xiang.key=@"123";
           xiang.number=@"123";
               xiang.count=@"123";
              xiang.position=@"12 13 21";
              xiang.remark=@"1";
               [xiangArray addObject:xiang];
}


@end
