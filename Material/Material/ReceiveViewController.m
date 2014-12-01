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
    [manager GET:[AFNet movables]
       parameters:@{@"id":data}
          success:^(AFHTTPRequestOperation *operation, id responseObject) {
              [AFNet.activeView stopAnimating];
              if([responseObject[@"result"] integerValue]==1){
                  int type=[responseObject[@"content"][@"type"] intValue];
                  if(type==1){
                      [self performSegueWithIdentifier:@"receiveXiang" sender:@{@"title":data}];
                  }
                  else if(type==2){
                      [self performSegueWithIdentifier:@"receiveTuo" sender:@{@"title":data}];
                  }
                  else if(type==3){
                      [self performSegueWithIdentifier:@"receiveYun" sender:@{@"title":data}];
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

#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    if([segue.identifier isEqualToString:@"receiveXiang"]){
        ReceiveXiangViewController *vc=segue.destinationViewController;
        vc.title=[sender objectForKey:@"title"];
    }
    else if([segue.identifier isEqualToString:@"receiveTuo"]){
        ReceiveTuoViewController *vc=segue.destinationViewController;
        vc.title=[sender objectForKey:@"title"];
        vc.enableCancel=YES;
        vc.enableConfirm=YES;
        
    }
    else if([segue.identifier isEqualToString:@"receiveYun"]){
        ReceiveYunViewController *vc=segue.destinationViewController;
        vc.title=[sender objectForKey:@"title"];
    }
}


- (IBAction)test:(id)sender {
    [self performSegueWithIdentifier:@"receiveTuo" sender:self];
}
@end
