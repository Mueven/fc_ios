//
//  PrintViewController.m
//  Material
//
//  Created by wayne on 14-6-8.
//  Copyright (c) 2014年 brilliantech. All rights reserved.
//

#import "PrintViewController.h"
#import "AFNetOperate.h"
#import "Tuo.h"
#import "Yun.h"
#import "Xiang.h"
#import "PrinterSetting.h"
#import "TuoSendViewController.h"
#import "YunSendViewController.h"

@interface PrintViewController ()<UITextFieldDelegate>
- (IBAction)print:(id)sender;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *yunSuccessContentLabel;

@property (weak, nonatomic) IBOutlet UILabel *printModelLabel;
@property (weak, nonatomic) IBOutlet UITextField *pageTextField;
@property (strong,nonatomic) PrinterSetting *printSetting;
@property (weak, nonatomic) IBOutlet UIButton *sendButton;
- (IBAction)touchScreen:(id)sender;
- (IBAction)send:(id)sender;
- (IBAction)finish:(id)sender;
@end

@implementation PrintViewController
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
    if([self.noBackButton boolValue]){
        [self.navigationItem setHidesBackButton:YES];
    }
    self.pageTextField.delegate=self;
    self.printModelLabel.adjustsFontSizeToFitWidth=YES;
    self.printSetting=[PrinterSetting sharedPrinterSetting];
    //self.printModelLabel.text=[self.printSetting getPrivatePrinter:@"P001"];
    self.printModelLabel.text=[self.printSetting getPrinterModelWithAlternative:@"P001"];
    if(self.enableSend){
        self.sendButton.hidden=NO;
    }
    //self.yunSuccessContent=[NSString string];
}
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    NSString *class=[NSString stringWithFormat:@"%@",[self.container class]];
    if([class isEqualToString:@"Yun"]){
        self.pageTextField.text=[self.printSetting getCopy:@"stock" type:@"yun" alternative:@"P002"];
    }
    else if([class isEqualToString:@"Tuo"] ){
        self.pageTextField.text=[self.printSetting getCopy:@"stock" type:@"tuo" alternative:@"P001"];
    }
    else if([class isEqualToString:@"Xiang"]){
        self.pageTextField.text=[self.printSetting getCopy:@"stock" type:@"xiang" alternative:@"P001"];
    }
    self.yunSuccessContentLabel.text=self.yunSuccessContent.length>0?self.yunSuccessContent:@"";
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)textFieldDidEndEditing:(UITextField *)textField
{
    if(textField.text.length>0){
        NSString *class=[NSString stringWithFormat:@"%@",[self.container class]];
        if([class isEqualToString:@"Yun"]){
            [self.printSetting setCopy:@"stock" type:@"yun" copies:textField.text];
        }
        else if([class isEqualToString:@"Tuo"]){
            [self.printSetting setCopy:@"stock" type:@"tuo" copies:textField.text];
        }
        else if([class isEqualToString:@"Xiang"]){
            [self.printSetting setCopy:@"stock" type:@"xiang" copies:textField.text];
        }
    }
    [textField resignFirstResponder];
}
-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return  YES;
}
//- (IBAction)unPrint:(id)sender {
//    NSString *containerClass=[NSString stringWithFormat:@"%@",[self.container class]];
//     if([containerClass isEqualToString:@"Tuo"]){
//         [self performSegueWithIdentifier:@"finishTuo" sender:self];
//     }
//     else if([containerClass isEqualToString:@"Yun"]){
//         [self performSegueWithIdentifier:@"finishYun" sender:self];
//     }
//}

- (IBAction)print:(id)sender {
     [self sameFinishAction];
    
}
-(void)sameFinishAction
{
    NSString *containerClass=[NSString stringWithFormat:@"%@",[self.container class]];
    AFNetOperate *AFNet=[[AFNetOperate alloc] init];
    AFHTTPRequestOperationManager *manager=[AFNet generateManager:self.view];
    if(self.pageTextField.text.length>0){
        NSString *class=[NSString stringWithFormat:@"%@",[self.container class]];
        if([class isEqualToString:@"Yun"]){
             [self.printSetting setCopy:@"stock" type:@"yun" copies:self.pageTextField.text];
        }
        else if([class isEqualToString:@"Tuo"]){
             [self.printSetting setCopy:@"stock" type:@"tuo" copies:self.pageTextField.text];
        }
        else if([class isEqualToString:@"Xiang"]){
           [self.printSetting setCopy:@"stock" type:@"xiang" copies:self.pageTextField.text];
        }
    }
    if([containerClass isEqualToString:@"Tuo"]){
        //这里掉打印拖的接口
        [manager GET:[[AFNet print_stock_tuo:[(Tuo *)self.container ID] printer_name:[self.printSetting getPrinterModelWithAlternative:@"P001"] copies:[self.printSetting getCopy:@"stock" type:@"tuo" alternative:@"P001"]] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]
          parameters:nil
             success:^(AFHTTPRequestOperation *operation, id responseObject) {
                 [AFNet.activeView stopAnimating];
                 if([responseObject[@"Code"] integerValue]==1){
                    [AFNet alertSuccess:responseObject[@"Content"]];
                 }
                 else{
                     [AFNet alert:responseObject[@"Content"]];
                 }
             }
             failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                 [AFNet.activeView stopAnimating];
                 [AFNet alert:[NSString stringWithFormat:@"%@",[error localizedDescription]]];
             }
         ];
    }
    else if([containerClass isEqualToString:@"Yun"]){
        [manager GET:[[AFNet print_stock_yun:[(Yun *)self.container ID] printer_name:[self.printSetting getPrinterModelWithAlternative:@"P002"] copies:[self.printSetting getCopy:@"stock" type:@"yun" alternative:@"P002"]] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]
          parameters:nil
             success:^(AFHTTPRequestOperation *operation, id responseObject) {
                 [AFNet.activeView stopAnimating];
                 if([responseObject[@"Code"] integerValue]==1){
                     [AFNet alertSuccess:responseObject[@"Content"]];
                 }
                 else{
                     [AFNet alert:responseObject[@"Content"]];
                 }
             }
             failure:^(AFHTTPRequestOperation *operation, NSError *error) {
             
                 [AFNet.activeView stopAnimating];
                 [AFNet alert:[NSString stringWithFormat:@"%@",[error localizedDescription]]];
             }
         ];
    }
    else if([containerClass isEqualToString:@"Xiang"]){
        [manager GET:[[AFNet print_stock_xiang:[(Xiang *)self.container ID] printer_name:[self.printSetting getPrinterModelWithAlternative:@"P001"] copies:[self.printSetting getCopy:@"stock" type:@"xiang" alternative:@"P001"]] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]
          parameters:nil
             success:^(AFHTTPRequestOperation *operation, id responseObject) {
                 [AFNet.activeView stopAnimating];
                 if([responseObject[@"Code"] integerValue]==1){
                     [AFNet alertSuccess:responseObject[@"Content"]];
                 }
                 else{
                     [AFNet alert:responseObject[@"Content"]];
                 }
             }
             failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                 
                 [AFNet.activeView stopAnimating];
                 [AFNet alert:[NSString stringWithFormat:@"%@",[error localizedDescription]]];
             }
         ];
    }
}
- (IBAction)touchScreen:(id)sender {
    [self.pageTextField resignFirstResponder];
}

- (IBAction)send:(id)sender {
    NSString *container=[NSString stringWithFormat:@"%@",[self.container class]];
    if([container isEqualToString:@"Tuo"]){
        [self performSegueWithIdentifier:@"sendTuo" sender:self];
    }
    else if([container isEqualToString:@"Yun"]){
        [self performSegueWithIdentifier:@"sendYun" sender:self];
    }
}


- (IBAction)finish:(id)sender {
    NSString *containerClass=[NSString stringWithFormat:@"%@",[self.container class]];
    if([containerClass isEqualToString:@"Tuo"]){
        if(![self.noBackButton boolValue]){
            [self.navigationController popViewControllerAnimated:YES];
        }
        else{
            [self performSegueWithIdentifier:@"finishTuo" sender:self];
        }
    }
    else if([containerClass isEqualToString:@"Yun"]){
        if(![self.noBackButton boolValue]){
            [self.navigationController popViewControllerAnimated:YES];
        }
        else{
            [self performSegueWithIdentifier:@"finishYun" sender:self];
        }
    }
    else if([containerClass isEqualToString:@"Xiang"]){
        if(![self.noBackButton boolValue]){
            [self.navigationController popViewControllerAnimated:YES];
        }
        else{
            [self performSegueWithIdentifier:@"finishXiang" sender:self];
        }
    }
}
-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if([segue.identifier isEqualToString:@"sendTuo"]){
        TuoSendViewController *sendVC=segue.destinationViewController;
        sendVC.tuo=self.container;
    }
//    else if ([segue.identifier isEqualToString:@"sendYun"]){
//        YunSendViewController *yunVC=segue.destinationViewController;
//        yunVC.yun=self.container;
//        yunVC.successContent=self.yunSuccessContent;
//    }
}
@end
