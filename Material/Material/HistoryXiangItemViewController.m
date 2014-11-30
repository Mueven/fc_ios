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
    self.stateLabel.text=self.xiang.state_display;
    if(self.xiang.state==1 || self.xiang.state==2){
        [self.stateLabel setTextColor:[UIColor blueColor]];
    }
    else if(self.xiang.state==3){
        [self.stateLabel setTextColor:[UIColor greenColor]];
    }
    else if(self.xiang.state==4){
        [self.stateLabel setTextColor:[UIColor redColor]];
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
