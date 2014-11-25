//
//  Login.m
//  Material
//
//  Created by wayne on 14-6-5.
//  Copyright (c) 2014年 brilliantech. All rights reserved.
//

#import "Login.h"
#import "KeychainItemWrapper.h"
#import "AFNetOperate.h"
#import "ScanStandard.h"
#import "PrinterSetting.h"
#import "SendAddress.h"

@interface Login ()<UITextFieldDelegate,CaptuvoEventsProtocol>
@property (weak, nonatomic) IBOutlet UITextField *email;
@property (weak, nonatomic) IBOutlet UITextField *password;
@property (weak, nonatomic) IBOutlet UIButton *loginButton;
- (IBAction)touchScreen:(id)sender;
- (IBAction)login:(id)sender;
@end

@implementation Login

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
    self.email.delegate=self;
    self.password.delegate=self;
    [[self navigationController] setNavigationBarHidden:YES animated:YES];
//    [PrinterSetting sharedPrinterSetting];
    // Do any additional setup after loading the view from its nib.
    
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    KeychainItemWrapper *keychain=[[KeychainItemWrapper alloc] initWithIdentifier:@"material"
                                                                      accessGroup:nil];
    if([keychain objectForKey:(__bridge id)kSecAttrAccount]){
        self.email.text=[keychain objectForKey:(__bridge id)kSecAttrAccount];
        
    }
     [[Captuvo sharedCaptuvoDevice] addCaptuvoDelegate:self];
//    [self.email becomeFirstResponder];
}
-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
//    [[Captuvo sharedCaptuvoDevice] stopDecoderHardware];
}
-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
     [[Captuvo sharedCaptuvoDevice] removeCaptuvoDelegate:self];
}
-(void)decoderDataReceived:(NSString *)data{
    if(data.length>0){
        self.email.text=data;
        [self.password becomeFirstResponder];
    }
}
//textField delegate
-(void)textFieldDidBeginEditing:(UITextField *)textField
{
    CGRect frame=textField.frame;
    int offset=frame.origin.y-150;
    NSTimeInterval animationDuration=0.30f;
    [UIView animateWithDuration:animationDuration
                     animations:^{
                         self.view.frame=CGRectMake(0, -offset, self.view.bounds.size.width, self.view.bounds.size.height);
                     }];
}
-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    [self.loginButton sendActionsForControlEvents:UIControlEventTouchUpInside];
    return YES;
}

- (IBAction)login:(id)sender {
//    [self loginSameAction:@"product"];
    
    NSString *email=self.email.text;
    NSString *password=self.password.text;
    KeychainItemWrapper *keychain=[[KeychainItemWrapper alloc] initWithIdentifier:@"material"
                                                                      accessGroup:nil];
    [keychain setObject:self.email.text forKey:(__bridge id)kSecAttrAccount];
    
    if(email.length>0){
        if(password.length>0){
            AFNetOperate *AFNet=[[AFNetOperate alloc] init];
            AFHTTPRequestOperationManager *manager=[AFNet generateManager:self.view];
            [manager POST:[AFNet log_in]
               parameters:@{@"user":@{@"id":email,@"password":password}}
                  success:^(AFHTTPRequestOperation *operation, id responseObject) {
                      [AFNet.activeView stopAnimating];
                      if([responseObject[@"result"] integerValue]==1){
                          NSString *requestCode=[NSString stringWithFormat:@"%@",responseObject[@"content"]];
                          if([requestCode isEqualToString:@"300"]){
                              [SendAddress sharedSendAddress];
                              [self loginSameAction:@"stock"];
                          }
                          else if([requestCode isEqualToString:@"400"]){
                              [self loginSameAction:@"shop"];
                          }
                          else if([requestCode isEqualToString:@"500"]){
                              [self loginSameAction:@"require"];
                          }
                          [ScanStandard sharedScanStandard];
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
            UIAlertView *alert=[[UIAlertView alloc] initWithTitle:@""
                                                          message:@"请填写密码"
                                                         delegate:self
                                                cancelButtonTitle:@"确定"
                                                otherButtonTitles:nil];
            [alert show];
        }
    }
    else{
        UIAlertView *alert=[[UIAlertView alloc] initWithTitle:@""
                                                      message:@"请填写用户名"
                                                     delegate:self
                                            cancelButtonTitle:@"确定"
                                            otherButtonTitles:nil];
        [alert show];
    }
    
    

}
-(void)loginSameAction:(NSString *)identifier
{
    UIStoryboard *storyboard=[UIStoryboard storyboardWithName:@"Storyboard" bundle:nil];
    UIViewController *tabbarStock=[[UIViewController alloc] init];
    if([identifier isEqualToString:@"product"]){
        tabbarStock=[storyboard instantiateViewControllerWithIdentifier:@"product"];
    }
    else{
        tabbarStock=[storyboard instantiateViewControllerWithIdentifier:identifier];
    }
    //写入用户信息
    NSString *number=self.email.text.length>0?self.email.text:@"default-example";
    NSArray *documentDictionary=NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *document=[documentDictionary firstObject];
    NSString *path=[document stringByAppendingPathComponent:@"user.info.archive"];
    [NSKeyedArchiver archiveRootObject:number toFile:path];
    
    [self presentViewController:tabbarStock
                       animated:YES
                     completion:nil];
}

- (IBAction)touchScreen:(id)sender {
    [self.email resignFirstResponder];
    [self.password resignFirstResponder];
    if(self.view.frame.origin.y!=0){
        NSTimeInterval animationDuration=0.30f;
        [UIView animateWithDuration:animationDuration
                         animations:^{
                             self.view.frame=CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height);
                         }];
    }
}
@end
