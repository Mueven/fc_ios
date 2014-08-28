//
//  PrinterSetting.h
//  Material
//
//  Created by wayne on 14-8-21.
//  Copyright (c) 2014年 brilliantech. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PrinterSetting : NSObject
+(instancetype)sharedPrinterSetting;
-(NSString *)getPrinterModel;
-(NSString *)getPrivatePrinter:(NSString *)name;
-(void)setPrinterModel:(NSString *)model;
-(NSArray *)get_all_printer_model;
-(NSString *)getPrivateCopy:(NSString *)name;
-(void)setPrivateCopy:(NSString *)name copies:(NSString *)copies;
-(void)resetPrinterModel;
@end
