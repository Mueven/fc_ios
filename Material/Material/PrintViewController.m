//
//  PrintViewController.m
//  Material
//
//  Created by wayne on 14-6-8.
//  Copyright (c) 2014年 brilliantech. All rights reserved.
//

#import "PrintViewController.h"
//#import "TuoStore.h"
//#import "YunStore.h"
#import "AFNetOperate.h"
#import "Tuo.h"

@interface PrintViewController ()
- (IBAction)unPrint:(id)sender;
- (IBAction)print:(id)sender;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
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
    [[Captuvo sharedCaptuvoDevice] stopDecoderHardware];
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    NSString *class=[NSString stringWithFormat:@"%@",[self.container class]];
    if([class isEqualToString:@"Yun"]){
        self.titleLabel.text=@"打印运单？";
    }
    else if([class isEqualToString:@"Tuo"]){
        self.titleLabel.text=@"打印拖清单？";
    }
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (IBAction)unPrint:(id)sender {
    [self performSegueWithIdentifier:@"finishTuo" sender:self];
}

- (IBAction)print:(id)sender {
     [self sameFinishAction];
    
}
-(void)sameFinishAction
{
    NSString *containerClass=[NSString stringWithFormat:@"%@",[self.container class]];
    if([containerClass isEqualToString:@"Tuo"]){
//        TuoStore *tuoStore=[TuoStore sharedTuoStore:self.view];
//        [tuoStore addTuo:self.container];
        
        //这里掉打印拖的接口
        AFNetOperate *AFNet=[[AFNetOperate alloc] init];
        AFHTTPRequestOperationManager *manager=[AFNet generateManager:self.view];
        [manager GET:[AFNet print_stock_tuo:[(Tuo *)self.container ID]]
          parameters:nil
             success:^(AFHTTPRequestOperation *operation, id responseObject) {
                 [AFNet.activeView stopAnimating];
                 if([responseObject[@"result"] integerValue]==1){
                     [self performSegueWithIdentifier:@"finishTuo" sender:self];
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
    else if([containerClass isEqualToString:@"Yun"]){
//        YunStore *yunStore=[YunStore sharedYunStore];
//        [yunStore.yunArray addObject:self.container];
        [self performSegueWithIdentifier:@"finishYun" sender:self];
    }
}
@end
