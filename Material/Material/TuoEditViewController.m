//
//  TuoEditViewController.m
//  Material
//
//  Created by wayne on 14-6-8.
//  Copyright (c) 2014年 brilliantech. All rights reserved.
//

#import "TuoEditViewController.h"
#import "HuoTableViewCell.h"
#import "XiangEditViewController.h"
#import "Xiang.h"
#import "TuoScanViewController.h"
#import "XiangTableViewCell.h"
#import "TuoPrintViewController.h"
#import "AFNetOperate.h"

@interface TuoEditViewController ()<UITableViewDataSource,UITableViewDelegate,UITextFieldDelegate,CaptuvoEventsProtocol>
@property (weak, nonatomic) IBOutlet UITextField *department;
@property (weak, nonatomic) IBOutlet UITextField *agent;
@property (weak, nonatomic) IBOutlet UITableView *xiangTable;
@property (strong, nonatomic) UITextField *firstResponder;
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
        NSString *department=self.department.text;
        AFNetOperate *AFNet=[[AFNetOperate alloc] init];
        AFHTTPRequestOperationManager *manager=[AFNet generateManager:self.view];
        [manager PUT:[AFNet tuo_index]
          parameters:@{@"forklift":@{@"id":self.tuo.ID,@"whouse_id":department}}
                success:^(AFHTTPRequestOperation *operation, id responseObject) {
                    [AFNet.activeView stopAnimating];
                    if([responseObject[@"result"] integerValue]==1){
                        self.tuo.department=department;
                        [textField resignFirstResponder];
                        self.firstResponder=nil;
                        
                    }
                    else{
                        [AFNet alert:responseObject[@"content"]];
                    }
                    
                }
                failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                    [AFNet.activeView stopAnimating];
                }
         ];
    }
    else if(textField.tag==22){
        NSString *agent=self.agent.text;
        AFNetOperate *AFNet=[[AFNetOperate alloc] init];
        AFHTTPRequestOperationManager *manager=[AFNet generateManager:self.view];
        [manager PUT:[AFNet tuo_index]
          parameters:@{@"forklift":@{@"id":self.tuo.ID,@"stocker_id":agent}}
             success:^(AFHTTPRequestOperation *operation, id responseObject) {
                 [AFNet.activeView stopAnimating];
                 if([responseObject[@"result"] integerValue]==1){
                     self.tuo.agent=agent;
                     [textField resignFirstResponder];
                      self.firstResponder=nil;
                
                 }
                 else{
                     [AFNet alert:responseObject[@"content"]];
                 }
                 
             }
             failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                 [AFNet.activeView stopAnimating];
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
        AFNetOperate *AFNet=[[AFNetOperate alloc] init];
        AFHTTPRequestOperationManager *manager=[AFNet generateManager:self.view];
        [manager DELETE:[AFNet tuo_remove_xiang]
             parameters:@{
                          @"forklift_id":self.tuo.ID,
                          @"package_id":[[self.tuo.xiang objectAtIndex:indexPath.row] ID]
                          }
                success:^(AFHTTPRequestOperation *operation, id responseObject) {
                    [AFNet.activeView stopAnimating];
                    if([responseObject[@"result"] integerValue]==1){
                        [self.tuo.xiang removeObjectAtIndex:indexPath.row];
                        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
                    }
                    else{
                        [AFNet alert:responseObject[@"content"]];
                    }
                    
                }
                failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                    [AFNet.activeView stopAnimating];
                }
         ];
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
}
@end
