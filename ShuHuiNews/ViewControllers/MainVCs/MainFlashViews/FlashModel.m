//
//  FlashModel.m
//  ShuHuiNews
//
//  Created by 耿一 on 2018/9/12.
//  Copyright © 2018年 耿一. All rights reserved.
//

#import "FlashModel.h"


@implementation FlashImgsModel

@end

@implementation FlashModel
//替换关键字
+ (NSDictionary *)mj_replacedKeyFromPropertyName
{
    return @{@"theId": @"id"
             };
}
+ (NSDictionary *)mj_objectClassInArray
{
    return @{
             @"imageArr" :@"FlashImgsModel",
             };
}
@end
