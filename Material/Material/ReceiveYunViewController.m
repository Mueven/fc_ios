//
//  ReceiveYunViewController.m
//  Material
//
//  Created by wayne on 14-11-26.
//  Copyright (c) 2014年 brilliantech. All rights reserved.
//

#import "ReceiveYunViewController.h"
#import "ShopTuoTableViewCell.h"
#import "Tuo.h"
#import <AudioToolbox/AudioToolbox.h>
#import "AFNetOperate.h"
#import "ReceiveTuoViewController.h"
#import "ReceivePrintViewController.h"
#import "Xiang.h"
@interface ReceiveYunViewController ()<UITextFieldDelegate,UITableViewDataSource,UITableViewDelegate,UIAlertViewDelegate,CaptuvoEventsProtocol>
@property (weak, nonatomic) IBOutlet UITextField *scanTextField;
@property (weak, nonatomic) IBOutlet UITableView *tuoTable;
@property (weak, nonatomic) IBOutlet UILabel *countLabel;
@property (weak, nonatomic) IBOutlet UIButton *confirmButton;
@property (weak, nonatomic) IBOutlet UIButton *cancelButton;
@property (nonatomic) int xiangCount;
- (IBAction)confirm:(id)sender;
- (IBAction)cancel:(id)sender;
@end

@implementation ReceiveYunViewController
- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.scanTextField.delegate=self;
    self.tuoTable.delegate=self;
    self.tuoTable.dataSource=self;
    UINib *itemCell=[UINib nibWithNibName:@"ShopTuoTableViewCell"  bundle:nil];
    [self.tuoTable registerNib:itemCell  forCellReuseIdentifier:@"tuoCell"];
    [self.navigationItem setHidesBackButton:YES];
}
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [[Captuvo sharedCaptuvoDevice] addCaptuvoDelegate:self];
    [self.scanTextField becomeFirstResponder];
    [self.tuoTable reloadData];
    NSInteger all_checked=0;
    NSInteger all_packages=0;
    for(int i=0;i<self.yun.tuoArray.count;i++){
        Tuo *tuoItem=self.yun.tuoArray[i];
        all_checked+=tuoItem.accepted_packages;
        all_packages+=tuoItem.sum_packages;
    }
    self.countLabel.text=[NSString stringWithFormat:@"%ld / %ld",(long)all_checked,(long)all_packages];
}
-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [[Captuvo sharedCaptuvoDevice] removeCaptuvoDelegate:self];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)decoderDataReceived:(NSString *)data{
        int count=0;
        NSString *tuoID=data;
        Tuo *tuo;
        NSArray *tuoArray=[self.yun.tuoArray copy];
        for(int i=0;i<tuoArray.count;i++){
            if([tuoID isEqualToString:[tuoArray[i] container_id]]){
                tuo=tuoArray[i];
                count++;
                break;
            }
        }
        if(count==0){
            UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"没有找到该拖"
                                                           message:[NSString stringWithFormat:@"未在该运单中发现托清单%@",tuoID]
                                                          delegate:self
                                                 cancelButtonTitle:@"确定"
                                                 otherButtonTitles:nil];
            AudioServicesPlaySystemSound(1051);
            [alert show];
        }
        else{
            [self performSegueWithIdentifier:@"checkTuo" sender:@{@"tuo":tuo,@"tuoArray":[self.yun.tuoArray copy]}];
        }
}

#pragma table delegate
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.yun.tuoArray count];
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    ShopTuoTableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:@"tuoCell" forIndexPath:indexPath];
    Tuo *tuo=[self.yun.tuoArray objectAtIndex:indexPath.row];
    cell.nameLabel.text=tuo.container_id;
    cell.dateLabel.text=tuo.department;
    NSInteger checked=tuo.accepted_packages;
    NSInteger count=tuo.sum_packages;
    cell.conditionLabel.text=[NSString stringWithFormat:@"%ld / %ld",(long)checked,(long)count];
    if(checked==count){
        [cell.conditionLabel setTextColor:[UIColor colorWithRed:68.0/255.0 green:178.0/255.0 blue:29.0/255.0 alpha:1.0]];
    }
    else{
        [cell.conditionLabel setTextColor:[UIColor redColor]];
    }
    cell.accessoryType=UITableViewCellAccessoryDisclosureIndicator;
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    Tuo *tuo=[self.yun.tuoArray objectAtIndex:indexPath.row];
    AFNetOperate *AFNet=[[AFNetOperate alloc] init];
    AFHTTPRequestOperationManager *manager=[AFNet generateManager:self.view];
    [manager GET:[AFNet tuo_packages]
      parameters:@{@"id":tuo.ID}
         success:^(AFHTTPRequestOperation *operation, id responseObject) {
            [AFNet.activeView stopAnimating];
             if([responseObject[@"result"] integerValue]==1){
                     NSArray *xiangList=responseObject[@"content"];
                     [tuo.xiang removeAllObjects];
                     for(int i=0;i<xiangList.count;i++){
                         Xiang *xiang=[[Xiang alloc] initWithObject:xiangList[i]];
                         [tuo.xiang addObject:xiang];
                     }
                     [self performSegueWithIdentifier:@"checkTuo" sender:@{@"tuo":tuo,@"tuoArray":[self.yun.tuoArray copy]}];
                 
             }
             else{
                 [AFNet alert:responseObject[@"content"]];
             }
             
         }
         failure:^(AFHTTPRequestOperation *operation, NSError *error) {
              [AFNet.activeView stopAnimating];
             [AFNet alert:@"something wrong"];
         }
     ];

}

#pragma textField delegate
-(void)textFieldDidBeginEditing:(UITextField *)textField
{
    UIView* dummyView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 1, 1)];
    textField.inputView = dummyView;
}

#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if([segue.identifier isEqualToString:@"checkTuo"]){
        ReceiveTuoViewController *vc=segue.destinationViewController;
        vc.enableConfirm=NO;
        vc.enableCancel=NO;
        vc.tuo=[sender objectForKey:@"tuo"];
        vc.tuoArray=[sender objectForKey:@"tuoArray"];
        vc.enableBack=YES;
    }
    else if([segue.identifier isEqualToString:@"print"]){
        ReceivePrintViewController *vc=segue.destinationViewController;
        vc.container=self.yun;
        vc.type=@"yun";
        vc.disableBack=YES;
    }
}
-(void)confirm:(id)sender
{
    UIAlertView *alert=[[UIAlertView alloc] initWithTitle:@""
                                                  message:@"确认收货？"
                                                 delegate:self
                                        cancelButtonTitle:@"取消"
                                        otherButtonTitles:@"确定", nil];
    [alert show];
}
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if(buttonIndex==1){
                AFNetOperate *AFNet=[[AFNetOperate alloc] init];
                AFHTTPRequestOperationManager *manager=[AFNet generateManager:self.view];
                [manager POST:[AFNet yun_confirm_receive]
                   parameters:@{@"id":self.yun.ID}
                      success:^(AFHTTPRequestOperation *operation, id responseObject) {
                          [AFNet.activeView stopAnimating];
                          if([responseObject[@"result"] integerValue]==1){
                              [self performSegueWithIdentifier:@"print" sender:self];
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
-(void)cancel:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}
#pragma alert button


@end
