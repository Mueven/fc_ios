//
//  YunInfoViewController.m
//  Material
//
//  Created by wayne on 14-6-9.
//  Copyright (c) 2014年 brilliantech. All rights reserved.
//

#import "YunInfoViewController.h"
#import "Yun.h"
#import "PrintViewController.h"

@interface YunInfoViewController ()<UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UILabel *tuoCountLabel;
@property (weak, nonatomic) IBOutlet UITextField *name;
@property (weak, nonatomic) IBOutlet UITextField *remark;
- (IBAction)touchScreen:(id)sender;
- (IBAction)generateYun:(id)sender;

@end

@implementation YunInfoViewController

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
    self.name.delegate=self;
    self.remark.delegate=self;
}
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.tuoCountLabel.text=[NSString stringWithFormat:@"%d",[self.yun.tuoArray count]];
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//textField delegate
-(void)textFieldDidBeginEditing:(UITextField *)textField
{
    CGRect frame=textField.frame;
    int offset=frame.origin.y-100;
    NSTimeInterval animationDuration=0.30f;
    [UIView animateWithDuration:animationDuration
                     animations:^{
                         self.view.frame=CGRectMake(0, -offset, self.view.bounds.size.width, self.view.bounds.size.height);
                     }];
}
-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [self.name resignFirstResponder];
    [self.remark resignFirstResponder];
    if(self.view.frame.origin.y!=0){
        NSTimeInterval animationDuration=0.30f;
        [UIView animateWithDuration:animationDuration
                         animations:^{
                             self.view.frame=CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height);
                         }];
    }
    return YES;
}


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if([segue.identifier isEqualToString:@"printYun"]){
        PrintViewController *print=segue.destinationViewController;
        print.container=self.yun;
    }
}


- (IBAction)touchScreen:(id)sender {
    [self.name resignFirstResponder];
    [self.remark resignFirstResponder];
    if(self.view.frame.origin.y!=0){
        NSTimeInterval animationDuration=0.30f;
        [UIView animateWithDuration:animationDuration
                         animations:^{
                             self.view.frame=CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height);
                         }];
    }
}

- (IBAction)generateYun:(id)sender {
    NSString *name=self.name.text;
    if(name.length>0){
        self.yun.name=name;
        NSDateFormatter *formatter=[[NSDateFormatter alloc] init];
        [formatter setDateFormat:@"yyyy-MM-dd"];
        self.yun.date=[formatter stringFromDate:[NSDate date]];
        self.yun.remark=self.remark.text;
        [self performSegueWithIdentifier:@"printYun" sender:self];
    }
}
@end
