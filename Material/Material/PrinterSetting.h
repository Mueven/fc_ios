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
-(void)setPrivateCopy:(NSString *)name copies:(NSString *)copies;
-(void)resetPrinterModel;
@end
