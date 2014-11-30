//
//  StoragesMoveViewController.m
//  Material
//
//  Created by wayne on 14/11/30.
//  Copyright (c) 2014年 brilliantech. All rights reserved.
//

#import "StoragesMoveViewController.h"
#import "AFNetOperate.h"
#import <AudioToolbox/AudioToolbox.h>
@interface StoragesMoveViewController ()<CaptuvoEventsProtocol,UITextViewDelegate,UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UITextField *scanTextField;
@property (weak, nonatomic) IBOutlet UITextView *resultTextview;

@end

@implementation StoragesMoveViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.scanTextField.text=@"";
    self.resultTextview.text=@"";
    self.scanTextField.delegate=self;
    self.resultTextview.delegate=self;
    [self.scanTextField becomeFirstResponder];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)textFieldDidBeginEditing:(UITextField *)textField
{
    UIView *dummy=[[UIView alloc] initWithFrame:CGRectMake(0, 0, 1, 1)];
    textField.inputView=dummy;
}
-(void)decoderDataReceived:(NSString *)data
{
    AFNetOperate *AFNet=[[AFNetOperate alloc] init];
    AFHTTPRequestOperationManager *manager=[AFNet generateManager:self.view];
    [manager POST:[AFNet storages_move_store]
      parameters:@{@"id":data}
         success:^(AFHTTPRequestOperation *operation, id responseObject) {
             [AFNet.activeView stopAnimating];
             if([responseObject[@"result"] integerValue]==1){
                 AudioServicesPlaySystemSound(1012);
                 self.scanTextField.text=data;
                 self.resultTextview.text=responseObject[@"content"]; 
             }
             else{
                 AudioServicesPlaySystemSound(1051);
                 self.resultTextview.text=responseObject[@"content"];
             }
             
         }
         failure:^(AFHTTPRequestOperation *operation, NSError *error) {
             [AFNet.activeView stopAnimating];
             [AFNet alert:[NSString stringWithFormat:@"%@",[error localizedDescription]]];
         }
     ];

}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
