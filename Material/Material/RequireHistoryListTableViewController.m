//
//  RequireHistoryListTableViewController.m
//  Material
//
//  Created by wayne on 14-7-22.
//  Copyright (c) 2014年 brilliantech. All rights reserved.
//

#import "RequireHistoryListTableViewController.h"
#import "RequireBill.h"
#import "RequireListTableViewCell.h"
#import "AFNetOperate.h"
#import "RequireXiang.h"
#import "RequireDetailViewController.h"

@interface RequireHistoryListTableViewController ()

@end

@implementation RequireHistoryListTableViewController

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    UINib *nib=[UINib nibWithNibName:@"RequireListTableViewCell" bundle:nil];
    [self.tableView registerNib:nib forCellReuseIdentifier:@"cell"];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
 
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
 
    // Return the number of rows in the section.
    return [self.billArray count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    RequireListTableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    RequireBill *bill=self.billArray[indexPath.row];
    cell.dateLabel.text=bill.date;
    cell.departmentLabel.text=bill.department;
    cell.statusLabel.text=bill.status;
    // Configure the cell...
    cell.accessoryType=UITableViewCellAccessoryDisclosureIndicator;
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    RequireBill *bill=self.billArray[indexPath.row];
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
                 [self performSegueWithIdentifier:@"historyXiang" sender:@{@"billName":bill.date,@"xiangArray":itemArray}];
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

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    if([segue.identifier isEqualToString:@"historyXiang"]){
        RequireDetailViewController *requireDetail=segue.destinationViewController;
        requireDetail.billName=[sender objectForKey:@"billName"];
        requireDetail.xiangArray=[sender objectForKey:@"xiangArray"];
    }
}


@end
