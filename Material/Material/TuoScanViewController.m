//
//  TuoScanViewController.m
//  Material
//
//  Created by wayne on 14-6-6.
//  Copyright (c) 2014年 brilliantech. All rights reserved.
//

#import "TuoScanViewController.h"
//#import "XiangStore.h"
#import "TuoStore.h"
#import "HuoTableViewCell.h"
#import "Xiang.h"
#import "PrintViewController.h"
#import "Tuo.h"
#import "XiangEditViewController.h"
#import "AFNetOperate.h"
#import "XiangTableViewCell.h"
#import <AudioToolbox/AudioToolbox.h>


@interface TuoScanViewController ()<UITextFieldDelegate,UITableViewDelegate,UITableViewDataSource,CaptuvoEventsProtocol>
@property (weak, nonatomic) IBOutlet UITextField *key;
@property (weak, nonatomic) IBOutlet UITextField *partNumber;
@property (weak, nonatomic) IBOutlet UITextField *quatity;
@property (weak, nonatomic) IBOutlet UITextField *dateTextField;
@property (strong, nonatomic) UITextField *firstResponder;
@property (weak, nonatomic) IBOutlet UILabel *xiangListLabel;
@property (weak, nonatomic) IBOutlet UITableView *xiangTable;
@property (strong,nonatomic)UIAlertView *alert;
//@property (strong, nonatomic) XiangStore *xiangStore;
//@property (strong,nonatomic) NSArray *validateAddress;
- (IBAction)finish:(id)sender;
@end

@implementation TuoScanViewController

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
    self.key.delegate=self;
    self.partNumber.delegate=self;
    self.quatity.delegate=self;
    self.dateTextField.delegate=self;
    self.xiangTable.delegate=self;
    self.xiangTable.dataSource=self;
    if([self.type isEqualToString:@"xiang"]){
        self.navigationItem.rightBarButtonItem=NULL;
        self.tuo=[[Tuo alloc] init];
    }
    else if([self.type isEqualToString:@"addXiang"]){
        self.navigationItem.rightBarButtonItem=NULL;
        self.xiangListLabel.text=@"该拖已经绑定的箱";
    }
    UINib *nib=[UINib nibWithNibName:@"XiangTableViewCell" bundle:nil];
    [self.xiangTable registerNib:nib forCellReuseIdentifier:@"xiangCell"];
    self.alert=nil;
}
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
//    [[Captuvo sharedCaptuvoDevice] removeCaptuvoDelegate:self];
    [[Captuvo sharedCaptuvoDevice] addCaptuvoDelegate:self];
//    [[Captuvo sharedCaptuvoDevice] startDecoderHardware];
    [self.key becomeFirstResponder];
}

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
//    [[Captuvo sharedCaptuvoDevice] stopDecoderHardware];
    [[Captuvo sharedCaptuvoDevice] removeCaptuvoDelegate:self];
    [self.firstResponder resignFirstResponder];
    self.firstResponder=nil;
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma decoder delegate
-(void)decoderDataReceived:(NSString *)data{
    if(self.firstResponder.tag==4){
        self.firstResponder.text=data;
        [self textFieldShouldReturn:self.firstResponder];
    }
    else{
        //验证数据的合法性
        AFNetOperate *AFNet=[[AFNetOperate alloc] init];
        AFHTTPRequestOperationManager *manager=[AFNet generateManager:self.view];
        [AFNet.activeView stopAnimating];
        NSString *address=[[NSString alloc] init];
        switch (self.firstResponder.tag){
            case 1:
                address=[AFNet xiang_validate];
                break;
            case 2:
                address=[AFNet part_validate];
                break;
            case 3:
                address=[AFNet part_quantity_validate];
                break;
        }
        if(self.tuo.ID.length>0 && self.firstResponder.tag==1){
            [manager POST:[AFNet tuo_key_for_bundle]
               parameters:@{
                            @"forklift_id":self.tuo.ID,
                            @"package_id":data
                            }
                  success:^(AFHTTPRequestOperation *operation, id responseObject) {
                      [AFNet.activeView stopAnimating];
                      if([responseObject[@"result"] integerValue]==1){
                          //绑定了直接添加
                          if([(NSDictionary *)responseObject[@"content"] count]>0){
                              Xiang *xiang=[[Xiang alloc] initWithObject:responseObject[@"content"]];
                              [self.tuo addXiang:xiang];
                              [self.xiangTable reloadData];
                              if(self.alert){
                                  [self.alert dismissWithClickedButtonIndex:0 animated:YES];
                                  self.alert=nil;
                              }
                              self.alert= [[UIAlertView alloc]initWithTitle:@"成功"
                                                                    message:@"绑定成功！"
                                                                   delegate:self
                                                          cancelButtonTitle:nil
                                                          otherButtonTitles:nil];
                              [NSTimer scheduledTimerWithTimeInterval:1.5f
                                                               target:self
                                                             selector:@selector(dissmissAlert:)
                                                             userInfo:nil
                                                              repeats:NO];
                              AudioServicesPlaySystemSound(1012);
                              [self.alert show];
                              [self.key becomeFirstResponder];
                              self.key.text=@"";
                          }
                          
                      }
                      else{
                          AFNetOperate *AFNet=[[AFNetOperate alloc] init];
                          AFHTTPRequestOperationManager *manager=[AFNet generateManager:self.view];
                          [AFNet.activeView stopAnimating];
                          [manager POST:address
                             parameters:@{@"id":data}
                                success:^(AFHTTPRequestOperation *operation, id responseObject) {
                                    [AFNet.activeView stopAnimating];
                                    if([responseObject[@"result"] integerValue]==1){
                                        self.firstResponder.text=data;
                                        [self textFieldShouldReturn:self.firstResponder];
                                        
                                    }
                                    else{
                                        [AFNet alert:responseObject[@"content"]];
                                        AudioServicesPlaySystemSound(1051);
                                    }
                                    
                                }
                                failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                                    [AFNet.activeView stopAnimating];
                                    [AFNet alert:[NSString stringWithFormat:@"%@",[error localizedDescription]]];
                                }
                           ];
                      }
                  }
                  failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                      [AFNet.activeView stopAnimating];
                      [AFNet alert:[NSString stringWithFormat:@"%@",[error localizedDescription]]];
                  }
             ];
        }
        else{
            [manager POST:address
               parameters:@{@"id":data}
                  success:^(AFHTTPRequestOperation *operation, id responseObject) {
                      [AFNet.activeView stopAnimating];
                      if([responseObject[@"result"] integerValue]==1){
                          self.firstResponder.text=data;
                          [self textFieldShouldReturn:self.firstResponder];
                          
                      }
                      else{
                          [AFNet alert:responseObject[@"content"]];
                          AudioServicesPlaySystemSound(1051);
                      }
                      
                  }
                  failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                      [AFNet.activeView stopAnimating];
                      [AFNet alert:[NSString stringWithFormat:@"%@",[error localizedDescription]]];
                  }
             ];
        }
    }
}


#pragma textField delegate
-(void)textFieldDidBeginEditing:(UITextField *)textField
{
    UIView* dummyView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 1, 1)];
    textField.inputView = dummyView;
    self.firstResponder=textField;
}
-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
     __block long tag=textField.tag;
    if(tag==4){
        AFNetOperate *AFNet=[[AFNetOperate alloc] init];
        AFHTTPRequestOperationManager *manager=[AFNet generateManager:self.view];
        NSString *key=self.key.text;
        NSString *partNumber=self.partNumber.text;
        NSString *quantity=self.quatity.text;
        NSString *date=self.dateTextField.text;
        if(self.tuo.ID.length>0){
            //拖下面的绑定，不仅绑定，而且会为拖加入新的箱
            [manager POST:[AFNet tuo_bundle_add]
               parameters:@{
                            @"forklift_id":self.tuo.ID,
                            @"package_id":key,
                            @"part_id":partNumber,
                            @"quantity_str":quantity,
                            @"check_in_time":date
                            }
                  success:^(AFHTTPRequestOperation *operation, id responseObject) {
                      //箱绑定成功了
                      [AFNet.activeView stopAnimating];
                      if([responseObject[@"result"] integerValue]==1){
                          if([(NSDictionary *)responseObject[@"content"] count]>0){
                              Xiang *newXiang=[[Xiang alloc] initWithObject:responseObject[@"content"]];
                              [self.tuo addXiang:newXiang];
                              [self.xiangTable reloadData];
                              tag=1;
                              UITextField *nextText=(UITextField *)[self.view viewWithTag:tag];
                              [nextText becomeFirstResponder];
                              self.key.text=@"";
                              self.partNumber.text=@"";
                              self.quatity.text=@"";
                              self.dateTextField.text=@"";
                              
                              self.alert= [[UIAlertView alloc]initWithTitle:@"成功"
                                                                    message:@"绑定成功！"
                                                                   delegate:self
                                                          cancelButtonTitle:nil
                                                          otherButtonTitles:nil];
                              [NSTimer scheduledTimerWithTimeInterval:1.5f
                                                               target:self
                                                             selector:@selector(dissmissAlert:)
                                                             userInfo:nil
                                                              repeats:NO];
                              AudioServicesPlaySystemSound(1012);
                              [self.alert show];
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
        else{
            //箱绑定下的绑定
            [manager POST:[AFNet xiang_index]
               parameters:@{
                            @"package":@{
                                    @"id":key,
                                    @"part_id":partNumber,
                                    @"quantity_str":quantity,
                                    @"check_in_time":date
                                    }
                            }
                  success:^(AFHTTPRequestOperation *operation, id responseObject) {
                      [AFNet.activeView stopAnimating];
                      if([responseObject[@"result"] integerValue]==1){
                          if([(NSDictionary *)responseObject[@"content"] count]>0){
                              Xiang *newXiang=[[Xiang alloc] initWithObject:responseObject[@"content"]];
                              [self.tuo addXiang:newXiang];
                              [self.xiangTable reloadData];
                              tag=1;
                              UITextField *nextText=(UITextField *)[self.view viewWithTag:tag];
                              [nextText becomeFirstResponder];
                              self.key.text=@"";
                              self.partNumber.text=@"";
                              self.quatity.text=@"";
                              self.dateTextField.text=@"";
                              
                              self.alert= [[UIAlertView alloc]initWithTitle:@"成功"
                                                                    message:@"绑定成功！"
                                                                   delegate:self
                                                          cancelButtonTitle:nil
                                                          otherButtonTitles:nil];
                              [NSTimer scheduledTimerWithTimeInterval:1.5f
                                                               target:self
                                                             selector:@selector(dissmissAlert:)
                                                             userInfo:nil
                                                              repeats:NO];
                              AudioServicesPlaySystemSound(1012);
                              [self.alert show];
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
    }
    else{
        tag++;
        UITextField *nextText=(UITextField *)[self.view viewWithTag:tag];
        [nextText becomeFirstResponder];
    }
    return YES;
}
-(void)dissmissAlert:(NSTimer *)timer
{
    if(self.alert){

        [self.alert dismissWithClickedButtonIndex:0 animated:YES];
        self.alert=nil;
    }
}
//table delegate
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
    XiangTableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:@"xiangCell" forIndexPath:indexPath];
    Xiang *xiang=[self.tuo.xiang objectAtIndex:indexPath.row];
    cell.partNumber.text=xiang.number;
    cell.key.text=xiang.key;
    cell.quantity.text=xiang.count;
    cell.position.text=xiang.position;
    cell.date.text=xiang.date;
    cell.accessoryType=UITableViewCellAccessoryDisclosureIndicator;
    return cell;
}

-(void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        AFNetOperate *AFNet=[[AFNetOperate alloc] init];
        AFHTTPRequestOperationManager *manager=[AFNet generateManager:self.view];
        [manager DELETE:[AFNet tuo_remove_xiang]
             parameters:@{
                          @"forklift_id":self.tuo.ID,
                          @"package_id":[[self.tuo.xiang objectAtIndex:indexPath.row] ID]
                          }
                success:^(AFHTTPRequestOperation *operation, id responseObject) {
                    [AFNet.activeView stopAnimating];
                    if([responseObject[@"result"] integerValue]==1){
                        [self.tuo.xiang removeObjectAtIndex:indexPath.row];
                        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
                    }
                    else{
                        [AFNet alert:responseObject[@"content"]];
                    }
                    
                }
                failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                    [AFNet.activeView stopAnimating];
                }
         ];
        
        
    }
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
//    Xiang *xiang=[[self.xiangStore xiangList] objectAtIndex:indexPath.row];
     Xiang *xiang=[self.tuo.xiang objectAtIndex:indexPath.row];
    [self performSegueWithIdentifier:@"fromTuo" sender:@{@"xiang":xiang}];
}
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    //单独绑定箱的时候，不让删除，会误导，在最外面删去
    if([self.type isEqualToString:@"xiang"]){
      return NO;
    }
    else{
        return YES;
    }
}
-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if([segue.identifier isEqualToString:@"scanToPrint"]){
        PrintViewController *printViewController = segue.destinationViewController;
        printViewController.container=[sender objectForKey:@"container"];
    }
    else if([segue.identifier isEqualToString:@"fromTuo"]){
        XiangEditViewController *xiangEdit=segue.destinationViewController;
        xiangEdit.xiang=[sender objectForKey:@"xiang"];
    }
}
- (IBAction)finish:(id)sender {
    [self performSegueWithIdentifier:@"scanToPrint" sender:@{@"container":self.tuo}];
}


@end
