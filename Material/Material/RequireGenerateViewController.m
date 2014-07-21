//
//  RequireGenerateViewController.m
//  Material
//
//  Created by wayne on 14-7-21.
//  Copyright (c) 2014年 brilliantech. All rights reserved.
//

#import "RequireGenerateViewController.h"
#import "RequireXiangTableViewCell.h"
#import "RequireXiang.h"

@interface RequireGenerateViewController ()<UITextFieldDelegate,UITableViewDelegate,UITableViewDataSource,CaptuvoEventsProtocol>
@property (weak, nonatomic) IBOutlet UITextField *partTextField;
@property (weak, nonatomic) IBOutlet UITextField *positionTextField;
@property (weak, nonatomic) IBOutlet UITextField *quantityTextField;
@property (weak, nonatomic) IBOutlet UITableView *xiangTable;
@property (strong, nonatomic) UITextField *firstResponder;
@property (strong,nonatomic)NSMutableArray *xiangArray;
- (IBAction)finish:(id)sender;
@end

@implementation RequireGenerateViewController

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
    self.partTextField.delegate=self;
    self.positionTextField.delegate=self;
    self.quantityTextField.delegate=self;
    self.xiangTable.delegate=self;
    self.xiangTable.dataSource=self;
    UINib *nib=[UINib nibWithNibName:@"RequireXiangTableViewCell" bundle:nil];
    [self.xiangTable registerNib:nib forCellReuseIdentifier:@"cell"];
    self.xiangArray=[[NSMutableArray alloc] init];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [[Captuvo sharedCaptuvoDevice] addCaptuvoDelegate:self];
    [self.partTextField becomeFirstResponder];
 
}
-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    //    [[Captuvo sharedCaptuvoDevice] stopDecoderHardware];
    [[Captuvo sharedCaptuvoDevice] removeCaptuvoDelegate:self];
    [self.firstResponder resignFirstResponder];
    self.firstResponder=nil;
}
#pragma decoder delegate
-(void)decoderDataReceived:(NSString *)data{
     self.firstResponder.text=[data copy];
     UITextField *targetTextField=self.firstResponder;
     [self textFieldShouldReturn:self.firstResponder];
}
#pragma textField delegate
-(void)textFieldDidBeginEditing:(UITextField *)textField
{
    UIView* dummyView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 1, 1)];
    textField.inputView = dummyView;
    self.firstResponder=textField;
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
     __block long tag=textField.tag;
    NSString *partNumber=self.partTextField.text;
    NSString *position=self.positionTextField.text;
    NSString *quantity=self.quantityTextField.text;
    if(tag==2){
        //有了位置可以显示出部门
    }
    if(partNumber.length>0&&position.length>0&&quantity.length>0){
        //发送请求
    }
    tag++;
    if(tag>3){
        tag=1;
    }
    UITextField *nextText=(UITextField *)[self.view viewWithTag:tag];
    [nextText becomeFirstResponder];
    return YES;
}
#pragma table delegate
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    RequireXiangTableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    RequireXiang *xiang=self.xiangArray[indexPath.row];
    
    return cell;
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

- (IBAction)finish:(id)sender {
}
@end
