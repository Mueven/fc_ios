//
//  StockEnterViewController.m
//  Material
//
//  Created by wayne on 15-1-22.
//  Copyright (c) 2015年 brilliantech. All rights reserved.
//

#import "StockEnterViewController.h"

@interface StockEnterViewController ()<UITextFieldDelegate,CaptuvoEventsProtocol>
@property (weak, nonatomic) IBOutlet UITextField *keyTextField;
@property (weak, nonatomic) IBOutlet UITextField *positionTextField;
@property (strong, nonatomic) UITextField *firstResponder;
@end

@implementation StockEnterViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [[Captuvo sharedCaptuvoDevice] addCaptuvoDelegate:self];
    [self.keyTextField becomeFirstResponder];
}
-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [[Captuvo sharedCaptuvoDevice] removeCaptuvoDelegate:self];
    [self.firstResponder resignFirstResponder];
    self.firstResponder=nil;
}
-(void)decoderDataReceived:(NSString *)data
{
    self.firstResponder.text=data;
    [self textFieldShouldReturn:self.firstResponder];
}
-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    int tag=textField.tag;
    tag++;
    if(tag>2){
        tag=1;
    }
    UITextField *nextTextField=(UITextField *)[self.view viewWithTag:tag];
    [nextTextField becomeFirstResponder];
    return YES;
}
-(void)textFieldDidBeginEditing:(UITextField *)textField
{
    UIView *dummy=[[UIView alloc] initWithFrame:CGRectMake(0, 0, 1, 1)];
    textField.inputView=dummy;
    self.firstResponder=textField;
}
@end
