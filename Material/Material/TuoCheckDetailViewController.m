//
//  TuoCheckDetailViewController.m
//  Material
//
//  Created by wayne on 14-8-19.
//  Copyright (c) 2014年 brilliantech. All rights reserved.
//

#import "TuoCheckDetailViewController.h"
#import "XiangTableViewCell.h"
#import "Xiang.h"

@interface TuoCheckDetailViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end

@implementation TuoCheckDetailViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationItem.title=self.partNumber;
    self.tableView.delegate=self;
    self.tableView.dataSource=self;
    UINib *nib=[UINib nibWithNibName:@"XiangTableViewCell" bundle:nil];
    [self.tableView registerNib:nib forCellReuseIdentifier:@"cell"];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.xiangArray count];
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    XiangTableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    Xiang *xiang=[self.xiangArray objectAtIndex:indexPath.row];
    cell.partNumber.text=xiang.number;
    cell.key.text=xiang.key;
    cell.quantity.text=xiang.count;
    cell.position.text=xiang.position;
    cell.date.text=xiang.date;
    cell.stateLabel.text=xiang.state_display;
    if(xiang.state==0){
        [cell.stateLabel setTextColor:[UIColor redColor]];
    }
    else if(xiang.state==1 || xiang.state==2){
        [cell.stateLabel setTextColor:[UIColor blueColor]];
    }
    else if(xiang.state==3){
        [cell.stateLabel setTextColor:[UIColor greenColor]];
    }
    else if(xiang.state==4){
        [cell.stateLabel setTextColor:[UIColor orangeColor]];
    }
    return cell;
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
