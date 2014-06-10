//
//  ReceiveTuoViewController.m
//  Material
//
//  Created by wayne on 14-6-10.
//  Copyright (c) 2014年 brilliantech. All rights reserved.
//

#import "ReceiveTuoViewController.h"
#import "ShopTuoTableViewCell.h"
#import "Tuo.h"
#import "Xiang.h"
#import "ReceiveXiangViewController.h"

@interface ReceiveTuoViewController ()<UITextFieldDelegate,UITableViewDataSource,UITableViewDelegate>
@property (weak, nonatomic) IBOutlet UITextField *scanTextField;
@property (weak, nonatomic) IBOutlet UITableView *tuoTable;
@property (weak, nonatomic) IBOutlet UILabel *countLabel;

@end

@implementation ReceiveTuoViewController

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
    self.scanTextField.delegate=self;
    self.tuoTable.delegate=self;
    self.tuoTable.dataSource=self;
    UINib *itemCell=[UINib nibWithNibName:@"ShopTuoTableViewCell"  bundle:nil];
    [self.tuoTable registerNib:itemCell  forCellReuseIdentifier:@"tuoCell"];
    self.countLabel.text=[NSString stringWithFormat:@"包含拖：%d",[self.yun.tuoArray count]];
    
    self.yun=[[Yun alloc] initExample];
    for(int i=0;i<10;i++){
        Tuo *tuo=[[Tuo alloc] initExample];
        [self.yun.tuoArray addObject:tuo];
    }
    [self.tuoTable reloadData];
}
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.scanTextField becomeFirstResponder];
    [self.tuoTable reloadData];
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma table delegate
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
    ShopTuoTableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:@"tuoCell" forIndexPath:indexPath];
    Tuo *tuo=[self.yun.tuoArray objectAtIndex:indexPath.row];
    cell.nameLabel.text=tuo.department;
    cell.dateLabel.text=tuo.date;
    NSMutableArray *array=tuo.xiang;
    int count=[array count];
    int checked=0;
    for(int i=0;i<count;i++){
        if([array[i] checked]){
            checked++;
        }
    }
    cell.conditionLabel.text=[NSString stringWithFormat:@"%d / %d",checked,count];
    if(checked==count){
        [cell.conditionLabel setTextColor:[UIColor greenColor]];
    }
    else{
        [cell.conditionLabel setTextColor:[UIColor redColor]];
    }
    cell.accessoryType=UITableViewCellAccessoryDisclosureIndicator;
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    Tuo *tuo=[self.yun.tuoArray objectAtIndex:indexPath.row];
    [self performSegueWithIdentifier:@"receiveXiang" sender:@{@"tuo":tuo}];
}

#pragma textField delegate
-(void)textFieldDidBeginEditing:(UITextField *)textField
{
    UIView* dummyView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 1, 1)];
    textField.inputView = dummyView;
}

#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    if([segue.identifier isEqualToString:@"receiveXiang"]){
        ReceiveXiangViewController *receiveXiang=segue.destinationViewController;
        receiveXiang.tuo=[sender objectForKey:@"tuo"];
    }
}


@end
