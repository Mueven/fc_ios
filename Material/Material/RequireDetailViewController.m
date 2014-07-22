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

@interface RequireDetailViewController ()<UITableViewDataSource,UITableViewDelegate>
@property (weak, nonatomic) IBOutlet UILabel *departmentTextField;
@property (weak, nonatomic) IBOutlet UITableView *xiangTable;
@property (strong,nonatomic) NSMutableArray *xiangArray;
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
    self.xiangArray=[[NSMutableArray alloc] init];
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
    return cell;
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
}


- (IBAction)print:(id)sender {
    [self performSegueWithIdentifier:@"printFromDetail" sender:@{@"type":@"detail"}];
}
@end
