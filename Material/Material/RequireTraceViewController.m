//
//  RequireTraceViewController.m
//  Material
//
//  Created by wayne on 14-8-21.
//  Copyright (c) 2014年 brilliantech. All rights reserved.
//

#import "RequireTraceViewController.h"

@interface RequireTraceViewController ()<UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UITextField *partTextField;
@property (weak, nonatomic) IBOutlet UIButton *checkButton;
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
    self.partTextField.delegate=self;
    self.checkButton.hidden=NO;
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

- (IBAction)check:(id)sender {
    [self performSegueWithIdentifier:@"checkDetail" sender:self];
}
@end
