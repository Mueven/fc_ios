//
//  ReceivePrintViewController.m
//  Material
//
//  Created by wayne on 14-6-19.
//  Copyright (c) 2014年 brilliantech. All rights reserved.
//

#import "ReceivePrintViewController.h"
#import "AFNetOperate.h"
#import "Yun.h"
#import "PrinterSetting.h"
@interface ReceivePrintViewController ()<UITextFieldDelegate>
- (IBAction)printUncheck:(id)sender;
- (IBAction)print:(id)sender;
- (IBAction)finishOver:(id)sender;
@property (weak, nonatomic) IBOutlet UILabel *printModelLabel;
@property (weak, nonatomic) IBOutlet UITextField *yunCopyTextField;
@property (weak, nonatomic) IBOutlet UITextField *uncheckYunCopyTextField;
@property (strong,nonatomic)PrinterSetting *printSetting;
- (IBAction)clickScreen:(id)sender;

@end

@implementation ReceivePrintViewController

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
        self.printSetting=[PrinterSetting sharedPrinterSetting];
    // Do any additional setup after loading the view.
    [self.navigationItem setHidesBackButton:YES];
    self.printModelLabel.adjustsFontSizeToFitWidth=YES;
    self.printModelLabel.text=[self.printSetting getPrivatePrinter:@"P003"];
    self.yunCopyTextField.delegate=self;
    self.uncheckYunCopyTextField.delegate=self;

    self.yunCopyTextField.text=[self.printSetting getPrivateCopy:@"P003"];
    self.uncheckYunCopyTextField.text=[self.printSetting getPrivateCopy:@"P004"];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)textFieldDidEndEditing:(UITextField *)textField
{
    if(textField.text.length>0){
        if(textField.tag==1){
            //确认单
            [self.printSetting setPrivateCopy:@"P003" copies:textField.text];
        }
        else if(textField.tag==2){
            //未确认单
            [self.printSetting setPrivateCopy:@"P004" copies:textField.text];
        }
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
- (IBAction)print:(id)sender {
    UITextField *textField=(UITextField *)[self.view viewWithTag:1];
    [self.printSetting setPrivateCopy:@"P003" copies:textField.text];
    AFNetOperate *AFNet=[[AFNetOperate alloc] init];
    AFHTTPRequestOperationManager *manager=[AFNet generateManager:self.view];
    [manager GET:[[AFNet print_shop_receive:self.yun.ID printer_name:[self.printSetting getPrivatePrinter:@"P003"] copies:[self.printSetting getPrivateCopy:@"P003"]] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]
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
- (IBAction)printUncheck:(id)sender {
    UITextField *textField=(UITextField *)[self.view viewWithTag:2];
    [self.printSetting setPrivateCopy:@"P004" copies:textField.text];
    AFNetOperate *AFNet=[[AFNetOperate alloc] init];
    AFHTTPRequestOperationManager *manager=[AFNet generateManager:self.view];
    [manager GET:[[AFNet print_shop_unreceive:self.yun.ID printer_name:[self.printSetting getPrivatePrinter:@"P004"] copies:[self.printSetting getPrivateCopy:@"P004"]] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]
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
- (IBAction)finishOver:(id)sender {
    if([self.type isEqualToString:@"receive"]){
        [self performSegueWithIdentifier:@"unwindToReceive" sender:self];
    }
    else if([self.type isEqualToString:@"history"]){
        [self.navigationController popViewControllerAnimated:YES];
    }
    
}
- (IBAction)clickScreen:(id)sender {
    [self.yunCopyTextField resignFirstResponder];
    [self.uncheckYunCopyTextField resignFirstResponder];
}
@end
