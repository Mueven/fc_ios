//
//  HistoryChooseViewController.m
//  Material
//
//  Created by wayne on 14-11-27.
//  Copyright (c) 2014年 brilliantech. All rights reserved.
//

#import "HistoryChooseViewController.h"
#import "AFNetOperate.h"
#import "HistoryYunTableViewController.h"
#import "HistoryTuoTableViewController.h"
#import "HistoryXiangTableViewController.h"
#import "Yun.h"
#import "Tuo.h"
#import "Xiang.h"
@interface HistoryChooseViewController ()
- (IBAction)yunClick:(id)sender;
- (IBAction)tuoClick:(id)sender;
- (IBAction)xiangClick:(id)sender;
@end

@implementation HistoryChooseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationItem.title=self.vc_title;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if([segue.identifier isEqualToString:@"yun"]){
        HistoryYunTableViewController *vc=segue.destinationViewController;
        vc.vc_title=self.vc_title;
        vc.yunArray=[sender objectForKey:@"container"];
    }
    else if([segue.identifier isEqualToString:@"tuo"]){
        HistoryTuoTableViewController *vc=segue.destinationViewController;
        vc.vc_title=self.vc_title;
        vc.tuoArray=[sender objectForKey:@"container"];
    }
    else if([segue.identifier isEqualToString:@"xiang"]){
        HistoryXiangTableViewController *vc=segue.destinationViewController;
        vc.vc_title=self.vc_title;
        vc.xiangArray=[sender objectForKey:@"container"];
    }
}

- (IBAction)yunClick:(id)sender {
    [self checkHistory:@"yun"];
}

- (IBAction)tuoClick:(id)sender {
    [self checkHistory:@"tuo"];
}

- (IBAction)xiangClick:(id)sender {
    [self checkHistory:@"xiang"];
}
-(void)checkHistory:(NSString *)type
{
    AFNetOperate *AFNet=[[AFNetOperate alloc] init];
    NSString *receive_parameters=[NSString string];
    if([type isEqualToString:@"yun"]){
        receive_parameters=[AFNet yun_received];
    }
    else if([type isEqualToString:@"tuo"]){
        receive_parameters=[AFNet tuo_received];
    }
    else if([type isEqualToString:@"xiang"]){
        receive_parameters=[AFNet xiang_received];
    }
    AFHTTPRequestOperationManager *manager=[AFNet generateManager:self.view];
    [manager GET:receive_parameters
      parameters:@{@"receive_date":self.date_for_post}
         success:^(AFHTTPRequestOperation *operation, id responseObject) {
             [AFNet.activeView stopAnimating];
             if([responseObject[@"result"] integerValue]==1){
                 NSMutableArray *listElements=[[NSMutableArray alloc] init];
                 NSArray *result=responseObject[@"content"];
                 if([type isEqualToString:@"yun"]){
                     for(int i=0;i<result.count;i++){
                         Yun *yunItem=[[Yun alloc] initWithObject:result[i]];
                         [listElements addObject:yunItem];
                     }
                     [self performSegueWithIdentifier:@"yun" sender:@{@"container":listElements}
                      ];
                 }
                 else if([type isEqualToString:@"tuo"]){
                     for(int i=0;i<result.count;i++){
                         Tuo *item=[[Tuo alloc] initWithObject:result[i]];
                         [listElements addObject:item];
                     }
                     [self performSegueWithIdentifier:@"tuo" sender:@{@"container":listElements}
                      ];
                 }
                 else if([type isEqualToString:@"xiang"]){
                     for(int i=0;i<result.count;i++){
                         Xiang *item=[[Xiang alloc] initWithObject:result[i]];
                         [listElements addObject:item];
                     }
                     [self performSegueWithIdentifier:@"xiang" sender:@{@"container":listElements}
                      ];
                 }
                 
             }
             else{
                 [AFNet alert:responseObject[@"content"]];
             }
         }
         failure:^(AFHTTPRequestOperation *operation, NSError *error) {
             [AFNet.activeView stopAnimating];
             [AFNet alert:[NSString stringWithFormat:@"%@",[error localizedDescription]]];
         }
     ];
}
@end
