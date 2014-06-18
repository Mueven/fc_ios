//
//  HistoryYunTableViewController.m
//  Material
//
//  Created by wayne on 14-6-10.
//  Copyright (c) 2014年 brilliantech. All rights reserved.
//

#import "HistoryYunTableViewController.h"
#import "Yun.h"
#import "Tuo.h"
#import "HistoryTuoTableViewController.h"
#import "AFNetOperate.h"

@interface HistoryYunTableViewController ()

@end

@implementation HistoryYunTableViewController

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
    self.navigationItem.title=self.chooseDate;
    
//    self.yunArray=[[NSMutableArray alloc] init];
//    for(int i=0;i<3;i++){
//        Yun *yun=[[Yun alloc] initExample];
//        for(int i=0;i<10;i++){
//            Tuo *tuo=[[Tuo alloc] initExample];
//            [yun.tuoArray addObject:tuo];
//        }
//        [self.yunArray addObject:yun];
//    }
//    

}
-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [[Captuvo sharedCaptuvoDevice] stopDecoderHardware];
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
    return [self.yunArray count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"yunCell" forIndexPath:indexPath];
    Yun *yun=[self.yunArray objectAtIndex:indexPath.row];
    cell.textLabel.text=yun.name;
    // Configure the cell...
    
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    Yun *yun=[self.yunArray objectAtIndex:indexPath.row];
    AFNetOperate *AFNet=[[AFNetOperate alloc] init];
    AFHTTPRequestOperationManager *manager=[AFNet generateManager:self.view];
    [manager GET:[AFNet yun_single]
      parameters:@{@"id":yun.ID}
         success:^(AFHTTPRequestOperation *operation, id responseObject) {
             [AFNet.activeView stopAnimating];
             if([responseObject[@"result"] integerValue]==1){
                 if([(NSDictionary *)responseObject[@"content"] count]>0){
                     NSArray *tuoArray=[responseObject[@"content"] objectForKey:@"forklifts"];
                     [yun.tuoArray removeAllObjects];
                     
                     for(int i=0;i<tuoArray.count;i++){
                         Tuo *tuoItem=[[Tuo alloc] initWithObject:tuoArray[i]];
                         [yun.tuoArray addObject:tuoItem];
                     }
                     [self performSegueWithIdentifier:@"checkTuo" sender:@{@"yun":yun}];
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
    if([segue.identifier isEqualToString:@"checkTuo"]){
        HistoryTuoTableViewController *historyTuo=segue.destinationViewController;
        historyTuo.yun=[sender objectForKey:@"yun"];
    }
}


@end
