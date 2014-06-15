//
//  SettingViewController.m
//  Material
//
//  Created by wayne on 14-6-5.
//  Copyright (c) 2014年 brilliantech. All rights reserved.
//

#import "SettingViewController.h"
#import "Login.h"
#import "AFNetOperate.h"

@interface SettingViewController ()
- (IBAction)logOut:(id)sender;

@end

@implementation SettingViewController

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
    // Do any additional setup after loading the view from its nib.
    self.navigationItem.title=@"账户设置";
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (IBAction)logOut:(id)sender {
//    AFNetOperate *AFNet=[[AFNetOperate alloc] init];
//    AFHTTPRequestOperationManager *manager=[AFNet generateManager:self.view];
//    [manager DELETE:[AFNet log_out]
//       parameters:nil
//          success:^(AFHTTPRequestOperation *operation, id responseObject) {
//              [AFNet.activeView stopAnimating];
//              if(responseObject[@"result"]){
//                  [self dismissViewControllerAnimated:YES completion:nil];
//              }
//              else{
//                  [AFNet alert:responseObject[@"content"]];
//              }
//          }
//          failure:^(AFHTTPRequestOperation *operation, NSError *error) {
//              [AFNet.activeView stopAnimating];
//              [AFNet alert:@"sth wrong"];
//          }
//     ];
    [self dismissViewControllerAnimated:YES completion:nil];
}
@end
