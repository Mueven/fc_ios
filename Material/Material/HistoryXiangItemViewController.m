//
//  HistoryXiangItemViewController.m
//  Material
//
//  Created by wayne on 14-11-27.
//  Copyright (c) 2014年 brilliantech. All rights reserved.
//

#import "HistoryXiangItemViewController.h"

@interface HistoryXiangItemViewController ()
@property (weak, nonatomic) IBOutlet UILabel *keyLabel;
@property (weak, nonatomic) IBOutlet UILabel *partNumberLabel;
@property (weak, nonatomic) IBOutlet UILabel *quantityLabel;
@property (weak, nonatomic) IBOutlet UILabel *stateLabel;

@end

@implementation HistoryXiangItemViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.keyLabel.adjustsFontSizeToFitWidth=YES;
    self.partNumberLabel.adjustsFontSizeToFitWidth=YES;
    self.quantityLabel.adjustsFontSizeToFitWidth=YES;
    
    self.keyLabel.text=self.xiang.key;
    self.partNumberLabel.text=self.xiang.number;
    self.quantityLabel.text=self.xiang.count;
    if(self.xiang.checked){
         [self.stateLabel setTextColor:[UIColor colorWithRed:68.0/255.0 green:178.0/255.0 blue:29.0/255.0 alpha:1.0]];
        self.stateLabel.text=@"已接收";
    }
    else{
        [self.stateLabel setTextColor:[UIColor redColor]];
        self.stateLabel.text=@"未接收";
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
