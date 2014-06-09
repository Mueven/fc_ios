//
//  YunChooseTuoViewController.m
//  Material
//
//  Created by wayne on 14-6-9.
//  Copyright (c) 2014年 brilliantech. All rights reserved.
//

#import "YunChooseTuoViewController.h"
#import "Yun.h"
#import "Tuo.h"
#import "YunHaveTuoTableViewController.h"
#import "YunInfoViewController.h"

@interface YunChooseTuoViewController ()<UITextFieldDelegate,UITableViewDelegate,UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITextField *scanTuo;
@property (weak, nonatomic) IBOutlet UITableView *tuoTable;

@end

@implementation YunChooseTuoViewController

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
    self.scanTuo.delegate=self;
    self.tuoTable.dataSource=self;
    self.tuoTable.delegate=self;
    if(!self.yun){
        self.yun=[[Yun alloc] init];
    }
    if([self.type isEqualToString:@"yunEdit"]){
        self.navigationItem.rightBarButtonItem=NULL;
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma tableDelegate

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.yun.tuoArray count];
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:@"tuoCell"];
    Tuo *tuo=[self.yun.tuoArray objectAtIndex:indexPath.row];
    cell.textLabel.text=tuo.department;
    cell.detailTextLabel.text=[NSString stringWithFormat:@"%@   %@",tuo.date,tuo.agent];;
    return cell;
}
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [self.yun.tuoArray removeObjectAtIndex:indexPath.row];
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }
}

#pragma textField delegate
-(void)textFieldDidBeginEditing:(UITextField *)textField
{
    UIView* dummyView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 1, 1)];
    textField.inputView = dummyView;
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [self.tuoTable reloadData];
    return YES;
}


-(IBAction)unwindYunChoose:(UIStoryboardSegue *)unwindSegue
{
    [self.tuoTable reloadData];
}
-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if([segue.identifier isEqualToString:@"toChoose"]){
        YunHaveTuoTableViewController *yunHave=segue.destinationViewController;
        yunHave.yun=self.yun;
    }
    else if([segue.identifier isEqualToString:@"nextStep"]){
        YunInfoViewController *yunInfo=segue.destinationViewController;
        yunInfo.yun=self.yun;
    }
    
}
@end
