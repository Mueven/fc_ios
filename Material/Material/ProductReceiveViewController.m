//
//  ProductReceiveViewController.m
//  Material
//
//  Created by wayne on 14-11-21.
//  Copyright (c) 2014年 brilliantech. All rights reserved.
//

#import "ProductReceiveViewController.h"
#import "AFNetOperate.h"
#import "ProductReceiveXiangViewController.h"
#import "ProductReceiveTuoViewController.h"
@interface ProductReceiveViewController ()<UITextFieldDelegate,CaptuvoEventsProtocol>
@property (weak, nonatomic) IBOutlet UITextField *scanTextField;
- (IBAction)xiangClick:(id)sender;
- (IBAction)tuoClick:(id)sender;

@end

@implementation ProductReceiveViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.scanTextField.delegate=self;
}
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [[Captuvo sharedCaptuvoDevice] addCaptuvoDelegate:self];
    [self.scanTextField becomeFirstResponder];
}
-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [[Captuvo sharedCaptuvoDevice] removeCaptuvoDelegate:self];
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)decoderDataReceived:(NSString *)data
{
    self.scanTextField.text=data;
}
-(void)textFieldDidBeginEditing:(UITextField *)textField
{
    UIView *dummyView=[[UIView alloc] initWithFrame:CGRectMake(0, 0, 1, 1)];
    textField.inputView=dummyView;
 
}

#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    if([segue.identifier isEqualToString:@"xiang"]){
        ProductReceiveXiangViewController *xiangVC=segue.destinationViewController;
        xiangVC.xiang=[sender objectForKey:@"xiang"];
    }
    else if([segue.identifier isEqualToString:@"tuo"]){
        ProductReceiveTuoViewController *tuoVC=segue.destinationViewController;
        tuoVC.tuo=[sender objectForKey:@"tuo"];
    }
}


- (IBAction)xiangClick:(id)sender {
    [self performSegueWithIdentifier:@"xiang" sender:self];
}

- (IBAction)tuoClick:(id)sender {
    [self performSegueWithIdentifier:@"tuo" sender:self];
}
@end
