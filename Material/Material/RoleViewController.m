//
//  RoleViewController.m
//  Material
//
//  Created by wayne on 14-11-21.
//  Copyright (c) 2014年 brilliantech. All rights reserved.
//

#import "RoleViewController.h"

@interface RoleViewController ()
- (IBAction)asRole1:(id)sender;
- (IBAction)asRole2:(id)sender;
- (IBAction)backOut:(id)sender;
@end

@implementation RoleViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    
}


- (IBAction)asRole1:(id)sender {
    [self performSegueWithIdentifier:@"in" sender:self];
}

- (IBAction)asRole2:(id)sender {
    [self performSegueWithIdentifier:@"out" sender:self];
}

- (IBAction)backOut:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}
@end
