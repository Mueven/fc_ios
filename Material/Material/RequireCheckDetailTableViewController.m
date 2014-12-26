//
//  RequireCheckDetailTableViewController.m
//  Material
//
//  Created by wayne on 14-12-26.
//  Copyright (c) 2014年 brilliantech. All rights reserved.
//

#import "RequireCheckDetailTableViewController.h"
#import "RequireCheckDetailTableViewCell.h"
#import "RequireXiang.h"
@interface RequireCheckDetailTableViewController ()
@property(nonatomic,strong)NSArray *requireXiangArray;
@end

@implementation RequireCheckDetailTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    UINib *nib=[UINib nibWithNibName:@"RequireCheckDetailTableViewCell" bundle:nil];
    [self.tableView registerNib:nib forCellReuseIdentifier:@"cell"];
    self.requireXiangArray=self.item[@"xiangArray"];
    [self.tableView reloadData];
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
    return [self.requireXiangArray count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    RequireCheckDetailTableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    RequireXiang *requireXiang=self.requireXiangArray[indexPath.row];
    cell.partNumberLabel.text=requireXiang.partNumber;
    cell.countLabel.text=requireXiang.quantity_int;
    cell.prepareStateLabel.text=requireXiang.is_finished_text;
    cell.stockStateLabel.text=requireXiang.out_of_stock_text;
    if(requireXiang.urgent){
        cell.emergencyMark.hidden=NO;
    }
    else{
        cell.emergencyMark.hidden=YES;
    }
    return cell;
}



@end
