//
//  ReceiveTuoViewController.m
//  Material
//
//  Created by wayne on 14-6-10.
//  Copyright (c) 2014年 brilliantech. All rights reserved.
//

#import "ReceiveTuoViewController.h"
#import "Xiang.h"
#import "ShopXiangTableViewCell.h"
#import "AFNetOperate.h"
#import <AudioToolbox/AudioToolbox.h>
#import "ReceivePrintViewController.h"

@interface ReceiveTuoViewController ()<UITextFieldDelegate,UITableViewDataSource,UITableViewDelegate,CaptuvoEventsProtocol>
@property (weak, nonatomic) IBOutlet UITextField *scanTextField;
@property (weak, nonatomic) IBOutlet UITableView *xiangTable;
@property (weak, nonatomic) IBOutlet UILabel *countLabel;
@property (weak, nonatomic) IBOutlet UILabel *amountLabel;
@property (nonatomic) int xiangCheckedCount;
@property (weak, nonatomic) IBOutlet UIButton *confirmButton;
@property (weak, nonatomic) IBOutlet UIButton *cancelButton;
- (IBAction)confirm:(id)sender;
- (IBAction)cancel:(id)sender;
@end
@implementation ReceiveTuoViewController
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
    self.navigationItem.title=self.tuo.container_id;
    self.scanTextField.delegate=self;
    self.xiangTable.delegate=self;
    self.xiangTable.dataSource=self;
    self.countLabel.adjustsFontSizeToFitWidth=YES;
    self.amountLabel.adjustsFontSizeToFitWidth=YES;
    [self.scanTextField becomeFirstResponder];
    UINib *cellNib=[UINib nibWithNibName:@"ShopXiangTableViewCell" bundle:nil];
    [self.xiangTable registerNib:cellNib forCellReuseIdentifier:@"xiangCell"];
    self.xiangCheckedCount=0;
    for(int i=0;i<self.tuo.xiang.count;i++){
        Xiang *xiang=self.tuo.xiang[i];
        if(xiang.checked){
            self.xiangCheckedCount++;
        }
    }
    self.tuoArray=self.tuoArray?self.tuoArray:[NSArray array];
    [self updateCheckedLabel];
    if(self.enableConfirm){
        self.confirmButton.hidden=NO;
    }
    if(self.enableCancel){
        self.cancelButton.hidden=NO;
    }
    if(!self.enableBack){
       [self.navigationItem setHidesBackButton:YES];
    }
}
-(void)updateCheckedLabel{
    NSString *count=[NSString stringWithFormat:@"%d",self.xiangCheckedCount];
    NSString *amount=[NSString stringWithFormat:@"%lu",(unsigned long)self.tuo.xiang.count];
    self.amountLabel.text=amount;
    self.countLabel.text=count;
}
-(void)updateAddCheckedLabel{
    self.xiangCheckedCount++;
    NSString *count=[NSString stringWithFormat:@"%d",self.xiangCheckedCount];
    NSString *amount=[NSString stringWithFormat:@"%lu",(unsigned long)self.tuo.xiang.count];
    self.amountLabel.text=amount;
    self.countLabel.text=count;
    self.tuo.accepted_packages++;
}
-(void)updateMinusCheckedLabel{
    self.xiangCheckedCount--;
    NSString *count=[NSString stringWithFormat:@"%d",self.xiangCheckedCount];
    NSString *amount=[NSString stringWithFormat:@"%lu",(unsigned long)self.tuo.xiang.count];
    self.amountLabel.text=amount;
    self.countLabel.text=count;
    self.tuo.accepted_packages--;
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
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma captuvo delegate
-(void)decoderDataReceived:(NSString *)data
{
    NSMutableArray *xiangArray=self.tuo.xiang;
    int count=0;
    for(int i=0;i<xiangArray.count;i++){
        if([data isEqualToString:[xiangArray[i] container_id]]){
            count++;
            dispatch_queue_t check_queue=dispatch_queue_create("com.check.pptalent", NULL);
            dispatch_async(check_queue, ^{
                
                if(![[self.tuo.xiang objectAtIndex:i] checked]){
                    AFNetOperate *AFNet=[[AFNetOperate alloc] init];
                    AFHTTPRequestOperationManager *manager=[AFNet generateManager:self.view];
                    [AFNet.activeView stopAnimating];
                    [manager POST:[AFNet xiang_check]
                       parameters:@{@"id":[xiangArray[i] ID]}
                          success:^(AFHTTPRequestOperation *operation, id responseObject) {
                              [AFNet.activeView stopAnimating];
                              if([responseObject[@"result"] integerValue]==1 ){
                                  [[self.tuo.xiang objectAtIndex:i] setChecked:YES];
                                  [self.xiangTable reloadData];
                                  [self updateAddCheckedLabel];
                              }
                              else{
                                  dispatch_async(dispatch_get_main_queue(), ^{
                                      [AFNet alert:responseObject[@"content"]];
                                  });
                              }
                          }
                          failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                              [AFNet.activeView stopAnimating];
                              dispatch_async(dispatch_get_main_queue(), ^{
                                  [AFNet alert:[NSString stringWithFormat:@"%@",[error localizedDescription]]];;
                              });
                              
                          }
                     ];
                }
                
            });
            break;
        }
    }
    if(count==0){
        //判断是不是扫的是另一个托中的箱
        BOOL noXiang=1;
        for(int i=0;i<self.tuoArray.count;i++){
            if(self.tuoArray[i]!=self.tuo){
                Tuo *tuoItem=self.tuoArray[i];
                for(int j=0;j<tuoItem.xiang.count;j++){
                    Xiang *xiangItem=tuoItem.xiang[j];
                    if([data isEqualToString:xiangItem.container_id]){
                        noXiang=0;
                        //切换到另一个拖的模式下
                        [self changeToAnotherXiang:tuoItem];
                        //把刚才扫描的那一箱给填上去
                        [self decoderDataReceived:xiangItem.container_id];
                        break ;
                    }
                }
            }
        }
        if(noXiang){
            UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"没有找到该箱"
                                                           message:[NSString stringWithFormat:@"未在该拖清单中发现托箱%@",data]
                                                          delegate:self
                                                 cancelButtonTitle:@"确定"
                                                 otherButtonTitles:nil];
            AudioServicesPlaySystemSound(1051);
            [alert show];
        }
    }
}
-(void)changeToAnotherXiang:(Tuo *)tuo
{
    self.tuo=tuo;
    self.navigationItem.title=self.tuo.container_id;
    self.xiangCheckedCount=0;
    for(int i=0;i<self.tuo.xiang.count;i++){
        Xiang *xiang=self.tuo.xiang[i];
        if(xiang.checked){
            self.xiangCheckedCount++;
        }
    }
    self.scanTextField.text=@"";
    [self.scanTextField becomeFirstResponder];
    [self updateCheckedLabel];
    [self.xiangTable reloadData];
}
#pragma textField
-(void)textFieldDidBeginEditing:(UITextField *)textField
{
    UIView *dummyView=[[UIView alloc] initWithFrame:CGRectMake(0, 0, 1, 1)];
    textField.inputView=dummyView;
}
// for test via keyboard
-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    NSMutableArray *xiangArray=self.tuo.xiang;
    int count=0;
    for(int i=0;i<xiangArray.count;i++){
        if([textField.text isEqualToString:[xiangArray[i] container_id]]){
            count++;
            AFNetOperate *AFNet=[[AFNetOperate alloc] init];
            AFHTTPRequestOperationManager *manager=[AFNet generateManager:self.view];
            [manager POST:[AFNet xiang_check]
               parameters:@{@"id":[xiangArray[i] ID]}
                  success:^(AFHTTPRequestOperation *operation, id responseObject) {
                      [AFNet.activeView stopAnimating];
                      if([responseObject[@"result"] integerValue]==1){
                          [[self.tuo.xiang objectAtIndex:i] setChecked:YES];
                          [self.xiangTable reloadData];
                          [self updateAddCheckedLabel];
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
            break;
        }
    }
    if(count==0){
        //判断是不是扫的是另一个托中的箱
        BOOL noXiang=1;
        for(int i=0;i<self.tuoArray.count;i++){
            if(self.tuoArray[i]!=self.tuo){
                Tuo *tuoItem=self.tuoArray[i];
                for(int j=0;j<tuoItem.xiang.count;j++){
                    Xiang *xiangItem=tuoItem.xiang[j];
                    
                    if([textField.text isEqualToString:xiangItem.container_id]){
                        noXiang=0;
                        //切换到另一个拖的模式下
                        [self changeToAnotherXiang:tuoItem];
                        //把刚才扫描的那一箱给填上去
                        [self decoderDataReceived:xiangItem.container_id];
                        break ;
                    }
                }
            }
        }
        if(noXiang){
            UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"没有找到该箱"
                                                           message:[NSString stringWithFormat:@"未在该拖清单中发现托箱%@",textField.text]
                                                          delegate:self
                                                 cancelButtonTitle:@"确定"
                                                 otherButtonTitles:nil];
            AudioServicesPlaySystemSound(1051);
            [alert show];
        }
    }
    
    return YES;
}
#pragma table delegate
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.tuo.xiang count];
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    Xiang *xiang=[self.tuo.xiang objectAtIndex:indexPath.row];
    ShopXiangTableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:@"xiangCell" forIndexPath:indexPath];
    cell.partNumberLabel.text=xiang.number;
    cell.keyLabel.text=xiang.key;
    cell.quantityLabel.text=[NSString stringWithFormat:@"%@",xiang.count];
    if(xiang.checked){
        cell.accessoryType=UITableViewCellAccessoryCheckmark;
    }
    else{
        cell.accessoryType=UITableViewCellAccessoryNone;
    }
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    Xiang *xiang=[self.tuo.xiang objectAtIndex:indexPath.row];
    ShopXiangTableViewCell *cell=(ShopXiangTableViewCell *)[tableView cellForRowAtIndexPath:indexPath];
    AFNetOperate *AFNet=[[AFNetOperate alloc] init];
    AFHTTPRequestOperationManager *manager=[AFNet generateManager:self.view];
    if(cell.accessoryType==UITableViewCellAccessoryNone){
        //手动点击添加
        [manager POST:[AFNet xiang_check]
           parameters:@{@"id":xiang.ID}
              success:^(AFHTTPRequestOperation *operation, id responseObject) {
                  [AFNet.activeView stopAnimating];
                  if([responseObject[@"result"] integerValue]==1){
                      cell.accessoryType=UITableViewCellAccessoryCheckmark;
                      xiang.checked=YES;
                      [self updateAddCheckedLabel];
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
    else if(cell.accessoryType==UITableViewCellAccessoryCheckmark){
        //手动点击取消
        [manager POST:[AFNet xiang_uncheck]
           parameters:@{@"id":xiang.ID}
              success:^(AFHTTPRequestOperation *operation, id responseObject) {
                  [AFNet.activeView stopAnimating];
                  if([responseObject[@"result"] integerValue]==1){
                      cell.accessoryType=UITableViewCellAccessoryNone;
                      xiang.checked=NO;
                      [self updateMinusCheckedLabel];
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


/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
 {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */


- (IBAction)confirm:(id)sender {
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
                [manager POST:[AFNet tuo_confirm_receive]
                   parameters:@{@"id":self.tuo.ID}
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
- (IBAction)cancel:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}
-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if([segue.identifier isEqualToString:@"print"]){
        ReceivePrintViewController *vc=segue.destinationViewController;
        vc.container=self.tuo;
        vc.type=@"tuo";
        vc.disableBack=YES;
    }
}
@end
