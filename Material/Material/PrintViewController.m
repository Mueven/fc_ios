//
//  PrintViewController.m
//  Material
//
//  Created by wayne on 14-6-8.
//  Copyright (c) 2014年 brilliantech. All rights reserved.
//

#import "PrintViewController.h"
#import "AFNetOperate.h"
#import "Tuo.h"
#import "Yun.h"

@interface PrintViewController ()<UITextFieldDelegate>
- (IBAction)unPrint:(id)sender;
- (IBAction)print:(id)sender;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *yunSuccessContentLabel;
@property (weak, nonatomic) IBOutlet UILabel *printModelLabel;
@property (weak, nonatomic) IBOutlet UITextField *pageTextField;

@end

@implementation PrintViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}
-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
//    [[Captuvo sharedCaptuvoDevice] stopDecoderHardware];
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.yunSuccessContentLabel.text=self.successContent?self.successContent:@"";
    if(self.noBackButton){
        [self.navigationItem setHidesBackButton:YES];
    }
    self.pageTextField.delegate=self;
    self.printModelLabel.adjustsFontSizeToFitWidth=YES;
    self.printModelLabel.text=[[[AFNetOperate alloc] init] get_current_print_model];
}
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    NSString *class=[NSString stringWithFormat:@"%@",[self.container class]];
    if([class isEqualToString:@"Yun"]){
        self.titleLabel.text=@"打印运单？";
        self.pageTextField.text=[[[AFNetOperate alloc] init] get_yun_copy];
    }
    else if([class isEqualToString:@"Tuo"]){
        self.titleLabel.text=@"打印拖清单？";
        self.pageTextField.text=[[[AFNetOperate alloc] init] get_tuo_copy];
    }
    
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (IBAction)unPrint:(id)sender {
    NSString *containerClass=[NSString stringWithFormat:@"%@",[self.container class]];
     if([containerClass isEqualToString:@"Tuo"]){
         [self performSegueWithIdentifier:@"finishTuo" sender:self];
     }
     else if([containerClass isEqualToString:@"Yun"]){
         [self performSegueWithIdentifier:@"finishYun" sender:self];
     }
}

- (IBAction)print:(id)sender {
     [self sameFinishAction];
    
}
-(void)sameFinishAction
{
    NSString *containerClass=[NSString stringWithFormat:@"%@",[self.container class]];
    AFNetOperate *AFNet=[[AFNetOperate alloc] init];
    AFHTTPRequestOperationManager *manager=[AFNet generateManager:self.view];
    if([containerClass isEqualToString:@"Tuo"]){
        //这里掉打印拖的接口
        [manager GET:[AFNet print_stock_tuo:[(Tuo *)self.container ID]]
          parameters:@{@"printer_name":self.printModelLabel.text}
             success:^(AFHTTPRequestOperation *operation, id responseObject) {
                 [AFNet.activeView stopAnimating];
                 if([responseObject[@"Code"] integerValue]==1){
                    [AFNet alertSuccess:responseObject[@"Content"]];
                     if(!self.noBackButton){
                         [self.navigationController popViewControllerAnimated:YES];
                     }
                     else{
                          [self performSegueWithIdentifier:@"finishTuo" sender:self];
                     }
                     [AFNet set_tuo_copy:self.pageTextField.text];
                    
                 }
                 else{
                     [AFNet alert:responseObject[@"Content"]];
                 }
             }
             failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                 [AFNet.activeView stopAnimating];
                 [AFNet alert:[NSString stringWithFormat:@"%@",[error localizedDescription]]];
             }
         ];
    }
    else if([containerClass isEqualToString:@"Yun"]){

        [manager GET:[AFNet print_stock_yun:[(Yun *)self.container ID]]
          parameters:@{@"printer_name":self.printModelLabel.text}
             success:^(AFHTTPRequestOperation *operation, id responseObject) {
                 
                 [AFNet.activeView stopAnimating];
                 if([responseObject[@"Code"] integerValue]==1){
                     [AFNet alertSuccess:responseObject[@"Content"]];
                     [self performSegueWithIdentifier:@"finishYun" sender:self];
                     [AFNet set_yun_copy:self.pageTextField.text];
                 }
                 else{
                     [AFNet alert:responseObject[@"Content"]];
                 }
             }
             failure:^(AFHTTPRequestOperation *operation, NSError *error) {
             
                 [AFNet.activeView stopAnimating];
                 [AFNet alert:[NSString stringWithFormat:@"%@",[error localizedDescription]]];
             }
         ];
    }
}
@end
