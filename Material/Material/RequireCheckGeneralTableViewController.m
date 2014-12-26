//
//  RequireCheckGeneralTableViewController.m
//  Material
//
//  Created by wayne on 14-12-26.
//  Copyright (c) 2014年 brilliantech. All rights reserved.
//

#import "RequireCheckGeneralTableViewController.h"
#import "RequireCheckGeneralTableViewCell.h"
#import "RequireCheckDetailTableViewController.h"
@interface RequireCheckGeneralTableViewController ()

@end

@implementation RequireCheckGeneralTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    UINib *nib=[UINib nibWithNibName:@"RequireCheckGeneralTableViewCell" bundle:nil];
    [self.tableView registerNib:nib forCellReuseIdentifier:@"cell"];
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
    return [self.xiangArray count];
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    RequireCheckGeneralTableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    NSDictionary *item=self.xiangArray[indexPath.row];
    cell.partNumberLabel.text=item[@"partNumber"];
    cell.xiangCountLabel.text=item[@"xiangCount"];
    cell.partCountLabel.text=item[@"partCount"];
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSDictionary *item=self.xiangArray[indexPath.row];
    [self performSegueWithIdentifier:@"detail" sender:@{@"item":item}];
}
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    if([segue.identifier isEqualToString:@"detail"]){
        RequireCheckDetailTableViewController *vc=segue.destinationViewController;
        vc.item=sender[@"item"];
    }
}

@end
