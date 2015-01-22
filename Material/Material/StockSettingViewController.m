//
//  StockSettingViewController.m
//  Material
//
//  Created by wayne on 15-1-22.
//  Copyright (c) 2015年 brilliantech. All rights reserved.
//

#import "StockSettingViewController.h"

@interface StockSettingViewController ()
- (IBAction)logout:(id)sender;

@end

@implementation StockSettingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)logout:(id)sender {
    [self.navigationController popToRootViewControllerAnimated:YES];
}
@end
