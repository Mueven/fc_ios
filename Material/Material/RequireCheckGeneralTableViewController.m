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
@interface RequireCheckGeneralTableViewController ()<UITableViewDataSource,UITableViewDelegate,UITextFieldDelegate,CaptuvoEventsProtocol>
@property (weak, nonatomic) IBOutlet UITextField *scanTextField;
@property (weak, nonatomic) IBOutlet UITableView *table;
@property (strong,nonatomic)NSMutableArray *xiangMutableArray;
@end

@implementation RequireCheckGeneralTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.table.dataSource=self;
    self.table.delegate=self;
    self.scanTextField.delegate=self;
    UINib *nib=[UINib nibWithNibName:@"RequireCheckGeneralTableViewCell" bundle:nil];
    [self.table registerNib:nib forCellReuseIdentifier:@"cell"];
    self.xiangMutableArray=[self.xiangArray mutableCopy];
    [self.table reloadData];
}
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [[Captuvo sharedCaptuvoDevice] addCaptuvoDelegate:self];
}
-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [[Captuvo sharedCaptuvoDevice] removeCaptuvoDelegate:self];
}
#pragma mark - Table view data source
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.xiangMutableArray count];
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    RequireCheckGeneralTableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    NSDictionary *item=self.xiangMutableArray[indexPath.row];
    cell.partNumberLabel.text=item[@"partNumber"];
    cell.xiangCountLabel.text=item[@"xiangCount"];
    cell.partCountLabel.text=item[@"partCount"];
    if([(NSNumber *)item[@"target"] boolValue]){
        cell.backgroundColor=[UIColor colorWithRed:242.0/255.0 green:67.0/255.0 blue:67.0/255.0 alpha:0.3];
    }
    else{
        cell.backgroundColor=[UIColor clearColor];
    }
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSDictionary *item=self.xiangArray[indexPath.row];
    [self performSegueWithIdentifier:@"detail" sender:@{@"item":item}];
}
-(void)decoderDataReceived:(NSString *)data
{
    self.scanTextField.text=data;
    [self toSearch:data];
}
-(void)textFieldDidBeginEditing:(UITextField *)textField
{
    UIView *dummy=[[UIView alloc] initWithFrame:CGRectMake(0, 0, 1, 1)];
    self.scanTextField.inputView=dummy;
}
-(void)toSearch:(NSString *)data
{
    for(int i=0;i<self.xiangMutableArray.count;i++){
        if([data isEqualToString:self.xiangMutableArray[i][@"partNumber"]]){
            NSMutableDictionary *dicFind=[self.xiangMutableArray[i] mutableCopy];
            [self.xiangMutableArray removeObjectAtIndex:i];
            [dicFind setObject:[NSNumber numberWithInt:1] forKey:@"target"];
            [self.xiangMutableArray insertObject:dicFind atIndex:0];
            [self.table reloadData];
            return;
        }
    }
}
//For test with keyboard
-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [self toSearch:textField.text];
    return YES;
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
