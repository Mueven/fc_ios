//
//  XiangEditViewController.m
//  Material
//
//  Created by wayne on 14-6-8.
//  Copyright (c) 2014年 brilliantech. All rights reserved.
//

#import "XiangEditViewController.h"
#import "AFNetOperate.h"
#import "ScanStandard.h"
#import "XiangSendViewController.h"
#import <AudioToolbox/AudioToolbox.h>
@interface XiangEditViewController ()<UITextFieldDelegate,CaptuvoEventsProtocol>

@property (weak, nonatomic) IBOutlet UILabel *keyLabel;
@property (weak, nonatomic) IBOutlet UITextField *partNumber;
@property (weak, nonatomic) IBOutlet UITextField *quantity;
@property (weak, nonatomic) IBOutlet UITextField *dateTextField;
@property (strong, nonatomic) UITextField *firstResponder;
@property (strong,nonatomic)ScanStandard *scanStandard;
@property (weak, nonatomic) IBOutlet UIButton *sendButton;
@property (nonatomic) int *dirty;
- (IBAction)finishEdit:(id)sender;
- (IBAction)sendXiang:(id)sender;
@end

@implementation XiangEditViewController

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
    self.partNumber.delegate=self;
    self.quantity.delegate=self;
    self.dateTextField.delegate=self;
    self.keyLabel.text=self.xiang.key;
    self.partNumber.text=self.xiang.number;
    self.quantity.text=self.xiang.quantity_display;
    self.dateTextField.text=self.xiang.date;
    self.keyLabel.adjustsFontSizeToFitWidth=YES;
    self.dirty=0;
    // Do any additional setup after loading the view.
     self.scanStandard=[ScanStandard sharedScanStandard];
    if(self.enableSend){
        self.sendButton.hidden=NO;
    }
}
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
//    [[Captuvo sharedCaptuvoDevice] removeCaptuvoDelegate:self];
    [[Captuvo sharedCaptuvoDevice] addCaptuvoDelegate:self];
//    [[Captuvo sharedCaptuvoDevice] startDecoderHardware];
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
    self.dirty++;
    UITextField *targetTextField=self.firstResponder;
    if(self.firstResponder.tag==4){
         //date
        NSString *alertString=@"请扫描日期";
        BOOL isMatch  = [self.scanStandard checkDate:data];
        if(isMatch){
            self.firstResponder.text=data;
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
    else if(self.firstResponder.tag==2){
        //part number
        NSString *alertString=@"请扫描零件号";
        BOOL isMatch  = [self.scanStandard checkPartNumber:data];
        if(isMatch){
            self.firstResponder.text=data;
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
         //count
        NSString *alertString=@"请扫描数量";
        BOOL isMatch  = [self.scanStandard checkQuantity:data];
        if(isMatch){
            self.firstResponder.text=data;
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

}
-(void)removeAlert:(NSTimer *)timer{
        UIAlertView *alert = [[timer userInfo]  objectForKey:@"alert"];
        [alert dismissWithClickedButtonIndex:0 animated:YES];
}

-(void)textFieldDidBeginEditing:(UITextField *)textField
{
    UIView* dummyView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 1, 1)];
    textField.inputView = dummyView;
    self.firstResponder=textField;
}
-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    return YES;
}

- (IBAction)finishEdit:(id)sender {
    if(self.dirty==0){
              [self.navigationController popViewControllerAnimated:YES];
    }
    else {
        NSString *partNumber=self.partNumber.text;
        NSString *quantity=self.quantity.text;
        NSString *date=self.dateTextField.text;
        
        //after regex partNumber
        NSString *partNumberPost=[self.scanStandard filterPartNumber:partNumber];
        //after regex quantity
        NSString *quantityPost=[self.scanStandard filterQuantity:quantity];
        //after regex date
        NSString *datePost=[self.scanStandard filterDate:date];
        
        
        AFNetOperate *AFNet=[[AFNetOperate alloc] init];
        AFHTTPRequestOperationManager *manager=[AFNet generateManager:self.view];
        [manager PUT:[AFNet xiang_index]
          parameters:@{@"package":@{
                               @"id":self.xiang.ID,
                               @"part_id":partNumberPost,
                               @"quantity":quantityPost,
                               @"custom_fifo_time":datePost,
                               @"part_id_display":partNumber,
                               @"quantity_display":quantity,
                               @"fifo_time_display":date
                               }
                       }
             success:^(AFHTTPRequestOperation *operation, id responseObject) {
                 [AFNet.activeView stopAnimating];
                 
                 if([responseObject[@"result"] integerValue]==1){
                     NSDictionary *dic=responseObject[@"content"];
                     self.xiang.date=[dic objectForKey:@"fifo_time_display"];
                     self.xiang.number=[dic objectForKey:@"part_id_display"];
                     self.xiang.count=[dic objectForKey:@"quantity"];
                     self.xiang.position=[dic objectForKey:@"position_nr"];
                     [self.navigationController popViewControllerAnimated:YES];
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

- (IBAction)sendXiang:(id)sender {
    if(self.dirty==0){
        NSLog(@"here");
        [self performSegueWithIdentifier:@"send" sender:@{@"xiang":self.xiang}];
    }
    else{
        NSString *partNumber=self.partNumber.text;
        NSString *quantity=self.quantity.text;
        NSString *date=self.dateTextField.text;
        
        //after regex partNumber
        NSString *partNumberPost=[self.scanStandard filterPartNumber:partNumber];
        //after regex quantity
        NSString *quantityPost=[self.scanStandard filterQuantity:quantity];
        //after regex date
        NSString *datePost=[self.scanStandard filterDate:date];
        
        AFNetOperate *AFNet=[[AFNetOperate alloc] init];
        AFHTTPRequestOperationManager *manager=[AFNet generateManager:self.view];
        [manager PUT:[AFNet xiang_index]
          parameters:@{@"package":@{
                               @"id":self.xiang.ID,
                               @"part_id":partNumberPost,
                               @"quantity":quantityPost,
                               @"custom_fifo_time":datePost,
                               @"part_id_display":partNumber,
                               @"quantity_display":quantity,
                               @"fifo_time_display":date
                               }}
             success:^(AFHTTPRequestOperation *operation, id responseObject) {
                 [AFNet.activeView stopAnimating];
                 
                 if([responseObject[@"result"] integerValue]==1){
                     NSDictionary *dic=responseObject[@"content"];
                     self.xiang.date=[dic objectForKey:@"fifo_time_display"];
                     self.xiang.number=[dic objectForKey:@"part_id_display"];
                     self.xiang.count=[dic objectForKey:@"quantity"];
                     self.xiang.position=[dic objectForKey:@"position_nr"];
                     self.dirty=0;
                     [self performSegueWithIdentifier:@"send" sender:@{@"xiang":self.xiang}];
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

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if([segue.identifier isEqualToString:@"send"]){
        XiangSendViewController *sendVC=[segue destinationViewController];
        sendVC.xiang=[sender objectForKey:@"xiang"];
        if(self.xiangArray){
            sendVC.xiangArray=self.xiangArray;
            sendVC.xiangIndex=self.xiangIndex;
        }
    }
}
@end
