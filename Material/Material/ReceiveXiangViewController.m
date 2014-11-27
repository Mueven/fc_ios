//
//  ReceiveXiangViewController.m
//  Material
//
//  Created by wayne on 14-6-10.
//  Copyright (c) 2014年 brilliantech. All rights reserved.
//

#import "ReceiveXiangViewController.h"
#import "AFNetOperate.h"
#import "ReceivePrintViewController.h"
@interface ReceiveXiangViewController ()<UIAlertViewDelegate>
@property (weak, nonatomic) IBOutlet UILabel *keyLabel;
@property (weak, nonatomic) IBOutlet UILabel *partNumberLabel;
@property (weak, nonatomic) IBOutlet UILabel *quantityLabel;
@property (weak, nonatomic) IBOutlet UILabel *dateLabel;
- (IBAction)confirm:(id)sender;
- (IBAction)cancel:(id)sender;

@end

@implementation ReceiveXiangViewController
-(void)viewDidLoad
{
    [super viewDidLoad];
    self.keyLabel.adjustsFontSizeToFitWidth=YES;
    self.partNumberLabel.adjustsFontSizeToFitWidth=YES;
    self.quantityLabel.adjustsFontSizeToFitWidth=YES;
    self.dateLabel.adjustsFontSizeToFitWidth=YES;
    
    self.keyLabel.text=self.xiang.key;
    self.partNumberLabel.text=self.xiang.number;
    self.quantityLabel.text=self.xiang.count;
    self.dateLabel.text=self.xiang.date;

}

- (IBAction)confirm:(id)sender {
    UIAlertView *alert=[[UIAlertView alloc] initWithTitle:@""
                                                  message:@"确认收货？"
                                                 delegate:self
                                        cancelButtonTitle:@"取消"
                                        otherButtonTitles:@"确定", nil];
    [alert show];
}

- (IBAction)cancel:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if(buttonIndex==1){
        AFNetOperate *AFNet=[[AFNetOperate alloc] init];
        AFHTTPRequestOperationManager *manager=[AFNet generateManager:self.view];
        [manager POST:[AFNet xiang_confirm_receive]
           parameters:@{@"id":self.xiang.ID}
              success:^(AFHTTPRequestOperation *operation, id responseObject) {
                  [AFNet.activeView stopAnimating];
                  if([responseObject[@"result"] integerValue]==1){
                      [self performSegueWithIdentifier:@"print" sender:self];
                  }
                  else{
                      [AFNet alert:responseObject[@"content"]];
                  }
              }
              failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                  [AFNet.activeView stopAnimating];
                  [AFNet alert:[NSString stringWithFormat:@"%@",[error localizedDescription]]];
              }
         ];
    }
}
-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if([segue.identifier isEqualToString:@"print"]){
        ReceivePrintViewController *vc=segue.destinationViewController;
        vc.container=self.xiang;
        vc.type=@"xiang";
        vc.disableBack=YES;
    }
}
@end
