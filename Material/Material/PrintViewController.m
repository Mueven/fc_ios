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
#import "PrinterSetting.h"

@interface PrintViewController ()<UITextFieldDelegate>
- (IBAction)unPrint:(id)sender;
- (IBAction)print:(id)sender;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *yunSuccessContentLabel;
@property (weak, nonatomic) IBOutlet UILabel *printModelLabel;
@property (weak, nonatomic) IBOutlet UITextField *pageTextField;
@property (strong,nonatomic) PrinterSetting *printSetting;
- (IBAction)touchScreen:(id)sender;
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
    self.yunSuccessContentLabel.text=self.successContent?self.successContent:@"";
    if([self.noBackButton boolValue]){
        [self.navigationItem setHidesBackButton:YES];
    }
    self.pageTextField.delegate=self;
    self.printModelLabel.adjustsFontSizeToFitWidth=YES;

    self.printSetting=[PrinterSetting sharedPrinterSetting];
        self.printModelLabel.text=[self.printSetting getPrivatePrinter:@"P001"];
}
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    NSString *class=[NSString stringWithFormat:@"%@",[self.container class]];
    if([class isEqualToString:@"Yun"]){
        self.titleLabel.text=@"打印运单？";
        self.pageTextField.text=[self.printSetting getPrivateCopy:@"P002"];
    }
    else if([class isEqualToString:@"Tuo"]){
        self.titleLabel.text=@"打印拖清单？";
        self.pageTextField.text=[self.printSetting getPrivateCopy:@"P001"];
    }
    
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
            [self.printSetting setPrivateCopy:@"P002" copies:textField.text];
        }
        else if([class isEqualToString:@"Tuo"]){
            [self.printSetting setPrivateCopy:@"P001" copies:textField.text];
        }
    }
    [textField resignFirstResponder];
}
-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return  YES;
}
- (IBAction)unPrint:(id)sender {
    NSString *containerClass=[NSString stringWithFormat:@"%@",[self.container class]];
     if([containerClass isEqualToString:@"Tuo"]){
         [self performSegueWithIdentifier:@"finishTuo" sender:self];
     }
     else if([containerClass isEqualToString:@"Yun"]){
         [self performSegueWithIdentifier:@"finishYun" sender:self];
     }
}

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
            [self.printSetting setPrivateCopy:@"P002" copies:self.pageTextField.text];
        }
        else if([class isEqualToString:@"Tuo"]){
            [self.printSetting setPrivateCopy:@"P001" copies:self.pageTextField.text];
        }
    }
    if([containerClass isEqualToString:@"Tuo"]){
        //这里掉打印拖的接口
        [manager GET:[[AFNet print_stock_tuo:[(Tuo *)self.container ID] printer_name:[self.printSetting getPrivatePrinter:@"P001"] copies:[self.printSetting getPrivateCopy:@"P001"]] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]
          parameters:nil
             success:^(AFHTTPRequestOperation *operation, id responseObject) {
                 [AFNet.activeView stopAnimating];
                 if([responseObject[@"Code"] integerValue]==1){
                    [AFNet alertSuccess:responseObject[@"Content"]];
                     if(![self.noBackButton boolValue]){
                         [self.navigationController popViewControllerAnimated:YES];
                     }
                     else{
                          [self performSegueWithIdentifier:@"finishTuo" sender:self];
                     }
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
        [manager GET:[[AFNet print_stock_yun:[(Yun *)self.container ID] printer_name:[self.printSetting getPrivatePrinter:@"P002"] copies:[self.printSetting getPrivateCopy:@"P002"]] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]
          parameters:nil
             success:^(AFHTTPRequestOperation *operation, id responseObject) {
                 
                 [AFNet.activeView stopAnimating];
                 if([responseObject[@"Code"] integerValue]==1){
                     [AFNet alertSuccess:responseObject[@"Content"]];
                     [self performSegueWithIdentifier:@"finishYun" sender:self];
                    
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
@end
