//
//  ReceiveXiangViewController.m
//  Material
//
//  Created by wayne on 14-6-10.
//  Copyright (c) 2014年 brilliantech. All rights reserved.
//

#import "ReceiveXiangViewController.h"
#import "Xiang.h"
#import "ShopXiangTableViewCell.h"

@interface ReceiveXiangViewController ()<UITextFieldDelegate,UITableViewDataSource,UITableViewDelegate>
@property (weak, nonatomic) IBOutlet UITextField *scanTextField;
@property (weak, nonatomic) IBOutlet UITableView *xiangTable;
@property (weak, nonatomic) IBOutlet UILabel *countLabel;

@end

@implementation ReceiveXiangViewController

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
    self.navigationItem.title=self.tuo.department;
    self.scanTextField.delegate=self;
    self.xiangTable.delegate=self;
    self.xiangTable.dataSource=self;
    [self.scanTextField becomeFirstResponder];
    UINib *cellNib=[UINib nibWithNibName:@"ShopXiangTableViewCell" bundle:nil];
    [self.xiangTable registerNib:cellNib forCellReuseIdentifier:@"xiangCell"];
    self.countLabel.text=[NSString stringWithFormat:@"包含箱：%d",[self.tuo.xiang count]];
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma textField
-(void)textFieldDidBeginEditing:(UITextField *)textField
{
    UIView *dummyView=[[UIView alloc] initWithFrame:CGRectMake(0, 0, 1, 1)];
    textField.inputView=dummyView;
}

#pragma table delegate
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.tuo.xiang count];
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    Xiang *xiang=[self.tuo.xiang objectAtIndex:indexPath.row];
    ShopXiangTableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:@"xiangCell" forIndexPath:indexPath];
    cell.partNumberLabel.text=xiang.number;
    cell.keyLabel.text=xiang.key;
    cell.quantityLabel.text=[NSString stringWithFormat:@"Q:%@",xiang.count];
    if(xiang.checked){
        cell.accessoryType=UITableViewCellAccessoryCheckmark;
    }
    else{
        cell.accessoryType=UITableViewCellAccessoryNone;
    }
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    Xiang *xiang=[self.tuo.xiang objectAtIndex:indexPath.row];
    ShopXiangTableViewCell *cell=(ShopXiangTableViewCell *)[tableView cellForRowAtIndexPath:indexPath];
    if(cell.accessoryType==UITableViewCellAccessoryNone){
        cell.accessoryType=UITableViewCellAccessoryCheckmark;
        xiang.checked=YES;
    }
    else if(cell.accessoryType==UITableViewCellAccessoryCheckmark){
        cell.accessoryType=UITableViewCellAccessoryNone;
        xiang.checked=NO;
    }
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
