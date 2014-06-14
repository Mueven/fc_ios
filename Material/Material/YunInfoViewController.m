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
#import "AFNetOperate.h"

@interface YunInfoViewController ()<UITextFieldDelegate,UIAlertViewDelegate>
@property (weak, nonatomic) IBOutlet UILabel *tuoCountLabel;
//@property (weak, nonatomic) IBOutlet UITextField *name;
@property (weak, nonatomic) IBOutlet UITextField *remark;
@property (strong,nonatomic) UIAlertView *printAlert;
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
//    self.name.delegate=self;
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
//    [self.name resignFirstResponder];
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
//    [self.name resignFirstResponder];
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
    AFNetOperate *AFNet=[[AFNetOperate alloc] init];
    AFHTTPRequestOperationManager *manager=[AFNet generateManager:self.view];
    NSMutableArray *tuoArrayID=[[NSMutableArray alloc] init];
    for(int i=0;i<self.yun.tuoArray.count;i++){
        [tuoArrayID addObject:[self.yun.tuoArray[i] ID]];
    }
    [manager POST:[AFNet yun_root]
       parameters:@{@"location_id":self.remark.text,@"forklifts":tuoArrayID}
          success:^(AFHTTPRequestOperation *operation, id responseObject) {
              [AFNet.activeView stopAnimating];
              if(responseObject[@"result"]){
                  self.yun.ID=[responseObject[@"content"] objectForKey:@"id"];
                  [self generateBelongs];
              }
              else{
                  [AFNet alert:responseObject[@"content"]];
              }
              
          }
          failure:^(AFHTTPRequestOperation *operation, NSError *error) {
              [AFNet.activeView stopAnimating];
              [AFNet alert:@"sth wrong"];
          }
     ];

//     [self generateBelongs];
    
//    NSString *name=self.name.text;
//    if(name.length>0){
//        self.yun.name=name;
//        NSDateFormatter *formatter=[[NSDateFormatter alloc] init];
//        [formatter setDateFormat:@"yyyy-MM-dd"];
//        self.yun.date=[formatter stringFromDate:[NSDate date]];
//        self.yun.remark=self.remark.text;
//        [self performSegueWithIdentifier:@"printYun" sender:self];
//    }
}
-(void)generateBelongs
{
    UIAlertView *alert=[[UIAlertView alloc] initWithTitle:@"发送运单"
                                                  message:@"是否发送运单"
                                                 delegate:self
                                        cancelButtonTitle:@"不发送"
                                        otherButtonTitles:@"发送", nil];
    [alert show];
}
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    //是否发送
    if(!self.printAlert){
        //发送运单
        if(buttonIndex==1){
            AFNetOperate *AFNet=[[AFNetOperate alloc] init];
            AFHTTPRequestOperationManager *manager=[AFNet generateManager:self.view];
            [manager POST:[AFNet yun_send]
               parameters:@{@"id":self.yun.ID}
                  success:^(AFHTTPRequestOperation *operation, id responseObject) {
                      [AFNet.activeView stopAnimating];
                      if(responseObject[@"result"]){
                          self.printAlert = [[UIAlertView alloc]initWithTitle:@"打印"
                                                                      message:@"要打印运单吗？"
                                                                     delegate:self
                                                            cancelButtonTitle:@"不打印"
                                                            otherButtonTitles:@"打印",nil];
                          [self.printAlert show];
                      }
                      else{
                          [AFNet alert:responseObject[@"content"]];
                      }
                      
                  }
                  failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                      [AFNet.activeView stopAnimating];
                      [AFNet alert:@"sth wrong"];
                  }
             ];

//            self.printAlert = [[UIAlertView alloc]initWithTitle:@"打 印"
//                                                        message:@"要打印运单吗？"
//                                                       delegate:self
//                                              cancelButtonTitle:@"不打印"
//                                              otherButtonTitles:@"打印",nil];
//            [self.printAlert show];
        }
        //不发送运单
        else{
            [self performSegueWithIdentifier:@"finishYun" sender:self];
        }
    }
    //是否打印运单
    else{
        //打印
        if(buttonIndex==1){
            
        }
        //不打印
        else{
            [self performSegueWithIdentifier:@"finishYun" sender:self];
        }
        self.printAlert=nil;
    }
}
@end
