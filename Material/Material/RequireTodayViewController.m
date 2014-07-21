//
//  RequireTodayViewController.m
//  Material
//
//  Created by wayne on 14-7-21.
//  Copyright (c) 2014年 brilliantech. All rights reserved.
//

#import "RequireTodayViewController.h"
#import "RequireListTableViewCell.h"
#import "RequireBill.h"

@interface RequireTodayViewController ()<UITableViewDataSource,UITableViewDelegate>
- (IBAction)requireGenerate:(id)sender;
@property (weak, nonatomic) IBOutlet UITableView *billTable;
@property (strong ,  nonatomic)NSArray *billListArray;
@end

@implementation RequireTodayViewController

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
    UINib *nib=[UINib nibWithNibName:@"RequireListTableViewCell" bundle:nil];
    [self.billTable registerNib:nib forCellReuseIdentifier:@"billCell"];
    self.billTable.dataSource=self;
    self.billTable.delegate=self;
    self.billListArray=[NSArray array];
    dispatch_queue_t bill_list_queue=dispatch_queue_create("com.bill.list.pptalent", NULL);
    dispatch_async(bill_list_queue, ^{
        //example
        NSMutableArray *billList=[[NSMutableArray alloc] init];
        for(int i=0;i<5;i++){
            NSDictionary *dic=@{@"date":[NSString stringWithFormat:@"2014-08-0%d 18:00",i],
                                @"department":@"MB",
                                @"status":@"在途"};
            RequireBill *bill=[[RequireBill alloc] initWithObject:dic];
            [billList addObject:bill];
            self.billListArray=[billList copy];
            
        }
       
        dispatch_async(dispatch_get_main_queue(), ^{
             [self.billTable reloadData];
        });

    });
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

    return [self.billListArray count];
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    RequireListTableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:@"billCell" forIndexPath:indexPath];
    RequireBill *bill=self.billListArray[indexPath.row];
    cell.dateLabel.text=bill.date;
    cell.departmentLabel.text=bill.department;
    cell.statusLabel.text=bill.status;
    cell.accessoryType=UITableViewCellAccessoryDisclosureIndicator;
    return cell;
}

#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if([segue.identifier isEqualToString:@"generateRequire"]){
        
    }
}


- (IBAction)requireGenerate:(id)sender {
    [self performSegueWithIdentifier:@"generateRequire" sender:self];
}
@end
