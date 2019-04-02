//
//  DESEncryption.h
//  AESDESencryption
//
//  Created by zzw on 16/6/27.
//  Copyright © 2016年 zzw. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CommonCrypto/CommonDigest.h>
#import <CommonCrypto/CommonCryptor.h>

@interface GYDes : NSObject

+ (NSString *) encode:(NSString *)str key:(NSString *)key;
+ (NSString *) decode:(NSString *)str key:(NSString *)key;


+ (void)gradualChangeLabWithEndNum:(NSString *)endNum Lab:(UILabel *)Lab Timer:(NSTimer *)changeTimer;

+ (BOOL)includeChinese:(NSString *)string;

+(void)presentLoginViewWithController:(UITableViewController*)tabC;

+(NSInteger )ComputingTimeWithDateArray:(NSArray *)dateArray;
@end
