//
//  TuoScanViewController.m
//  Material
//
//  Created by wayne on 14-6-6.
//  Copyright (c) 2014年 brilliantech. All rights reserved.
//

#import "TuoScanViewController.h"

@interface TuoScanViewController ()<UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UITextField *key;
@property (weak, nonatomic) IBOutlet UITextField *partNumber;
@property (weak, nonatomic) IBOutlet UITextField *quatity;

@end

@implementation TuoScanViewController

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
    self.key.delegate=self;
    self.partNumber.delegate=self;
    self.quatity.delegate=self;
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)textFieldDidBeginEditing:(UITextField *)textField
{
    UIView* dummyView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 1, 1)];
    textField.inputView = dummyView;
}

@end
