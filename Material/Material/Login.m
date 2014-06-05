//
//  Login.m
//  Material
//
//  Created by wayne on 14-6-5.
//  Copyright (c) 2014年 brilliantech. All rights reserved.
//

#import "Login.h"
#import "KeychainItemWrapper.h"
#import "TuoTableViewController.h"
#import "YunTableViewController.h"
#import "SettingViewController.h"

@interface Login ()<UITextFieldDelegate>
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
//    KeychainItemWrapper *keychain=[[KeychainItemWrapper alloc] initWithIdentifier:@"material"
//                                                                      accessGroup:nil];
//    if([keychain objectForKey:(__bridge id)kSecAttrAccount]){
//        self.email.text=[keychain objectForKey:(__bridge id)kSecAttrAccount];
//    }
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
//    NSString *email=self.email.text;
//    NSString *password=self.password.text;
//    KeychainItemWrapper *keychain=[[KeychainItemWrapper alloc] initWithIdentifier:@"material"
//                                                                      accessGroup:nil];
//    [keychain setObject:self.email.text forKey:(__bridge id)kSecAttrAccount];
//    if([email isEqualToString:@"superxiao21@163.com"]&&[password isEqualToString:@"w"]){
    UIStoryboard *storyboard=[UIStoryboard storyboardWithName:@"Storyboard" bundle:nil];
    UITabBarController *tabbarStock=[storyboard instantiateViewControllerWithIdentifier:@"stock"];
    [self presentViewController:tabbarStock
                           animated:YES
                         completion:nil];
//    }
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
