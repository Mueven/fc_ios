//
//  ShopSettingViewController.m
//  Material
//
//  Created by wayne on 14-6-10.
//  Copyright (c) 2014年 brilliantech. All rights reserved.
//

#import "ShopSettingViewController.h"
#import "AFNetOperate.h"
#import "PrinterSetting.h"

@interface ShopSettingViewController ()<UITextFieldDelegate,UIPickerViewDataSource,UIPickerViewDelegate>
- (IBAction)logout:(id)sender;
@property (weak, nonatomic) IBOutlet UITextField *addressTextField;
@property (weak, nonatomic) IBOutlet UITextField *portTextField;
- (IBAction)saveChange:(id)sender;
- (IBAction)touchScreen:(id)sender;
- (IBAction)resetPrint:(id)sender;
@property (weak, nonatomic) IBOutlet UITextField *typeTextField;
@property (strong , nonatomic) UIPickerView *typePicker;
@property (strong, nonatomic) NSArray *pickerElements;
@property (strong,nonatomic)PrinterSetting *printerSetting;
@end

@implementation ShopSettingViewController

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
    // Do any additional setup after loading the view.
    self.addressTextField.delegate=self;
    self.portTextField.delegate=self;
    self.typePicker=[[UIPickerView alloc] init];
    self.typePicker.delegate=self;
    self.typePicker.dataSource=self;
    self.typePicker.showsSelectionIndicator = YES;
    self.typeTextField.inputView=self.typePicker;
    self.printerSetting=[PrinterSetting sharedPrinterSetting];
    
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

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    NSArray *documentDictionary=NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *document=[documentDictionary firstObject];
    NSString *path=[document stringByAppendingPathComponent:@"print.ip.address.archive"];
    if([NSKeyedUnarchiver unarchiveObjectWithFile:path]){
        NSDictionary *dictionary=[NSKeyedUnarchiver unarchiveObjectWithFile:path];
        self.addressTextField.text=[dictionary objectForKey:@"print_ip"];
        self.portTextField.text=[dictionary objectForKey:@"print_port"];
    }
    else{
        NSString *plistPath=[[NSBundle mainBundle] pathForResource:@"URL" ofType:@"plist"];
        NSMutableDictionary *URLDictionary=[[NSMutableDictionary alloc] initWithContentsOfFile:plistPath];
        NSDictionary *printAddress=[URLDictionary objectForKey:@"print"];
        self.addressTextField.text=[printAddress objectForKey:@"base"];
        self.portTextField.text=[printAddress objectForKey:@"port"];
    }
     self.typeTextField.text=[self.printerSetting getPrinterModel];
    self.pickerElements = [self.printerSetting get_all_printer_model];
    [self.typePicker reloadAllComponents];
}
-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
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
- (IBAction)logout:(id)sender {
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
}
- (IBAction)saveChange:(id)sender {
    NSDictionary *dictionary=[NSDictionary dictionaryWithObjectsAndKeys:self.addressTextField.text,@"print_ip",self.portTextField.text,@"print_port",nil];
    NSArray *documentDictionary=NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *document=[documentDictionary firstObject];
    NSString *path=[document stringByAppendingPathComponent:@"print.ip.address.archive"];
    [NSKeyedArchiver archiveRootObject:dictionary toFile:path];
    if(self.typeTextField.text.length>0){
        [self.printerSetting setPrinterModel:self.typeTextField.text];
    }
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

- (IBAction)resetPrint:(id)sender {
    [self.printerSetting resetPrinterModel];
    self.typeTextField.text=@"";
}
@end
