//
//  LoginRoleViewController.m
//  Material
//
//  Created by wayne on 14-8-15.
//  Copyright (c) 2014年 brilliantech. All rights reserved.
//

#import "LoginRoleViewController.h"
#import "ScanStandard.h"
@interface LoginRoleViewController ()
@end

@implementation LoginRoleViewController

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
     [[self navigationController] setNavigationBarHidden:NO animated:YES];

}
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    for(int i=0;i<self.roleArray.count;i++){
        [self createButton:i];
    }
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)createButton:(int)index
{
    CGFloat half_margin=40;
    CGFloat top_margin=55;
    CGFloat button_height=60;
    CGFloat screen_width=[UIScreen mainScreen].bounds.size.width;
    CGFloat navigation_top=64;
    CGRect buttonFrame=CGRectMake(half_margin, top_margin*(index+1)+button_height*index+navigation_top,screen_width-2*half_margin, button_height);
 
    UIButton *button=[[UIButton alloc] initWithFrame:buttonFrame];
    button.backgroundColor=[UIColor colorWithRed:66.0/255.0 green:120.0/255.0 blue:207.0/255.0 alpha:1.0];
    button.titleLabel.font=[UIFont systemFontOfSize:17];
    button.tintColor=[UIColor whiteColor];
    button.tag=index;
    [button setTitle:[self.roleArray objectAtIndex:index] forState:UIControlStateNormal];
    [button addTarget:self
               action:@selector(clickButton:)
     forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:button];
}
-(void)clickButton:(UIButton *)button
{
    NSString *code=[self.roleArray objectAtIndex:button.tag];
    if([code isEqualToString:@"300"]){
        [self loginSameAction:@"stock"];
    }
    else if([code isEqualToString:@"400"]){
        [self loginSameAction:@"shop"];
    }
    else if([code isEqualToString:@"500"]){
        [self loginSameAction:@"require"];
    }
}
-(void)loginSameAction:(NSString *)identifier
{
    UIStoryboard *storyboard=[UIStoryboard storyboardWithName:@"Storyboard" bundle:nil];
    UITabBarController *tabbarStock=[storyboard instantiateViewControllerWithIdentifier:identifier];
    //写入用户信息
    [self presentViewController:tabbarStock
                       animated:YES
                     completion:nil];
}
@end
