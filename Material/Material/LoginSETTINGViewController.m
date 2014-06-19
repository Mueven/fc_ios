//
//  LoginSETTINGViewController.m
//  Material
//
//  Created by wayne on 14-6-16.
//  Copyright (c) 2014年 brilliantech. All rights reserved.
//

#import "LoginSETTINGViewController.h"

@interface LoginSETTINGViewController ()<UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UITextField *ipTextField;
@property (weak, nonatomic) IBOutlet UITextField *portTextField;
- (IBAction)saveChange:(id)sender;

@end

@implementation LoginSETTINGViewController

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
    self.ipTextField.delegate=self;
    self.portTextField.delegate=self;
     [[self navigationController] setNavigationBarHidden:NO animated:YES];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
//text field delegate
-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
//    [[Captuvo sharedCaptuvoDevice] stopDecoderHardware];
}
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    NSArray *documentDictionary=NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *document=[documentDictionary firstObject];
    NSString *path=[document stringByAppendingPathComponent:@"ip.address.archive"];
    if([NSKeyedUnarchiver unarchiveObjectWithFile:path]){
        NSDictionary *dictionary=[NSKeyedUnarchiver unarchiveObjectWithFile:path];
        self.ipTextField.text=[dictionary objectForKey:@"ip"];
        self.portTextField.text=[dictionary objectForKey:@"port"];
    }
    else{
        NSString *plistPath=[[NSBundle mainBundle] pathForResource:@"URL" ofType:@"plist"];
        NSMutableDictionary *URLDictionary=[[NSMutableDictionary alloc] initWithContentsOfFile:plistPath];
        self.ipTextField.text=[URLDictionary objectForKey:@"base"];
        self.portTextField.text=[URLDictionary objectForKey:@"port"];
    }
}
-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}

- (IBAction)saveChange:(id)sender {
    NSDictionary *dictionary=[NSDictionary dictionaryWithObjectsAndKeys:self.ipTextField.text,@"ip",self.portTextField.text,@"port", nil];
    NSArray *documentDictionary=NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *document=[documentDictionary firstObject];
    NSString *path=[document stringByAppendingPathComponent:@"ip.address.archive"];
    [NSKeyedArchiver archiveRootObject:dictionary toFile:path];
    [self.ipTextField resignFirstResponder];
    [self.portTextField resignFirstResponder];
    [self.navigationController popToRootViewControllerAnimated:YES];
}
@end
