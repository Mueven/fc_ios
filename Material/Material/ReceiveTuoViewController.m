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
#import "ReceiveConfirmViewController.h"

@interface ReceiveTuoViewController ()<UITextFieldDelegate,UITableViewDataSource,UITableViewDelegate,UIAlertViewDelegate,CaptuvoEventsProtocol>
@property (weak, nonatomic) IBOutlet UITextField *scanTextField;
@property (weak, nonatomic) IBOutlet UITableView *tuoTable;
@property (weak, nonatomic) IBOutlet UILabel *countLabel;
//@property (strong,nonatomic) UIAlertView *printAlert;
@property (weak, nonatomic) IBOutlet UILabel *scanLabel;
@property (nonatomic)BOOL currentModel;
//1是运单状态，0是拖状态
- (IBAction)fake:(id)sender;
@end

@implementation ReceiveTuoViewController

- (IBAction)fake:(id)sender {
    self.yun=[[Yun alloc] initExample];
    for(int i=0;i<10;i++){
        Tuo *tuo=[[Tuo alloc] initExample];
        [self.yun.tuoArray addObject:tuo];
    }
    [self tuoModel];
    [self.tuoTable reloadData];
}

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
    self.currentModel=1;
    UINib *itemCell=[UINib nibWithNibName:@"ShopTuoTableViewCell"  bundle:nil];
    [self.tuoTable registerNib:itemCell  forCellReuseIdentifier:@"tuoCell"];
    [self yunModel];
}
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.scanTextField becomeFirstResponder];
    [[Captuvo sharedCaptuvoDevice] removeCaptuvoDelegate:self];
    [[Captuvo sharedCaptuvoDevice] addCaptuvoDelegate:self];
    [[Captuvo sharedCaptuvoDevice] startDecoderHardware];
    

    [self.tuoTable reloadData];
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)decoderDataReceived:(NSString *)data{
    //AFNET 取运单数据（需要下面的拖以及更下面的箱）
    
    
    
    [self tuoModel];
}
-(void)tuoModel
{
    self.currentModel=0;
    self.navigationItem.title=self.yun.name;
    self.navigationItem.rightBarButtonItem=[[UIBarButtonItem alloc] initWithTitle:@"确认收货"
                                                                            style:UIBarButtonItemStyleBordered target:self
                                                                           action:@selector(receive)];
    self.navigationItem.leftBarButtonItem=[[UIBarButtonItem alloc] initWithTitle:@"放弃收货"
                                                                            style:UIBarButtonItemStyleBordered target:self
                                                                           action:@selector(unReceive)];
    self.scanLabel.text=@"扫描托清单号";
    self.countLabel.text=[NSString stringWithFormat:@"包含拖：%d",[self.yun.tuoArray count]];
    self.tuoTable.hidden=NO;
    [self.tuoTable reloadData];
    [self.scanTextField becomeFirstResponder];
}
-(void)yunModel
{
    self.currentModel=1;
    self.navigationItem.title=@"收货";
    self.navigationItem.rightBarButtonItem=NULL;
    self.navigationItem.leftBarButtonItem=NULL;
    self.scanLabel.text=@"扫描运单号";
    self.countLabel.text=@"";
    self.tuoTable.hidden=YES;
    [self.scanTextField becomeFirstResponder];
}
-(void)receive{
    [self performSegueWithIdentifier:@"receiveConfirm" sender:@{@"yun":self.yun}];
}
-(void)unReceive
{
    [self yunModel];
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
    else if([segue.identifier isEqualToString:@"receiveConfirm"]){
        ReceiveConfirmViewController *receiveConfirm=segue.destinationViewController;
        receiveConfirm.yun=[sender objectForKey:@"yun"];
    }
}

#pragma alert button

-(IBAction)unwindToReceive:(UIStoryboardSegue *)unwind{
    [self yunModel];
}
@end
