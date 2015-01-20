//
//  XiangChooseDepartmentViewController.m
//  Material
//
//  Created by wayne on 14-12-4.
//  Copyright (c) 2014年 brilliantech. All rights reserved.
//

#import "XiangChooseDepartmentViewController.h"

@interface XiangChooseDepartmentViewController () <UITextFieldDelegate,UITableViewDataSource,UITableViewDelegate,CaptuvoEventsProtocol>
@property (weak, nonatomic) IBOutlet UILabel *currentChooseLabel;
@property (weak, nonatomic) IBOutlet UITextField *scanTextField;
@property (weak, nonatomic) IBOutlet UITableView *departmentTable;
@end

@implementation XiangChooseDepartmentViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.scanTextField.delegate=self;
    self.departmentTable.dataSource=self;
    self.departmentTable.delegate=self;
    [self.departmentTable registerClass:[UITableViewCell class] forCellReuseIdentifier:@"cell"];
}
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [[Captuvo sharedCaptuvoDevice] addCaptuvoDelegate:self];
}
-(void)viewWillDisappear:(BOOL)animated
{
    [[Captuvo sharedCaptuvoDevice] removeCaptuvoDelegate:self];
}
-(void)textFieldDidBeginEditing:(UITextField *)textField
{
    UIView *dummy=[[UIView alloc] initWithFrame:CGRectMake(0, 0, 1, 1)];
    textField.inputView=dummy;
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)decoderDataReceived:(NSString *)data
{
    self.scanTextField.text=data;
    for(int i=0;i<self.departmentArray.count;i++){
        NSString *deparID=[NSString stringWithFormat:@"%@", self.departmentArray[i][@"id"]];
        if([data isEqualToString:deparID]){
            [self chooseAnDepartment:i];
            return;
        }
    }
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.departmentArray count];
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    NSDictionary *item=self.departmentArray[indexPath.row];

    if([item[@"id"] isEqualToString:self.departmentReceive[@"id"]]){
        cell.accessoryType=UITableViewCellAccessoryCheckmark;
    }
    else{
        cell.accessoryType=UITableViewCellAccessoryNone;
    }
    cell.textLabel.text=[item objectForKey:@"name"];
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell=[tableView cellForRowAtIndexPath:indexPath];
    if(cell.accessoryType==UITableViewCellAccessoryNone){
        cell.accessoryType=UITableViewCellAccessoryCheckmark;
        [self chooseAnDepartment:indexPath.row];
    }
}
-(void)chooseAnDepartment:(NSInteger)index
{
    NSDictionary *item=self.departmentArray[index];
    self.currentChooseLabel.text=item[@"name"];
    [self.departmentReceive setObject:item[@"name"] forKey:@"name"];
    [self.departmentReceive setObject:item[@"id"] forKey:@"id"];
    [self.departmentTable reloadData];
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
