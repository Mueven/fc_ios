//
//  ReceiveConfirmViewController.m
//  Material
//
//  Created by wayne on 14-6-15.
//  Copyright (c) 2014年 brilliantech. All rights reserved.
//

#import "ReceiveConfirmViewController.h"
#import "Yun.h"
#import "Tuo.h"
#import "Xiang.h"
#import "AFNetOperate.h"
#import "ReceivePrintViewController.h"

@interface ReceiveConfirmViewController ()<UIAlertViewDelegate>
- (IBAction)cnfirmReceive:(id)sender;
@property (strong,nonatomic) UIAlertView *printAlert;
@property (weak, nonatomic) IBOutlet UILabel *checkedLabel;
@property (weak, nonatomic) IBOutlet UILabel *amountLabel;
@end

@implementation ReceiveConfirmViewController

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
    self.checkedLabel.adjustsFontSizeToFitWidth=YES;
    self.amountLabel.adjustsFontSizeToFitWidth=YES;
}
-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
//    [[Captuvo sharedCaptuvoDevice] stopDecoderHardware];
}
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    int count=0;
    int checked=0;
    for(int i=0;i<[self.yun.tuoArray count];i++){
        Tuo *tuo=[self.yun.tuoArray objectAtIndex:i];
        int aTuoXiangCount=(int)[tuo.xiang count];
        count+=aTuoXiangCount;
        for(int j=0;j<aTuoXiangCount;j++){
            Xiang *xiang=[tuo.xiang objectAtIndex:j];
            if(xiang.checked){
                checked++;
            }
        }
    }
    self.checkedLabel.text=[NSString stringWithFormat:@"%d",checked];
    self.amountLabel.text=[NSString stringWithFormat:@"%d",count];
    if(checked!=count){
        [self.checkedLabel setTextColor:[UIColor redColor]];
        [self.amountLabel setTextColor:[UIColor redColor]];
    }
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    if([segue.identifier isEqualToString:@"printYun"]){
        ReceivePrintViewController *receivePrint=segue.destinationViewController;
        receivePrint.yun=[sender objectForKey:@"yun"];
        receivePrint.type=[sender objectForKey:@"type"];
    }
}

- (IBAction)cnfirmReceive:(id)sender {
    UIAlertView *alert=[[UIAlertView alloc] initWithTitle:@""
                                                  message:@"确认收货？"
                                                 delegate:self
                                        cancelButtonTitle:@"取消"
                                        otherButtonTitles:@"确定", nil];
    [alert show];
}
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if(buttonIndex==1){
        AFNetOperate *AFNet=[[AFNetOperate alloc] init];
        AFHTTPRequestOperationManager *manager=[AFNet generateManager:self.view];
        [manager POST:[AFNet yun_confirm_receive]
           parameters:@{@"id":self.yun.ID}
              success:^(AFHTTPRequestOperation *operation, id responseObject) {
                  [AFNet.activeView stopAnimating];
                  if([responseObject[@"result"] integerValue]==1){
                      [self performSegueWithIdentifier:@"printYun" sender:@{@"yun":self.yun,@"type":@"receive"}];
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

@end
