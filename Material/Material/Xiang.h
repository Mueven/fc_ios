//
//  Xiang.h
//  Material
//
//  Created by wayne on 14-6-6.
//  Copyright (c) 2014年 brilliantech. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Xiang : NSObject
@property(nonatomic,strong)NSString *id;
@property(nonatomic,strong)NSString *number;
@property(nonatomic,strong)NSString *key;
@property(nonatomic,strong)NSString *count;
@property(nonatomic,strong)NSString *position;
@property(nonatomic,strong)NSString *remark;
@property(nonatomic)BOOL checked;
-(instancetype)initExample;
@end
