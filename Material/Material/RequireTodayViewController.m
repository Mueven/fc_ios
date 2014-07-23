//
//  RequireTodayViewController.m
//  Material
//
//  Created by wayne on 14-7-21.
//  Copyright (c) 2014年 brilliantech. All rights reserved.
//

#import "RequireTodayViewController.h"
#import "RequireListTableViewCell.h"
#import "RequireBill.h"
#import "RequireXiang.h"
#import "RequireDetailViewController.h"
#import "AFNetOperate.h"

@interface RequireTodayViewController ()<UITableViewDataSource,UITableViewDelegate>
- (IBAction)requireGenerate:(id)sender;
@property (weak, nonatomic) IBOutlet UITableView *billTable;
@property (strong ,  nonatomic)NSArray *billListArray;
@end

@implementation RequireTodayViewController

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
    UINib *nib=[UINib nibWithNibName:@"RequireListTableViewCell" bundle:nil];
    [self.billTable registerNib:nib forCellReuseIdentifier:@"billCell"];
    self.billTable.dataSource=self;
    self.billTable.delegate=self;
    self.billListArray=[NSArray array];
    
    NSDateFormatter *formatter=[[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-MM-dd'T'00:00:00ZZZZZ"];
    NSString *startDate=[formatter stringFromDate:[NSDate date]];
    [formatter setDateFormat:@"yyyy-MM-dd'T'HH:mm:ssZZZZZ"];
    NSString *endDate=[formatter stringFromDate:[NSDate date]];
    
    AFNetOperate *AFNet=[[AFNetOperate alloc] init];
    [AFNet.activeView stopAnimating];
    AFHTTPRequestOperationManager *manager=[AFNet generateManager:self.view];
    [AFNet.activeView stopAnimating];
     [manager GET:[AFNet order_history]
      parameters:@{@"start":startDate,@"end":endDate}
             success:^(AFHTTPRequestOperation *operation, id responseObject) {
                 [AFNet.activeView stopAnimating];
                 if([responseObject[@"result"] integerValue]==1){
                     NSMutableArray *billList=[[NSMutableArray alloc] init];
                     for(int i=0;i<5;i++){
                         NSDictionary *dic=responseObject[i];
                         RequireBill *bill=[[RequireBill alloc] initWithObject:dic];
                         [billList addObject:bill];
                         self.billListArray=[billList copy];
                     }
                     [self.billTable reloadData];
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
    
        
        //example
//        NSMutableArray *billList=[[NSMutableArray alloc] init];
//        for(int i=0;i<5;i++){
//            NSDictionary *dic=@{@"date":[NSString stringWithFormat:@"2014-08-0%d 18:00",i],
//                                @"department":@"MB",
//                                @"status":@"在途"};
//            RequireBill *bill=[[RequireBill alloc] initWithObject:dic];
//            [billList addObject:bill];
//            self.billListArray=[billList copy];
//            
//        }
//       [self.billTable reloadData];
    
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

    return [self.billListArray count];
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    RequireListTableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:@"billCell" forIndexPath:indexPath];
    RequireBill *bill=self.billListArray[indexPath.row];
    cell.dateLabel.text=bill.date;
    cell.departmentLabel.text=bill.department;
    cell.statusLabel.text=bill.status;
    cell.accessoryType=UITableViewCellAccessoryDisclosureIndicator;
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
     RequireBill *bill=self.billListArray[indexPath.row];
    AFNetOperate *AFNet=[[AFNetOperate alloc] init];
    [AFNet.activeView stopAnimating];
    AFHTTPRequestOperationManager *manager=[AFNet generateManager:self.view];
    [AFNet.activeView stopAnimating];
    [manager GET:[AFNet order_root]
      parameters:@{@"id":bill.id}
         success:^(AFHTTPRequestOperation *operation, id responseObject) {
             [AFNet.activeView stopAnimating];
             if([responseObject[@"result"] integerValue]==1){
                NSArray *order_items=(NSArray *)[responseObject[@"content"] objectForKey:@"order_items"];
                 NSMutableArray *itemArray=[[NSMutableArray alloc] init];
                 for(int i=0;i<[order_items count];i++){
                     RequireXiang *xiang=[[RequireXiang alloc] initWithObject:order_items[i]];
                     [itemArray addObject:xiang];
                 }
                [self performSegueWithIdentifier:@"requireDetail" sender:@{@"billName":bill.date,@"xiangArray":itemArray}];
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
    
//    [self performSegueWithIdentifier:@"requireDetail" sender:@{@"billName":bill.date}];
}
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if([segue.identifier isEqualToString:@"generateRequire"]){
        
    }
    else if([segue.identifier isEqualToString:@"requireDetail"]){
        RequireDetailViewController *requireDetail=segue.destinationViewController;
        requireDetail.billName=[sender objectForKey:@"billName"];
        requireDetail.xiangArray=[sender objectForKey:@"xiangArray"];
    }
}

- (IBAction)requireGenerate:(id)sender {
    [self performSegueWithIdentifier:@"generateRequire" sender:self];
}

-(IBAction)unwindToRequireList:(UIStoryboardSegue *)unwind{
    
}

@end
