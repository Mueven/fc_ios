//
//  RequireHistoryViewController.m
//  Material
//
//  Created by wayne on 14-7-22.
//  Copyright (c) 2014年 brilliantech. All rights reserved.
//

#import "RequireHistoryViewController.h"

@interface RequireHistoryViewController ()<UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UITextField *dateTextField;
@property (strong,nonatomic)NSString *postDate;
- (IBAction)query:(id)sender;
- (IBAction)touchScreen:(id)sender;
@end

@implementation RequireHistoryViewController

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
                   action:@selector(updateDateTextField:)
         forControlEvents:UIControlEventValueChanged];
    datePicker.datePickerMode=UIDatePickerModeDate;
    [self.dateTextField setInputView:datePicker];
    self.postDate=[[NSString alloc] init];
}
-(void)updateDateTextField:(id)sender
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

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)query:(id)sender {
}

- (IBAction)touchScreen:(id)sender {
    [self.dateTextField resignFirstResponder];
}
@end
