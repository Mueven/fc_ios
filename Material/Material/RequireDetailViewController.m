//
//  RequireDetailViewController.m
//  Material
//
//  Created by wayne on 14-7-22.
//  Copyright (c) 2014年 brilliantech. All rights reserved.
//

#import "RequireDetailViewController.h"
#import "RequireXiangTableViewCell.h"
#import "RequireXiang.h"
#import "RequirePrintViewController.h"
#import "RequireXiangDetailViewController.h"


@interface RequireDetailViewController ()<UITableViewDataSource,UITableViewDelegate>
@property (weak, nonatomic) IBOutlet UITableView *xiangTable;
@property (weak, nonatomic) IBOutlet UILabel *statusLabel;
@property (weak, nonatomic) IBOutlet UILabel *xiangCountLabel;
- (IBAction)print:(id)sender;
@end

@implementation RequireDetailViewController

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
    self.navigationItem.title=self.billName;
    UINib *nib=[UINib nibWithNibName:@"RequireXiangTableViewCell" bundle:nil];
    [self.xiangTable registerNib:nib forCellReuseIdentifier:@"cell"];
    self.xiangTable.delegate=self;
    self.xiangTable.dataSource=self;
    self.statusLabel.text=self.status?@"已处理":@"未处理";
    if(self.status){
        [self.statusLabel setTextColor:[UIColor colorWithRed:75.0/255.0 green:156.0/255.0 blue:75.0/255.0 alpha:1.0]];
    }
    else{
        [self.statusLabel setTextColor:[UIColor redColor]];
    }
    self.xiangCountLabel.text=[NSString stringWithFormat:@"%d",[self.xiangArray count]];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma table delege
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
    RequireXiangTableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    RequireXiang *xiang=self.xiangArray[indexPath.row];

    cell.positionTextField.text=xiang.position;
    cell.partNumberTextField.text=xiang.partNumber;
    cell.quantityTextField.text=xiang.quantity;
    cell.urgentButton.hidden=YES;
    cell.clickCell=^(){};
    if(xiang.urgent){
        //加急状态下
        cell.backgroundColor=[UIColor colorWithRed:242.0/255.0 green:67.0/255.0 blue:67.0/255.0 alpha:0.3];
        cell.urgentButton.backgroundColor=[UIColor colorWithRed:242.0/255.0 green:67.0/255.0 blue:67.0/255.0 alpha:1.0];
        [cell.urgentButton setTitle:@"加急箱" forState:UIControlStateNormal];
        cell.urgentButton.hidden=NO;
    }
    else{
        //不加急状态
        cell.backgroundColor=[UIColor whiteColor];

    }
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    RequireXiang *xiang=self.xiangArray[indexPath.row];
    [self performSegueWithIdentifier:@"xiangDetail" sender:@{@"xiang":xiang}];
}

#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    if([segue.identifier isEqualToString:@"printFromDetail"]){
        RequirePrintViewController *print=segue.destinationViewController;
        print.type=[sender objectForKey:@"type"];
    }
    else if([segue.identifier isEqualToString:@"xiangDetail"]){
        RequireXiangDetailViewController *xiangDetail=segue.destinationViewController;
        xiangDetail.xiang=[sender objectForKey:@"xiang"];
        xiangDetail.invisible=1;
    }
}


- (IBAction)print:(id)sender {
    [self performSegueWithIdentifier:@"printFromDetail" sender:@{@"type":@"detail"}];
}
@end
