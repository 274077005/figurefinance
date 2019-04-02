//
//  StockDetailModel.m
//  ShuHuiNews
//
//  Created by 耿一 on 2018/6/21.
//  Copyright © 2018年 耿一. All rights reserved.
//

#import "StockDetailModel.h"

@implementation StockDetailModel

//替换关键字
+ (NSDictionary *)mj_replacedKeyFromPropertyName
{
    return @{@"nowP": @"tradePrice",
             @"open": @"openPrice",
             @"top": @"highPrice",
             @"low": @"lowPrice",
             @"lastClose": @"preClosePrice",
             @"margin": @"range",
             @"mp": @"rangePercent"
             };
}
@end
