//
//  RequireTraceViewController.m
//  Material
//
//  Created by wayne on 14-8-21.
//  Copyright (c) 2014年 brilliantech. All rights reserved.
//

#import "RequireTraceViewController.h"
#import "AFNetOperate.h"
#import "LED.h"
#import "RequireTraceDetailViewController.h"
#import "ScanStandard.h"
@interface RequireTraceViewController ()<UITextFieldDelegate,CaptuvoEventsProtocol>
@property (weak, nonatomic) IBOutlet UITextField *departmentTextField;
@property (weak, nonatomic) IBOutlet UITextField *partTextField;
@property (weak, nonatomic) IBOutlet UIButton *checkButton;
@property (strong, nonatomic) UITextField *firstResponder;
@property (strong,nonatomic)ScanStandard *scanStandard;
- (IBAction)touchScreen:(id)sender;
- (IBAction)check:(id)sender;
@end

@implementation RequireTraceViewController

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
    self.departmentTextField.delegate=self;
    self.partTextField.delegate=self;
    self.scanStandard=[ScanStandard sharedScanStandard];
    self.checkButton.hidden=NO;
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
    [self.firstResponder resignFirstResponder];
    self.firstResponder=nil;
}
-(void)decoderDataReceived:(NSString *)data
{
    self.firstResponder.text=data;
    if(self.firstResponder.tag==1){
        UITextField *nextTextField=(UITextField *)[self.view viewWithTag:2];
        nextTextField.text=@"";
        [nextTextField becomeFirstResponder];
    }
    else if(self.firstResponder.tag==2){
        [self check:self.checkButton];
    }
}
-(void)textFieldDidBeginEditing:(UITextField *)textField
{
    //UIView* dummyView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 1, 1)];
    //textField.inputView = dummyView;
    self.firstResponder=textField;
}
-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [self touchScreen:self];
    return YES;
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    if([segue.identifier isEqualToString:@"checkDetail"]){
        RequireTraceDetailViewController *traceDetail=segue.destinationViewController;
        traceDetail.LED=[sender objectForKey:@"LED"];
    }
}


- (IBAction)touchScreen:(id)sender {
    [self.departmentTextField resignFirstResponder];
    [self.partTextField resignFirstResponder];
    self.firstResponder=nil;
}

- (IBAction)check:(id)sender {
    NSString *department=self.departmentTextField.text;
    NSString *part=self.partTextField.text;
    if(department.length>0 && part.length>0){
        AFNetOperate *AFNet=[[AFNetOperate alloc] init];
        AFHTTPRequestOperationManager *manager=[AFNet generateManager:self.view];
        [manager GET:[AFNet order_led_position_state]
             parameters:@{
                          @"whouse":[self.scanStandard filterDepartment:department],
                          @"part_id":[self.scanStandard filterPartNumber:part]
                          }
                success:^(AFHTTPRequestOperation *operation, id responseObject) {
                    [AFNet.activeView stopAnimating];
                    if([responseObject[@"result"] integerValue]==1){
                        LED *led=[[LED alloc] initWithObject:responseObject[@"content"]];
                        [self performSegueWithIdentifier:@"checkDetail" sender:@{@"LED":led}];
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
    else{
        UIAlertView *alert=[[UIAlertView alloc] initWithTitle:@""
                                                      message:@"信息不完整"
                                                     delegate:self
                                            cancelButtonTitle:@"确定"
                                            otherButtonTitles: nil];
        [alert show];
    }
   
}
@end
