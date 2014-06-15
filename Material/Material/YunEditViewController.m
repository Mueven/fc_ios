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

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
//    self.name.delegate=self;
    self.remark.delegate=self;
    self.tuoTable.delegate=self;
    self.tuoTable.dataSource=self;
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
    UITableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:@"tuoCell"];
    Tuo *tuo=[self.yun.tuoArray objectAtIndex:indexPath.row];
    cell.textLabel.text=tuo.department;
    cell.detailTextLabel.text=[NSString stringWithFormat:@"%@   %@",tuo.date,tuo.agent];;
    return cell;
}
-(void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    Tuo *tuoChosen=[self.yun.tuoArray objectAtIndex:indexPath.row];
    if(editingStyle==UITableViewCellEditingStyleDelete){
        AFNetOperate *AFNet=[[AFNetOperate alloc] init];
        AFHTTPRequestOperationManager *manager=[AFNet generateManager:self.view];
        [manager POST:[AFNet yun_remove_tuo]
           parameters:@{@"id":tuoChosen.ID}
                success:^(AFHTTPRequestOperation *operation, id responseObject) {
                    [AFNet.activeView stopAnimating];
                    if(responseObject[@"result"]){
                        [self.yun.tuoArray removeObjectAtIndex:indexPath.row];
                        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
                    }
                    else{
                        [AFNet alert:responseObject[@"content"]];
                    }
                    
                }
                failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                    [AFNet.activeView stopAnimating];
                    [AFNet alert:@"sth wrong"];
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
    
        self.yun.remark=textField.text;
//    AFNetOperate *AFNet=[[AFNetOperate alloc] init];
//    AFHTTPRequestOperationManager *manager=[AFNet generateManager:self.view];
//    NSString *ID=self.yun.ID;
//    [manager PUT:[AFNet yun_edit:ID]
//      parameters:@{@"delivery_date":questDate}
//         success:^(AFHTTPRequestOperation *operation, id responseObject) {
//             [AFNet.activeView stopAnimating];
//             self.yun.remark=textField.text;
//         }
//         failure:^(AFHTTPRequestOperation *operation, NSError *error) {
//             [AFNet.activeView stopAnimating];
//             [AFNet alert:@"something wrong"];
//         }
//     ];

    
    
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
//        chooseTuo.yun=self.yun;
        chooseTuo.yunTarget=self.yun;
        chooseTuo.type=@"yunEdit";
        chooseTuo.barTitle=@"完成更改";
    }
}


- (IBAction)sendYun:(id)sender {
    UIAlertView *alert=[[UIAlertView alloc] initWithTitle:@"发送运单"
                                                  message:@"是否发送运单"
                                                 delegate:self
                                        cancelButtonTitle:@"不发送"
                                        otherButtonTitles:@"发送", nil];
    [alert show];
}
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    //是否发送
    if(!self.printAlert){
        //发送运单
        if(buttonIndex==1){
            AFNetOperate *AFNet=[[AFNetOperate alloc] init];
            AFHTTPRequestOperationManager *manager=[AFNet generateManager:self.view];
            [manager POST:[AFNet yun_send]
               parameters:@{@"id":self.yun.ID}
                  success:^(AFHTTPRequestOperation *operation, id responseObject) {
                      [AFNet.activeView stopAnimating];
                      if(responseObject[@"result"]){
                          self.printAlert = [[UIAlertView alloc]initWithTitle:@"打印"
                                                                      message:@"要打印运单吗？"
                                                                     delegate:self
                                                            cancelButtonTitle:@"不打印"
                                                            otherButtonTitles:@"打印",nil];
                          [self.printAlert show];
                      }
                      else{
                          [AFNet alert:responseObject[@"content"]];
                      }
                      
                  }
                  failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                      [AFNet.activeView stopAnimating];
                      [AFNet alert:@"sth wrong"];
                  }
             ];
            
            //            self.printAlert = [[UIAlertView alloc]initWithTitle:@"打 印"
            //                                                        message:@"要打印运单吗？"
            //                                                       delegate:self
            //                                              cancelButtonTitle:@"不打印"
            //                                              otherButtonTitles:@"打印",nil];
            //            [self.printAlert show];
        }
        //不发送运单
        else{
            [self.navigationController popViewControllerAnimated:YES];
        }
    }
    //是否打印运单
    else{
        //打印
        if(buttonIndex==1){
            
        }
        //不打印
        else{
           
        }
        self.printAlert=nil;
        [self.navigationController popViewControllerAnimated:YES];
    }
}

@end
