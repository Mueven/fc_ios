//
//  RequirePrintViewController.m
//  Material
//
//  Created by wayne on 14-7-22.
//  Copyright (c) 2014年 brilliantech. All rights reserved.
//

#import "RequirePrintViewController.h"

@interface RequirePrintViewController ()
- (IBAction)unPrint:(id)sender;
- (IBAction)print:(id)sender;
@end

@implementation RequirePrintViewController

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
    if([self.type isEqualToString:@"list"]){
        [self.navigationItem setHidesBackButton:YES];
    }
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

- (IBAction)unPrint:(id)sender {
    [self sameAction];
}

- (IBAction)print:(id)sender {
    [self sameAction];
}
-(void)sameAction
{
    if([self.type isEqualToString:@"list"]){
         [self performSegueWithIdentifier:@"unwindToRequireList" sender:self];
    }
    else if([self.type isEqualToString:@"detail"]){
        [self.navigationController popViewControllerAnimated:YES];
    }
   
}
@end
