//
//  TuoBaseViewController.m
//  Material
//
//  Created by wayne on 14-6-6.
//  Copyright (c) 2014年 brilliantech. All rights reserved.
//

#import "TuoBaseViewController.h"
#import "TuoScanViewController.h"
#import "Tuo.h"
#import "AFNetOperate.h"

@interface TuoBaseViewController ()<UITextFieldDelegate,CaptuvoEventsProtocol>
- (IBAction)nextStep:(id)sender;
@property (weak, nonatomic) IBOutlet UITextField *department;
@property (weak, nonatomic) IBOutlet UITextField *agent;
@property (strong, nonatomic) UITextField *firstResponder;
@end

@implementation TuoBaseViewController

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
    self.department.delegate=self;
    self.agent.delegate=self;
    
}
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [[Captuvo sharedCaptuvoDevice] removeCaptuvoDelegate:self];
    [[Captuvo sharedCaptuvoDevice] addCaptuvoDelegate:self];
    [[Captuvo sharedCaptuvoDevice] startDecoderHardware];
    NSArray *documentDictionary=NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *document=[documentDictionary firstObject];
    NSString *path=[document stringByAppendingPathComponent:@"user.info.archive"];
    NSString *number=[NSKeyedUnarchiver unarchiveObjectWithFile:path];
    self.agent.text=number;
    [self.department becomeFirstResponder];
}
-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [self.firstResponder resignFirstResponder];
    self.firstResponder=nil;
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma decoder delegate
-(void)decoderDataReceived:(NSString *)data{
    self.firstResponder.text=data;
}
-(void)textFieldDidBeginEditing:(UITextField *)textField
{
    self.firstResponder=textField;
}
-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if([segue.identifier isEqualToString:@"tuoBaseToScan"]){
        TuoScanViewController *scanViewController=segue.destinationViewController;
        Tuo *tuo=[[Tuo alloc] init];
        tuo.department=self.department.text;
        tuo.agent=self.agent.text;
        NSDateFormatter *formatter=[[NSDateFormatter alloc] init];
        [formatter setDateFormat:@"yyyy.MM.dd"];
        tuo.date=[formatter stringFromDate:[NSDate date]];
        tuo.ID=[sender objectForKey:@"ID"];
        scanViewController.tuo=tuo;
        //tuoStore中也要加入
        
        scanViewController.type=@"tuo";
    }
    
}

- (IBAction)nextStep:(id)sender {
    NSString *department=self.department.text;
    NSString *agent=self.agent.text;
    if(department.length>0 && agent.length>0){
        [self baseToScan:department agent:agent];
    }
    else{
        UIAlertView *alert=[[UIAlertView alloc] initWithTitle:@"错误"
                                                      message:@"信息填写不完整"
                                                     delegate:self
                                            cancelButtonTitle:@"确定"
                                            otherButtonTitles:nil];
        [alert show];
    }
}
-(void)baseToScan:(NSString *)department agent:(NSString *)agent
{
    AFNetOperate *AFNet=[[AFNetOperate alloc] init];
    AFHTTPRequestOperationManager *manager=[AFNet generateManager:self.view];
    [manager POST:[AFNet tuo_root]
       parameters:@{@"forklift":@{
                            @"whouse_id":department,
                            @"user_id":agent
                            }}
          success:^(AFHTTPRequestOperation *operation, id responseObject) {
              [AFNet.activeView stopAnimating];
              if(responseObject[@"result"]){
                  [self performSegueWithIdentifier:@"tuoBaseToScan" sender:@{@"ID":responseObject[@"id"]}];
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
@end
