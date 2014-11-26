//
//  YunEditViewController.m
//  Material
//
//  Created by wayne on 14-6-9.
//  Copyright (c) 2014年 brilliantech. All rights reserved.
//

#import "YunEditViewController.h"
#import "Tuo.h"
#import "AFNetOperate.h"
#import "YunChooseTuoViewController.h"
#import "PrintViewController.h"
#import "TuoTableViewCell.h"

@interface YunEditViewController ()<UITableViewDataSource,UITableViewDelegate,UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tuoTable;
//@property (weak, nonatomic) IBOutlet UITextField *name;
@property (weak, nonatomic) IBOutlet UITextField *remark;
@property (strong,nonatomic) UIAlertView *printAlert;
- (IBAction)sendYun:(id)sender;
@end

@implementation YunEditViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}
-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
//    [[Captuvo sharedCaptuvoDevice] stopDecoderHardware];
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
//    self.name.delegate=self;
    self.remark.delegate=self;
    self.tuoTable.delegate=self;
    self.tuoTable.dataSource=self;
    UINib *nib=[UINib nibWithNibName:@"TuoTableViewCell" bundle:nil];
    [self.tuoTable registerNib:nib forCellReuseIdentifier:@"tuoCell"];
}
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.navigationItem.title=self.yun.name;
//    self.name.text=self.yun.name;
    self.remark.text=self.yun.remark;
    [self.tuoTable reloadData];
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
    
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
    Tuo *tuo=[self.yun.tuoArray objectAtIndex:indexPath.row];
    TuoTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"tuoCell" forIndexPath:indexPath];
    cell.idLabel.text=tuo.container_id;
    cell.departmentLabel.text=tuo.department;
    cell.agentLabel.text=tuo.agent;
     cell.sumPackageLabel.text=[NSString stringWithFormat:@"%d",tuo.sum_packages];
    return cell;
}
-(void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    Tuo *tuoChosen=[self.yun.tuoArray objectAtIndex:indexPath.row];
    if(editingStyle==UITableViewCellEditingStyleDelete){
        AFNetOperate *AFNet=[[AFNetOperate alloc] init];
        AFHTTPRequestOperationManager *manager=[AFNet generateManager:self.view];
//        NSLog(@"address:%@  id:%@",[AFNet yun_remove_tuo],tuoChosen.ID);
        [manager DELETE:[AFNet yun_remove_tuo]
           parameters:@{@"forklift_id":tuoChosen.ID}
                success:^(AFHTTPRequestOperation *operation, id responseObject) {
                    [AFNet.activeView stopAnimating];
                    if([responseObject[@"result"] integerValue]==1){
                        [self.yun.tuoArray removeObjectAtIndex:indexPath.row];
                        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
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
        
//        [self.yun.tuoArray removeObjectAtIndex:indexPath.row];
//        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }
}

#pragma textField delegate
-(void)textFieldDidEndEditing:(UITextField *)textField
{
//    if(textField.tag==21){
//        self.yun.name=textField.text;
//        self.navigationItem.title=self.yun.name;
//    }
//    else if(textField.tag==22){
    
//        self.yun.remark=textField.text;
    AFNetOperate *AFNet=[[AFNetOperate alloc] init];
    AFHTTPRequestOperationManager *manager=[AFNet generateManager:self.view];
    NSString *ID=self.yun.ID;
    [manager PUT:[AFNet yun_index]
      parameters:@{@"delivery":@{@"id":ID,@"remark":textField.text}}
         success:^(AFHTTPRequestOperation *operation, id responseObject) {
             [AFNet.activeView stopAnimating];
             self.yun.remark=textField.text;
         }
         failure:^(AFHTTPRequestOperation *operation, NSError *error) {
             [AFNet.activeView stopAnimating];
             [AFNet alert:[NSString stringWithFormat:@"%@",[error localizedDescription]]];
         }
     ];

    
    
//    }
}
-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return  YES;
}


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    if([segue.identifier isEqualToString:@"yunEditTuo"]){
        YunChooseTuoViewController *chooseTuo=segue.destinationViewController;
        chooseTuo.yunTarget=self.yun;
        chooseTuo.type=@"yunEdit";
        chooseTuo.barTitle=@"完成更改";
    }
    else if([segue.identifier isEqualToString:@"printYun"]){
        PrintViewController *yunPrint=segue.destinationViewController;
        yunPrint.container=[sender objectForKey:@"yun"];
        yunPrint.noBackButton=@1;
        yunPrint.enableSend=YES;
    }
}


- (IBAction)sendYun:(id)sender {
    [self performSegueWithIdentifier:@"printYun" sender:@{@"yun":self.yun}];
//    UIAlertView *alert=[[UIAlertView alloc] initWithTitle:@"发送运单"
//                                                  message:@"是否发送运单"
//                                                 delegate:self
//                                        cancelButtonTitle:@"不发送"
//                                        otherButtonTitles:@"发送", nil];
//    [alert show];
}
//-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
//{
//        //发送运单
//        if(buttonIndex==1){
//            AFNetOperate *AFNet=[[AFNetOperate alloc] init];
//            AFHTTPRequestOperationManager *manager=[AFNet generateManager:self.view];
//            [manager POST:[AFNet yun_send]
//               parameters:@{@"id":self.yun.ID}
//                  success:^(AFHTTPRequestOperation *operation, id responseObject) {
//                      [AFNet.activeView stopAnimating];
//                      if([responseObject[@"result"] integerValue]==1){
//                            [self performSegueWithIdentifier:@"printYun" sender:@{@"yun":self.yun,@"content":responseObject[@"content"]}];
//                      }
//                      else{
//                          [AFNet alert:responseObject[@"content"]];
//                      }
//                      
//                  }
//                  failure:^(AFHTTPRequestOperation *operation, NSError *error) {
//                      [AFNet.activeView stopAnimating];
//                      [AFNet alert:[NSString stringWithFormat:@"%@",[error localizedDescription]]];
//                  }
//             ];
//        }
//        //不发送运单
//        else{
//             
//        }
//}
@end
