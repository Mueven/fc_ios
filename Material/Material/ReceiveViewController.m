//
//  ReceiveViewController.m
//  Material
//
//  Created by wayne on 14-11-26.
//  Copyright (c) 2014年 brilliantech. All rights reserved.
//

#import "ReceiveViewController.h"
#import "ReceiveXiangViewController.h"
#import "ReceiveTuoViewController.h"
#import "ReceiveYunViewController.h"
#import "AFNetOperate.h"
@interface ReceiveViewController ()<CaptuvoEventsProtocol,UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UITextField *scanTextField;
- (IBAction)test:(id)sender;
@end

@implementation ReceiveViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.scanTextField.delegate=self;
    [self.scanTextField becomeFirstResponder];
}
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [[Captuvo sharedCaptuvoDevice] addCaptuvoDelegate:self];
    self.scanTextField.text=@"";
}
-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [[Captuvo sharedCaptuvoDevice] removeCaptuvoDelegate:self];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)textFieldDidBeginEditing:(UITextField *)textField
{
    UIView *dummy=[[UIView alloc] initWithFrame:CGRectMake(0, 0, 1, 1)];
    textField.inputView=dummy;
}
-(void)decoderDataReceived:(NSString *)data
{
    self.scanTextField.text=data;
    //扫描到对应的号码时应该去触发receive
    AFNetOperate *AFNet=[[AFNetOperate alloc] init];
    AFHTTPRequestOperationManager *manager=[AFNet generateManager:self.view];
    [manager POST:[AFNet movables]
       parameters:@{@"id":data}
          success:^(AFHTTPRequestOperation *operation, id responseObject) {
              [AFNet.activeView stopAnimating];
              if([responseObject[@"result"] integerValue]==1){
                  int type=[responseObject[@"content"][@"type"] intValue];
                  if(type==1){
                      Xiang *xiang=[[Xiang alloc] initWithObject:responseObject[@"content"][@"object"]];
                       self.scanTextField.text=@"";
                      [self performSegueWithIdentifier:@"receiveXiang" sender:@{@"title":data,@"xiang":xiang}];
                  }
                  else if(type==2){
                      Tuo *tuo=[[Tuo alloc] initWithObject:responseObject[@"content"][@"object"]];
                      [manager GET:[AFNet tuo_packages]
                        parameters:@{@"id":tuo.ID}
                           success:^(AFHTTPRequestOperation *operation, id responseObject) {
                               if([responseObject[@"result"] integerValue]==1){
                                   NSArray *xiangList=responseObject[@"content"];
                                   [tuo.xiang removeAllObjects];
                                   for(int i=0;i<xiangList.count;i++){
                                       Xiang *xiang=[[Xiang alloc] initWithObject:xiangList[i]];
                                       [tuo.xiang addObject:xiang];
                                   }
                                   self.scanTextField.text=@"";
                                   [self performSegueWithIdentifier:@"receiveTuo" sender:@{@"title":data,@"tuo":tuo}];
                               }
                               else{
                                   [AFNet alert:responseObject[@"content"]];
                               }
                               
                           }
                           failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                               [AFNet alert:@"something wrong"];
                           }
                       ];
                      
                  }
                  else if(type==3){
                      Yun *yun=[[Yun alloc] initWithObject:responseObject[@"content"][@"object"]];
                      [manager GET:[AFNet yun_folklifts]
                        parameters:@{@"id":yun.ID}
                           success:^(AFHTTPRequestOperation *operation, id responseObject) {
                               [AFNet.activeView stopAnimating];
                               if([responseObject[@"result"] integerValue]==1){
                                   NSArray *tuoArray=responseObject[@"content"];
                                   [yun.tuoArray removeAllObjects];
                                   for(int i=0;i<tuoArray.count;i++){
                                       Tuo *tuoItem=[[Tuo alloc] initWithObject:tuoArray[i]];
                                       [yun.tuoArray addObject:tuoItem];
                                   }
                                    self.scanTextField.text=@"";
                                   [self performSegueWithIdentifier:@"receiveYun" sender:@{@"title":data,@"yun":yun}];
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
//only for test use
-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    NSString *data=  self.scanTextField.text;
    AFNetOperate *AFNet=[[AFNetOperate alloc] init];
    AFHTTPRequestOperationManager *manager=[AFNet generateManager:self.view];
    [manager POST:[AFNet movables]
      parameters:@{@"id":data}
         success:^(AFHTTPRequestOperation *operation, id responseObject) {
             [AFNet.activeView stopAnimating];
             if([responseObject[@"result"] integerValue]==1){
                 int type=[responseObject[@"content"][@"type"] intValue];
                 if(type==1){
                     Xiang *xiang=[[Xiang alloc] initWithObject:responseObject[@"content"][@"object"]];
                     [self performSegueWithIdentifier:@"receiveXiang" sender:@{@"title":data,@"xiang":xiang}];
                 }
                 else if(type==2){
                     Tuo *tuo=[[Tuo alloc] initWithObject:responseObject[@"content"][@"object"]];
                     [manager GET:[AFNet tuo_packages]
                       parameters:@{@"id":tuo.ID}
                          success:^(AFHTTPRequestOperation *operation, id responseObject) {
                              if([responseObject[@"result"] integerValue]==1){
                                      NSArray *xiangList=responseObject[@"content"];
                                      [tuo.xiang removeAllObjects];
                                      for(int i=0;i<xiangList.count;i++){
                                          Xiang *xiang=[[Xiang alloc] initWithObject:xiangList[i]];
                                          [tuo.xiang addObject:xiang];
                                      }
                                      [self performSegueWithIdentifier:@"receiveTuo" sender:@{@"title":data,@"tuo":tuo}];
                              }
                              else{
                                  [AFNet alert:responseObject[@"content"]];
                              }
                              
                          }
                          failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                              [AFNet alert:@"something wrong"];
                          }
                      ];

                 }
                 else if(type==3){
                     Yun *yun=[[Yun alloc] initWithObject:responseObject[@"content"][@"object"]];
                     [manager GET:[AFNet yun_folklifts]
                       parameters:@{@"id":yun.ID}
                          success:^(AFHTTPRequestOperation *operation, id responseObject) {
                              [AFNet.activeView stopAnimating];
                              if([responseObject[@"result"] integerValue]==1){
                                      NSArray *tuoArray=responseObject[@"content"];
                                      [yun.tuoArray removeAllObjects];
                                      for(int i=0;i<tuoArray.count;i++){
                                          Tuo *tuoItem=[[Tuo alloc] initWithObject:tuoArray[i]];
                                          [yun.tuoArray addObject:tuoItem];
                                      }
                                      [self performSegueWithIdentifier:@"receiveYun" sender:@{@"title":data,@"yun":yun}];
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
    return YES;
}
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    if([segue.identifier isEqualToString:@"receiveXiang"]){
        ReceiveXiangViewController *vc=segue.destinationViewController;
        vc.title=[sender objectForKey:@"title"];
        vc.xiang=[sender objectForKey:@"xiang"];
    }
    else if([segue.identifier isEqualToString:@"receiveTuo"]){
        ReceiveTuoViewController *vc=segue.destinationViewController;
        vc.title=[sender objectForKey:@"title"];
        vc.enableCancel=YES;
        vc.enableConfirm=YES;
        vc.tuo=[sender objectForKey:@"tuo"];
    }
    else if([segue.identifier isEqualToString:@"receiveYun"]){
        ReceiveYunViewController *vc=segue.destinationViewController;
        vc.title=[sender objectForKey:@"title"];
        vc.yun=[sender objectForKey:@"yun"];
    }
}


- (IBAction)test:(id)sender {
    [self performSegueWithIdentifier:@"receiveTuo" sender:self];
}
- (IBAction)unwindToReceive:(UIStoryboardSegue *)unwind
{
    
}
@end
