//
//  RequireGenerateViewController.m
//  Material
//
//  Created by wayne on 14-7-21.
//  Copyright (c) 2014年 brilliantech. All rights reserved.
//

#import "RequireGenerateViewController.h"
#import "RequireXiangTableViewCell.h"
#import "RequireXiang.h"
#import "RequirePrintViewController.h"
#import "AFNetOperate.h"
#import "RequireXiangDetailViewController.h"
#import <AudioToolbox/AudioToolbox.h>
#import "NewValidate.h"
#import "RequireCheckXiangTableViewCell.h"
#import "RequireCheckBill.h"
#import "ScanStandard.h"
#import "RequireSort.h"
#import "RequireCheckGeneralTableViewController.h"
@interface RequireGenerateViewController ()<UITextFieldDelegate,UITableViewDelegate,UITableViewDataSource,CaptuvoEventsProtocol>
@property (weak, nonatomic) IBOutlet UITextField *departmentTextField;
@property (weak, nonatomic) IBOutlet UITextField *partTextField;
@property (weak, nonatomic) IBOutlet UITextField *quantityTextField;
@property (weak, nonatomic) IBOutlet UITableView *xiangTable;
@property (strong, nonatomic) UITextField *firstResponder;
@property (strong,nonatomic)NSMutableArray *xiangArray;
@property (weak, nonatomic) IBOutlet UILabel *countLabel;
@property (strong ,nonatomic)NewValidate *validate;
@property (strong,nonatomic)NSString *order_source_id;
@property (nonatomic)int xiangCount;
@property (weak, nonatomic) IBOutlet UIButton *firstTabButton;
@property (weak, nonatomic) IBOutlet UIButton *secondTabButton;
@property (weak, nonatomic) IBOutlet UIView *firstView;
@property (strong,nonatomic)ScanStandard *scanStandard;
@property (strong,nonatomic)UIAlertView *backAlert;
- (IBAction)firstTabClick:(id)sender;
- (IBAction)secondTabClick:(id)sender;
- (IBAction)clickBackButton:(id)sender;
- (IBAction)finish:(id)sender;
//second view property
@property (weak, nonatomic) IBOutlet UIView *secondView;
@property (weak, nonatomic) IBOutlet UITextField *secondDepartmentTextField;
@property (weak, nonatomic) IBOutlet UITextField *secondPartNumberTextField;
@property (weak, nonatomic) IBOutlet UILabel *thisXiangCountLabel;
@property (weak, nonatomic) IBOutlet UITableView *thisXiangTable;
@property (strong,nonatomic) NSMutableArray *thisXiangArray;
@property (strong,nonatomic) NSMutableDictionary *isExistDictionary;
- (IBAction)clickScreen:(id)sender;
- (IBAction)check:(id)sender;
@end

@implementation RequireGenerateViewController

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
    self.partTextField.delegate=self;
    self.departmentTextField.delegate=self;
    self.quantityTextField.delegate=self;
    self.xiangTable.delegate=self;
    self.secondDepartmentTextField.delegate=self;
    self.secondPartNumberTextField.delegate=self;
    self.thisXiangTable.delegate=self;
    self.thisXiangTable.dataSource=self;
    self.xiangTable.dataSource=self;
    
    UINib *nib=[UINib nibWithNibName:@"RequireXiangTableViewCell" bundle:nil];
    [self.xiangTable registerNib:nib forCellReuseIdentifier:@"cell"];
    UINib *secondeNib=[UINib nibWithNibName:@"RequireCheckXiangTableViewCell" bundle:nil];
    [self.thisXiangTable registerNib:secondeNib forCellReuseIdentifier:@"secondCell"];
    
    self.xiangArray=[[NSMutableArray alloc] init];
    self.xiangCount=0;
    [self updateCountLabel];
    self.validate=[NewValidate sharedValidate];
    self.order_source_id=[NSString string];
    self.scanStandard=[ScanStandard sharedScanStandard];
    [self.navigationItem setHidesBackButton:YES];
    //second view init
    self.thisXiangArray=[NSMutableArray array];
    self.thisXiangCountLabel.adjustsFontSizeToFitWidth=YES;
    self.isExistDictionary=[NSMutableDictionary dictionary];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [[Captuvo sharedCaptuvoDevice] addCaptuvoDelegate:self];
    [self.departmentTextField becomeFirstResponder];
    [self.xiangTable reloadData];
 
}
-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    //    [[Captuvo sharedCaptuvoDevice] stopDecoderHardware];
    [[Captuvo sharedCaptuvoDevice] removeCaptuvoDelegate:self];
    [self.firstResponder resignFirstResponder];
    self.firstResponder=nil;
}
#pragma decoder delegate
-(void)decoderDataReceived:(NSString *)data{
    self.firstResponder.text=[data copy];
    UITextField *targetTextField=self.firstResponder;
    NSString *regex=[NSString string];
    if(targetTextField.tag==2 || targetTextField.tag==5){
        //零件号
        NSString *alertString=@"请扫描零件号";
        BOOL isMatch  = [self.scanStandard checkPartNumber:data];
        if(isMatch){
            [self textFieldShouldReturn:self.firstResponder];
        }
        else{
            UIAlertView *alert=[[UIAlertView alloc] initWithTitle:@""
                                                          message:alertString
                                                         delegate:self
                                                cancelButtonTitle:@"确定"
                                                otherButtonTitles:nil];
            [alert show];
            [NSTimer scheduledTimerWithTimeInterval:1.5f
                                             target:self
                                           selector:@selector(dismissAlert:)
                                           userInfo:[NSDictionary dictionaryWithObjectsAndKeys:alert,@"alert", nil]
                                            repeats:NO];
            AudioServicesPlaySystemSound(1051);
            targetTextField.text=@"";
            [targetTextField becomeFirstResponder];
        }
    }
    else if(targetTextField.tag==3){
        //数量
        NSString *alertString=@"请扫描数量";
        BOOL isMatch  = [self.scanStandard checkQuantity:data];
        if(isMatch){
            [self textFieldShouldReturn:self.firstResponder];
        }
        else{
            UIAlertView *alert=[[UIAlertView alloc] initWithTitle:@""
                                                          message:alertString
                                                         delegate:self
                                                cancelButtonTitle:@"确定"
                                                otherButtonTitles:nil];
            [alert show];
            [NSTimer scheduledTimerWithTimeInterval:1.5f
                                             target:self
                                           selector:@selector(dismissAlert:)
                                           userInfo:[NSDictionary dictionaryWithObjectsAndKeys:alert,@"alert", nil]
                                            repeats:NO];
            AudioServicesPlaySystemSound(1051);
            targetTextField.text=@"";
            [targetTextField becomeFirstResponder];
        }
    }
    else if(targetTextField.tag==1 || targetTextField.tag==4){
        //部门
        NSString *alertString=@"请扫描部门";
        BOOL isMatch  =  [self.scanStandard checkDepartment:data];
        if(isMatch){
            [self textFieldShouldReturn:self.firstResponder];
        }
        else{
            UIAlertView *alert=[[UIAlertView alloc] initWithTitle:@""
                                                          message:alertString
                                                         delegate:self
                                                cancelButtonTitle:@"确定"
                                                otherButtonTitles:nil];
            [alert show];
            [NSTimer scheduledTimerWithTimeInterval:1.5f
                                             target:self
                                           selector:@selector(dismissAlert:)
                                           userInfo:[NSDictionary dictionaryWithObjectsAndKeys:alert,@"alert", nil]
                                            repeats:NO];
            AudioServicesPlaySystemSound(1051);
            targetTextField.text=@"";
            [targetTextField becomeFirstResponder];
        }
    }
}
#pragma textField delegate
-(void)textFieldDidBeginEditing:(UITextField *)textField
{
//    if(textField.tag!=5){
//        UIView* dummyView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 1, 1)];
//        textField.inputView = dummyView;
//    }
    self.firstResponder=textField;
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    long tag=textField.tag;
    if(!self.firstView.hidden){
        //under first view
        NSString *partNumber=self.partTextField.text;
        NSString *department=self.departmentTextField.text;
        NSString *quantity=self.quantityTextField.text;
        
        if(partNumber.length>0&&department.length>0&&quantity.length>0){
            //after regex quantity
            NSString *quantityPost=[self.scanStandard filterQuantity:quantity];
            //after regex part
            NSString *partNumberPost=[self.scanStandard filterPartNumber:partNumber];
            //after regex part
            NSString *departmentPost=[self.scanStandard filterDepartment:department];
            //发送请求
            AFNetOperate *AFNet=[[AFNetOperate alloc] init];
            AFHTTPRequestOperationManager *manager=[AFNet generateManager:self.view];
            [manager POST:[AFNet order_item_verify]
               parameters:@{
                            @"department":departmentPost,
                            @"part_id":partNumberPost,
                            @"quantity":quantityPost
                            }
                  success:^(AFHTTPRequestOperation *operation, id responseObject) {
                      [AFNet.activeView stopAnimating];
                      if([responseObject[@"result"] integerValue]==1){
                          
                          NSMutableDictionary *content=[responseObject[@"content"] mutableCopy];
                          NSString *source=[content objectForKey:@"source_id"];
                          [content setObject:partNumber forKey:@"part_id"];
                          [content setObject:quantity forKey:@"quantity"];
                          [content setObject:department forKey:@"whouse_id"];
                          [content removeObjectForKey:@"box_quantity"];
                          
                          RequireXiang *xiang=[[RequireXiang alloc] initWithObject:content];
                          //to check whether the part is existed
                          if([responseObject[@"error_code"] intValue]==10000){
                              [xiang setIsExisted:NO];
                          }
                          else{
                              [xiang setIsExisted:YES];
                          }
                          if(self.xiangArray.count>0){
                              BOOL result=[self.validate sourceValidate:source];
                              if(result){
                                  //和初始化的零件source一样
                                  [self xiangAdd:xiang];
                              }
                              else{
                                  //和初始化零件的source不一样
                                  [self xiangAddFail];
                              }
                          }
                          else{
                              //加入的第一个零件，初始化对比的对象
                              [self.validate firstSetSource:source];
                              self.order_source_id=source;
                              [self xiangAdd:xiang];
                          }
                      }
                      else{
                          AudioServicesPlaySystemSound(1051);
                          [AFNet alert:responseObject[@"content"]];
                          self.partTextField.text=@"";
                          self.quantityTextField.text=@"";
                          [self.partTextField becomeFirstResponder];
                      }
                  }
                  failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                      [AFNet.activeView stopAnimating];
                      AudioServicesPlaySystemSound(1051);
                      [AFNet alert:[NSString stringWithFormat:@"%@",[error localizedDescription]]];
                  }
             ];
        }
        tag++;
        if(tag>3){
            tag=1;
        }
        UITextField *nextText=(UITextField *)[self.view viewWithTag:tag];
        [nextText becomeFirstResponder];
    }
    else{
        //under second view
        NSString *partNumber=self.secondPartNumberTextField.text;
        NSString *department=self.secondDepartmentTextField.text;

        
        if(partNumber.length>0&&department.length>0){
            //after regex part
            NSString *partNumberPost=[self.scanStandard filterPartNumber:partNumber];
            //after regex part
            NSString *departmentPost=[self.scanStandard filterDepartment:department];
            //发送请求
         
            AFNetOperate *AFNet=[[AFNetOperate alloc] init];
            AFHTTPRequestOperationManager *manager=[AFNet generateManager:self.view];
            [manager GET:[AFNet order_check_part]
               parameters:@{
                            @"department":departmentPost,
                            @"part_id":partNumberPost
                            }
                  success:^(AFHTTPRequestOperation *operation, id responseObject) {
                      [AFNet.activeView stopAnimating];
                      if([responseObject[@"result"] integerValue]==1){
                          NSArray *resultArray=responseObject[@"content"];
                          int sumCount=0;
                          for(int i=0;i<resultArray.count;i++){
                              NSDictionary *dic=resultArray[i];
                              NSString *created_at=[dic objectForKey:@"created_at"];
                              for(int j=0;j<[dic[@"order_items"] count];j++){
                                  NSMutableDictionary *dicDetail=[[dic[@"order_items"] objectAtIndex:j] mutableCopy];
                                  [dicDetail setObject:created_at forKey:@"created_at"];
                                  RequireCheckBill *checkBill=[[RequireCheckBill alloc] initWithObject:dicDetail];
                                  sumCount+=[dicDetail[@"box_quantity"] intValue];
                                  [self.thisXiangArray addObject:checkBill];
                              }
                          }
                          self.thisXiangCountLabel.text=[NSString stringWithFormat:@"%d",sumCount];
                          [self.thisXiangTable reloadData];
                          [self.firstResponder resignFirstResponder];
                      }
                      else{
                          AudioServicesPlaySystemSound(1051);
                          [AFNet alert:responseObject[@"content"]];
                          self.secondPartNumberTextField.text=@"";
                          [self.secondPartNumberTextField becomeFirstResponder];
                      }
                  }
                  failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                      [AFNet.activeView stopAnimating];
                      AudioServicesPlaySystemSound(1051);
                      [AFNet alert:[NSString stringWithFormat:@"%@",[error localizedDescription]]];
                  }
             ];
        }
        tag++;
        if(tag>5){
            tag=4;
        }
        UITextField *nextText=(UITextField *)[self.view viewWithTag:tag];
        [nextText becomeFirstResponder];
    }
    return YES;
}
//添加箱
-(void)xiangAdd:(RequireXiang *)xiang
{
    AudioServicesPlaySystemSound(1012);
    UIAlertView *alert=[[UIAlertView alloc] initWithTitle:@""
                                                  message:@"添加成功"
                                                 delegate:self
                                        cancelButtonTitle:@"确定"
                                        otherButtonTitles: nil];
    [NSTimer scheduledTimerWithTimeInterval:0.9f
                                     target:self
                                   selector:@selector(dismissAlert:)
                                   userInfo:[NSDictionary dictionaryWithObjectsAndKeys:alert,@"alert", nil]
                                    repeats:NO];
    [alert show];
    self.partTextField.text=@"";
    self.quantityTextField.text=@"";
    [self.partTextField becomeFirstResponder];
    //合并处理
    [self xiangMerge:xiang];
    //检查 isExist
    if(!xiang.isExisted){
        [self.isExistDictionary setObject:xiang forKey:xiang.id];
    }
}
//无法添加箱
-(void)xiangAddFail
{
    AudioServicesPlaySystemSound(1051);
    UIAlertView *alert=[[UIAlertView alloc] initWithTitle:@""
                                                  message:@"零件来源地不一致"
                                                 delegate:self
                                        cancelButtonTitle:@"确定"
                                        otherButtonTitles: nil];
    [NSTimer scheduledTimerWithTimeInterval:2.1f
                                     target:self
                                   selector:@selector(dismissAlert:)
                                   userInfo:[NSDictionary dictionaryWithObjectsAndKeys:alert,@"alert", nil]
                                    repeats:NO];
    [alert show];
    self.partTextField.text=@"";
    self.quantityTextField.text=@"";
    [self.partTextField becomeFirstResponder];
}
//添加箱后的合并
-(void)xiangMerge:(RequireXiang *)xiang
{
//    NSString *uniq_id=xiang.uniq_id;
//    BOOL merge=0;
//    for(int i=0;i<self.xiangArray.count;i++){
//        RequireXiang *xiangItem=self.xiangArray[i];
//        if([xiangItem.uniq_id isEqualToString:uniq_id] && !xiangItem.urgent){
//            int origin=[xiangItem.quantity_int intValue];
//            int new=[xiang.quantity_int intValue];
//            xiangItem.quantity_int=[NSString stringWithFormat:@"%d",origin+new];
//            xiangItem.xiangCount++;
//            merge=1;
//            break ;
//        }
//    }
//    if(merge){
//        
//    }
//    else{
        [self.xiangArray insertObject:xiang atIndex:0];
//    }
    [self updateAddCount];
    [self.xiangTable reloadData];
}
-(void)dismissAlert:(NSTimer *)timer
{
    UIAlertView *alert=[[timer userInfo] objectForKey:@"alert"];
    [alert dismissWithClickedButtonIndex:0 animated:YES];
}
#pragma table delegate
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if(tableView==self.xiangTable){
        return [self.xiangArray count];
    }
    else{
        return [self.thisXiangArray count];
    }
  
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(tableView==self.xiangTable){
        RequireXiangTableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
        RequireXiang *xiang=self.xiangArray[indexPath.row];
        cell.is_finished_label.text=xiang.is_finished_text;
        if(xiang.out_of_stock==1){
            cell.out_of_stock_label.text=xiang.out_of_stock_text;
        }
        else{
            cell.out_of_stock_label.text=@"";
        }
        cell.positionTextField.text=xiang.quantity_int;
        cell.partNumberTextField.text=xiang.partNumber;
        cell.quantityTextField.text=[NSString stringWithFormat:@"%d",xiang.xiangCount];
        __weak RequireXiangTableViewCell *cellForBlock=cell;
        cell.clickCell=^(){
            if(xiang.urgent){
                //取消加急
                xiang.urgent=0;
                cellForBlock.backgroundColor=[UIColor whiteColor];
                cellForBlock.urgentButton.backgroundColor=[UIColor colorWithRed:170.0/255.0 green:170.0/255.0 blue:170.0/255.0 alpha:1.0];
                [cellForBlock.urgentButton setTitle:@"设为加急" forState:UIControlStateNormal];
            }
            else{
                //加急
                xiang.urgent=1;
                cellForBlock.backgroundColor=[UIColor colorWithRed:242.0/255.0 green:67.0/255.0 blue:67.0/255.0 alpha:0.3];
                cellForBlock.urgentButton.backgroundColor=[UIColor colorWithRed:242.0/255.0 green:67.0/255.0 blue:67.0/255.0 alpha:1.0];
                [cellForBlock.urgentButton setTitle:@"取消加急" forState:UIControlStateNormal];
            }
//            [self urgentSwitchMerg:xiang];
        };
        if(xiang.urgent){
            //加急状态下
            cell.backgroundColor=[UIColor colorWithRed:242.0/255.0 green:67.0/255.0 blue:67.0/255.0 alpha:0.3];
            cell.urgentButton.backgroundColor=[UIColor colorWithRed:242.0/255.0 green:67.0/255.0 blue:67.0/255.0 alpha:1.0];
            [cell.urgentButton setTitle:@"取消加急" forState:UIControlStateNormal];
        }
        else{
            //不加急状态
            cell.backgroundColor=[UIColor whiteColor];
            cell.urgentButton.backgroundColor=[UIColor colorWithRed:170.0/255.0 green:170.0/255.0 blue:170.0/255.0 alpha:1.0];
            [cell.urgentButton setTitle:@"设为加急" forState:UIControlStateNormal];
        }
        return cell;
    }
    else{
        RequireCheckXiangTableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:@"secondCell" forIndexPath:indexPath];
        RequireCheckBill *bill=self.thisXiangArray[indexPath.row];
        cell.yunDateLabel.text=bill.yunDate;
        cell.partCountLabel.text=bill.partAmount;
        cell.xiangCountLabel.text=bill.xiangCount;
        if(bill.urgent){
            cell.urgentLabel.hidden=NO;
            cell.urgentLabel.text=@"加急箱";
        }
        else{
             cell.urgentLabel.hidden=YES;
        }
        return cell;
    }
    
    
}
-(void)urgentSwitchMerg:(RequireXiang *)xiang
{
    NSString *uniq_id=xiang.uniq_id;
    if(xiang.urgent==1){
        //不加急变为加急
        for(int i=0;i<self.xiangArray.count;i++){
            RequireXiang *xiangItem=self.xiangArray[i];
            if([xiangItem.uniq_id isEqualToString:uniq_id] && xiangItem.urgent==1 && xiangItem!=xiang){
                int origin=[xiangItem.quantity_int intValue];
                int new=[xiang.quantity_int intValue];
                xiangItem.quantity_int=[NSString stringWithFormat:@"%d",origin+new];
                xiangItem.xiangCount=xiangItem.xiangCount+xiang.xiangCount;
                [self.xiangArray removeObjectIdenticalTo:xiang];
                break ;
            }
        }
    }
    else{
        //加急变为不加急
        for(int i=0;i<self.xiangArray.count;i++){
            RequireXiang *xiangItem=self.xiangArray[i];
            if([xiangItem.uniq_id isEqualToString:uniq_id] && xiangItem.urgent==0 && xiangItem!=xiang){
                int origin=[xiangItem.quantity_int intValue];
                int new=[xiang.quantity_int intValue];
                xiangItem.quantity_int=[NSString stringWithFormat:@"%d",origin+new];
                xiangItem.xiangCount++;
                [self.xiangArray removeObjectIdenticalTo:xiang];
                break ;
            }
        }
    }
    [self.xiangTable reloadData];
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(tableView==self.xiangTable){
        RequireXiang *xiang=self.xiangArray[indexPath.row];
        [self performSegueWithIdentifier:@"xiangDetail" sender:@{@"xiang":xiang}];
    }
  
}
-(void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        RequireXiang *xiang=self.xiangArray[indexPath.row];
        for(int i=0;i<xiang.xiangCount;i++){
            [self updateMinusCount];
        }
        [self.xiangArray removeObjectAtIndex:indexPath.row];
        if(!xiang.isExisted){
            [self.isExistDictionary removeObjectForKey:xiang.id];
        }
        [tableView cellForRowAtIndexPath:indexPath].alpha = 0.0;
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];

    }
}
-(BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(tableView==self.xiangTable){
        return YES;
    }
    else{
        return NO;
    }
}
#pragma mark - Navigation

- (IBAction)finish:(id)sender {
//    [self performSegueWithIdentifier:@"printFormGenerate" sender:@{@"type":@"list"}];
    if(self.xiangArray.count>0){
        UIAlertView *alert=[[UIAlertView alloc] initWithTitle:@""
                                                      message:@"确认发送需求？"
                                                     delegate:self
                                            cancelButtonTitle:@"取消"
                                            otherButtonTitles:@"确定", nil];
        [alert show];
    }
    else{
        UIAlertView *alert=[[UIAlertView alloc] initWithTitle:@""
                                                      message:@"请添加至少一个零件"
                                                     delegate:self
                                            cancelButtonTitle:@"确定"
                                            otherButtonTitles: nil];
        [alert show];
    }
}
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    //发送运单
    if(buttonIndex==1){
        if(alertView==self.backAlert){
            //确认退出
            [self.navigationController popViewControllerAnimated:YES];
        }
        else{
            //确认发送
            NSMutableArray *postItems=[[NSMutableArray alloc] init];
            for(int i=0;i<self.xiangArray.count;i++){
                RequireXiang *xiang=self.xiangArray[i];
                NSNumber *emergency=xiang.urgent?[NSNumber numberWithInt:1]:[NSNumber numberWithInt:0];
                NSMutableDictionary *dic=[NSMutableDictionary dictionaryWithObjectsAndKeys:xiang.department_origin,@"department",xiang.partNumber_origin,@"part_id",xiang.quantity_int,@"quantity",emergency,@"is_emergency",[NSString stringWithFormat:@"%d",xiang.xiangCount],@"box_quantity",nil];
                [postItems addObject:dic];
            }
            NSMutableArray *isExistedArray=[[NSMutableArray alloc] init];
                id keys=[self.isExistDictionary allKeys];
                for(int i;i<self.isExistDictionary.count;i++){
                    id key=[keys objectAtIndex:i];
                    RequireXiang *xiangItem=[self.isExistDictionary objectForKey:key];
                    NSNumber *emergency=xiangItem.urgent?[NSNumber numberWithInt:1]:[NSNumber numberWithInt:0];
                    NSMutableDictionary *dic=[[NSMutableDictionary alloc] initWithObjectsAndKeys:xiangItem.department_origin,@"department",xiangItem.partNumber_origin,@"part_id",xiangItem.quantity_int,@"quantity",emergency,@"is_emergency",nil];
                    [isExistedArray addObject:dic];
            }
            AFNetOperate *AFNet=[[AFNetOperate alloc] init];
            AFHTTPRequestOperationManager *manager=[AFNet generateManager:self.view];
            [manager POST:[AFNet order_root]
               parameters:@{
                            @"order":@{@"source_id":self.order_source_id},
                            @"order_items":postItems,
                            @"no_part_items":isExistedArray
                            }
                  success:^(AFHTTPRequestOperation *operation, id responseObject) {
                      [AFNet.activeView stopAnimating];
                      //                  if([responseObject[@"result"] integerValue]==1){
                      //                      [self performSegueWithIdentifier:@"printFormGenerate" sender:@{@"type":@"list",@"success":@1}];
                      //                  }
                      //                  else{
                      //                      [AFNet alert:responseObject[@"content"]];
                      //                  }
                      AudioServicesPlaySystemSound(1012);
                      [self.navigationController popViewControllerAnimated:YES];
                  }
                  failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                      [AFNet.activeView stopAnimating];
                      [AFNet alert:[NSString stringWithFormat:@"%@",[error localizedDescription]]];
                  }
             ];
            
        }
    }
}
-(void)updateCountLabel
{
    NSString *count=[NSString stringWithFormat:@"%d",self.xiangCount];
    self.countLabel.text=count;
}
-(void)updateAddCount
{
    self.xiangCount++;
    [self updateCountLabel];
}
-(void)updateMinusCount
{
    self.xiangCount--;
    [self updateCountLabel];
}

- (IBAction)firstTabClick:(id)sender {
    [self initFirstView];
}

- (IBAction)secondTabClick:(id)sender {
   [self initSecondView];
}

- (IBAction)clickBackButton:(id)sender {
   self.backAlert=[[UIAlertView alloc] initWithTitle:@"确认退出？"
                                                 message:@"退出后正在生成的需求单会被清空"
                                                delegate:self
                                       cancelButtonTitle:@"取消"
                                       otherButtonTitles:@"确定", nil];
    [self.backAlert show];
}
-(void)toggleButton:(UIButton *)button secondButton:(UIButton *)secondButton
{
    button.backgroundColor=[UIColor colorWithRed:66.0/255.0 green:120.0/255.0 blue:207.0/255.0 alpha:1.0];
    secondButton.backgroundColor=[UIColor colorWithRed:170.0/255.0 green:170.0/255.0 blue:170.0/255.0 alpha:1.0];
}
-(void)initFirstView
{
    [self toggleButton:self.firstTabButton secondButton:self.secondTabButton];
    self.navigationItem.title=@"生成需求";
    self.firstView.hidden=NO;
    self.secondView.hidden=YES;
    if(self.departmentTextField.text.length>0){
        [self.partTextField becomeFirstResponder];
    }
    else{
        [self.departmentTextField becomeFirstResponder];
    }
}
-(void)initSecondView
{
    [self toggleButton:self.secondTabButton secondButton:self.firstTabButton];
    self.navigationItem.title=@"零件查看";
    self.firstView.hidden=YES;
    self.secondView.hidden=NO;
    if(self.departmentTextField.text.length>0){
        self.secondDepartmentTextField.text=self.departmentTextField.text;
        [self.secondPartNumberTextField becomeFirstResponder];
    }
    else{
        [self.secondDepartmentTextField becomeFirstResponder];
    }
}

- (IBAction)clickScreen:(id)sender {
//    [self.firstResponder resignFirstResponder];
//    self.firstResponder=nil;
}

- (IBAction)check:(id)sender {
    NSArray *xiangArray=[RequireSort sortByPartNumber:[self.xiangArray copy]];
    [self performSegueWithIdentifier:@"check" sender:@{@"xiangArray":xiangArray}];
}
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    if([segue.identifier isEqualToString:@"printFormGenerate"]){
        RequirePrintViewController *print=segue.destinationViewController;
        print.type=[sender objectForKey:@"type"];
        print.success=[[sender objectForKey:@"success"] integerValue];
    }
    else if([segue.identifier isEqualToString:@"xiangDetail"]){
        RequireXiangDetailViewController *xiangDetail=segue.destinationViewController;
        xiangDetail.xiang=[sender objectForKey:@"xiang"];
    }
    else if([segue.identifier isEqualToString:@"check"]){
        RequireCheckGeneralTableViewController *vc=segue.destinationViewController;
        vc.xiangArray=[sender objectForKey:@"xiangArray"];
    }
}
@end
