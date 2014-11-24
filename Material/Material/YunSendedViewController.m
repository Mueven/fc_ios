//
//  YunSendedViewController.m
//  Material
//
//  Created by wayne on 14-6-15.
//  Copyright (c) 2014年 brilliantech. All rights reserved.
//

#import "YunSendedViewController.h"
#import "Tuo.h"
#import "YunCheckXiangTableViewController.h"
#import "Xiang.h"
#import "AFNetOperate.h"
#import "ShopTuoTableViewCell.h"
#import "PrinterSetting.h"

@interface YunSendedViewController ()<UITableViewDataSource,UITableViewDelegate>
@property (weak, nonatomic) IBOutlet UILabel *remarkLabel;
@property (weak, nonatomic) IBOutlet UITableView *tuoTable;
- (IBAction)printYun:(id)sender;
@property (strong,nonatomic)PrinterSetting *printSetting;
@end

@implementation YunSendedViewController

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
    self.remarkLabel.text=self.yun.remark;
    self.remarkLabel.adjustsFontSizeToFitWidth=YES;
    self.tuoTable.delegate=self;
    self.tuoTable.dataSource=self;
    self.navigationItem.title=self.yun.name;
    UINib *itemCell=[UINib nibWithNibName:@"ShopTuoTableViewCell"  bundle:nil];
    [self.tuoTable registerNib:itemCell  forCellReuseIdentifier:@"tuoCell"];
    self.printSetting=[PrinterSetting sharedPrinterSetting];
}
-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
//    [[Captuvo sharedCaptuvoDevice] stopDecoderHardware];
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
    return [self.yun.tuoArray count];
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    Tuo *tuo=[self.yun.tuoArray objectAtIndex:indexPath.row];
    ShopTuoTableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:@"tuoCell" forIndexPath:indexPath];
    cell.nameLabel.text=tuo.container_id;
    cell.dateLabel.text=tuo.date;
    cell.conditionLabel.text=[NSString stringWithFormat:@"%d / %d",tuo.accepted_packages,tuo.sum_packages];
    if(tuo.accepted_packages==tuo.sum_packages){
        [cell.conditionLabel setTextColor:[UIColor colorWithRed:68.0/255.0 green:178.0/255.0 blue:29.0/255.0 alpha:1.0]];
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
    AFNetOperate *AFNet=[[AFNetOperate alloc] init];
    AFHTTPRequestOperationManager *manager=[AFNet generateManager:self.view];
    [manager GET:[AFNet tuo_single]
      parameters:@{@"id":tuo.ID}
         success:^(AFHTTPRequestOperation *operation, id responseObject) {
             [AFNet.activeView stopAnimating];
             if([responseObject[@"result"] integerValue]==1){
                    if([(NSDictionary *)responseObject[@"content"] count]>0){
                        NSArray *xiangArray=[responseObject[@"content"] objectForKey:@"packages"];
                        [tuo.xiang removeAllObjects];
                        for(int i=0;i<xiangArray.count;i++){
                            Xiang *xiangItem=[[Xiang alloc] initWithObject:xiangArray[i]];
                            [tuo.xiang addObject:xiangItem];
                        }
                        [self performSegueWithIdentifier:@"checkXiang" sender:@{@"tuo":tuo}];
                    }
                 
             }
             else{
                 [AFNet alert:responseObject[@"content"]];
             }
             
         }
         failure:^(AFHTTPRequestOperation *operation, NSError *error) {
             [AFNet.activeView stopAnimating];
             [AFNet alert:@"sth wrong"];
         }
     ];
    
    
//    [self performSegueWithIdentifier:@"checkXiang" sender:@{@"tuo":tuo}];
}

#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    if([segue.identifier isEqualToString:@"checkXiang"]){
        YunCheckXiangTableViewController *checkXiang=segue.destinationViewController;
        checkXiang.tuo=[sender objectForKey:@"tuo"];
    }
}


- (IBAction)printYun:(id)sender {
   
    AFNetOperate *AFNet=[[AFNetOperate alloc] init];
   
    AFHTTPRequestOperationManager *manager=[AFNet generateManager:self.view];
    [manager GET:[[AFNet print_stock_yun:self.yun.ID printer_name:[self.printSetting getPrivatePrinter:@"P002"] copies:[self.printSetting getPrivateCopy:@"P002"]] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]
      parameters:nil
         success:^(AFHTTPRequestOperation *operation, id responseObject) {
            
             [AFNet.activeView stopAnimating];
             if([responseObject[@"Code"] integerValue]==1){
                  [AFNet alertSuccess:responseObject[@"Content"]];
             }
             else{
                 [AFNet alert:responseObject[@"Content"]];
             }
         }
         failure:^(AFHTTPRequestOperation *operation, NSError *error) {
         
             [AFNet.activeView stopAnimating];
             [AFNet alert:[NSString stringWithFormat:@"%@",[error localizedDescription]]];
         }
     ];
}
@end
