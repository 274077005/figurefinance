//
//  FansModel.m
//  ShuHuiNews
//
//  Created by 耿一 on 2018/4/25.
//  Copyright © 2018年 耿一. All rights reserved.
//

#import "FansModel.h"

@implementation FansModel
//替换关键字
+ (NSDictionary *)mj_replacedKeyFromPropertyName
{
    return @{@"theId": @"id"};
}
@end
