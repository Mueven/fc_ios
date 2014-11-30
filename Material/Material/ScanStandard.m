//
//  ScanStandard.m
//  Material
//
//  Created by wayne on 14-7-14.
//  Copyright (c) 2014年 brilliantech. All rights reserved.
//

#import "ScanStandard.h"
#import "AFNetOperate.h"

// rules include
// material:原材料包装箱标签规范
// product:成品合格证
// require:需求单标签规范
// 保存在ITOUCH文件系统的default应该是一个ID
@interface ScanStandard()
@property(nonatomic,strong)NSMutableDictionary *regexDictionary;
@property(nonatomic,strong)NSDictionary *localRules;
@end
@implementation ScanStandard
+(instancetype)sharedScanStandard
{
    static ScanStandard *scanStandard=nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        scanStandard=[[ScanStandard alloc] initPrivate];
    });
    return scanStandard;
}
-(instancetype)initPrivate
{
    self=[super init];
    if(self){
        self.regexDictionary=[NSMutableDictionary dictionary];
        self.localRules=@{
                          @"material":@{
                                    @"QUANTITY":@"quantity",
                                    @"PART":@"partNumber",
                                    @"DATE":@"date",
                                    @"UNIQ":@"key"
                                  },
                          @"product":@{
                                    @"PART":@"partNumber",
                                    @"QUANTITY":@"quantity",
                                    @"DATE":@"date",
                                    @"UNIQ":@"key"
                                  },
                          @"require":@{
                                    @"ORDERITEM_QTY":@"quantity",
                                    @"ORDERITEM_PART":@"partNumber",
                                    @"ORDERITEM_DEPARTMENT":@"department"
                                  }
                          };
        AFNetOperate *operate=[[AFNetOperate alloc] init];
        NSString *validateString=[operate scan_validate];
        AFHTTPRequestOperationManager *manager=[AFHTTPRequestOperationManager manager];
        [manager GET:validateString
          parameters:nil
             success:^(AFHTTPRequestOperation *operation, id responseObject) {
                 NSArray *result=responseObject;
                 if([result count]>0){
                     if([operate getKeyArchive:@"com.brilliantech.rules.remark" key:@"id"]){
                         NSString *id=[operate getKeyArchive:@"com.brilliantech.rules.remark" key:@"id"];
                         NSString *type=[operate getKeyArchive:@"com.brilliantech.rules.remark" key:@"type"];
                         [self searchMyRules:id type:type originArray:responseObject[@"content"]];
                     }
                 }
             }
             failure:^(AFHTTPRequestOperation *operation, NSError *error) {
             }
         ];
    }
    return self;
}
-(void)searchMyRules:(NSString *)id type:(NSString *)type originArray:(NSArray *)originArray
{
    //id 是规范的id，type是我定义的，array是全部得到的整个完整表单
    NSArray *regexArray=[NSArray array];
    for(int i=0;i<originArray.count;i++){
        if([originArray[i][@"id"] isEqualToString:id]){
            regexArray=[originArray[i][@"regexes"] copy];
            return;
        }
    }
    if(regexArray.count>0){
        NSDictionary *rules=self.localRules[type];
        for(int j=0;j<regexArray.count;j++){
            NSString *key=regexArray[j][@"code"];
            [self.regexDictionary setObject:regexArray[j] forKey:rules[key]];
        }
    }
    
}

-(void)updateRule:(NSString *)id type:(NSString *)type regex:(NSArray *)regexArray
{
    [[[AFNetOperate alloc] init] setKeyArchive:@"com.brilliantech.rules.remark"
                                      keyArray:@[@"id",@"type"] objectArray:@[id,type]];
    [self searchMyRules:id type:type originArray:regexArray];
}


-(NSString *)filterQuantity:(NSString *)data
{
    if(self.regexDictionary.count==0){
        [self alertForSetting];
        return @"";
    }
    NSString *myData=[data copy];
    int beginP=[self.regexDictionary[@"quantity"][@"prefix_length"] intValue];
    int lastP=[self.regexDictionary[@"quantity"][@"suffix_length"] intValue];
    NSString *postString=[NSString string];
    if([myData substringWithRange:NSMakeRange(beginP, [myData length]-beginP-lastP)]){
        postString=[myData substringWithRange:NSMakeRange(beginP, [myData length]-beginP-lastP)];
    }
    else{
        postString=@"";
    }
    return postString;
}
-(NSString *)filterPartNumber:(NSString *)data
{
    if(self.regexDictionary.count==0){
        [self alertForSetting];
        return @"";
    }
    NSString *myData=[data copy];
    int beginP=[self.regexDictionary[@"partNumber"][@"prefix_length"] intValue];
    int lastP=[self.regexDictionary[@"partNumber"][@"suffix_length"] intValue];
    NSString *postString=[NSString string];
    if([myData substringWithRange:NSMakeRange(beginP, [myData length]-beginP-lastP)]){
        postString=[myData substringWithRange:NSMakeRange(beginP, [myData length]-beginP-lastP)];
    }
    else{
        postString=@"";
    }
    return postString;
}
-(NSString *)filterDate:(NSString *)data
{
    if(self.regexDictionary.count==0){
        [self alertForSetting];
        return @"";
    }
    NSString *myData=[data copy];
    int beginP=[self.regexDictionary[@"date"][@"prefix_length"] intValue];
    int lastP=[self.regexDictionary[@"date"][@"suffix_length"] intValue];
    NSString *postString=[NSString string];
    if([myData substringWithRange:NSMakeRange(beginP, [myData length]-beginP-lastP)]){
        postString=[myData substringWithRange:NSMakeRange(beginP, [myData length]-beginP-lastP)];
    }
    else{
        postString=@"";
    }
    return postString;
}
-(NSString *)filterKey:(NSString *)data
{
    if(self.regexDictionary.count==0){
        [self alertForSetting];
        return @"";
    }
    NSString *myData=[data copy];
    int beginP=[self.regexDictionary[@"key"][@"prefix_length"] intValue];
    int lastP=[self.regexDictionary[@"key"][@"suffix_length"] intValue];
    NSString *postString=[NSString string];
    if([myData substringWithRange:NSMakeRange(beginP, [myData length]-beginP-lastP)]){
        postString=[myData substringWithRange:NSMakeRange(beginP, [myData length]-beginP-lastP)];
    }
    else{
        postString=@"";
    }
    return postString;
}
-(NSString *)filterDepartment:(NSString *)data
{
    if(self.regexDictionary.count==0){
        [self alertForSetting];
        return @"";
    }
    NSString *myData=[data copy];
    int beginP=[self.regexDictionary[@"department"][@"prefix_length"] intValue];
    int lastP=[self.regexDictionary[@"department"][@"suffix_length"] intValue];
    NSString *postString=[NSString string];
    if([myData substringWithRange:NSMakeRange(beginP, [myData length]-beginP-lastP)]){
        postString=[myData substringWithRange:NSMakeRange(beginP, [myData length]-beginP-lastP)];
    }
    else{
        postString=@"";
    }
    return postString;
}
-(BOOL)checkQuantity:(NSString *)data{
    if(self.regexDictionary.count==0){
        [self alertForSetting];
        return NO;
    }
    NSString *regex=self.regexDictionary[@"quantity"][@"regex_string"];
    NSPredicate * pred= [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
    BOOL isMatch  = [pred evaluateWithObject:data];
    return isMatch;
}
-(BOOL)checkPartNumber:(NSString *)data
{
    if(self.regexDictionary.count==0){
        [self alertForSetting];
        return NO;
    }
    NSString *regex=self.regexDictionary[@"partNumber"][@"regex_string"];
    NSPredicate * pred= [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
    BOOL isMatch  = [pred evaluateWithObject:data];
    return isMatch;
}
-(BOOL)checkDate:(NSString *)data
{
    if(self.regexDictionary.count==0){
        [self alertForSetting];
        return NO;
    }
    NSString *regex=self.regexDictionary[@"date"][@"regex_string"];
    NSPredicate * pred= [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
    BOOL isMatch  = [pred evaluateWithObject:data];
    return isMatch;
}
-(BOOL)checkKey:(NSString *)data
{
    if(self.regexDictionary.count==0){
        [self alertForSetting];
        return NO;
    }
    NSString *regex=self.regexDictionary[@"key"][@"regex_string"];
    NSPredicate * pred= [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
    BOOL isMatch  = [pred evaluateWithObject:data];
    return isMatch;
}
-(BOOL)checkDepartment:(NSString *)data
{
    if(self.regexDictionary.count==0){
        [self alertForSetting];
        return NO;
    }
    NSString *regex=self.regexDictionary[@"department"][@"regex_string"];
    NSPredicate * pred= [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
    BOOL isMatch  = [pred evaluateWithObject:data];
    return isMatch;
}
-(void)alertForSetting
{
    UIAlertView *alert=[[UIAlertView alloc] initWithTitle:@""
                                                  message:@"请在设置界面设置标签规范"
                                                 delegate:self
                                        cancelButtonTitle:@"确定"
                                        otherButtonTitles:nil];
    [alert show];
}
@end
