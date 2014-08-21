//
//  RequireTraceDetailViewController.m
//  Material
//
//  Created by wayne on 14-8-21.
//  Copyright (c) 2014年 brilliantech. All rights reserved.
//

#import "RequireTraceDetailViewController.h"
#import "DrawLight.h"
@interface RequireTraceDetailViewController ()
- (IBAction)finishCheck:(id)sender;
@property (weak, nonatomic) IBOutlet UILabel *positionLabel;
@property (weak, nonatomic) IBOutlet UILabel *dateLastLabel;
@property (weak, nonatomic) IBOutlet UILabel *dateCurrentLabel;
@property (weak, nonatomic) IBOutlet UILabel *sumLabel;
@property (weak, nonatomic) IBOutlet UILabel *receiveLabel;
@property (weak, nonatomic) IBOutlet UILabel *unreceiveLabel;
@property (strong,nonatomic)DrawLight *graphView;
- (IBAction)reset:(id)sender;
@end

@implementation RequireTraceDetailViewController

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
-(void)loadView
{
    [super loadView];
    CGRect graphFrame=CGRectMake(33, 328, 253, 130);
    self.graphView=[[DrawLight alloc] initWithFrame:graphFrame color:@"red"];
    self.graphView.backgroundColor=[UIColor clearColor];
    [self.view addSubview:self.graphView];
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)finishCheck:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}
- (IBAction)reset:(id)sender {
    [self.graphView removeFromSuperview];
    self.graphView=nil;
    CGRect graphFrame=CGRectMake(33, 328, 253, 130);
    self.graphView=[[DrawLight alloc] initWithFrame:graphFrame color:@"blue"];
    self.graphView.backgroundColor=[UIColor clearColor];
    [self.view addSubview:self.graphView];
}
@end
