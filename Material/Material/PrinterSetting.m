//
//  PrinterSetting.m
//  Material
//
//  Created by wayne on 14-8-21.
//  Copyright (c) 2014年 brilliantech. All rights reserved.
//

//printer_model
//P00x_printer
//P00x_copy
//P00x_copy_update

#import "PrinterSetting.h"
#import "AFNetOperate.h"
@interface PrinterSetting()
@property(nonatomic,strong)NSMutableDictionary *printerDictionary;
@property(nonatomic,strong)NSArray *printerModelArray;
@end
@implementation PrinterSetting
+(instancetype)sharedPrinterSetting
{
    static PrinterSetting *printerSetting;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken,^{
        printerSetting=[[PrinterSetting alloc] initPrivate];
    });
    return printerSetting;
}
-(instancetype)initPrivate
{
    self=[super init];
    if(self){
        self.printerDictionary=[[NSMutableDictionary alloc] init];
        AFNetOperate *AFNet=[[AFNetOperate alloc] init];
        AFHTTPRequestOperationManager *manager=[AFHTTPRequestOperationManager manager];
        [manager GET:[AFNet print_model_list]
          parameters:nil
             success:^(AFHTTPRequestOperation *operation, id responseObject) {;
                 if([responseObject[@"Code"] integerValue]==1){
                     if(responseObject[@"Object"]){
                         NSArray *printerArray=responseObject[@"Object"][@"DefaultPrinters"];
                         for(int i=0;i<printerArray.count;i++){
                             NSDictionary *printerItem=printerArray[i];
                             NSDictionary *item=@{
                                                  @"printer":printerItem[@"Name"],
                                                  @"copy":[NSString stringWithFormat:@"%@",printerItem[@"Copy"]]
                                                  };
                             [self.printerDictionary setObject:item forKey:printerItem[@"Id"]];
                         }
                         self.printerModelArray=responseObject[@"Object"][@"SystemPrinters"];
 
                     }
                 }
                 else{
                    
                 }
             }
             failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                 [AFNet alert:[NSString stringWithFormat:@"%@",error.localizedDescription]];
             }
         ];
    }
    return self;
}
#pragma basic method for archive
-(NSString *)archivePath
{
    NSArray *documentDictionary=NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *document=[documentDictionary firstObject];
    NSString *path=[document stringByAppendingPathComponent:@"printer.setting.archive"];
    return path;
}
-(NSDictionary *)archiveDictionary
{
    NSDictionary *dictionary;
    if([NSKeyedUnarchiver unarchiveObjectWithFile:[self archivePath]]){
        dictionary=[NSKeyedUnarchiver unarchiveObjectWithFile:[self archivePath]];
    }
    else{
        dictionary=[NSDictionary dictionary];
    }
    return dictionary;
}
-(void)saveToArchive:(NSString *)key object:(id)object
{
    NSMutableDictionary *dic=[[self archiveDictionary] mutableCopy];
    [dic setObject:object forKey:key];
    [NSKeyedArchiver archiveRootObject:[dic copy] toFile:[self archivePath]];
}
-(id)dissolveArchive:(NSString *)key alternative:(NSString *)alternative
{
    id result;
    NSDictionary *dictionary=[self archiveDictionary];
    if([dictionary objectForKey:key]){
        result=[dictionary objectForKey:key];
    }
    else{
        result=alternative;
    }
    return result;
}
-(BOOL)isSavedKey:(NSString *)key
{
    BOOL result;
    NSDictionary *dictionary=[self archiveDictionary];
    if([dictionary objectForKey:key]){
        result=YES;
    }
    else{
        result=NO;
    }
    return result;
}
#pragma printer model
-(NSString *)getPrinterModel{
    NSString *model=[self dissolveArchive:@"printer_model" alternative:@""];
    return model;
}
//每一个端口，例如P001都会有一个默认的打印机对应，这样只是为了防止没有设置打印机时去取自己默认的打印机
-(NSString *)getPrivatePrinter:(NSString *)name
{
    if([self isSavedKey:@"printer_update"]){
        return [self getPrinterModel];
    }
    else{
        return self.printerDictionary[name][@"printer"]?self.printerDictionary[name][@"printer"]:@"";
    }
}
//在设置界面设置打印机型号，单独的ITOUCH全局使用这个打印机
-(void)setPrinterModel:(NSString *)model{
    [self saveToArchive:@"printer_model" object:model];
    [self saveToArchive:@"printer_update" object:@1];
}
#pragma return printer models list
-(NSArray *)get_all_printer_model
{
    return self.printerModelArray;
}
#pragma printer copies
-(NSString *)getPrivateCopy:(NSString *)name
{
    NSString *update_sign=[NSString stringWithFormat:@"%@_copy_update",name];
    if([self isSavedKey:update_sign]){
        NSString *copy_sign=[NSString stringWithFormat:@"%@_copy",name];
        return [self dissolveArchive:copy_sign alternative:@"1"];
    }
    else{
        return self.printerDictionary[name][@"copy"]?self.printerDictionary[name][@"copy"]:@"";
    }
}
-(void)setPrivateCopy:(NSString *)name copies:(NSString *)copies
{
    NSString *copy_sign=[NSString stringWithFormat:@"%@_copy",name];
    [self saveToArchive:copy_sign object:copies];
     NSString *update_sign=[NSString stringWithFormat:@"%@_copy_update",name];
    [self saveToArchive:update_sign object:@1];
}
-(void)resetPrinterModel{
    [self saveToArchive:@"printer_update" object:@NO];
}
#pragma method about get/set copy and printer
//same function with getPrivatePrinter , just a proper demonstration
-(NSString *)getPrinterModelWithAlternative:(NSString *)name
{
    if([self isSavedKey:@"printer_update"]){
        return [self getPrinterModel];
    }
    else{
        return self.printerDictionary[name][@"printer"]?self.printerDictionary[name][@"printer"]:@"";
    }
}
//positionName like stoke or shop,dealType like xiang/tuo/yun
-(void)setCopy:(NSString *)positionName type:(NSString *)dealType copies:(NSString *)copies
{
    NSString *copy_sign=[NSString stringWithFormat:@"%@_%@",positionName,dealType];
    [self saveToArchive:copy_sign object:copies];
    NSString *update_sign=[NSString stringWithFormat:@"%@_%@_copy_update",positionName,dealType];
    [self saveToArchive:update_sign object:@1];
}
//alternative use for the situation that u get the copy quantity from default instead setting
-(NSString *)getCopy:(NSString *)positionName type:(NSString *)dealType alternative:(NSString *)PName
{
    NSString *update_sign=[NSString stringWithFormat:@"%@_%@_copy_update",positionName,dealType];
    NSString *alternative=self.printerDictionary[PName][@"copy"]?self.printerDictionary[PName][@"copy"]:@"1";
    if([self isSavedKey:update_sign]){
        NSString *copy_sign=[NSString stringWithFormat:@"%@_%@",positionName,dealType];
        return [self dissolveArchive:copy_sign alternative:alternative];
    }
    else{
        return alternative;
    }
}
@end
