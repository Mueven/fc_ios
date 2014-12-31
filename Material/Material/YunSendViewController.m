//
//  YunSendViewController.m
//  Material
//
//  Created by wayne on 14-11-26.
//  Copyright (c) 2014年 brilliantech. All rights reserved.
//

#import "YunSendViewController.h"
#import "SendAddress.h"
#import "SendAddressItem.h"
#import "DefaultAddressTableViewController.h"
#import "AFNetOperate.h"
#import <AudioToolbox/AudioToolbox.h>
#import "PrintViewController.h"
@interface YunSendViewController ()
@property (weak, nonatomic) IBOutlet UILabel *remarkLabel;
@property (weak, nonatomic) IBOutlet UILabel *tuoCountLabel;
@property (weak, nonatomic) IBOutlet UILabel *defaultAddress;
@property (strong,nonatomic) SendAddressItem *myAddress;
@property(nonatomic,strong)NSString *successContent;
- (IBAction)changeAddress:(id)sender;
- (IBAction)confirm:(id)sender;
- (IBAction)cancel:(id)sender;
@end
@implementation YunSendViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.remarkLabel.text=self.yun.remark;
    self.tuoCountLabel.text=[NSString stringWithFormat:@"%lu",(unsigned long)self.yun.tuoArray.count];
    self.myAddress=[[SendAddress sharedSendAddress] defaultAddress];
    self.defaultAddress.adjustsFontSizeToFitWidth=YES;
}
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.defaultAddress.text=self.myAddress.name;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Navigation
// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    if([segue.identifier isEqualToString:@"changeAddress"]){
        DefaultAddressTableViewController *addressVC=segue.destinationViewController;
        addressVC.myAddress=self.myAddress;
    }
    else if([segue.identifier isEqualToString:@"print"]){
        PrintViewController *yunPrint=segue.destinationViewController;
        yunPrint.container=[sender objectForKey:@"yun"];
        yunPrint.noBackButton=@1;
        yunPrint.enableSend=NO;
        yunPrint.yunSuccessContent=sender[@"content"];
    }
}

- (IBAction)changeAddress:(id)sender {
    [self performSegueWithIdentifier:@"changeAddress" sender:self];
}

- (IBAction)confirm:(id)sender {
    if(self.yun.tuoArray.count>0){
        AFNetOperate *AFNet=[[AFNetOperate alloc] init];
        AFHTTPRequestOperationManager *manager=[AFNet generateManager:self.view];
        [manager POST:[AFNet yun_send]
           parameters:@{
                        @"id":self.yun.ID,
                        @"destination_id":self.myAddress.id
                        }
              success:^(AFHTTPRequestOperation *operation, id responseObject) {
                  [AFNet.activeView stopAnimating];
                  if([responseObject[@"result"] integerValue]==1){
                      AudioServicesPlaySystemSound(1012);
                      //self.successContent=responseObject[@"content"];
//                      [self.navigationController popViewControllerAnimated:YES];
                      [self performSegueWithIdentifier:@"print" sender:@{@"content":responseObject[@"content"]}];
                  }
                  else{
                      [AFNet alert:responseObject[@"content"]];
                  }
                  
              }
              failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                  [AFNet.activeView stopAnimating];
                  [AFNet alert:[NSString stringWithFormat:@"%@",error.localizedDescription]];
              }
         ];
    }
    else{
        UIAlertView *alert=[[UIAlertView alloc] initWithTitle:@""
                                                      message:@"不能发送空运单"
                                                     delegate:self
                                            cancelButtonTitle:@"确定"
                                            otherButtonTitles:nil];
        [alert show];
    }
}

- (IBAction)cancel:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}
@end
