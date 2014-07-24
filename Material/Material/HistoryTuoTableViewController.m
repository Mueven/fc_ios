//
//  HistoryTuoTableViewController.m
//  Material
//
//  Created by wayne on 14-6-10.
//  Copyright (c) 2014年 brilliantech. All rights reserved.
//

#import "HistoryTuoTableViewController.h"
#import "ShopTuoTableViewCell.h"
#import "Tuo.h"
#import "Xiang.h"
#import "HistoryXiangTableViewController.h"
#import "AFNetOperate.h"
#import "ReceivePrintViewController.h"
@interface HistoryTuoTableViewController ()
- (IBAction)printYun:(id)sender;

@end

@implementation HistoryTuoTableViewController

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
    self.navigationItem.title=self.yun.name;
    UINib *itemCell=[UINib nibWithNibName:@"ShopTuoTableViewCell"  bundle:nil];
    [self.tableView registerNib:itemCell  forCellReuseIdentifier:@"tuoCell"];
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

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return [self.yun.tuoArray count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    ShopTuoTableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:@"tuoCell" forIndexPath:indexPath];
    Tuo *tuo=[self.yun.tuoArray objectAtIndex:indexPath.row];
    cell.nameLabel.text=tuo.ID;
    cell.dateLabel.text=tuo.department;
    cell.conditionLabel.text=[NSString stringWithFormat:@"%d / %d",tuo.accepted_packages,tuo.sum_packages];
    if(tuo.accepted_packages==tuo.sum_packages){
        [cell.conditionLabel setTextColor:[UIColor colorWithRed:68.0/255.0 green:178.0/255.0 blue:29.0/255.0 alpha:1.0]];
    }
    else{
        [cell.conditionLabel setTextColor:[UIColor redColor]];
    }
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
                     NSDictionary *result=responseObject[@"content"];
                     NSArray *xiangList=result[@"packages"];
                     [tuo.xiang removeAllObjects];
                     for(int i=0;i<xiangList.count;i++){
                         NSLog(@"xiang:%@",xiangList[i]);
                         Xiang *xiang=[[Xiang alloc] initWithObject:xiangList[i]];
                         [tuo.xiang addObject:xiang];
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
             [AFNet alert:@"something wrong"];
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
    if([segue.identifier isEqualToString:@"checkXiang"]){
        HistoryXiangTableViewController *historyXiang=segue.destinationViewController;
        historyXiang.tuo=[sender objectForKey:@"tuo"];
    }
    else if([segue.identifier isEqualToString:@"printYun"]){
        ReceivePrintViewController *print=segue.destinationViewController;
        print.yun=self.yun;
        print.type=@"history";
    }
}


- (IBAction)printYun:(id)sender {
    [self performSegueWithIdentifier:@"printYun" sender:self];
}
@end
