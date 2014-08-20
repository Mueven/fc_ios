//
//  ShopVerifyMoveViewController.m
//  Material
//
//  Created by wayne on 14-8-20.
//  Copyright (c) 2014年 brilliantech. All rights reserved.
//

#import "ShopVerifyMoveViewController.h"
#import "AFNetOperate.h"
#import "Tuo.h"

@interface ShopVerifyMoveViewController ()<UITextFieldDelegate,CaptuvoEventsProtocol,UIAlertViewDelegate>
@property (weak, nonatomic) IBOutlet UITextField *tuoTextField;
@property (weak, nonatomic) IBOutlet UIView *infoView;
@property (weak, nonatomic) IBOutlet UIButton *printButton;
@property (weak, nonatomic) IBOutlet UILabel *dateLabel;
@property (weak, nonatomic) IBOutlet UILabel *sumPackageLabel;
@property (weak, nonatomic) IBOutlet UILabel *checkPackageLabel;
@property (weak, nonatomic) IBOutlet UILabel *agentLabel;
@property (weak, nonatomic) IBOutlet UILabel *departmentLabel;
@property (weak, nonatomic) IBOutlet UITextField *pagesTextField;
@property (weak, nonatomic) IBOutlet UILabel *copiesLabel;
@property (nonatomic,strong)Tuo *tuo;
- (IBAction)print:(id)sender;
- (IBAction)clickScreen:(id)sender;
@end

@implementation ShopVerifyMoveViewController

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
    self.tuoTextField.delegate=self;
    self.pagesTextField.delegate=self;
    self.dateLabel.adjustsFontSizeToFitWidth=YES;
    self.sumPackageLabel.adjustsFontSizeToFitWidth=YES;
    self.checkPackageLabel.adjustsFontSizeToFitWidth=YES;
    self.agentLabel.adjustsFontSizeToFitWidth=YES;
    self.departmentLabel.adjustsFontSizeToFitWidth=YES;
    [self hideInfo];
}
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.tuoTextField becomeFirstResponder];
    [[Captuvo sharedCaptuvoDevice] addCaptuvoDelegate:self];
    self.pagesTextField.text=[[[AFNetOperate alloc] init] get_transfer_note_copy];
    
}
-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [[Captuvo sharedCaptuvoDevice] removeCaptuvoDelegate:self];
}
-(void)decoderDataReceived:(NSString *)data
{
    self.tuoTextField.text=data;
    AFNetOperate *AFNet=[[AFNetOperate alloc] init];
    AFHTTPRequestOperationManager *manager=[AFNet generateManager:self.view];
    [manager GET:[AFNet tuo_single]
      parameters:@{@"id":data}
         success:^(AFHTTPRequestOperation *operation, id responseObject) {
             [AFNet.activeView stopAnimating];
             if([responseObject[@"result"] integerValue]==1){
                 if([(NSDictionary *)responseObject[@"content"] count]>0){
                     NSDictionary *result=responseObject[@"content"];
                     self.tuo=[[Tuo alloc] initWithObject:result];
                     [self showInfo];
                     [self deliveryInfo];
                 }
                 
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
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)textFieldDidBeginEditing:(UITextField *)textField
{
    if(textField==self.tuoTextField){
        UIView *dummyView=[[UIView alloc] initWithFrame:CGRectMake(0, 0, 1, 1)];
        textField.inputView=dummyView;
    }
    else{
        CGRect frame=textField.frame;
        int offset=frame.origin.y-200;
        NSTimeInterval animationDuration=0.30f;
        [UIView animateWithDuration:animationDuration
                         animations:^{
                             self.view.frame=CGRectMake(0, -offset, self.view.bounds.size.width, self.view.bounds.size.height);
                         }];
    }
}
-(void)textFieldDidEndEditing:(UITextField *)textField
{
    if(textField==self.pagesTextField){
        NSTimeInterval animationDuration=0.30f;
        [UIView animateWithDuration:animationDuration
                         animations:^{
                             self.view.frame=CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height);
                         }];
    }
}
-(void)deliveryInfo
{
    NSRange range=NSMakeRange(0, 10);
    if([self.tuo.date substringWithRange:range]){
        self.dateLabel.text=[self.tuo.date substringWithRange:range];
    }
    else{
        self.dateLabel.text=self.tuo.date?self.tuo.date:@"";
    }
    self.sumPackageLabel.text=self.tuo.sum_packages?[NSString stringWithFormat:@"%d",self.tuo.sum_packages]:@"";
    self.checkPackageLabel.text=self.tuo.accepted_packages?[NSString stringWithFormat:@"%d",self.tuo.accepted_packages]:@"";
    self.agentLabel.text=self.tuo.agent?self.tuo.agent:@"";
    self.departmentLabel.text=self.tuo.department?self.tuo.department:@"";
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
-(void)hideInfo
{
    self.infoView.hidden=YES;
    self.printButton.hidden=YES;
    self.copiesLabel.hidden=YES;
    self.pagesTextField.hidden=YES;
}
-(void)showInfo
{
    self.infoView.hidden=NO;
    self.printButton.hidden=NO;
    self.copiesLabel.hidden=NO;
    self.pagesTextField.hidden=NO;
}
- (IBAction)print:(id)sender {
    UIAlertView *alert=[[UIAlertView alloc] initWithTitle:@""
                                                  message:@"打印该拖移库单？"
                                                 delegate:self
                                        cancelButtonTitle:@"取消"
                                        otherButtonTitles:@"打印", nil];
    [alert show];
}
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if(buttonIndex==1){
        AFNetOperate *AFNet=[[AFNetOperate alloc] init];
        AFHTTPRequestOperationManager *manager=[AFNet generateManager:self.view];
        [manager GET:[[AFNet print_transfer_note:self.tuo.ID printer_name:[AFNet get_current_print_model] copies:self.pagesTextField.text] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]
              parameters:nil
                 success:^(AFHTTPRequestOperation *operation, id responseObject) {
                     [AFNet.activeView stopAnimating];
                     if([responseObject[@"Code"] integerValue]==1){
                         [AFNet alertSuccess:responseObject[@"Content"]];
                         [AFNet set_transfer_note_copy:self.pagesTextField.text];
                     }
                     else{
                         [AFNet alert:responseObject[@"Content"]];
                     }
                 }
                 failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                     [AFNet.activeView stopAnimating];
                     [AFNet alert:[NSString stringWithFormat:@"%@",[error localizedDescription]]];
                 }
             ];
    }
}
- (IBAction)clickScreen:(id)sender {
    [self.pagesTextField resignFirstResponder];
}
@end
