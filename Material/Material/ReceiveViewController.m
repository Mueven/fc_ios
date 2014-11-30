//
//  ReceiveViewController.m
//  Material
//
//  Created by wayne on 14-11-26.
//  Copyright (c) 2014年 brilliantech. All rights reserved.
//

#import "ReceiveViewController.h"
#import "ReceiveXiangViewController.h"
#import "ReceiveTuoViewController.h"
#import "ReceiveYunViewController.h"

@interface ReceiveViewController ()<CaptuvoEventsProtocol,UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UITextField *scanTextField;
- (IBAction)test:(id)sender;
@end

@implementation ReceiveViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.scanTextField.delegate=self;
    [self.scanTextField becomeFirstResponder];
}
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [[Captuvo sharedCaptuvoDevice] addCaptuvoDelegate:self];
}
-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [[Captuvo sharedCaptuvoDevice] removeCaptuvoDelegate:self];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)textFieldDidBeginEditing:(UITextField *)textField
{
    UIView *dummy=[[UIView alloc] initWithFrame:CGRectMake(0, 0, 1, 1)];
    textField.inputView=dummy;
}
-(void)decoderDataReceived:(NSString *)data
{
    self.scanTextField.text=data;
    //扫描到对应的号码时应该去触发receive
}

#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    if([segue.identifier isEqualToString:@"receiveXiang"]){
        
    }
    else if([segue.identifier isEqualToString:@"receiveTuo"]){
        ReceiveTuoViewController *vc=segue.destinationViewController;
        vc.enableCancel=YES;
        vc.enableConfirm=YES;
        
    }
    else if([segue.identifier isEqualToString:@"receiveYun"]){
        
    }
}


- (IBAction)test:(id)sender {
    [self performSegueWithIdentifier:@"receiveTuo" sender:self];
}
@end
