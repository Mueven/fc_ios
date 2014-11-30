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
    self.navigationItem.title=self.vc_title;
    if(self.yun){
        self.navigationItem.rightBarButtonItem=[[UIBarButtonItem alloc] initWithTitle:@"打印"
                                                                                style:UIBarButtonItemStyleBordered
                                                                               target:self
                                                                               action:@selector(print)];
    }
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
    return [self.tuoArray count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    ShopTuoTableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:@"tuoCell" forIndexPath:indexPath];
    Tuo *tuo=[self.tuoArray objectAtIndex:indexPath.row];
    cell.nameLabel.text=tuo.container_id;
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
    Tuo *tuo=[self.tuoArray objectAtIndex:indexPath.row];
    AFNetOperate *AFNet=[[AFNetOperate alloc] init];
    AFHTTPRequestOperationManager *manager=[AFNet generateManager:self.view];
    [manager GET:[AFNet tuo_packages]
      parameters:@{@"id":tuo.ID}
         success:^(AFHTTPRequestOperation *operation, id responseObject) {
             if([responseObject[@"result"] integerValue]==1){
                 if([(NSArray *)responseObject[@"content"] count]>0){
                     NSArray *xiangList=responseObject[@"content"];
                     [tuo.xiang removeAllObjects];
                     for(int i=0;i<xiangList.count;i++){
                         Xiang *xiang=[[Xiang alloc] initWithObject:xiangList[i]];
                         [tuo.xiang addObject:xiang];
                     }
                     [self performSegueWithIdentifier:@"checkXiang" sender:@{
                                                                             @"tuo":tuo,
                                                                             @"xiangArray":tuo.xiang,
                                                                             @"title":tuo.container_id
                                                                             }];
                 }
             }
             else{
                 [AFNet alert:responseObject[@"content"]];
             }
             
         }
         failure:^(AFHTTPRequestOperation *operation, NSError *error) {
             [AFNet alert:@"something wrong"];
         }
     ];
}
-(void)print
{
    [self performSegueWithIdentifier:@"printYun" sender:self];
}


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    if([segue.identifier isEqualToString:@"checkXiang"]){
        HistoryXiangTableViewController *historyXiang=segue.destinationViewController;
        historyXiang.tuo=[sender objectForKey:@"tuo"];
        historyXiang.xiangArray=[sender objectForKey:@"xiangArray"];
        historyXiang.vc_title=[sender objectForKey:@"title"];
    }
    else if([segue.identifier isEqualToString:@"printYun"]){
        ReceivePrintViewController *print=segue.destinationViewController;
        print.container=self.yun;
        print.type=@"history_yun";
    }
}

@end
