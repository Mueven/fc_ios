//
//  RequireXiangDetailViewController.m
//  Material
//
//  Created by wayne on 14-7-24.
//  Copyright (c) 2014年 brilliantech. All rights reserved.
//

#import "RequireXiangDetailViewController.h"

@interface RequireXiangDetailViewController ()
@property (weak, nonatomic) IBOutlet UIButton *urgentButton;
- (IBAction)setUrgent:(id)sender;

@end

@implementation RequireXiangDetailViewController

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
    if(self.xiang.urgent){
        //加急
        self.urgentButton.backgroundColor=[UIColor colorWithRed:242.0/255.0 green:67.0/255.0 blue:67.0/255.0 alpha:1.0];
        [self.urgentButton setTitle:@"取消加急" forState:UIControlStateNormal];
    }
    else{
        self.urgentButton.backgroundColor=[UIColor colorWithRed:170.0/255.0 green:170.0/255.0 blue:170.0/255.0 alpha:1.0];
        [self.urgentButton setTitle:@"设为加急" forState:UIControlStateNormal];
        
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

- (IBAction)setUrgent:(id)sender {
    if(self.xiang.urgent){
        //设为不加急
        self.xiang.urgent=0;
        self.urgentButton.backgroundColor=[UIColor colorWithRed:170.0/255.0 green:170.0/255.0 blue:170.0/255.0 alpha:1.0];
        [self.urgentButton setTitle:@"设为加急" forState:UIControlStateNormal];
    }
    else{
        //设为加急
        self.xiang.urgent=1;
        self.urgentButton.backgroundColor=[UIColor colorWithRed:242.0/255.0 green:67.0/255.0 blue:67.0/255.0 alpha:1.0];
        [self.urgentButton setTitle:@"取消加急" forState:UIControlStateNormal];
    }
}
@end
