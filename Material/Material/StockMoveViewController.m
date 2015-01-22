//
//  StockMoveViewController.m
//  Material
//
//  Created by wayne on 15-1-22.
//  Copyright (c) 2015年 brilliantech. All rights reserved.
//

#import "StockMoveViewController.h"
#import "DetailStockMoveViewController.h"
@interface StockMoveViewController ()<CaptuvoEventsProtocol>
@property (weak, nonatomic) IBOutlet UITextField *keyTextField;

@end

@implementation StockMoveViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self.keyTextField becomeFirstResponder];
}
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [[Captuvo sharedCaptuvoDevice] addCaptuvoDelegate:self];

}
-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [[Captuvo sharedCaptuvoDevice] removeCaptuvoDelegate:self];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)decoderDataReceived:(NSString *)data
{
    self.keyTextField.text=data;
}

#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    if([segue.identifier isEqualToString:@"detail"]){
        DetailStockMoveViewController *vc=segue.destinationViewController;
        
    }
}


@end
