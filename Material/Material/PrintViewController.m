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
    [self sameFinishAction];
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
        [self performSegueWithIdentifier:@"finishTuo" sender:self];
    }
    else if([containerClass isEqualToString:@"Yun"]){
//        YunStore *yunStore=[YunStore sharedYunStore];
//        [yunStore.yunArray addObject:self.container];
        [self performSegueWithIdentifier:@"finishYun" sender:self];
    }
}
@end
