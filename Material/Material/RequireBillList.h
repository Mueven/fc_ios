//
//  RequireBillList.h
//  Material
//
//  Created by wayne on 14-7-21.
//  Copyright (c) 2014年 brilliantech. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface RequireBillList : NSObject
+(void)getBillList:(NSArray *)array tableView:(UITableView *)tableView type:(NSString *)type;
@end
