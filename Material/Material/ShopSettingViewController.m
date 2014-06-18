//
//  ShopSettingViewController.m
//  Material
//
//  Created by wayne on 14-6-10.
//  Copyright (c) 2014年 brilliantech. All rights reserved.
//

#import "ShopSettingViewController.h"

@interface ShopSettingViewController ()
- (IBAction)logout:(id)sender;

@end

@implementation ShopSettingViewController

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
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [[Captuvo sharedCaptuvoDevice] stopDecoderHardware];
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

- (IBAction)logout:(id)sender {
//    AFNetOperate *AFNet=[[AFNetOperate alloc] init];
//    AFHTTPRequestOperationManager *manager=[AFNet generateManager:self.view];
//    [manager DELETE:[AFNet log_out]
//         parameters:nil
//            success:^(AFHTTPRequestOperation *operation, id responseObject) {
//                [AFNet.activeView stopAnimating];
//                if([responseObject[@"result"] integerValue]==1){
//                    [self dismissViewControllerAnimated:YES completion:nil];
//                }
//                else{
//                    [AFNet alert:responseObject[@"content"]];
//                }
//            }
//            failure:^(AFHTTPRequestOperation *operation, NSError *error) {
//                [AFNet.activeView stopAnimating];
//                [AFNet alert:@"sth wrong"];
//            }
//     ];

    [self dismissViewControllerAnimated:YES completion:nil];
}
@end
