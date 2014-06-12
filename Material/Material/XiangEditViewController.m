//
//  XiangEditViewController.m
//  Material
//
//  Created by wayne on 14-6-8.
//  Copyright (c) 2014年 brilliantech. All rights reserved.
//

#import "XiangEditViewController.h"
#import "AFNetOperate.h"

@interface XiangEditViewController ()<UITextFieldDelegate,CaptuvoEventsProtocol>
@property (weak, nonatomic) IBOutlet UITextField *key;
@property (weak, nonatomic) IBOutlet UITextField *partNumber;
@property (weak, nonatomic) IBOutlet UITextField *quantity;
@property (strong, nonatomic) UITextField *firstResponder;
- (IBAction)finishEdit:(id)sender;
@end

@implementation XiangEditViewController

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
    self.key.delegate=self;
    self.partNumber.delegate=self;
    self.quantity.delegate=self;
    self.key.text=self.xiang.key;
    self.partNumber.text=self.xiang.number;
    self.quantity.text=self.xiang.count;
    // Do any additional setup after loading the view.
    [[Captuvo sharedCaptuvoDevice] removeCaptuvoDelegate:self];
    [[Captuvo sharedCaptuvoDevice] addCaptuvoDelegate:self];
    [[Captuvo sharedCaptuvoDevice] startDecoderHardware];
}
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [[Captuvo sharedCaptuvoDevice] removeCaptuvoDelegate:self];
    [[Captuvo sharedCaptuvoDevice] addCaptuvoDelegate:self];
    [[Captuvo sharedCaptuvoDevice] startDecoderHardware];
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma decoder delegate
-(void)decoderReady
{
    
}
-(void)decoderDataReceived:(NSString *)data{
    AFNetOperate *AFNet=[[AFNetOperate alloc] init];
    AFHTTPRequestOperationManager *manager=[AFNet generateManager:self.view];
    [manager POST:@""
       parameters:nil
          success:^(AFHTTPRequestOperation *operation, id responseObject) {
              [AFNet.activeView stopAnimating];
              self.firstResponder.text=data;
              [self textFieldShouldReturn:self.firstResponder];
          }
          failure:^(AFHTTPRequestOperation *operation, NSError *error) {
              [AFNet.activeView stopAnimating];
          }
     ];
}
- (void)decoderRawDataReceived:(NSData *)data{
    
    
}
-(void)textFieldDidBeginEditing:(UITextField *)textField
{
    UIView* dummyView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 1, 1)];
    textField.inputView = dummyView;
    self.firstResponder=textField;
}

- (IBAction)finishEdit:(id)sender {
    self.xiang.key=self.key.text;
    self.xiang.number=self.partNumber.text;
    self.xiang.count=self.quantity.text;
    AFNetOperate *AFNet=[[AFNetOperate alloc] init];
    NSString *edit_address=[AFNet xiang_edit:self.xiang.ID];
//    AFHTTPRequestOperationManager *manager=[AFNet generateManager:self.view];
//    [manager PUT:[]
//      parameters:nil
//         success:^(AFHTTPRequestOperation *operation, id responseObject) {
//             
//         }
//         failure:^(AFHTTPRequestOperation *operation, NSError *error) {
//             
//         }
//     ];

    
    
    [self.navigationController popViewControllerAnimated:YES];
}
@end
