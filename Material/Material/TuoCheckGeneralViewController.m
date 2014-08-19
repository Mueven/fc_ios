//
//  TuoCheckGeneralViewController.m
//  Material
//
//  Created by wayne on 14-8-19.
//  Copyright (c) 2014年 brilliantech. All rights reserved.
//

#import "TuoCheckGeneralViewController.h"
#import "TuoCheckTableViewCell.h"
#import "Xiang.h"
#import "TuoCheckDetailViewController.h"
@interface TuoCheckGeneralViewController ()<UITableViewDataSource,UITableViewDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@end

@implementation TuoCheckGeneralViewController
//xiangArray=[{@"partNumber":@"",@"xiangArray"}:[]];
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
    self.tableView.dataSource=self;
    self.tableView.delegate=self;
    self.navigationItem.title=@"检查已扫描箱";
    UINib *nib=[UINib nibWithNibName:@"TuoCheckTableViewCell" bundle:nil];
    [self.tableView registerNib:nib forCellReuseIdentifier:@"cell"];
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
    return [self.xiangArray count];
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    TuoCheckTableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    NSDictionary *item=self.xiangArray[indexPath.row];
    cell.partNumberLabel.text=[item objectForKey:@"partNumber"];
    cell.countLabel.text=[NSString stringWithFormat:@"%d",[(NSArray *)[item objectForKey:@"xiangArray"] count]];
    cell.accessoryType=UITableViewCellAccessoryDisclosureIndicator;
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSDictionary *item=self.xiangArray[indexPath.row];
    NSString *partNumber=[item   objectForKey:@"partNumber"];
    NSArray *xiangArray=[item objectForKey:@"xiangArray"];
    [self performSegueWithIdentifier:@"checkDetail" sender:@{@"xiangArray":xiangArray,@"partNumber":partNumber}];
}
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    if([segue.identifier isEqualToString:@"checkDetail"]){
        TuoCheckDetailViewController *checkDetail=segue.destinationViewController;
        checkDetail.xiangArray=[sender objectForKey:@"xiangArray"];
        checkDetail.partNumber=[sender objectForKey:@"partNumber"];
    }
}


@end
