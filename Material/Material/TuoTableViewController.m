//
//  TuoTableViewController.m
//  Material
//
//  Created by wayne on 14-6-5.
//  Copyright (c) 2014年 brilliantech. All rights reserved.
//

#import "TuoTableViewController.h"
#import "TuoStore.h"
#import "Tuo.h"
#import "TuoEditViewController.h"
#import "AFNetOperate.h"
#import "Xiang.h"
#import "TuoTableViewCell.h"

@interface TuoTableViewController ()
@property(nonatomic,strong)TuoStore *tuoStore;
@end

@implementation TuoTableViewController

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
    UINib *nib=[UINib nibWithNibName:@"TuoTableViewCell" bundle:nil];
    [self.tableView registerNib:nib forCellReuseIdentifier:@"tuoCell"];
}
-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
//    [[Captuvo sharedCaptuvoDevice] stopDecoderHardware];

}

-(void)viewWillAppear:(BOOL)animated
{

    [super viewWillAppear:animated];

    //得到数据
    TuoStore *tuoStore=[[TuoStore alloc] init];
    tuoStore.listArray=[[NSMutableArray alloc] init];
    AFNetOperate *AFNet=[[AFNetOperate alloc] init];
    [AFNet.activeView stopAnimating];
    AFHTTPRequestOperationManager *manager=[AFNet generateManager:self.view];
    [manager GET:[AFNet tuo_root]
      parameters:nil
         success:^(AFHTTPRequestOperation *operation, id responseObject) {
             [AFNet.activeView stopAnimating];
             NSArray *resultArray=responseObject;
             for(int i=0;i<[resultArray count];i++){
                 Tuo *tuo=[[Tuo alloc] initWithObject:resultArray[i]];
//                 NSLog(@"%@",resultArray[i]);
                 [tuoStore.listArray addObject:tuo];
             }
             self.tuoStore=tuoStore;
             [self.tableView reloadData];
         }
         failure:^(AFHTTPRequestOperation *operation, NSError *error) {
             [AFNet.activeView stopAnimating];
             [AFNet alert:[NSString stringWithFormat:@"%@",[error localizedDescription]]];
         }
     ];
    UITabBarController *tabber= self.tabBarController;
    tabber.selectedIndex=1;
//    self.tuoStore=[TuoStore sharedTuoStore:self.tableView];
//    [self.tableView reloadData];
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
    Tuo *tuo=[[self.tuoStore tuoList] objectAtIndex:indexPath.row];
    TuoTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"tuoCell" forIndexPath:indexPath];
    cell.idLabel.text=tuo.ID;
    cell.departmentLabel.text=tuo.department;
    cell.agentLabel.text=tuo.agent;
    cell.accessoryType=UITableViewCellAccessoryDisclosureIndicator;
    return cell;
}

//unwind
- (IBAction)unwindToTuoTable:(UIStoryboardSegue *)unwindSegue{
    [self.tableView reloadData];
    UITabBarController *tabber= self.tabBarController;
    tabber.selectedIndex=1;
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
        AFNetOperate *AFNet=[[AFNetOperate alloc] init];
        AFHTTPRequestOperationManager *manager=[AFNet generateManager:self.view];
        NSString *ID=[[self.tuoStore.tuoList objectAtIndex:indexPath.row] ID];
        [manager DELETE:[AFNet tuo_index]
             parameters:@{@"id":ID}
                success:^(AFHTTPRequestOperation *operation, id responseObject) {
                    [AFNet.activeView stopAnimating];
                    if([responseObject[@"result"] integerValue]==1){
                        [self.tuoStore removeTuo:indexPath.row];
                        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
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
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    Tuo *tuo=[self.tuoStore.tuoList objectAtIndex:indexPath.row];
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
                     for(int i=0;i<xiangList.count;i++){
                         Xiang *xiang=[[Xiang alloc] initWithObject:xiangList[i]];
                         [tuo.xiang addObject:xiang];
                     }
                     [self performSegueWithIdentifier:@"tuoEdit" sender:@{@"tuo":tuo}];
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

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/
-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if([segue.identifier isEqualToString:@"tuoEdit"]){
        TuoEditViewController *tuoEdit=segue.destinationViewController;
        tuoEdit.tuo=[sender objectForKey:@"tuo"];
    }
}

@end
