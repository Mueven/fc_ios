//
//  XiangTableViewController.m
//  Material
//
//  Created by wayne on 14-6-8.
//  Copyright (c) 2014年 brilliantech. All rights reserved.
//

#import "XiangTableViewController.h"
#import "TuoScanViewController.h"
#import "XiangStore.h"
#import "Xiang.h"
#import "HuoTableViewCell.h"
#import "XiangEditViewController.h"

@interface XiangTableViewController ()
@property (nonatomic , strong) XiangStore *xiangStore;
@end

@implementation XiangTableViewController

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
    
//    UIActivityIndicatorView *spinner = [[UIActivityIndicatorView alloc]
//                                        initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
//    spinner.center = self.;
//    spinner.hidesWhenStopped = YES;
//    [self.view addSubview:spinner];
//    [spinner startAnimating];
    
    
}
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.xiangStore=[XiangStore sharedXiangStore:self.view];
    [self.tableView reloadData];
 
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
    return [self.xiangStore xiangCount];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    HuoTableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:@"xiangCell"];
    Xiang *xiang=[[self.xiangStore xiangList] objectAtIndex:indexPath.row];
    cell.leoniNumber.text=xiang.number;
    cell.kwyNumber.text=xiang.key;
    cell.extraInfo.text=[NSString stringWithFormat:@"Q%@ / %@",xiang.count,xiang.position];
    cell.leoniNumber.adjustsFontSizeToFitWidth=YES;
    cell.kwyNumber.adjustsFontSizeToFitWidth=YES;
    cell.extraInfo.adjustsFontSizeToFitWidth=YES;
    return cell;
}

#pragma mark - Navigation
-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if([segue.identifier isEqualToString:@"bundleXiang"]){
        TuoScanViewController *scan=segue.destinationViewController;
        scan.type=@"xiang";
    }
    else if([segue.identifier isEqualToString:@"fromXiang"]){
        int row=[[self.tableView indexPathForCell:sender] row];
        XiangEditViewController *xiangEdit=segue.destinationViewController;
        xiangEdit.xiang=[[self.xiangStore xiangList] objectAtIndex:row];
    }
}


// Override to support conditional editing of the table view.
//- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
//{
    // Return NO if you do not want the specified item to be editable.
//    return YES;
//}



// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [self.xiangStore removeXiang:indexPath.row];
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
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



@end
