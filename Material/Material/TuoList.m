//
//  TuoList.m
//  Material
//
//  Created by wayne on 14-11-20.
//  Copyright (c) 2014年 brilliantech. All rights reserved.
//

#import "TuoList.h"
#import "ShopTuoTableViewCell.h"
#import "Tuo.h"
#import "XiangList.h"
#import "AFNetOperate.h"
@implementation TuoList
- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    self.navigationItem.title=self.title;
    UINib *itemCell=[UINib nibWithNibName:@"ShopTuoTableViewCell"  bundle:nil];
    [self.tableView registerNib:itemCell  forCellReuseIdentifier:@"tuoCell"];
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return [self.tuoArray count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    ShopTuoTableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:@"tuoCell" forIndexPath:indexPath];
    Tuo *tuo=[self.tuoArray objectAtIndex:indexPath.row];
    cell.nameLabel.text=tuo.ID;
    cell.dateLabel.text=tuo.department;
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
    Tuo *tuo=[self.tuoArray objectAtIndex:indexPath.row];
//    AFNetOperate *AFNet=[[AFNetOperate alloc] init];
//    AFHTTPRequestOperationManager *manager=[AFNet generateManager:self.view];
//    [manager GET:[AFNet tuo_single]
//      parameters:@{@"id":tuo.ID}
//         success:^(AFHTTPRequestOperation *operation, id responseObject) {
//             [AFNet.activeView stopAnimating];
//             if([responseObject[@"result"] integerValue]==1){
//                 if([(NSDictionary *)responseObject[@"content"] count]>0){
//                     NSLog(@"%@",responseObject);
//                     NSDictionary *result=responseObject[@"content"];
//                     NSArray *xiangList=result[@"packages"];
//                     [tuo.xiang removeAllObjects];
//                     for(int i=0;i<xiangList.count;i++){
//                         Xiang *xiang=[[Xiang alloc] initWithObject:xiangList[i]];
//                         [tuo.xiang addObject:xiang];
//                     }
//                     [self performSegueWithIdentifier:@"checkXiang" sender:@{@"tuo":tuo}];
//                 }
//                 
//             }
//             else{
//                 [AFNet alert:responseObject[@"content"]];
//             }
//             
//         }
//         failure:^(AFHTTPRequestOperation *operation, NSError *error) {
//             [AFNet.activeView stopAnimating];
//             [AFNet alert:@"something wrong"];
//         }
//     ];
}
-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if([segue.identifier isEqualToString:@"tuoToXiang"]){
        XiangList *xiangList=segue.destinationViewController;
        xiangList.xiangArray=[sender objectForKey:@"xiangArray"];
        xiangList.title=[sender objectForKey:@"title"];
    }
}
@end
