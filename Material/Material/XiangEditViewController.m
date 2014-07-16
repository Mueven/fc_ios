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
#import <AudioToolbox/AudioToolbox.h>
@interface XiangEditViewController ()<UITextFieldDelegate,CaptuvoEventsProtocol>

@property (weak, nonatomic) IBOutlet UILabel *keyLabel;
@property (weak, nonatomic) IBOutlet UITextField *partNumber;
@property (weak, nonatomic) IBOutlet UITextField *quantity;
@property (weak, nonatomic) IBOutlet UITextField *dateTextField;
@property (strong, nonatomic) UITextField *firstResponder;
@property (strong,nonatomic)ScanStandard *scanStandard;
- (IBAction)finishEdit:(id)sender;
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
    self.quantity.text=self.xiang.count;
    self.dateTextField.text=self.xiang.date;
    
    self.keyLabel.adjustsFontSizeToFitWidth=YES;
    // Do any additional setup after loading the view.
     self.scanStandard=[ScanStandard sharedScanStandard];
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
    UITextField *targetTextField=self.firstResponder;
    NSString *regex=[NSString string];
    if(self.firstResponder.tag==4){
         //date
        regex=[[self.scanStandard.rules objectForKey:@"DATE"] objectForKey:@"regex_string"];
        NSString *alertString=@"请扫描日期";
        NSPredicate * pred= [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
        BOOL isMatch  = [pred evaluateWithObject:data];
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
        regex=[[self.scanStandard.rules objectForKey:@"PART"] objectForKey:@"regex_string"];
        NSString *alertString=@"请扫描零件号";
        NSPredicate * pred= [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
        BOOL isMatch  = [pred evaluateWithObject:data];
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
        regex=[[self.scanStandard.rules objectForKey:@"QUANTITY"] objectForKey:@"regex_string"];
        NSString *alertString=@"请扫描数量";
        NSPredicate * pred= [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
        BOOL isMatch  = [pred evaluateWithObject:data];
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
    NSString *partNumber=self.partNumber.text;
    NSString *quantity=self.quantity.text;
    NSString *date=self.dateTextField.text;
    
    //after regex partNumber
    int beginP=[[[self.scanStandard.rules objectForKey:@"PART"] objectForKey:@"prefix_length"] intValue];
    int lastP=[[[self.scanStandard.rules objectForKey:@"PART"] objectForKey:@"suffix_length"] intValue];
    NSString *partNumberPost=[partNumber substringWithRange:NSMakeRange(beginP, [partNumber length]-beginP-lastP)];
    //after regex quantity
    int beginQ=[[[self.scanStandard.rules objectForKey:@"QUANTITY"] objectForKey:@"prefix_length"] intValue];
    int lastQ=[[[self.scanStandard.rules objectForKey:@"QUANTITY"] objectForKey:@"suffix_length"] intValue];
    NSString *quantityPost=[quantity substringWithRange:NSMakeRange(beginQ, [quantity length]-beginQ-lastQ)];
    //after regex date
    int beginD=[[[self.scanStandard.rules objectForKey:@"DATE"] objectForKey:@"prefix_length"] intValue];
    int lastD=[[[self.scanStandard.rules objectForKey:@"DATE"] objectForKey:@"suffix_length"] intValue];
    NSString *datePost=[date substringWithRange:NSMakeRange(beginD, [date length]-beginD-lastD)];
    
    
    
    AFNetOperate *AFNet=[[AFNetOperate alloc] init];
    AFHTTPRequestOperationManager *manager=[AFNet generateManager:self.view];
    [manager PUT:[AFNet xiang_index]
      parameters:@{@"package":@{
                           @"id":self.xiang.ID,
                           @"part_id":partNumberPost,
                           @"quantity_str":quantityPost,
                           @"check_in_time":datePost
                           }}
         success:^(AFHTTPRequestOperation *operation, id responseObject) {
             [AFNet.activeView stopAnimating];
            
             if([responseObject[@"result"] integerValue]==1){
                 NSDictionary *dic=responseObject[@"content"];
                 self.xiang.date=[dic objectForKey:@"check_in_time"];
                 self.xiang.number=[dic objectForKey:@"part_id"];
                 self.xiang.count=[dic objectForKey:@"quantity_str"];
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
@end
