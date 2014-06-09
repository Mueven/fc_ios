//
//  YunEditViewController.m
//  Material
//
//  Created by wayne on 14-6-9.
//  Copyright (c) 2014年 brilliantech. All rights reserved.
//

#import "YunEditViewController.h"
#import "Tuo.h"
#import "YunChooseTuoViewController.h"

@interface YunEditViewController ()<UITableViewDataSource,UITableViewDelegate,UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tuoTable;
@property (weak, nonatomic) IBOutlet UITextField *name;
@property (weak, nonatomic) IBOutlet UITextField *remark;

@end

@implementation YunEditViewController

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
    self.name.delegate=self;
    self.remark.delegate=self;
    self.tuoTable.delegate=self;
    self.tuoTable.dataSource=self;
}
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.navigationItem.title=self.yun.name;
    self.name.text=self.yun.name;
    self.remark.text=self.yun.remark;
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
    UITableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:@"tuoCell"];
    Tuo *tuo=[self.yun.tuoArray objectAtIndex:indexPath.row];
    cell.textLabel.text=tuo.department;
    cell.detailTextLabel.text=[NSString stringWithFormat:@"%@   %@",tuo.date,tuo.agent];;
    return cell;
}
-(void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(editingStyle==UITableViewCellEditingStyleDelete){
        [self.yun.tuoArray removeObjectAtIndex:indexPath.row];
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }
}

#pragma textField delegate
-(void)textFieldDidEndEditing:(UITextField *)textField
{
    if(textField.tag==21){
        self.yun.name=textField.text;
        self.navigationItem.title=self.yun.name;
    }
    else if(textField.tag==22){
        self.yun.remark=textField.text;
    }
}
-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return  YES;
}


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    if([segue.identifier isEqualToString:@"yunEditTuo"]){
        YunChooseTuoViewController *chooseTuo=segue.destinationViewController;
        chooseTuo.yun=self.yun;
        chooseTuo.type=@"yunEdit";
    }
}


@end
