//
//  YunSendedViewController.m
//  Material
//
//  Created by wayne on 14-6-15.
//  Copyright (c) 2014年 brilliantech. All rights reserved.
//

#import "YunSendedViewController.h"
#import "Tuo.h"
#import "YunCheckXiangTableViewController.h"
#import "Xiang.h"
#import "AFNetOperate.h"

@interface YunSendedViewController ()<UITableViewDataSource,UITableViewDelegate>
@property (weak, nonatomic) IBOutlet UILabel *remarkLabel;
@property (weak, nonatomic) IBOutlet UITableView *tuoTable;
- (IBAction)printYun:(id)sender;

@end

@implementation YunSendedViewController

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
    self.remarkLabel.text=self.yun.remark;
    self.remarkLabel.adjustsFontSizeToFitWidth=YES;
    self.tuoTable.delegate=self;
    self.tuoTable.dataSource=self;
    self.navigationItem.title=self.yun.name;
}
-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
//    [[Captuvo sharedCaptuvoDevice] stopDecoderHardware];
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
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
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"tuoCell"];
    cell.textLabel.text=tuo.department ;
    cell.detailTextLabel.text=[NSString stringWithFormat:@"%@   %@",tuo.date,tuo.agent];
    cell.accessoryType=UITableViewCellAccessoryDisclosureIndicator;
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    Tuo *tuo=[self.yun.tuoArray objectAtIndex:indexPath.row];
    AFNetOperate *AFNet=[[AFNetOperate alloc] init];
    AFHTTPRequestOperationManager *manager=[AFNet generateManager:self.view];
    [manager GET:[AFNet tuo_single]
      parameters:@{@"id":tuo.ID}
         success:^(AFHTTPRequestOperation *operation, id responseObject) {
             [AFNet.activeView stopAnimating];
             if([responseObject[@"result"] integerValue]==1){
                    if([(NSDictionary *)responseObject[@"content"] count]>0){
                        NSArray *xiangArray=[responseObject[@"content"] objectForKey:@"packages"];
                        [tuo.xiang removeAllObjects];
                        for(int i=0;i<xiangArray.count;i++){
                            Xiang *xiangItem=[[Xiang alloc] initWithObject:xiangArray[i]];
                            [tuo.xiang addObject:xiangItem];
                        }
                        [self performSegueWithIdentifier:@"checkXiang" sender:@{@"tuo":tuo}];
                    }
                 
             }
             else{
                 [AFNet alert:responseObject[@"content"]];
             }
             
         }
         failure:^(AFHTTPRequestOperation *operation, NSError *error) {
             [AFNet.activeView stopAnimating];
             [AFNet alert:@"sth wrong"];
         }
     ];
    
    
//    [self performSegueWithIdentifier:@"checkXiang" sender:@{@"tuo":tuo}];
}

#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    if([segue.identifier isEqualToString:@"checkXiang"]){
        YunCheckXiangTableViewController *checkXiang=segue.destinationViewController;
        checkXiang.tuo=[sender objectForKey:@"tuo"];
    }
}


- (IBAction)printYun:(id)sender {
    AFNetOperate *AFNet=[[AFNetOperate alloc] init];
    AFHTTPRequestOperationManager *manager=[AFNet generateManager:self.view];
    [manager GET:[AFNet print_stock_yun:self.yun.ID]
      parameters:nil
         success:^(AFHTTPRequestOperation *operation, id responseObject) {
             [AFNet.activeView stopAnimating];
             if([responseObject[@"result"] integerValue]==1){
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
@end
