//
//  RequireXiangTableViewCell.m
//  Material
//
//  Created by wayne on 14-7-21.
//  Copyright (c) 2014年 brilliantech. All rights reserved.
//

#import "RequireXiangTableViewCell.h"
@interface RequireXiangTableViewCell()

@property (nonatomic)BOOL state;
@end
@implementation RequireXiangTableViewCell

- (void)awakeFromNib
{
    // Initialization code
    self.partNumberTextField.adjustsFontSizeToFitWidth=YES;
    self.positionTextField.adjustsFontSizeToFitWidth=YES;
    self.quantityTextField.adjustsFontSizeToFitWidth=YES;
    self.state=1;
    [self.urgentButton setTitle:@"设为加急" forState:UIControlStateNormal];
 
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
//    [super setSelected:selected animated:animated];
    // Configure the view for the selected state
}

- (IBAction)setUrgent:(id)sender {
//    if(self.state){
        //加急
//        self.state=0;
//        self.backgroundColor=[UIColor colorWithRed:242.0/255.0 green:67.0/255.0 blue:67.0/255.0 alpha:0.3];
//        self.urgentButton.backgroundColor=[UIColor colorWithRed:242.0/255.0 green:67.0/255.0 blue:67.0/255.0 alpha:1.0];
//            [self.urgentButton setTitle:@"取消加急" forState:UIControlStateNormal];
//    }
//    else{
        //取消加急
//        self.state=1;
//        self.backgroundColor=[UIColor whiteColor];
//        self.urgentButton.backgroundColor=[UIColor colorWithRed:170.0/255.0 green:170.0/255.0 blue:170.0/255.0 alpha:1.0];
//            [self.urgentButton setTitle:@"设为加急" forState:UIControlStateNormal];
//    }
    self.clickCell();
}
-(void)urgentState
{
    self.backgroundColor=[UIColor colorWithRed:242.0/255.0 green:67.0/255.0 blue:67.0/255.0 alpha:0.3];
    self.urgentButton.backgroundColor=[UIColor colorWithRed:242.0/255.0 green:67.0/255.0 blue:67.0/255.0 alpha:1.0];
    [self.urgentButton setTitle:@"取消加急" forState:UIControlStateNormal];
}
-(void)normalState
{
    self.backgroundColor=[UIColor whiteColor];
    self.urgentButton.backgroundColor=[UIColor colorWithRed:170.0/255.0 green:170.0/255.0 blue:170.0/255.0 alpha:1.0];
    [self.urgentButton setTitle:@"设为加急" forState:UIControlStateNormal];
}
@end
