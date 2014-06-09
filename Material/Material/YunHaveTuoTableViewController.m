//
//  YunHaveTuoTableViewController.m
//  Material
//
//  Created by wayne on 14-6-9.
//  Copyright (c) 2014年 brilliantech. All rights reserved.
//

#import "YunHaveTuoTableViewController.h"
#import "TuoStore.h"
#import "Tuo.h"
#import "YunChooseTuoViewController.h"

@interface YunHaveTuoTableViewController ()
@property(nonatomic,strong)TuoStore *tuoStore;
@property(nonatomic,strong)NSMutableArray *privateTuo;
- (IBAction)finishChoose:(id)sender;
@end

@implementation YunHaveTuoTableViewController

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
    self.privateTuo=[self.yun.tuoArray mutableCopy];
    self.tuoStore=[TuoStore sharedTuoStore];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{

    return [self.tuoStore tuoCount];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"tuoCell"];
    cell.accessoryType=UITableViewCellAccessoryNone;
    Tuo *tuo=[self.tuoStore.tuoList objectAtIndex:indexPath.row];
    int count=[self.privateTuo count];
    for(int i=0;i<count;i++){
        if(tuo==[self.privateTuo objectAtIndex:i]){
            cell.accessoryType=UITableViewCellAccessoryCheckmark;
        }
    }
    cell.textLabel.text=tuo.department;
    cell.detailTextLabel.text=[NSString stringWithFormat:@"%@   %@",tuo.date,tuo.agent];;
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    Tuo *tuo=[self.tuoStore.tuoList objectAtIndex:indexPath.row];
    UITableViewCell *cell=[tableView cellForRowAtIndexPath:indexPath];
    if(cell.accessoryType==UITableViewCellAccessoryNone){
        cell.accessoryType=UITableViewCellAccessoryCheckmark;
        [self.privateTuo addObject:tuo];
    }
    else if(cell.accessoryType==UITableViewCellAccessoryCheckmark){
        cell.accessoryType=UITableViewCellAccessoryNone;
        [self.privateTuo removeObjectIdenticalTo:tuo];
    }
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
    if([segue.identifier isEqualToString:@"unwindToYunChoose"]){
        YunChooseTuoViewController *yunChoose=segue.destinationViewController;
        yunChoose.yun.tuoArray=[self.privateTuo mutableCopy];
    }
}

- (IBAction)finishChoose:(id)sender {
    [self performSegueWithIdentifier:@"unwindToYunChoose" sender:self];
}
@end
