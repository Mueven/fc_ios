//
//  SettingRemarkTableViewController.m
//  Material
//
//  Created by wayne on 14/11/30.
//  Copyright (c) 2014年 brilliantech. All rights reserved.
//

#import "SettingRemarkTableViewController.h"
#import "AFNetOperate.h"
#import "ScanStandard.h"
@interface SettingRemarkTableViewController ()
@property(nonatomic,strong)ScanStandard *scanStandard;
@property(nonatomic,strong)NSArray *ruleArray;
@property(nonatomic,strong)NSArray *typeArray;
@end

@implementation SettingRemarkTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    self.scanStandard=[ScanStandard sharedScanStandard];
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"cell"];
    AFNetOperate *operate=[[AFNetOperate alloc] init];
    NSString *validateString=[operate scan_validate];
    AFHTTPRequestOperationManager *manager=[AFHTTPRequestOperationManager manager];
    [manager GET:validateString
      parameters:nil
         success:^(AFHTTPRequestOperation *operation, id responseObject) {
             NSArray *result=responseObject;
             if([result count]>0){
                 self.ruleArray=result;
                 [self.tableView reloadData];
             }
         }
         failure:^(AFHTTPRequestOperation *operation, NSError *error) {
         }
     ];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    return [self.ruleArray count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    NSDictionary *item=self.ruleArray[indexPath.row];
    cell.textLabel.text=item[@"name"];
    NSString *id=[[[AFNetOperate alloc] init] getKeyArchive:@"com.brilliantech.rules.remark" key:@"id"];
    if([id isEqualToString:item[@"id"]]){
        cell.accessoryType=UITableViewCellAccessoryCheckmark;
    }
    else{
        cell.accessoryType=UITableViewCellAccessoryNone;
    }
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell=(UITableViewCell *)[tableView cellForRowAtIndexPath:indexPath];
    NSDictionary *item=self.ruleArray[indexPath.row];
    if(cell.accessoryType==UITableViewCellAccessoryNone){
        [self.scanStandard updateRule:item[@"id"] type:[NSString stringWithFormat:@"%@",item[@"type"]] regex:self.ruleArray];
        [self.tableView reloadData];
    }
}

@end
