//
//  YunChooseTuoViewController.m
//  Material
//
//  Created by wayne on 14-6-9.
//  Copyright (c) 2014年 brilliantech. All rights reserved.
//

#import "YunChooseTuoViewController.h"
#import "Yun.h"
#import "Tuo.h"
#import "YunHaveTuoTableViewController.h"
#import "YunInfoViewController.h"
#import "AFNetOperate.h"
#import "TuoTableViewCell.h"

@interface YunChooseTuoViewController ()<UITextFieldDelegate,UITableViewDelegate,UITableViewDataSource,CaptuvoEventsProtocol>
@property (weak, nonatomic) IBOutlet UITextField *scanTuo;
@property (weak, nonatomic) IBOutlet UITableView *tuoTable;
- (IBAction)pressNavigation:(id)sender;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *navigationButton;
@end

@implementation YunChooseTuoViewController

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
    self.scanTuo.delegate=self;
    self.tuoTable.dataSource=self;
    self.tuoTable.delegate=self;
    if(!self.yun){
        self.yun=[[Yun alloc] init];
    }
    if([self.type isEqualToString:@"yunEdit"]){
        self.navigationItem.rightBarButtonItem.title=self.barTitle;
    }
    UINib *nib=[UINib nibWithNibName:@"TuoTableViewCell" bundle:nil];
    [self.tuoTable registerNib:nib forCellReuseIdentifier:@"tuoCell"];
}
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
//    [[Captuvo sharedCaptuvoDevice] removeCaptuvoDelegate:self];
    [[Captuvo sharedCaptuvoDevice] addCaptuvoDelegate:self];
//    [[Captuvo sharedCaptuvoDevice] startDecoderHardware];
    [self.scanTuo becomeFirstResponder];
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
#pragma can delegate
-(void)decoderDataReceived:(NSString *)data
{
    //扫描托清单号看是否能加入，能加入就加入
    AFNetOperate *AFNet=[[AFNetOperate alloc] init];
    AFHTTPRequestOperationManager *manager=[AFNet generateManager:self.view];
    [manager POST:[AFNet yun_add_tuo_by_scan]
      parameters:@{@"forklift_id":data}
         success:^(AFHTTPRequestOperation *operation, id responseObject) {
             [AFNet.activeView stopAnimating];
             if([responseObject[@"result"] integerValue]==1){
                 if([(NSDictionary *)responseObject[@"content"] count]>0){
                     Tuo *tuo=[[Tuo alloc] initWithObject:responseObject[@"content"]];
                     [self.yun.tuoArray addObject:tuo];
                     [self.tuoTable reloadData];
                 }
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
#pragma tableDelegate

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.yun.tuoArray count];
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    Tuo *tuo=[self.yun.tuoArray objectAtIndex:indexPath.row];
    TuoTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"tuoCell" forIndexPath:indexPath];
    cell.idLabel.text=tuo.ID;
    cell.departmentLabel.text=tuo.department;
    cell.agentLabel.text=tuo.agent;
    return cell;
}
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [self.yun.tuoArray removeObjectAtIndex:indexPath.row];
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }
}

#pragma textField delegate
-(void)textFieldDidBeginEditing:(UITextField *)textField
{
    UIView* dummyView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 1, 1)];
    textField.inputView = dummyView;
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [self.tuoTable reloadData];
    
//    AFNetOperate *AFNet=[[AFNetOperate alloc] init];
//    AFHTTPRequestOperationManager *manager=[AFNet generateManager:self.view];
//    NSLog(@"%@",[AFNet yun_add_tuo_by_scan]);
//    [manager POST:[AFNet yun_add_tuo_by_scan]
//       parameters:@{@"forklift_id":@"F1402893937814"}
//          success:^(AFHTTPRequestOperation *operation, id responseObject) {
//              [AFNet.activeView stopAnimating];
//              if([responseObject[@"result"] integerValue]==1){
//                  Tuo *tuo=[[Tuo alloc] initWithObject:responseObject[@"content"]];
//                  [self.yun.tuoArray addObject:tuo];
//                  [self.tuoTable reloadData];
//              }
//              else{
//                  [AFNet alert:responseObject[@"content"]];
//              }
//              
//          }
//          failure:^(AFHTTPRequestOperation *operation, NSError *error) {
//              [AFNet.activeView stopAnimating];
//              [AFNet alert:[NSString stringWithFormat:@"%@",[error localizedDescription]]];
//          }
//     ];
    
    
    return YES;
}


-(IBAction)unwindYunChoose:(UIStoryboardSegue *)unwindSegue
{
    [self.tuoTable reloadData];
}
-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if([segue.identifier isEqualToString:@"toChoose"]){
        YunHaveTuoTableViewController *yunHave=segue.destinationViewController;
        yunHave.yun=self.yun;
    }
    else if([segue.identifier isEqualToString:@"nextStep"]){
        YunInfoViewController *yunInfo=segue.destinationViewController;
        yunInfo.yun=self.yun;
    }
    
}
- (IBAction)pressNavigation:(id)sender {
    if([self.navigationButton.title isEqualToString:@"下一步"]){
        [self performSegueWithIdentifier:@"nextStep" sender:self];
    }
    else if([self.navigationButton.title isEqualToString:self.barTitle]){
        //修改未发送的运单时点击完成更改，添加新的拖到箱里
        NSMutableArray *tuoIDArray=[[NSMutableArray alloc] init];
        for(int i=0;i<self.yun.tuoArray.count;i++){
            NSString *ID=[self.yun.tuoArray[i] ID];
            [tuoIDArray addObject:ID];
        }
        AFNetOperate *AFNet=[[AFNetOperate alloc] init];
        AFHTTPRequestOperationManager *manager=[AFNet generateManager:self.view];
        [manager POST:[AFNet yun_add_tuo]
           parameters:@{@"id":self.yunTarget.ID,@"forklifts":tuoIDArray}
              success:^(AFHTTPRequestOperation *operation, id responseObject) {
                  [AFNet.activeView stopAnimating];
                  if([responseObject[@"result"] integerValue]==1){
                      for(int i=0;i<self.yun.tuoArray.count;i++){
                          [self.yunTarget.tuoArray addObject:self.yun.tuoArray[i]];
                      }
                      [self.navigationController popViewControllerAnimated:YES];
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
//        [self.navigationController popViewControllerAnimated:YES];
    }
}
@end
