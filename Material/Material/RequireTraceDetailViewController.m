//
//  RequireTraceDetailViewController.m
//  Material
//
//  Created by wayne on 14-8-21.
//  Copyright (c) 2014年 brilliantech. All rights reserved.
//

#import "RequireTraceDetailViewController.h"
#import "DrawLight.h"
#import "AFNetOperate.h"
@interface RequireTraceDetailViewController ()
- (IBAction)finishCheck:(id)sender;
@property (weak, nonatomic) IBOutlet UILabel *positionLabel;
@property (weak, nonatomic) IBOutlet UILabel *dateLastLabel;
@property (weak, nonatomic) IBOutlet UILabel *dateCurrentLabel;
@property (weak, nonatomic) IBOutlet UILabel *sumLabel;
@property (weak, nonatomic) IBOutlet UILabel *receiveLabel;
@property (weak, nonatomic) IBOutlet UILabel *unreceiveLabel;
@property (strong,nonatomic)DrawLight *graphView;
- (IBAction)reset:(id)sender;
@property (weak, nonatomic) IBOutlet UIButton *resetButton;
@end

@implementation RequireTraceDetailViewController

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
}
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.positionLabel.text=self.LED.position;
    self.dateCurrentLabel.text=self.LED.beginDate;
    self.dateLastLabel.text=self.LED.endDate;
    self.sumLabel.text=[NSString stringWithFormat:@"%d",self.LED.requirement];
    self.receiveLabel.text=[NSString stringWithFormat:@"%d",self.LED.received];
    self.unreceiveLabel.text=[NSString stringWithFormat:@"%d",self.LED.absent];
     [self resetButtonState];
}
-(void)loadView
{
    [super loadView];
    CGRect graphFrame=CGRectMake(33, 328, 253, 130);
    self.graphView=[[DrawLight alloc] initWithFrame:graphFrame state:self.LED.state];
    self.graphView.backgroundColor=[UIColor clearColor];
    [self.view addSubview:self.graphView];
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)finishCheck:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}
- (IBAction)reset:(id)sender {
    AFNetOperate *AFNet=[[AFNetOperate alloc] init];
    AFHTTPRequestOperationManager *manager=[AFNet generateManager:self.view];
    [manager POST:[AFNet order_led_reset]
      parameters:@{
                   @"position":self.LED.position,
                   @"state":@0
                   }
         success:^(AFHTTPRequestOperation *operation, id responseObject) {
             [AFNet.activeView stopAnimating];
             if([responseObject[@"result"] integerValue]==1){
                 [self resetLed];
             }
             else{
                 [AFNet alert:responseObject[@"content"]];
             }
         }
         failure:^(AFHTTPRequestOperation *operation, NSError *error) {
             [AFNet.activeView stopAnimating];
             [AFNet alert:[NSString stringWithFormat:@"%@",[error localizedDescription]]];
         }
     ];
}
-(void)resetLed
{
    [self.graphView removeFromSuperview];
    self.graphView=nil;
    CGRect graphFrame=CGRectMake(33, 328, 253, 130);
    self.graphView=[[DrawLight alloc] initWithFrame:graphFrame state:0];
    self.graphView.backgroundColor=[UIColor clearColor];
    [self.view addSubview:self.graphView];
    self.LED.state=0;
    [self resetButtonState];
}
-(void)resetButtonState
{
    if(self.LED.state==0){
        self.resetButton.backgroundColor=[UIColor colorWithRed:239.0/255.0 green:239.0/255.0 blue:244.0/255.0 alpha:1.0];
        self.resetButton.enabled=NO;
    }
    else{
        self.resetButton.backgroundColor=[UIColor colorWithRed:248.0/255.0 green:94.0/255.0 blue:100.0/255.0 alpha:1.0];
        self.resetButton.enabled=YES;
    }
}
@end
