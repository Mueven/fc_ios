//
//  ReceivePrintViewController.m
//  Material
//
//  Created by wayne on 14-6-19.
//  Copyright (c) 2014年 brilliantech. All rights reserved.
//

#import "ReceivePrintViewController.h"
#import "AFNetOperate.h"
#import "PrinterSetting.h"
#import "Xiang.h"
#import "Tuo.h"
#import "Yun.h"
@interface ReceivePrintViewController ()<UITextFieldDelegate>
- (IBAction)printUncheck:(id)sender;
- (IBAction)print:(id)sender;
- (IBAction)finishOver:(id)sender;
@property (weak, nonatomic) IBOutlet UILabel *printModelLabel;
@property (weak, nonatomic) IBOutlet UITextField *yunCopyTextField;
@property (weak, nonatomic) IBOutlet UITextField *uncheckYunCopyTextField;
@property (strong,nonatomic)PrinterSetting *printSetting;
@property (strong,nonatomic)NSString *container_id;
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
    self.yunCopyTextField.delegate=self;
    self.uncheckYunCopyTextField.delegate=self;
    if(self.disableBack){
        [self.navigationItem setHidesBackButton:YES];
    }
    
    NSString *class=[NSString stringWithFormat:@"%@",[self.container class]];
    if([class isEqualToString:@"Xiang"]){
        self.container_id=[(Xiang *)self.container ID];
        self.printModelLabel.text=[self.printSetting getPrinterModelWithAlternative:@"P005"];
        self.yunCopyTextField.text=[self.printSetting getCopy:@"shop_receive" type:@"xiang" alternative:@"P005"];
        self.uncheckYunCopyTextField.text=[self.printSetting getCopy:@"shop_unreceive" type:@"xiang" alternative:@"P004"];
    }
    else if([class isEqualToString:@"Tuo"]){
        self.container_id=[(Tuo *)self.container ID];
        self.printModelLabel.text=[self.printSetting getPrinterModelWithAlternative:@"P005"];
        self.yunCopyTextField.text=[self.printSetting getCopy:@"shop_receive" type:@"tuo" alternative:@"P005"];
        self.uncheckYunCopyTextField.text=[self.printSetting getCopy:@"shop_unreceive" type:@"tuo" alternative:@"P004"];
    }
    else if([class isEqualToString:@"Yun"]){
        self.container_id=[(Yun *)self.container ID];
        self.printModelLabel.text=[self.printSetting getPrinterModelWithAlternative:@"P003"];
        self.yunCopyTextField.text=[self.printSetting getCopy:@"shop_receive" type:@"yun" alternative:@"P003"];
        self.uncheckYunCopyTextField.text=[self.printSetting getCopy:@"shop_unreceive" type:@"yun" alternative:@"P004"];
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
        if(textField.tag==1){
            //确认单
            [self setCopy:textField.text type:class receiveOrUnreceive:@"shop_receive"];
        }
        else if(textField.tag==2){
            //未确认单
            [self setCopy:textField.text type:class receiveOrUnreceive:@"shop_unreceive"];;
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
     NSString *class=[NSString stringWithFormat:@"%@",[self.container class]];
     [self setCopy:textField.text type:class receiveOrUnreceive:@"shop_receive"];
    
    AFNetOperate *AFNet=[[AFNetOperate alloc] init];
    AFHTTPRequestOperationManager *manager=[AFNet generateManager:self.view];
    [manager GET:[self print:AFNet class:class receiveOrUnreceive:YES]
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
    NSString *class=[NSString stringWithFormat:@"%@",[self.container class]];
    [self setCopy:textField.text type:class receiveOrUnreceive:@"shop_unreceive"];
    
    AFNetOperate *AFNet=[[AFNetOperate alloc] init];
    AFHTTPRequestOperationManager *manager=[AFNet generateManager:self.view];
    [manager GET:[self print:AFNet class:class receiveOrUnreceive:NO]
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
    NSPredicate * pred= [NSPredicate predicateWithFormat:@"SELF MATCHES %@", @"history.*"];
    BOOL isMatch  = [pred evaluateWithObject:self.type];
   
    if(isMatch){
        [self.navigationController popViewControllerAnimated:YES];
    }
    else{
        [self performSegueWithIdentifier:@"unwindToReceive" sender:self];
    }    
}
- (IBAction)clickScreen:(id)sender {
    [self.yunCopyTextField resignFirstResponder];
    [self.uncheckYunCopyTextField resignFirstResponder];
}
-(void)setCopy:(NSString *)copies type:(NSString *)type receiveOrUnreceive:(NSString *)choose{
    if([type isEqualToString:@"Xiang"]){
      [self.printSetting setCopy:choose type:@"xiang" copies:copies];
    }
    else if([type isEqualToString:@"Tuo"]){
      [self.printSetting setCopy:choose type:@"tuo" copies:copies];
    }
    else if([type isEqualToString:@"Yun"]){
      [self.printSetting setCopy:choose type:@"yun" copies:copies];
    }
}
-(NSString *)print:(AFNetOperate *)AFNet class:(NSString *)class receiveOrUnreceive:(BOOL)receive
{
    NSString *result=[NSString string];
    if([class isEqualToString:@"Xiang"]){
        if(receive){
            result=[[AFNet print_shop_xiang_receive:self.container_id
                                     printer_name:[self.printSetting getPrinterModelWithAlternative:@"P005"]
                                           copies:[self.printSetting getCopy:@"shop_receive" type:@"xiang" alternative:@"P005"]] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        }
        else{
            result=[[AFNet print_shop_xiang_unreceive:self.container_id
                                       printer_name:[self.printSetting getPrinterModelWithAlternative:@"P004"]
                                             copies:[self.printSetting getCopy:@"shop_unreceive" type:@"xiang" alternative:@"P004"]] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        }
    }
    else if([class isEqualToString:@"Tuo"]){
        if(receive){
            result=[[AFNet print_shop_tuo_receive:self.container_id
                                     printer_name:[self.printSetting getPrinterModelWithAlternative:@"P005"]
                                           copies:[self.printSetting getCopy:@"shop_receive" type:@"tuo" alternative:@"P005"]] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        }
        else{
            result=[[AFNet print_shop_tuo_unreceive:self.container_id
                                       printer_name:[self.printSetting getPrinterModelWithAlternative:@"P004"]
                                             copies:[self.printSetting getCopy:@"shop_unreceive" type:@"tuo" alternative:@"P004"]] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        }
      
    }
    else if([class isEqualToString:@"Yun"]){
        if(receive){
            result=[[AFNet print_shop_yun_receive:self.container_id
                          printer_name:[self.printSetting getPrinterModelWithAlternative:@"P003"]
                                    copies:[self.printSetting getCopy:@"shop_receive" type:@"yun" alternative:@"P003"]] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        }
        else{
            result=[[AFNet print_shop_yun_unreceive:self.container_id
                                     printer_name:[self.printSetting getPrinterModelWithAlternative:@"P004"]
                                           copies:[self.printSetting getCopy:@"shop_unreceive" type:@"yun" alternative:@"P004"]] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        }

    }
    return result;
}
@end
