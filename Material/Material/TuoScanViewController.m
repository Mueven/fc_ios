//
//  TuoScanViewController.m
//  Material
//
//  Created by wayne on 14-6-6.
//  Copyright (c) 2014年 brilliantech. All rights reserved.
//

#import "TuoScanViewController.h"
#import "XiangStore.h"
#import "TuoStore.h"
#import "HuoTableViewCell.h"
#import "Xiang.h"
#import "PrintViewController.h"
#import "Tuo.h"
#import "XiangEditViewController.h"
#import "AFNetOperate.h"


@interface TuoScanViewController ()<UITextFieldDelegate,UITableViewDelegate,UITableViewDataSource,CaptuvoEventsProtocol>
@property (weak, nonatomic) IBOutlet UITextField *key;
@property (weak, nonatomic) IBOutlet UITextField *partNumber;
@property (weak, nonatomic) IBOutlet UITextField *quatity;
@property (strong, nonatomic) UITextField *firstResponder;
@property (weak, nonatomic) IBOutlet UITableView *xiangTable;
@property (strong, nonatomic) XiangStore *xiangStore;
//@property (strong,nonatomic) NSArray *validateAddress;
- (IBAction)finish:(id)sender;
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
    self.xiangStore=[XiangStore sharedXiangStore:self.view];
    self.xiangTable.delegate=self;
    self.xiangTable.dataSource=self;
    if([self.type isEqualToString:@"xiang"]){
        self.navigationItem.rightBarButtonItem=NULL;
        self.tuo=[[Tuo alloc] init];
    }
    else if([self.type isEqualToString:@"addXiang"]){
        self.navigationItem.rightBarButtonItem=NULL;
    }
    [[Captuvo sharedCaptuvoDevice] removeCaptuvoDelegate:self];
    [[Captuvo sharedCaptuvoDevice] addCaptuvoDelegate:self];
    [[Captuvo sharedCaptuvoDevice] startDecoderHardware];
}
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.key becomeFirstResponder];
    [[Captuvo sharedCaptuvoDevice] removeCaptuvoDelegate:self];
    [[Captuvo sharedCaptuvoDevice] addCaptuvoDelegate:self];
    [[Captuvo sharedCaptuvoDevice] startDecoderHardware];
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma decoder delegate
-(void)decoderReady
{
    
}
-(void)decoderDataReceived:(NSString *)data{
    AFNetOperate *AFNet=[[AFNetOperate alloc] init];
    AFHTTPRequestOperationManager *manager=[AFNet generateManager:self.view];
    [manager POST:@""
       parameters:nil
          success:^(AFHTTPRequestOperation *operation, id responseObject) {
               [AFNet.activeView stopAnimating];
               self.firstResponder.text=data;
               [self textFieldShouldReturn:self.firstResponder];
          }
          failure:^(AFHTTPRequestOperation *operation, NSError *error) {
               [AFNet.activeView stopAnimating];
          }
     ];
}
- (void)decoderRawDataReceived:(NSData *)data{
    

}
#pragma textField delegate
-(void)textFieldDidBeginEditing:(UITextField *)textField
{
    UIView* dummyView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 1, 1)];
    textField.inputView = dummyView;
    self.firstResponder=textField;
}
-(BOOL)textFieldShouldReturn:(UITextField *)textField
//-(void)textFieldDidEndEditing:(UITextField *)textField
{
    long tag=textField.tag;
    if(tag==3){
//        NSString *key=self.key.text;
//        NSString *partNumber=self.partNumber.text;
//        NSString *quantity=self.quatity.text;
        
//        AFNetOperate *AFNet=[[AFNetOperate alloc] init];
//        AFHTTPRequestOperationManager *manager=[AFNet generateManager:self.view];
//        [manager POST:[AFNet xiang_root]
//           parameters:@{
//                        @"key":key,
//                        @"partNumber":partNumber,
//                        @"quantity":quantity
//                        }
//              success:^(AFHTTPRequestOperation *operation, id responseObject) {
//                  [AFNet.activeView stopAnimating];
//                    Xiang *newXiang=[self.xiangStore addXiang:key partNumber:partNumber quatity:quantity];
//                  [self.tuo addXiang:newXiang];
//                  [self.xiangTable reloadData];
//              }
//              failure:^(AFHTTPRequestOperation *operation, NSError *error) {
//                  [AFNet.activeView stopAnimating];
//              }
//         ];
    }
    tag++;
    if(tag>3){
        tag=1;
    }
    UITextField *nextText=(UITextField *)[self.view viewWithTag:tag];
    [nextText becomeFirstResponder];
    return YES;
}
//扫描唯一码如果已经绑定，则直接添加
-(void)fillAllTextField:(NSDictionary *)xiang
{
    // [self.tuo addXiang:newXiang];
    // [self.xiangTable reloadData];
}
//table delegate
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.tuo.xiang count];
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    HuoTableViewCell *cell=(HuoTableViewCell *)[tableView dequeueReusableCellWithIdentifier:@"huoCell"];
    Xiang *xiang=[self.tuo.xiang objectAtIndex:indexPath.row];
    cell.leoniNumber.text=xiang.number;
    cell.kwyNumber.text=xiang.key;
    cell.extraInfo.text=[NSString stringWithFormat:@"Q%@ / %@",xiang.count,xiang.position];
    cell.leoniNumber.adjustsFontSizeToFitWidth=YES;
    cell.kwyNumber.adjustsFontSizeToFitWidth=YES;
    cell.extraInfo.adjustsFontSizeToFitWidth=YES;
    return cell;
}
-(void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [self.tuo.xiang removeObjectAtIndex:indexPath.row];
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }
}
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    if([self.type isEqualToString:@"xiang"]){
      return NO;
    }
    else{
        return YES;
    }
}
-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if([segue.identifier isEqualToString:@"scanToPrint"]){
        PrintViewController *printViewController = segue.destinationViewController;
        printViewController.container=[sender objectForKey:@"container"];
    }
    else if([segue.identifier isEqualToString:@"fromTuo"]){
        int row=[[self.xiangTable indexPathForCell:sender] row];
        XiangEditViewController *xiangEdit=segue.destinationViewController;
        xiangEdit.xiang=[self.tuo.xiang objectAtIndex:row];
    }
}
- (IBAction)finish:(id)sender {
    [self performSegueWithIdentifier:@"scanToPrint" sender:@{@"container":self.tuo}];
}


@end
