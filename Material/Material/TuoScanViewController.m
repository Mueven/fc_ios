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

#import "Xiang.h"
#import "PrintViewController.h"
#import "Tuo.h"
#import "XiangEditViewController.h"
#import "AFNetOperate.h"
#import "XiangTableViewCell.h"
#import <AudioToolbox/AudioToolbox.h>
#import "ScanStandard.h"
#import "SortArray.h"
#import "TuoCheckGeneralViewController.h"


@interface TuoScanViewController ()<UITextFieldDelegate,UITableViewDelegate,UITableViewDataSource,CaptuvoEventsProtocol>
@property (weak, nonatomic) IBOutlet UITextField *key;
@property (weak, nonatomic) IBOutlet UITextField *partNumber;
@property (weak, nonatomic) IBOutlet UITextField *quatity;
@property (weak, nonatomic) IBOutlet UITextField *dateTextField;
@property (strong, nonatomic) UITextField *firstResponder;
@property (weak, nonatomic) IBOutlet UILabel *xiangListLabel;
@property (weak, nonatomic) IBOutlet UITableView *xiangTable;
@property (strong,nonatomic)UIAlertView *alert;
@property (strong,nonatomic)ScanStandard *scanStandard;
//@property (strong, nonatomic) XiangStore *xiangStore;
//@property (strong,nonatomic) NSArray *validateAddress;
@property (weak, nonatomic) IBOutlet UILabel *xiangCountLabel;
@property (nonatomic)int sum_packages_count;
- (IBAction)finish:(id)sender;
- (IBAction)checkXiang:(id)sender;
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
        self.xiangListLabel.text=@"已绑定箱数:";
    }
    else if([self.type isEqualToString:@"tuo"]){
        [self.navigationItem setHidesBackButton:YES];
        self.navigationItem.title=self.tuo.department;
    }
    self.xiangCountLabel.adjustsFontSizeToFitWidth=YES;
    UINib *nib=[UINib nibWithNibName:@"XiangTableViewCell" bundle:nil];
    [self.xiangTable registerNib:nib forCellReuseIdentifier:@"xiangCell"];
    self.alert=nil;
    self.scanStandard=[ScanStandard sharedScanStandard];
    self.sum_packages_count=[self.tuo.xiang count];
    [self updateXiangCountLabel];
}
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    //    [[Captuvo sharedCaptuvoDevice] removeCaptuvoDelegate:self];
    [[Captuvo sharedCaptuvoDevice] addCaptuvoDelegate:self];
    //    [[Captuvo sharedCaptuvoDevice] startDecoderHardware];
    [self.key becomeFirstResponder];
    [self.xiangTable reloadData];
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
    self.firstResponder.text=[data copy];
    UITextField *targetTextField=self.firstResponder;
    NSString *regex=[NSString string];
    if(targetTextField.tag==4 ){
        //date
        regex=[[self.scanStandard.rules objectForKey:@"DATE"] objectForKey:@"regex_string"];
        NSString *alertString=@"请扫描日期";
        NSPredicate * pred= [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
        BOOL isMatch  = [pred evaluateWithObject:data];
        if(isMatch){
            [self textFieldShouldReturn:self.firstResponder];
        }
        else{
            UIAlertView *alert=[[UIAlertView alloc] initWithTitle:@""
                                                          message:alertString
                                                         delegate:self
                                                cancelButtonTitle:@"确定"
                                                otherButtonTitles:nil];
            [alert show];
            [NSTimer scheduledTimerWithTimeInterval:2.0f
                                             target:self
                                           selector:@selector(removeAlert:)
                                           userInfo:[NSDictionary dictionaryWithObjectsAndKeys:alert,@"alert", nil]
                                            repeats:NO];
            AudioServicesPlaySystemSound(1051);
            targetTextField.text=@"";
            [targetTextField becomeFirstResponder];
        }
    }
    else if(targetTextField.tag==2){
        //part number
        regex=[[self.scanStandard.rules objectForKey:@"PART"] objectForKey:@"regex_string"];
        NSString *alertString=@"请扫描零件号";
        NSPredicate * pred= [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
        BOOL isMatch  = [pred evaluateWithObject:data];
        if(isMatch){
            [self textFieldShouldReturn:self.firstResponder];
        }
        else{
            UIAlertView *alert=[[UIAlertView alloc] initWithTitle:@""
                                                          message:alertString
                                                         delegate:self
                                                cancelButtonTitle:@"确定"
                                                otherButtonTitles:nil];
            [alert show];
            [NSTimer scheduledTimerWithTimeInterval:2.0f
                                             target:self
                                           selector:@selector(removeAlert:)
                                           userInfo:[NSDictionary dictionaryWithObjectsAndKeys:alert,@"alert", nil]
                                            repeats:NO];
            AudioServicesPlaySystemSound(1051);
            targetTextField.text=@"";
            [targetTextField becomeFirstResponder];
        }
    }
    else if(targetTextField.tag==3){
        //count
        regex=[[self.scanStandard.rules objectForKey:@"QUANTITY"] objectForKey:@"regex_string"];
        NSString *alertString=@"请扫描数量";
        NSPredicate * pred= [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
        BOOL isMatch  = [pred evaluateWithObject:data];
        if(isMatch){
            [self textFieldShouldReturn:self.firstResponder];
        }
        else{
            UIAlertView *alert=[[UIAlertView alloc] initWithTitle:@""
                                                          message:alertString
                                                         delegate:self
                                                cancelButtonTitle:@"确定"
                                                otherButtonTitles:nil];
            [alert show];
            [NSTimer scheduledTimerWithTimeInterval:2.0f
                                             target:self
                                           selector:@selector(removeAlert:)
                                           userInfo:[NSDictionary dictionaryWithObjectsAndKeys:alert,@"alert", nil]
                                            repeats:NO];
            AudioServicesPlaySystemSound(1051);
            targetTextField.text=@"";
            [targetTextField becomeFirstResponder];
        }
        
    }
    else{
        //唯一码
        regex=[[self.scanStandard.rules objectForKey:@"UNIQ"] objectForKey:@"regex_string"];
        NSString *alertString=@"请扫描唯一码";
        NSPredicate * pred= [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
        BOOL isMatch  = [pred evaluateWithObject:data];
        if(isMatch){
            
            [self textFieldShouldReturn:self.firstResponder];
            //验证数据的合法性
            AFNetOperate *AFNet=[[AFNetOperate alloc] init];
            AFHTTPRequestOperationManager *manager=[AFNet generateManager:self.view];
            [AFNet.activeView stopAnimating];
            NSString *address=[AFNet xiang_validate];
            
            
            dispatch_queue_t validate=dispatch_queue_create("com.validate.pptalent", NULL);
            dispatch_async(validate, ^{
                NSString *myData=data;
                if(self.tuo.ID.length>0 && targetTextField.tag==1){
                    [manager POST:[AFNet tuo_key_for_bundle]
                       parameters:@{
                                    @"forklift_id":self.tuo.ID,
                                    @"package_id":myData
                                    }
                          success:^(AFHTTPRequestOperation *operation, id responseObject) {
                              [AFNet.activeView stopAnimating];
                              if([responseObject[@"result"] integerValue]==1){
                                  //如果已经绑定了就直接添加
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
                                      [NSTimer scheduledTimerWithTimeInterval:1.0f
                                                                       target:self
                                                                     selector:@selector(dissmissAlert:)
                                                                     userInfo:nil
                                                                      repeats:NO];
                                      AudioServicesPlaySystemSound(1012);
                                      [self.alert show];
                                      [self.key becomeFirstResponder];
                                      self.key.text=@"";
                                      self.partNumber.text=@"";
                                      self.quatity.text=@"";
                                      self.dateTextField.text=@"";
                                      [self updateAddXiangCount];
                                  }
                                  
                              }
                              else{
                                  AFNetOperate *AFNet=[[AFNetOperate alloc] init];
                                  AFHTTPRequestOperationManager *manager=[AFNet generateManager:self.view];
                                  [AFNet.activeView stopAnimating];
                                  [manager POST:address
                                     parameters:@{@"id":myData}
                                        success:^(AFHTTPRequestOperation *operation, id responseObject) {
                                            [AFNet.activeView stopAnimating];
                                            if([responseObject[@"result"] integerValue]==1){
                                                //self.firstResponder.text=data;
                                                //[self textFieldShouldReturn:self.firstResponder];
                                            }
                                            else{
                                                [AFNet alert:responseObject[@"content"]];
                                                AudioServicesPlaySystemSound(1051);
                                                targetTextField.text=@"";
                                                [targetTextField becomeFirstResponder];
                                            }
                                            
                                        }
                                        failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                                            [AFNet.activeView stopAnimating];
                                            [AFNet alert:[NSString stringWithFormat:@"%@",[error localizedDescription]]];
                                            targetTextField.text=@"";
                                            [targetTextField becomeFirstResponder];
                                        }
                                   ];
                              }
                          }
                          failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                              [AFNet.activeView stopAnimating];
                              [AFNet alert:[NSString stringWithFormat:@"%@",[error localizedDescription]]];
                              targetTextField.text=@"";
                              [targetTextField becomeFirstResponder];
                          }
                     ];
                }
                else{
                    [manager POST:address
                       parameters:@{@"id":data}
                          success:^(AFHTTPRequestOperation *operation, id responseObject) {
                              [AFNet.activeView stopAnimating];
                              if([responseObject[@"result"] integerValue]==1){
                                  //                              self.firstResponder.text=data;
                                  //                              [self textFieldShouldReturn:self.firstResponder];
                                  
                              }
                              else{
                                  [AFNet alert:responseObject[@"content"]];
                                  AudioServicesPlaySystemSound(1051);
                                  targetTextField.text=@"";
                                  [targetTextField becomeFirstResponder];
                              }
                              
                          }
                          failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                              [AFNet.activeView stopAnimating];
                              [AFNet alert:[NSString stringWithFormat:@"%@",[error localizedDescription]]];
                              targetTextField.text=@"";
                              [targetTextField becomeFirstResponder];
                          }
                     ];
                }
            });
            
            
            
        }
        else{
            UIAlertView *alert=[[UIAlertView alloc] initWithTitle:@""
                                                          message:alertString
                                                         delegate:self
                                                cancelButtonTitle:@"确定"
                                                otherButtonTitles:nil];
            [alert show];
            [NSTimer scheduledTimerWithTimeInterval:2.0f
                                             target:self
                                           selector:@selector(removeAlert:)
                                           userInfo:[NSDictionary dictionaryWithObjectsAndKeys:alert,@"alert", nil]
                                            repeats:NO];
            AudioServicesPlaySystemSound(1051);
            targetTextField.text=@"";
            [targetTextField becomeFirstResponder];
        }
        
        
    }
}
-(void)removeAlert:(NSTimer *)timer{
    UIAlertView *alert = [[timer userInfo]  objectForKey:@"alert"];
    [alert dismissWithClickedButtonIndex:0 animated:YES];
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
        NSString *key=self.key.text?self.key.text:@"";
        NSString *partNumber=self.partNumber.text?self.partNumber.text:@"";
        NSString *quantity=self.quatity.text?self.quatity.text:@"";
        NSString *date=self.dateTextField.text?self.dateTextField.text:@"";
        
        //after regex partNumber
        int beginP=[[[self.scanStandard.rules objectForKey:@"PART"] objectForKey:@"prefix_length"] intValue];
        int lastP=[[[self.scanStandard.rules objectForKey:@"PART"] objectForKey:@"suffix_length"] intValue];
        NSString *partNumberPost=[NSString string];
        if([partNumber substringWithRange:NSMakeRange(beginP, [partNumber length]-beginP-lastP)]){
             partNumberPost=[partNumber substringWithRange:NSMakeRange(beginP, [partNumber length]-beginP-lastP)];
        }
        else{
            partNumberPost=@"";
        }
        //after regex quantity
        int beginQ=[[[self.scanStandard.rules objectForKey:@"QUANTITY"] objectForKey:@"prefix_length"] intValue];
        int lastQ=[[[self.scanStandard.rules objectForKey:@"QUANTITY"] objectForKey:@"suffix_length"] intValue];
        NSString *quantityPost=[NSString string];
        if([quantity substringWithRange:NSMakeRange(beginQ, [quantity length]-beginQ-lastQ)]){
             quantityPost=[quantity substringWithRange:NSMakeRange(beginQ, [quantity length]-beginQ-lastQ)];
        }
        else{
            quantityPost=@"";
        }
        //after regex date
        int beginD=[[[self.scanStandard.rules objectForKey:@"DATE"] objectForKey:@"prefix_length"] intValue];
        int lastD=[[[self.scanStandard.rules objectForKey:@"DATE"] objectForKey:@"suffix_length"] intValue];
        NSString *datePost=[NSString string];
        if([date substringWithRange:NSMakeRange(beginD, [date length]-beginD-lastD)]){
             datePost=[date substringWithRange:NSMakeRange(beginD, [date length]-beginD-lastD)];
        }
        else{
              datePost=@"";
        }
        if(self.tuo.ID.length>0){
            //拖下面的绑定，不仅绑定，而且会为拖加入新的箱
            [manager POST:[AFNet tuo_bundle_add]
               parameters:@{
                            @"forklift_id":self.tuo.ID,
                            @"package_id":key,
                            @"part_id":partNumberPost,
                            @"quantity_str":quantityPost,
                            @"check_in_time":datePost
                            }
                  success:^(AFHTTPRequestOperation *operation, id responseObject) {
                      //箱绑定成功了
                      [AFNet.activeView stopAnimating];
                      if([responseObject[@"result"] integerValue]==1){
                          
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
                          [self updateAddXiangCount];
                          
                          
                          NSString *result_code=responseObject[@"result_code"];
                          if([result_code isEqualToString:@"100"]){
                              AudioServicesPlaySystemSound(1012);
                              self.alert= [[UIAlertView alloc]initWithTitle:@"成功"
                                                                    message:@"绑定成功"
                                                                   delegate:self
                                                          cancelButtonTitle:nil
                                                          otherButtonTitles:nil];
                              [NSTimer scheduledTimerWithTimeInterval:0.5f
                                                               target:self
                                                             selector:@selector(dissmissAlert:)
                                                             userInfo:nil
                                                              repeats:NO];
                              
                              [self.alert show];
                          }
                          else if([result_code isEqualToString:@"101"]){
                              AudioServicesPlaySystemSound(1051);
                              UIAlertView *positionAlert=[[UIAlertView alloc] initWithTitle:@"警告"
                                                                                    message:@"请确认部门是否正确"
                                                                                   delegate:self
                                                                          cancelButtonTitle:@"确定"
                                                                          otherButtonTitles:nil];
                              [positionAlert show];
                          }
                      }
                      else{
                          [AFNet alert:responseObject[@"content"]];
                          self.key.text=@"";
                          self.partNumber.text=@"";
                          self.quatity.text=@"";
                          self.dateTextField.text=@"";
                          [self.key becomeFirstResponder];
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
                                    @"part_id":partNumberPost,
                                    @"quantity_str":quantityPost,
                                    @"check_in_time":datePost
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
                              [NSTimer scheduledTimerWithTimeInterval:0.5f
                                                               target:self
                                                             selector:@selector(dissmissAlert:)
                                                             userInfo:nil
                                                              repeats:NO];
                              AudioServicesPlaySystemSound(1012);
                              [self.alert show];
                              [self updateAddXiangCount];
                          }
                          
                      }
                      else{
                          [AFNet alert:responseObject[@"content"]];
                          self.key.text=@"";
                          self.partNumber.text=@"";
                          self.quatity.text=@"";
                          self.dateTextField.text=@"";
                          [self.key becomeFirstResponder];
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
                        [self updateMinusXiangCount];
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
        printViewController.noBackButton=@1;
    }
    else if([segue.identifier isEqualToString:@"fromTuo"]){
        XiangEditViewController *xiangEdit=segue.destinationViewController;
        xiangEdit.xiang=[sender objectForKey:@"xiang"];
    }
    else if([segue.identifier isEqualToString:@"checkXiang"]){
        TuoCheckGeneralViewController *tuoCheck=segue.destinationViewController;
        tuoCheck.xiangArray=[sender objectForKey:@"xiangArray"];
    }
}
- (IBAction)finish:(id)sender {
    [self performSegueWithIdentifier:@"scanToPrint" sender:@{@"container":self.tuo}];
}

- (IBAction)checkXiang:(id)sender {
    NSArray *xiangArray=[SortArray sortByPartNumber:self.tuo.xiang];
    [self performSegueWithIdentifier:@"checkXiang" sender:@{@"xiangArray":xiangArray}];
}

-(void)updateAddXiangCount{
    self.sum_packages_count++;
    [self updateXiangCountLabel];
}
-(void)updateMinusXiangCount{
    self.sum_packages_count--;
    [self updateXiangCountLabel];
}
-(void)updateXiangCountLabel
{
    self.xiangCountLabel.text=[NSString stringWithFormat:@"%d",self.sum_packages_count];
}

@end
