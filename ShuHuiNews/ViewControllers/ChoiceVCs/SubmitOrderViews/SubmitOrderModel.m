//
//  SubmitOrderModel.m
//  ShuHuiNews
//
//  Created by 耿一 on 2018/7/25.
//  Copyright © 2018年 耿一. All rights reserved.
//

#import "SubmitOrderModel.h"
@implementation SBookModel
//替换关键字
+ (NSDictionary *)mj_replacedKeyFromPropertyName
{
    return @{@"content": @"description",
             @"theId": @"id"
             };
}
@end

@implementation SAddressModel
//替换关键字
+ (NSDictionary *)mj_replacedKeyFromPropertyName
{
    return @{@"content": @"description",
             @"theId": @"id"
             };
}
@end

@implementation SubmitOrderModel

@end

@implementation SubmitNumModel

@end
