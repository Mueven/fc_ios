//
//  WrapMiniViewController.m
//  Material
//
//  Created by wayne on 14-6-10.
//  Copyright (c) 2014年 brilliantech. All rights reserved.
//

#import "WrapMiniViewController.h"

@interface WrapMiniViewController ()<UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UITextField *scanTextField;

@end

@implementation WrapMiniViewController

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
    self.scanTextField.delegate=self;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)textFieldDidBeginEditing:(UITextField *)textField
{
    UIView *dummyView=[[UIView alloc] initWithFrame:CGRectMake(0, 0, 1, 1)];
    textField.inputView=dummyView;
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

@end
