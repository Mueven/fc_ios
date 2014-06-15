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
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    int count=0;
    int checked=0;
    for(int i=0;i<[self.yun.tuoArray count];i++){
        Tuo *tuo=[self.yun.tuoArray objectAtIndex:i];
        int aTuoXiangCount=[tuo.xiang count];
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

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/
- (IBAction)cnfirmReceive:(id)sender {
    UIAlertView*alert = [[UIAlertView alloc]initWithTitle:@"打印"
                                                  message:@"要打印运单吗？"
                                                 delegate:self
                                        cancelButtonTitle:@"不打印"
                                        otherButtonTitles:@"打印",nil];
    [alert show];
    
}
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if(buttonIndex==1){
        
    }
    [self performSegueWithIdentifier:@"unwindToReceive" sender:self];
}


@end
