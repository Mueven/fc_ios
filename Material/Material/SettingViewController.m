//
//  SettingViewController.m
//  Material
//
//  Created by wayne on 14-6-5.
//  Copyright (c) 2014年 brilliantech. All rights reserved.
//

#import "SettingViewController.h"
#import "Login.h"
#import "AFNetOperate.h"

@interface SettingViewController ()<UITextFieldDelegate,UIPickerViewDataSource,UIPickerViewDelegate>
- (IBAction)logOut:(id)sender;
@property (weak, nonatomic) IBOutlet UITextField *addressTextField;
@property (weak, nonatomic) IBOutlet UITextField *portTextField;
@property (weak, nonatomic) IBOutlet UITextField *typeTextField;
@property (strong , nonatomic) UIPickerView *typePicker;
@property (strong, nonatomic) NSArray *pickerElements;
- (IBAction)saveChange:(id)sender;
- (IBAction)touchScreen:(id)sender;
@end

@implementation SettingViewController

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
    // Do any additional setup after loading the view from its nib.
    self.navigationItem.title=@"账户设置";
    self.addressTextField.delegate=self;
    self.portTextField.delegate=self;
    self.typePicker=[[UIPickerView alloc] init];
    self.typePicker.delegate=self;
    self.typePicker.dataSource=self;
    self.typePicker.showsSelectionIndicator = YES;
    self.typeTextField.inputView=self.typePicker;
//    self.pickerElements = @[@"text1", @"text2", @"text3", @"text4"];
    
    
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    AFNetOperate *AFNet=[[AFNetOperate alloc] init];
    AFHTTPRequestOperationManager *manager=[AFNet generateManager:self.view];
    [manager GET:[AFNet print_model_list]
      parameters:nil
         success:^(AFHTTPRequestOperation *operation, id responseObject) {
             [AFNet.activeView stopAnimating];
             if([responseObject[@"result"] integerValue]==1){
                 self.pickerElements = responseObject[@"content"];
                 [self.typePicker reloadAllComponents];
             }
             else{
                 [AFNet alert:responseObject[@"content"]];
             }
         }
         failure:^(AFHTTPRequestOperation *operation, NSError *error) {
             [AFNet.activeView stopAnimating];
             [AFNet alert:[NSString stringWithFormat:@"%@",error.localizedDescription]];
         }
     ];
    NSArray *documentDictionary=NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *document=[documentDictionary firstObject];
    NSString *path=[document stringByAppendingPathComponent:@"print.ip.address.archive"];
    if([NSKeyedUnarchiver unarchiveObjectWithFile:path]){
        NSDictionary *dictionary=[NSKeyedUnarchiver unarchiveObjectWithFile:path];
        self.addressTextField.text=[dictionary objectForKey:@"print_ip"]?[dictionary objectForKey:@"print_ip"]:@"";
        self.portTextField.text=[dictionary objectForKey:@"print_port"]?[dictionary objectForKey:@"print_port"]:@"";
        self.typeTextField.text=[dictionary objectForKey:@"print_model"]?[dictionary objectForKey:@"print_model"]:@"";
    }
    else{
        NSString *plistPath=[[NSBundle mainBundle] pathForResource:@"URL" ofType:@"plist"];
        NSMutableDictionary *URLDictionary=[[NSMutableDictionary alloc] initWithContentsOfFile:plistPath];
        NSDictionary *printAddress=[URLDictionary objectForKey:@"print"];
        self.addressTextField.text=[printAddress objectForKey:@"base"];
        self.portTextField.text=[printAddress objectForKey:@"port"];
        self.typeTextField.text=@"";
    }
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
//    [[Captuvo sharedCaptuvoDevice] stopDecoderHardware];
}


- (IBAction)logOut:(id)sender {
    AFNetOperate *AFNet=[[AFNetOperate alloc] init];
    AFHTTPRequestOperationManager *manager=[AFNet generateManager:self.view];
    [manager DELETE:[AFNet log_out]
       parameters:nil
          success:^(AFHTTPRequestOperation *operation, id responseObject) {
              [AFNet.activeView stopAnimating];
              if([responseObject[@"result"] integerValue]==1){
                  [self dismissViewControllerAnimated:YES completion:nil];
              }
              else{
                  [AFNet alert:responseObject[@"content"]];
              }
          }
          failure:^(AFHTTPRequestOperation *operation, NSError *error) {
              [AFNet.activeView stopAnimating];
              [AFNet alert:[NSString stringWithFormat:@"%@",error.localizedDescription]];
          }
     ];
//    [self dismissViewControllerAnimated:YES completion:nil];
}
#pragma pick view delegate
- (int)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 1;
}

- (int)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    return [self.pickerElements count];
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    return [self.pickerElements objectAtIndex:row];
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    self.typeTextField.text = [self.pickerElements objectAtIndex:row];
}

- (IBAction)saveChange:(id)sender {
    NSDictionary *dictionary=[NSDictionary dictionaryWithObjectsAndKeys:self.addressTextField.text,@"print_ip",self.portTextField.text,@"print_port",self.typeTextField.text,@"print_model",nil];
    NSArray *documentDictionary=NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *document=[documentDictionary firstObject];
    NSString *path=[document stringByAppendingPathComponent:@"print.ip.address.archive"];
    [NSKeyedArchiver archiveRootObject:dictionary toFile:path];
    [self.addressTextField resignFirstResponder];
    [self.portTextField resignFirstResponder];
    [self.typeTextField resignFirstResponder];
    [self.navigationController popToRootViewControllerAnimated:YES];
}

- (IBAction)touchScreen:(id)sender {
    [self.addressTextField resignFirstResponder];
    [self.portTextField resignFirstResponder];
    [self.typeTextField resignFirstResponder];
}
@end
