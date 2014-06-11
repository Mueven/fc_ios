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

@interface TuoScanViewController ()<UITextFieldDelegate,UITableViewDelegate,UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITextField *key;
@property (weak, nonatomic) IBOutlet UITextField *partNumber;
@property (weak, nonatomic) IBOutlet UITextField *quatity;
@property (weak, nonatomic) IBOutlet UITableView *xiangTable;
@property (strong, nonatomic) XiangStore *xiangStore;
- (IBAction)finish:(id)sender;
- (IBAction)startDecoder:(id)sender;

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
}
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
//    [self.key becomeFirstResponder];
    [[Captuvo sharedCaptuvoDevice] addCaptuvoDelegate:self];
   
    ProtocolConnectionStatus connectionStatus = [[Captuvo sharedCaptuvoDevice] startDecoderHardware];
    switch (connectionStatus) {
        case ProtocolConnectionStatusConnected:
        case ProtocolConnectionStatusAlreadyConnected:
            NSLog(@"Connected!");
            break;
        case ProtocolConnectionStatusBatteryDepleted:
            NSLog(@"Battery depleted!");
            break;
        case ProtocolConnectionStatusUnableToConnect:
            NSLog(@"Error connecting!");
            break;
        case ProtocolConnectionStatusUnableToConnectIncompatiableSledFirmware:
            NSLog(@"Incompatible firmware!");
            break;
        default:
            break;
    }
   
}
- (void)decoderReady
{
    UIAlertView* alert = [[UIAlertView alloc]initWithTitle:nil
                                                   message:@"111111 decoder ready"
                                                  delegate:nil
                                         cancelButtonTitle:@"OK"
                                         otherButtonTitles:nil];
    [alert show];
    
    
}

-(void)decoderDataReceived:(NSString *)data{
    NSLog(@"Decoder Data Received: %@",data);

}
- (void)decoderRawDataReceived:(NSData *)data{
    NSLog(@"- (void)decoderRawDataReceived:(NSData *)data") ;

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

-(BOOL)textFieldShouldReturn:(UITextField *)textField
//-(void)textFieldDidEndEditing:(UITextField *)textField
{
    int tag=textField.tag;
    if(tag==23){
        NSString *key=self.key.text;
        NSString *partNumber=self.partNumber.text;
        NSString *quantity=self.quatity.text;
        
        AFNetOperate *AFNet=[[AFNetOperate alloc] init];
        AFHTTPRequestOperationManager *manager=[AFNet generateManager:self.view];
        [manager POST:[AFNet xiang_root]
           parameters:@{
                        @"key":key,
                        @"partNumber":partNumber,
                        @"quantity":quantity
                        }
              success:^(AFHTTPRequestOperation *operation, id responseObject) {
                  [AFNet.activeView stopAnimating];
                    Xiang *newXiang=[self.xiangStore addXiang:key partNumber:partNumber quatity:quantity];
                  [self.tuo addXiang:newXiang];
                  [self.xiangTable reloadData];
              }
              failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                  [AFNet.activeView stopAnimating];
              }
         ];
    }
    tag++;
    if(tag>23){
        tag=21;
    }
    UITextField *nextText=(UITextField *)[self.view viewWithTag:tag];
    [nextText becomeFirstResponder];
    return YES;
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

- (IBAction)startDecoder:(id)sender {
    [[Captuvo sharedCaptuvoDevice] startDecoderScanning];
    [[Captuvo sharedCaptuvoDevice] startMSRHardware];
}
@end
