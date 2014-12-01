//
//  TuoEditViewController.m
//  Material
//
//  Created by wayne on 14-6-8.
//  Copyright (c) 2014年 brilliantech. All rights reserved.
//

#import "TuoEditViewController.h"

#import "XiangEditViewController.h"
#import "Xiang.h"
#import "TuoScanViewController.h"
#import "XiangTableViewCell.h"
#import "TuoPrintViewController.h"
#import "AFNetOperate.h"
#import "TuoSendViewController.h"

@interface TuoEditViewController ()<UITableViewDataSource,UITableViewDelegate,UITextFieldDelegate,CaptuvoEventsProtocol>
@property (weak, nonatomic) IBOutlet UITextField *department;
@property (weak, nonatomic) IBOutlet UITextField *agent;
@property (weak, nonatomic) IBOutlet UITableView *xiangTable;
@property (strong, nonatomic) UITextField *firstResponder;
@property (weak, nonatomic) IBOutlet UILabel *xiangCountLabel;
@property (nonatomic)int sum_packages_count;
- (IBAction)sendTuo:(id)sender;

@end

@implementation TuoEditViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}
-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
//    [[Captuvo sharedCaptuvoDevice] stopDecoderHardware];
    [[Captuvo sharedCaptuvoDevice] removeCaptuvoDelegate:self];
    [self.firstResponder resignFirstResponder];
    self.firstResponder=nil;
  
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.xiangTable.delegate=self;
    self.xiangTable.dataSource=self;
    self.department.delegate=self;
    self.agent.delegate=self;
    self.xiangCountLabel.adjustsFontSizeToFitWidth=YES;
    UINib *nib=[UINib nibWithNibName:@"XiangTableViewCell" bundle:nil];
    [self.xiangTable registerNib:nib forCellReuseIdentifier:@"xiangCell"];
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
    
//    [[Captuvo sharedCaptuvoDevice] startDecoderHardware];
    self.department.text=self.tuo.department;
    self.agent.text=self.tuo.agent;
    [self.xiangTable reloadData];
    self.sum_packages_count=self.tuo.sum_packages;
    [self updateXiangCountLabel];
}

-(void)decoderDataReceived:(NSString *)data
{
    self.firstResponder.text=data;
    [self textFieldShouldReturn:self.firstResponder];
}
-(void)textFieldDidBeginEditing:(UITextField *)textField
{
    UIView *dummyView=[[UIView alloc] initWithFrame:CGRectMake(0, 0, 1, 1)];
    textField.inputView=dummyView;
    self.firstResponder=textField;
}
-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if(textField.tag==21){
        NSString *department=textField.text;
        AFNetOperate *AFNet=[[AFNetOperate alloc] init];
        AFHTTPRequestOperationManager *manager=[AFNet generateManager:self.view];
        [manager PUT:[AFNet tuo_index]
          parameters:@{@"id":self.tuo.ID,@"whouse_id":department}
                success:^(AFHTTPRequestOperation *operation, id responseObject) {
                    [AFNet.activeView stopAnimating];
                    if([responseObject[@"result"] integerValue]==1){
                        self.tuo.department=department;
                        self.tuo.xiang=[[NSMutableArray alloc] init];
                        NSArray *xiangArray=[responseObject[@"content"] objectForKey:@"packages"];
                        for(int i=0;i<xiangArray.count;i++){
                            Xiang *xiangItem=[[Xiang alloc] initWithObject:xiangArray[i]];
                            [self.tuo.xiang addObject:xiangItem];
                        }
                        [textField resignFirstResponder];
                        self.firstResponder=nil;
                        [self.xiangTable reloadData];
                    }
                    else{
                        [AFNet alert:responseObject[@"content"]];
                        [textField resignFirstResponder];
                        self.firstResponder=nil;
                    }
                    
                }
                failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                    [AFNet.activeView stopAnimating];
                    [textField resignFirstResponder];
                    self.firstResponder=nil;
                }
         ];
    }
    else if(textField.tag==22){
        NSString *agent=self.agent.text;
        AFNetOperate *AFNet=[[AFNetOperate alloc] init];
        AFHTTPRequestOperationManager *manager=[AFNet generateManager:self.view];
        [manager PUT:[AFNet tuo_index]
          parameters:@{@"id":self.tuo.ID,@"stocker_id":agent}
             success:^(AFHTTPRequestOperation *operation, id responseObject) {
                 [AFNet.activeView stopAnimating];
                 if([responseObject[@"result"] integerValue]==1){
                     self.tuo.agent=agent;
                     [textField resignFirstResponder];
                      self.firstResponder=nil;
                
                 }
                 else{
                     [AFNet alert:responseObject[@"content"]];
                     [textField resignFirstResponder];
                     self.firstResponder=nil;
                 }
                 
             }
             failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                 [AFNet.activeView stopAnimating];
                 [textField resignFirstResponder];
                 self.firstResponder=nil;
             }
         ];
    }
    [textField resignFirstResponder];
    return YES;
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.tuo xiangAmount];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    Xiang *xiang=[[self.tuo xiang] objectAtIndex:indexPath.row];
    XiangTableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:@"xiangCell" forIndexPath:indexPath];
    cell.partNumber.text=xiang.number;
    cell.key.text=xiang.key;
    cell.quantity.text=xiang.count;
    cell.position.text=xiang.position;
    cell.date.text=xiang.date;
    cell.accessoryType=UITableViewCellAccessoryDisclosureIndicator;
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    Xiang *xiang=[[self.tuo xiang] objectAtIndex:indexPath.row];
    [self performSegueWithIdentifier:@"xiangEdit" sender:@{@"xiang":xiang}];
}
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        int row=indexPath.row;
        if(self.tuo.xiang.count>row){
            Xiang *xiangReserve=[[[Xiang alloc] init] copyMe:[self.tuo.xiang objectAtIndex:row]];
            [self.tuo.xiang removeObjectAtIndex:row];
            [tableView cellForRowAtIndexPath:indexPath].alpha = 0.0;
            [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationBottom];
            self.sum_packages_count--;
            [self updateXiangCountLabel];
            dispatch_queue_t deleteRow=dispatch_queue_create("com.delete.row.pptalent", NULL);
            dispatch_async(deleteRow, ^{
                AFNetOperate *AFNet=[[AFNetOperate alloc] init];
                AFHTTPRequestOperationManager *manager=[AFNet generateManager:self.view];
                dispatch_async(dispatch_get_main_queue(), ^{
                    [AFNet.activeView stopAnimating];
                });
                [manager DELETE:[AFNet tuo_remove_xiang]
                     parameters:@{
                                  @"package_id":xiangReserve.ID
                                  }
                        success:^(AFHTTPRequestOperation *operation, id responseObject) {
                            [AFNet.activeView stopAnimating];
                            if([responseObject[@"result"] integerValue]==1){
                                
                            }
                            else{
                                [AFNet alert:responseObject[@"content"]];
                                [self.tuo.xiang addObject:xiangReserve];
                                self.sum_packages_count++;
                                [self updateXiangCountLabel];
                                [self.xiangTable reloadData];
                            }
                        }
                        failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                            [AFNet.activeView stopAnimating];
                            [AFNet alert:[NSString stringWithFormat:@"%@",[error localizedDescription]]];
                            self.sum_packages_count++;
                            [self updateXiangCountLabel];
                            [self.tuo.xiang addObject:xiangReserve];
                            [self.xiangTable reloadData];
                        }
                 ];
            });
 
        }
        

    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if([segue.identifier isEqualToString:@"xiangEdit"]){
        XiangEditViewController *xiangEdit=segue.destinationViewController;
        xiangEdit.xiang=[sender objectForKey:@"xiang"];
    }
    else if([segue.identifier isEqualToString:@"addXiang"]){
        TuoScanViewController *scanView=segue.destinationViewController;
        scanView.type=@"addXiang";
        scanView.tuo=self.tuo;
    }
    else if([segue.identifier isEqualToString:@"tuoPrint"]){
        TuoPrintViewController *tuoPrint=segue.destinationViewController;
        tuoPrint.tuo=self.tuo;
    }
    else if([segue.identifier isEqualToString:@"send"]){
        TuoSendViewController  *sendVC=segue.destinationViewController;
        sendVC.wetherJumpBack=YES;
        sendVC.tuo=self.tuo;
    }
}
-(void)updateXiangCountLabel
{
    self.xiangCountLabel.text=[NSString stringWithFormat:@"%d",self.sum_packages_count];
}

- (IBAction)sendTuo:(id)sender {
    [self performSegueWithIdentifier:@"send" sender:self];
}
@end
