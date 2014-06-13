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

@property (weak, nonatomic) IBOutlet UILabel *keyLabel;
@property (weak, nonatomic) IBOutlet UITextField *partNumber;
@property (weak, nonatomic) IBOutlet UITextField *quantity;
@property (weak, nonatomic) IBOutlet UITextField *dateTextField;
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
    
    self.partNumber.delegate=self;
    self.quantity.delegate=self;
    self.dateTextField.delegate=self;
    
    self.keyLabel.text=self.xiang.key;
    self.partNumber.text=self.xiang.number;
    self.quantity.text=self.xiang.count;
    self.dateTextField.text=self.xiang.date;
    
    self.keyLabel.adjustsFontSizeToFitWidth=YES;
    // Do any additional setup after loading the view.
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
-(void)decoderDataReceived:(NSString *)data{
    if(self.firstResponder.tag==4){
        self.firstResponder.text=data;
        [self textFieldShouldReturn:self.firstResponder];
    }
    else{
        AFNetOperate *AFNet=[[AFNetOperate alloc] init];
        AFHTTPRequestOperationManager *manager=[AFNet generateManager:self.view];
        NSString *address=[[NSString alloc] init];
        switch (self.firstResponder.tag){
            case 2:
                address=[AFNet part_validate];
                break;
            case 3:
                address=@"still waiting";
                break;
        }
        [manager POST:address
           parameters:@{data:data}
              success:^(AFHTTPRequestOperation *operation, id responseObject) {
                  [AFNet.activeView stopAnimating];
                  if(responseObject[@"result"]){
                      self.firstResponder.text=data;
                      [self textFieldShouldReturn:self.firstResponder];
                  }
                  else{
                      [AFNet alert:responseObject[@"content"]];
                  }
                  
              }
              failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                  [AFNet.activeView stopAnimating];
              }
         ];
    }

}
-(void)textFieldDidBeginEditing:(UITextField *)textField
{
    UIView* dummyView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 1, 1)];
    textField.inputView = dummyView;
    self.firstResponder=textField;
}
-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    return YES;
}

- (IBAction)finishEdit:(id)sender {
    
    AFNetOperate *AFNet=[[AFNetOperate alloc] init];
    NSString *edit_address=[AFNet xiang_edit:self.xiang.ID];
    AFHTTPRequestOperationManager *manager=[AFNet generateManager:self.view];
    [manager PUT:edit_address
      parameters:@{@"package":@{
                           @"part_id":self.partNumber.text,
                           @"quantity":self.quantity.text,
                           @"date":self.dateTextField.text
                           }}
         success:^(AFHTTPRequestOperation *operation, id responseObject) {
             [AFNet.activeView stopAnimating];
             if(responseObject[@"result"]){
                 self.xiang.date=self.dateTextField.text;
                 self.xiang.number=self.partNumber.text;
                 self.xiang.count=self.quantity.text;
                 [self.navigationController popViewControllerAnimated:YES];
             }
             else{
                 [AFNet alert:responseObject[@"content"]];
             }
         }
         failure:^(AFHTTPRequestOperation *operation, NSError *error) {
             [AFNet.activeView stopAnimating];
             [AFNet alert:@"sth wrong"];
         }
     ];
}
@end
