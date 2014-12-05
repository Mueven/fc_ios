//
//  PrinterSetting.h
//  Material
//
//  Created by wayne on 14-8-21.
//  Copyright (c) 2014年 brilliantech. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PrinterSetting : NSObject
-(NSString *)getPrinterModel;
-(NSArray *)get_all_printer_model;
-(NSString *)getPrivatePrinter:(NSString *)name;
-(NSString *)getPrivateCopy:(NSString *)name;
+(instancetype)sharedPrinterSetting;
-(void)setPrinterModel:(NSString *)model;
//移库清单还在使用的方法
-(void)setPrivateCopy:(NSString *)name copies:(NSString *)copies;
-(void)resetPrinterModel;
//same function with getPrivatePrinter , just a proper demonstration
-(NSString *)getPrinterModelWithAlternative:(NSString *)name;
//positionName like stoke or shop,dealType like xiang/tuo/yun
-(void)setCopy:(NSString *)positionName type:(NSString *)dealType copies:(NSString *)copies;
//alternative use for the situation that u get the copy quantity from default instead setting
-(NSString *)getCopy:(NSString *)positionName type:(NSString *)dealType alternative:(NSString *)PName;
@end
