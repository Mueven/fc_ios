//
//  TuoPrintViewController.m
//  Material
//
//  Created by wayne on 14-6-8.
//  Copyright (c) 2014年 brilliantech. All rights reserved.
//

#import "TuoPrintViewController.h"
#import "HuoTableViewCell.h"
#import "Xiang.h"

@interface TuoPrintViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UILabel *departmentLabel;
@property (weak, nonatomic) IBOutlet UILabel *agentLabel;
@property (weak, nonatomic) IBOutlet UITableView *xiangTable;

@end

@implementation TuoPrintViewController

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
    self.xiangTable.delegate=self;
    self.xiangTable.dataSource=self;
    // Do any additional setup after loading the view.
}
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.departmentLabel.text=self.tuo.department;
    self.agentLabel.text=[NSString stringWithFormat:@"%@   %@",self.tuo.date,self.tuo.agent];
    self.departmentLabel.adjustsFontSizeToFitWidth=YES;
    self.agentLabel.adjustsFontSizeToFitWidth=YES;
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
    return [self.tuo xiangAmount];
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    HuoTableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:@"xiangCell"];
    Xiang *xiang=[[self.tuo xiang] objectAtIndex:indexPath.row];
    cell.leoniNumber.text=xiang.number;
    cell.kwyNumber.text=xiang.key;
    cell.extraInfo.text=[NSString stringWithFormat:@"Q%@ / %@",xiang.count,xiang.position];
    cell.leoniNumber.adjustsFontSizeToFitWidth=YES;
    cell.kwyNumber.adjustsFontSizeToFitWidth=YES;
    cell.extraInfo.adjustsFontSizeToFitWidth=YES;
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
