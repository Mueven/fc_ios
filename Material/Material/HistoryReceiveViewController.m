//
//  HistoryReceiveViewController.m
//  Material
//
//  Created by wayne on 14-6-10.
//  Copyright (c) 2014年 brilliantech. All rights reserved.
//

#import "HistoryReceiveViewController.h"

@interface HistoryReceiveViewController ()
@property (weak, nonatomic) IBOutlet UITextField *dateTextField;
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
    UIDatePicker *datePicker=[[UIDatePicker alloc] init];
    [datePicker setDate:[NSDate date]];
    [datePicker addTarget:self
                   action:@selector(updateTextField:)
         forControlEvents:UIControlEventValueChanged];
    datePicker.datePickerMode=UIDatePickerModeDate;
    [self.dateTextField setInputView:datePicker];

}
-(void)updateTextField:(id)sender
{
    UIDatePicker *datePicker=(UIDatePicker *)self.dateTextField.inputView;
    NSDateFormatter *formatter=[[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-MM-dd"];
    self.dateTextField.text=[NSString stringWithFormat:@"%@",[formatter stringFromDate:datePicker.date]];
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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

- (IBAction)touchScreen:(id)sender {
    if([self.dateTextField isFirstResponder]){
            [self.dateTextField resignFirstResponder];
    }

}

- (IBAction)checkYun:(id)sender {
    [self performSegueWithIdentifier:@"checkYun" sender:self];
}
@end
