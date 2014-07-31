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
#import "YunSendedViewController.h"
#import "Tuo.h"

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
    
//    self.yunStore=[YunStore sharedYunStore:self.tableView];
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;

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
    YunStore *yunStore=[[YunStore alloc] init];
    yunStore.yunArray=[[NSMutableArray alloc] init];
     [self.tableView reloadData];
    NSDateFormatter *formatter=[[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-MM-dd'T'HH:mm:ssZZZZZ"];
    NSString *questDate=[formatter stringFromDate:[NSDate date]];
    AFNetOperate *AFNet=[[AFNetOperate alloc] init];
    AFHTTPRequestOperationManager *manager=[AFNet generateManager:self.view];
    [AFNet.activeView stopAnimating];
    [manager GET:[AFNet yun_root]
      parameters:@{@"delivery_date":questDate}
         success:^(AFHTTPRequestOperation *operation, id responseObject) {
             [AFNet.activeView stopAnimating];
//             NSLog(@"%@",responseObject);
              if([responseObject[@"result"] integerValue]==1){
                  NSArray *resultArray=responseObject[@"content"];
                  for(int i=0;i<[resultArray count];i++){
                      Yun *yun=[[Yun alloc] initWithObject:resultArray[i]];
                      [yunStore.yunArray addObject:yun];
                  }
                  self.yunStore=yunStore;
                  [self.tableView reloadData];

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
    if(yun.sended==0){
        cell.statusLabel.text=@"未发送";
        [cell.statusLabel setTextColor:[UIColor redColor]];
        
    }
    else if(yun.sended==1){
        cell.statusLabel.text=@"在途";
        [cell.statusLabel setTextColor:[UIColor colorWithRed:0.0/255.0 green:122.0/255.0 blue:255.0/255.0 alpha:1.0]];
    }
    else if(yun.sended==2){
        cell.statusLabel.text=@"到达";
        [cell.statusLabel setTextColor:[UIColor colorWithRed:0.0/255.0 green:122.0/255.0 blue:255.0/255.0 alpha:1.0]];
        
    }
    else if(yun.sended==3){
        cell.statusLabel.text=@"已接收";
        [cell.statusLabel setTextColor:[UIColor colorWithRed:75.0/255.0 green:156.0/255.0 blue:75.0/255.0 alpha:1.0]];
    }
    cell.accessoryType=UITableViewCellAccessoryDisclosureIndicator;
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    Yun *yun=[self.yunStore.yunArray objectAtIndex:indexPath.row];
    AFNetOperate *AFNet=[[AFNetOperate alloc] init];
    AFHTTPRequestOperationManager *manager=[AFNet generateManager:self.view];
    if(yun.sended){
        //查看
        [manager GET:[AFNet yun_single]
          parameters:@{@"id":yun.ID}
                success:^(AFHTTPRequestOperation *operation, id responseObject) {
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [AFNet.activeView stopAnimating];
                    });
                    if([responseObject[@"result"] integerValue]==1){
                        if([(NSDictionary *)responseObject[@"content"] count]>0){
                            yun.remark=[responseObject[@"content"] objectForKey:@"remark"];
                            NSArray *tuoArray=[responseObject[@"content"] objectForKey:@"forklifts"];
                            [yun.tuoArray removeAllObjects];
                            for(int i=0;i<tuoArray.count;i++){
                                Tuo *tuoItem=[[Tuo alloc] initWithObject:tuoArray[i]];
                                [yun.tuoArray addObject:tuoItem];
                            }
                            [self performSegueWithIdentifier:@"checkYun" sender:@{@"yun":yun}];
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
    else{
        //修改
        [manager GET:[AFNet yun_single]
          parameters:@{@"id":yun.ID}
             success:^(AFHTTPRequestOperation *operation, id responseObject) {
                 [AFNet.activeView stopAnimating];
                 if([responseObject[@"result"] integerValue]==1){
                     if([(NSDictionary *)responseObject[@"content"] count]>0){
                         yun.remark=[responseObject[@"content"] objectForKey:@"remark"];
                         yun.name=[responseObject[@"content"] objectForKey:@"id"];
                         NSArray *tuoArray=[responseObject[@"content"] objectForKey:@"forklifts"];
                         [yun.tuoArray removeAllObjects];
                         for(int i=0;i<tuoArray.count;i++){
                             Tuo *tuoItem=[[Tuo alloc] initWithObject:tuoArray[i]];
                             [yun.tuoArray addObject:tuoItem];
                         }
                         [self performSegueWithIdentifier:@"editYun" sender:@{@"yun":yun}];
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
        
        int row=indexPath.row;
        Yun *yunRetain=[[[Yun alloc] init] copyMe:[self.yunStore.yunArray objectAtIndex:row]];
        if(yunRetain.sended==0){
            dispatch_queue_t deleteRow=dispatch_queue_create("com.delete.row.pptalent", NULL);
            dispatch_async(deleteRow, ^{
                NSString *ID=[yunRetain ID];
                AFNetOperate *AFNet=[[AFNetOperate alloc] init];
                AFHTTPRequestOperationManager *manager=[AFNet generateManager:self.view];
                [AFNet.activeView stopAnimating];
                [manager DELETE:[AFNet yun_index]
                     parameters:@{@"id":ID}
                        success:^(AFHTTPRequestOperation *operation, id responseObject) {
                            [AFNet.activeView stopAnimating];
                            if([responseObject[@"result"] integerValue]==1){
                                
                            }
                            else{
                                [AFNet alert:responseObject[@"content"]];
                                [self viewWillAppear:YES];
                            }
                            
                        }
                        failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                            [AFNet.activeView stopAnimating];
                            [AFNet alert:[NSString stringWithFormat:@"%@",[error localizedDescription]]];
                            [self viewWillAppear:YES];
                        }
                 ];
            });
            [self.yunStore.yunArray removeObjectAtIndex:indexPath.row];
            [tableView cellForRowAtIndexPath:indexPath].alpha = 0.0;
            [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
        }
       
        
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
    if([segue.identifier isEqualToString:@"editYun"]){
        YunEditViewController *yunEdit=segue.destinationViewController;
        yunEdit.yun=[sender objectForKey:@"yun"];
    }
    else if([segue.identifier isEqualToString:@"checkYun"]){
        YunSendedViewController *yunCheck=segue.destinationViewController;
        yunCheck.yun=[sender objectForKey:@"yun"];
    }
}

-(IBAction)unwindToYunTable:(UIStoryboardSegue *)unwind{
    [self.tableView reloadData];
}
@end
