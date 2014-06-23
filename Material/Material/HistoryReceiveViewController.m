//
//  HistoryReceiveViewController.m
//  Material
//
//  Created by wayne on 14-6-10.
//  Copyright (c) 2014年 brilliantech. All rights reserved.
//

#import "HistoryReceiveViewController.h"
#import "AFNetOperate.h"
#import "Yun.h"
#import "HistoryYunTableViewController.h"

@interface HistoryReceiveViewController ()<UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UITextField *dateTextField;
@property(nonatomic,strong)NSString *postDate;
- (IBAction)touchScreen:(id)sender;
- (IBAction)checkYun:(id)sender;

@end

@implementation HistoryReceiveViewController

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
    self.dateTextField.delegate=self;
    UIDatePicker *datePicker=[[UIDatePicker alloc] init];
    [datePicker setDate:[NSDate date]];
    [datePicker addTarget:self
                   action:@selector(updateTextField:)
         forControlEvents:UIControlEventValueChanged];
    datePicker.datePickerMode=UIDatePickerModeDate;
    [self.dateTextField setInputView:datePicker];
    self.postDate=[[NSString alloc] init];
}
-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
//    [[Captuvo sharedCaptuvoDevice] stopDecoderHardware];
}
-(void)updateTextField:(id)sender
{
    UIDatePicker *datePicker=(UIDatePicker *)self.dateTextField.inputView;
    NSDateFormatter *formatter=[[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-MM-dd"];
    self.dateTextField.text=[NSString stringWithFormat:@"%@",[formatter stringFromDate:datePicker.date]];
    [formatter setDateFormat:@"yyyy-MM-dd'T'HH:mm:ssZZZZZ"];
    self.postDate=[NSString stringWithFormat:@"%@",[formatter stringFromDate:datePicker.date]];
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)textFieldDidBeginEditing:(UITextField *)textField
{
    if(textField.text.length==0){
        NSDateFormatter *formatter=[[NSDateFormatter alloc] init];
        [formatter setDateFormat:@"yyyy-MM-dd"];
        textField.text=[formatter stringFromDate:[NSDate date]];
        [formatter setDateFormat:@"yyyy-MM-dd'T'HH:mm:ssZZZZZ"];
        self.postDate=[formatter stringFromDate:[NSDate date]];
    }
    
}

#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    if([segue.identifier isEqualToString:@"checkYun"]){
        NSLog(@"%@ and %@",[sender objectForKey:@"yunArray"],[sender objectForKey:@"date"]);
        HistoryYunTableViewController *historyYun=segue.destinationViewController;
        historyYun.yunArray=[sender objectForKey:@"yunArray"];
        historyYun.chooseDate=[sender objectForKey:@"date"];
    }
}


- (IBAction)touchScreen:(id)sender {
    if([self.dateTextField isFirstResponder]){
        [self.dateTextField resignFirstResponder];
    }

}

- (IBAction)checkYun:(id)sender {
    if(self.dateTextField.text.length>0){
        AFNetOperate *AFNet=[[AFNetOperate alloc] init];
        AFHTTPRequestOperationManager *manager=[AFNet generateManager:self.view];
        [manager GET:[AFNet yun_received]
          parameters:@{@"receive_date":self.postDate}
             success:^(AFHTTPRequestOperation *operation, id responseObject) {
                 [AFNet.activeView stopAnimating];
                 if([responseObject[@"result"] integerValue]==1){
                     NSMutableArray *yunArray=[[NSMutableArray alloc] init];
                     NSArray *result=responseObject[@"content"];
                     for(int i=0;i<result.count;i++){
                         Yun *yunItem=[[Yun alloc] initWithObject:result[i]];
                         [yunArray addObject:yunItem];
                     }
                     NSLog(@"yunarray:%@,data:%@",yunArray,self.dateTextField.text);
                     [self performSegueWithIdentifier:@"checkYun" sender:@{
                                                                           @"yunArray":yunArray,
                                                                           @"date":self.dateTextField.text
                                                                           }
                      ];
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
    else{
        UIAlertView *alert=[[UIAlertView alloc] initWithTitle:@""
                                                      message:@"请选择日期"
                                                     delegate:self
                                            cancelButtonTitle:@"确定"
                                            otherButtonTitles:nil];
        [alert show];
    }
    
    
}
@end
