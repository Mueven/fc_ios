//
//  ReceiveXiangViewController.m
//  Material
//
//  Created by wayne on 14-6-10.
//  Copyright (c) 2014年 brilliantech. All rights reserved.
//

#import "ReceiveXiangViewController.h"
#import "Xiang.h"
#import "ShopXiangTableViewCell.h"
#import "AFNetOperate.h"
#import <AudioToolbox/AudioToolbox.h>

@interface ReceiveXiangViewController ()<UITextFieldDelegate,UITableViewDataSource,UITableViewDelegate,CaptuvoEventsProtocol>
@property (weak, nonatomic) IBOutlet UITextField *scanTextField;
@property (weak, nonatomic) IBOutlet UITableView *xiangTable;
@property (weak, nonatomic) IBOutlet UILabel *countLabel;
@property (nonatomic) int xiangCheckedCount;
- (IBAction)finish:(id)sender;

@end

@implementation ReceiveXiangViewController

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
    self.navigationItem.title=self.tuo.department;
    self.scanTextField.delegate=self;
    self.xiangTable.delegate=self;
    self.xiangTable.dataSource=self;
    [self.scanTextField becomeFirstResponder];
    UINib *cellNib=[UINib nibWithNibName:@"ShopXiangTableViewCell" bundle:nil];
    [self.xiangTable registerNib:cellNib forCellReuseIdentifier:@"xiangCell"];
    self.xiangCheckedCount=0;
    for(int i=0;i<self.tuo.xiang.count;i++){
        Xiang *xiang=self.tuo.xiang[i];
        if(xiang.checked){
            self.xiangCheckedCount++;
        }
    }
    [self updateCheckedLabel];
}
-(void)updateCheckedLabel{
    NSString *count=[NSString stringWithFormat:@"%d",self.xiangCheckedCount];
    self.countLabel.text=count;
}
-(void)updateAddCheckedLabel{
    self.xiangCheckedCount++;
    NSString *count=[NSString stringWithFormat:@"%d",self.xiangCheckedCount];
    self.countLabel.text=count;
}
-(void)updateMinusCheckedLabel{
    self.xiangCheckedCount--;
    NSString *count=[NSString stringWithFormat:@"%d",self.xiangCheckedCount];
    self.countLabel.text=count;
}
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
//    [[Captuvo sharedCaptuvoDevice] removeCaptuvoDelegate:self];
    [[Captuvo sharedCaptuvoDevice] addCaptuvoDelegate:self];
//    [[Captuvo sharedCaptuvoDevice] startDecoderHardware];
}
-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
//    [[Captuvo sharedCaptuvoDevice] stopDecoderHardware];
    [[Captuvo sharedCaptuvoDevice] removeCaptuvoDelegate:self];
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma captuvo delegate
-(void)decoderDataReceived:(NSString *)data
{
    NSMutableArray *xiangArray=self.tuo.xiang;
    int count=0;
    for(int i=0;i<xiangArray.count;i++){
        if([data isEqualToString:[xiangArray[i] ID]]){
            count++;
            dispatch_queue_t check_queue=dispatch_queue_create("com.check.pptalent", NULL);
            dispatch_async(check_queue, ^{
                NSString *myData=data;
                AFNetOperate *AFNet=[[AFNetOperate alloc] init];
                AFHTTPRequestOperationManager *manager=[AFNet generateManager:self.view];
                [AFNet.activeView stopAnimating];
                [manager POST:[AFNet xiang_check]
                   parameters:@{@"id":myData}
                      success:^(AFHTTPRequestOperation *operation, id responseObject) {
                          [AFNet.activeView stopAnimating];
                          if([responseObject[@"result"] integerValue]==1){
                              [[self.tuo.xiang objectAtIndex:i] setChecked:YES];
                              [self.xiangTable reloadData];
                          }
                          else{
                              [AFNet alert:responseObject[@"content"]];
                          }
                      }
                      failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                          [AFNet.activeView stopAnimating];
                          [AFNet alert:[NSString stringWithFormat:@"%@",[error localizedDescription]]];
                      }
                 ];
            });
            break;
        }
    }
    if(count==0){
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"没有找到该箱"
                                                       message:[NSString stringWithFormat:@"未在该拖清单中发现托箱%@",data]
                                                      delegate:self
                                             cancelButtonTitle:@"确定"
                                             otherButtonTitles:nil];
        AudioServicesPlaySystemSound(1051);
        [alert show];
        
    }
}
#pragma textField
-(void)textFieldDidBeginEditing:(UITextField *)textField
{
    UIView *dummyView=[[UIView alloc] initWithFrame:CGRectMake(0, 0, 1, 1)];
    textField.inputView=dummyView;
}
-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    NSMutableArray *xiangArray=self.tuo.xiang;
    int count=0;
    for(int i=0;i<xiangArray.count;i++){
        if([textField.text isEqualToString:[xiangArray[i] ID]]){
            count++;
            AFNetOperate *AFNet=[[AFNetOperate alloc] init];
            AFHTTPRequestOperationManager *manager=[AFNet generateManager:self.view];
            [manager POST:[AFNet xiang_check]
               parameters:@{@"id":textField.text}
                  success:^(AFHTTPRequestOperation *operation, id responseObject) {
                      [AFNet.activeView stopAnimating];
                      if([responseObject[@"result"] integerValue]==1){
                          [[self.tuo.xiang objectAtIndex:i] setChecked:YES];
                          [self.xiangTable reloadData];
                          [self updateAddCheckedLabel];
                      }
                      else{
                          [AFNet alert:responseObject[@"content"]];
                      }
                  }
                  failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                      [AFNet.activeView stopAnimating];
                      [AFNet alert:[NSString stringWithFormat:@"%@",[error localizedDescription]]];
                  }
             ];
            break;
        }
    }
    if(count==0){
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"没有找到该箱"
                                                       message:[NSString stringWithFormat:@"未在该拖清单中发现托箱%@",textField.text]
                                                      delegate:self
                                             cancelButtonTitle:@"确定"
                                             otherButtonTitles:nil];
        AudioServicesPlaySystemSound(1051);
        [alert show];

    }
    
    return YES;
}
#pragma table delegate
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
    Xiang *xiang=[self.tuo.xiang objectAtIndex:indexPath.row];
    ShopXiangTableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:@"xiangCell" forIndexPath:indexPath];
    cell.partNumberLabel.text=xiang.number;
    cell.keyLabel.text=xiang.key;
    cell.quantityLabel.text=[NSString stringWithFormat:@"Q:%@",xiang.count];
    if(xiang.checked){
        cell.accessoryType=UITableViewCellAccessoryCheckmark;
    }
    else{
        cell.accessoryType=UITableViewCellAccessoryNone;
    }
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    Xiang *xiang=[self.tuo.xiang objectAtIndex:indexPath.row];
    ShopXiangTableViewCell *cell=(ShopXiangTableViewCell *)[tableView cellForRowAtIndexPath:indexPath];
    if(cell.accessoryType==UITableViewCellAccessoryNone){
//        cell.accessoryType=UITableViewCellAccessoryCheckmark;
//        xiang.checked=YES;
    }
    else if(cell.accessoryType==UITableViewCellAccessoryCheckmark){
        AFNetOperate *AFNet=[[AFNetOperate alloc] init];
        AFHTTPRequestOperationManager *manager=[AFNet generateManager:self.view];
        [manager POST:[AFNet xiang_uncheck]
           parameters:@{@"id":xiang.ID}
              success:^(AFHTTPRequestOperation *operation, id responseObject) {
                  [AFNet.activeView stopAnimating];
                  if([responseObject[@"result"] integerValue]==1){
                      cell.accessoryType=UITableViewCellAccessoryNone;
                      xiang.checked=NO;
                      [self updateMinusCheckedLabel];
                  }
                  else{
                      [AFNet alert:responseObject[@"content"]];
                  }
              }
              failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                  [AFNet.activeView stopAnimating];
                  [AFNet alert:[NSString stringWithFormat:@"%@",[error localizedDescription]]];
              }
         ];   
        
    }
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
    [self.navigationController popViewControllerAnimated:YES];
}
@end
