//
//  YunTableViewController.m
//  Material
//
//  Created by wayne on 14-6-5.
//  Copyright (c) 2014年 brilliantech. All rights reserved.
//

#import "YunTableViewController.h"
#import "YunStore.h"
#import "Yun.h"
#import "YunEditViewController.h"
#import "YunTableViewCell.h"
#import "AFNetOperate.h"

@interface YunTableViewController ()
@property (nonatomic,strong)YunStore *yunStore;
@end

@implementation YunTableViewController

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
    UINib *nib=[UINib nibWithNibName:@"YunTableViewCell" bundle:nil];
    [self.tableView registerNib:nib forCellReuseIdentifier:@"yunCell"];
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
   
}
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    //得到数据
    YunStore *yunStore=[[YunStore alloc] init];
    yunStore.yunArray=[[NSMutableArray alloc] init];
    NSDateFormatter *formatter=[[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-MM-dd'T'HH:mm:ssZZZZZ"];
    NSString *questDate=[formatter stringFromDate:[NSDate date]];
    AFNetOperate *AFNet=[[AFNetOperate alloc] init];
    AFHTTPRequestOperationManager *manager=[AFNet generateManager:self.view];
    [manager GET:[AFNet yun_root]
      parameters:@{@"delivery_date":questDate}
         success:^(AFHTTPRequestOperation *operation, id responseObject) {
             [AFNet.activeView stopAnimating];
             NSArray *resultArray=responseObject;
             for(int i=0;i<[resultArray count];i++){
                 Yun *yun=[[Yun alloc] initWithObject:resultArray[i]];
                 [yunStore.yunArray addObject:yun];
             }
             self.yunStore=yunStore;
             [self.tableView reloadData];
         }
         failure:^(AFHTTPRequestOperation *operation, NSError *error) {
             [AFNet.activeView stopAnimating];
             [AFNet alert:@"something wrong"];
         }
     ];
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
    return [self.yunStore.yunArray count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    YunTableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:@"yunCell" forIndexPath:indexPath];
    Yun *yun=[self.yunStore.yunArray objectAtIndex:indexPath.row];
    cell.nameLabel.text=yun.name;
    cell.dateLabel.text=yun.date;
    if(yun.sended){
        cell.statusLabel.text=@"已发送";
    }
    else{
        cell.statusLabel.text=@"未发送";
        [cell.statusLabel setTextColor:[UIColor redColor]];
    }
    return cell;
}


/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/


// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        AFNetOperate *AFNet=[[AFNetOperate alloc] init];
        AFHTTPRequestOperationManager *manager=[AFNet generateManager:self.view];
        NSString *ID=[[self.yunStore.yunArray objectAtIndex:indexPath.row] ID];
        [manager DELETE:[AFNet tuo_edit:ID]
             parameters:nil
                success:^(AFHTTPRequestOperation *operation, id responseObject) {
                    [AFNet.activeView stopAnimating];
                    if(responseObject[@"result"]){
                        [self.yunStore.yunArray removeObjectAtIndex:indexPath.row];
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
//        [self.yunStore.yunArray removeObjectAtIndex:indexPath.row];
//        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}


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
    if([segue.identifier isEqualToString:@"yunEdit"]){
        YunEditViewController *yunEdit=segue.destinationViewController;
        yunEdit.yun=[self.yunStore.yunArray objectAtIndex:[[self.tableView indexPathForCell:sender] row]];
    }
}

-(IBAction)unwindToYunTable:(UIStoryboardSegue *)unwind{
    [self.tableView reloadData];
}
@end
