//
//  XiangSendViewController.m
//  Material
//
//  Created by wayne on 14-11-20.
//  Copyright (c) 2014年 brilliantech. All rights reserved.
//

#import "XiangSendViewController.h"
#import "SendAddressItem.h"
#import "SendAddress.h"
#import "DefaultAddressTableViewController.h"
#import "AFNetOperate.h"
#import <AudioToolbox/AudioToolbox.h>
#import "XiangChooseDepartmentViewController.h"
#import "PrintViewController.h"
@interface XiangSendViewController()<UIAlertViewDelegate>
@property (weak, nonatomic) IBOutlet UILabel *keyLabel;
@property (weak, nonatomic) IBOutlet UILabel *partNumberLabel;
@property (weak, nonatomic) IBOutlet UILabel *quantityLabel;
@property (weak, nonatomic) IBOutlet UILabel *dateLabel;
@property (weak, nonatomic) IBOutlet UILabel *defaultAddressLabel;
@property (weak, nonatomic) IBOutlet UILabel *departmentLabel;
@property (strong,nonatomic)SendAddressItem *myAddress;
@property (strong,nonatomic)NSMutableDictionary *departmentReceive;
@property (strong,nonatomic)UIAlertView *wrongDepartAlert;
- (IBAction)changeAddress:(id)sender;
- (IBAction)confirm:(id)sender;
- (IBAction)cancel:(id)sender;
- (IBAction)chooseDepartment:(id)sender;
//- (IBAction)printClick:(id)sender;
@end
@implementation XiangSendViewController
-(void)viewDidLoad
{
    [super viewDidLoad];
    self.keyLabel.text=self.xiang.key;
    self.partNumberLabel.text=self.xiang.number;
    self.quantityLabel.text=self.xiang.quantity_display;
    self.dateLabel.text=self.xiang.date;
    self.keyLabel.adjustsFontSizeToFitWidth=YES;
    self.partNumberLabel.adjustsFontSizeToFitWidth=YES;
    self.quantityLabel.adjustsFontSizeToFitWidth=YES;
    self.dateLabel.adjustsFontSizeToFitWidth=YES;
    self.myAddress=[[SendAddress sharedSendAddress] defaultAddress];
    self.defaultAddressLabel.adjustsFontSizeToFitWidth=YES;
    self.departmentReceive=[NSMutableDictionary dictionaryWithObjectsAndKeys:@"",@"name",@"",@"id", nil];
}
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.defaultAddressLabel.text=self.myAddress.name;
    self.departmentLabel.text=self.departmentReceive[@"name"];
}
- (IBAction)changeAddress:(id)sender {
    [self performSegueWithIdentifier:@"changeAddress" sender:self];
}

- (IBAction)confirm:(id)sender {
    if(self.departmentReceive[@"id"]){
        if(![self.xiang.position isEqualToString:self.departmentReceive[@"name"]]){
            self.wrongDepartAlert=[[UIAlertView alloc] initWithTitle:@"警告"
                                                             message:@"箱所属部门与发送部门不一致"
                                                            delegate:self
                                                   cancelButtonTitle:@"不发送"
                                                   otherButtonTitles:@"继续发送", nil];
            [self.wrongDepartAlert show];
        }
        else{
            [self sendBox];
        }
    }
    else {
        UIAlertView *alert=[[UIAlertView alloc] initWithTitle:@""
                                                      message:@"请选择收货部门"
                                                     delegate:self
                                            cancelButtonTitle:@"确定"
                                            otherButtonTitles: nil];
        [alert show];
    }
}
-(void)sendBox
{
    AFNetOperate *AFNet=[[AFNetOperate alloc] init];
    AFHTTPRequestOperationManager *manager=[AFNet generateManager:self.view];
    [manager POST:[AFNet xiang_send]
       parameters:@{
                    @"id":self.xiang.ID,
                    @"destination_id":self.myAddress.id,
                    @"whouse_id":self.departmentReceive[@"id"]
                    }
          success:^(AFHTTPRequestOperation *operation, id responseObject) {
              [AFNet.activeView stopAnimating];
              if([responseObject[@"result"] integerValue]==1){
                  AudioServicesPlaySystemSound(1012);
                  [AFNet.activeView stopAnimating];
                  if(self.xiangArray){
                      [self.xiangArray removeObjectAtIndex:self.xiangIndex];
                  }
                  
                  UIAlertView *alert=[[UIAlertView alloc] initWithTitle:@""
                                                                message:@"是否打印"
                                                               delegate:self
                                                      cancelButtonTitle:@"否"
                                                      otherButtonTitles:@"是", nil];
                  [alert show];
                  
              }
              else {
                  [AFNet alert: responseObject[@"content"]];
                  
              }
          }
          failure:^(AFHTTPRequestOperation *operation, NSError *error) {
              [AFNet.activeView stopAnimating];
              [AFNet alert:[NSString stringWithFormat:@"%@",[error localizedDescription]]];
          }
     ];
}
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if(buttonIndex==1){
        if(self.wrongDepartAlert==alertView){
            [self sendBox];
        }
        else{
            [self performSegueWithIdentifier:@"print" sender:@{@"noBackButton":@1}];
        }
    }
    else {
        if(self.wrongDepartAlert==alertView){
            
        }
        else{
            [self.navigationController popToViewController:[self.navigationController.viewControllers objectAtIndex:([self.navigationController.viewControllers count] -3)] animated:YES];
        }
    }
}
- (IBAction)cancel:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}
- (IBAction)chooseDepartment:(id)sender {
    AFNetOperate *AFNet=[[AFNetOperate alloc] init];
    AFHTTPRequestOperationManager *manager=[AFNet generateManager:self.view];
    [manager GET:[AFNet locations_warehosues]
       parameters:@{
                    @"id":self.myAddress.id
                    }
          success:^(AFHTTPRequestOperation *operation, id responseObject) {
              [AFNet.activeView stopAnimating];
              [self performSegueWithIdentifier:@"chooseDepartment" sender:@{@"departmentArray":responseObject}];
               
          }
          failure:^(AFHTTPRequestOperation *operation, NSError *error) {
              [AFNet.activeView stopAnimating];
              [AFNet alert:[NSString stringWithFormat:@"%@",[error localizedDescription]]];
          }
     ];
}

//- (IBAction)printClick:(id)sender {
//    [self performSegueWithIdentifier:@"print" sender:@{@"noBackButton":@0}];
//}
-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if([segue.identifier isEqualToString:@"changeAddress"]){
        DefaultAddressTableViewController *address=segue.destinationViewController;
        address.myAddress=self.myAddress;
    }
    else if([segue.identifier isEqualToString:@"chooseDepartment"]){
        XiangChooseDepartmentViewController *vc=segue.destinationViewController;
        vc.departmentReceive=self.departmentReceive;
        vc.departmentArray=[sender objectForKey:@"departmentArray"];
    }
    else if([segue.identifier isEqualToString:@"print"]){
        PrintViewController *vc=segue.destinationViewController;
        vc.container=self.xiang;
        vc.noBackButton=[sender objectForKey:@"noBackButton"];
        vc.enableSend=NO;
    }
}
@end
