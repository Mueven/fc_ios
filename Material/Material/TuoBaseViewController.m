//
//  TuoBaseViewController.m
//  Material
//
//  Created by wayne on 14-6-6.
//  Copyright (c) 2014年 brilliantech. All rights reserved.
//

#import "TuoBaseViewController.h"
#import "TuoScanViewController.h"
#import "Tuo.h"

@interface TuoBaseViewController ()
- (IBAction)nextStep:(id)sender;
@property (weak, nonatomic) IBOutlet UITextField *department;
@property (weak, nonatomic) IBOutlet UITextField *agent;

@end

@implementation TuoBaseViewController

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

//- (IBAction)selectGroupCondition:(id)sender {
//    NSArray *entity=[self.entityArray copy];
//    void (^dismiss)()=^(){
//        
//    };
//    [self performSegueWithIdentifier:@"selectGroupCondition" sender:@{
//                                                                      @"entity":entity,
//                                                                      @"dismiss":dismiss
//                                                                      }];
//}
-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if([segue.identifier isEqualToString:@"tuoBaseToScan"]){
        TuoScanViewController *scanViewController=segue.destinationViewController;
        Tuo *tuo=[[Tuo alloc] init];
        tuo.department=self.department.text;
        tuo.agent=self.agent.text;
        scanViewController.tuo=tuo;
        scanViewController.type=@"tuo";
    }
    
}

- (IBAction)nextStep:(id)sender {
//    NSString *department=self.department.text;
//    NSString *agent=self.agent.text;
//    if(department.length!=0 && agent.length!=0){
        [self baseToScan];
//    }
}
-(void)baseToScan
{
    [self performSegueWithIdentifier:@"tuoBaseToScan" sender:self];
}
@end
