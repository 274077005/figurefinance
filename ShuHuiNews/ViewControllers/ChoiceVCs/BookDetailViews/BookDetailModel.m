//
//  BookDetailModel.m
//  ShuHuiNews
//
//  Created by 耿一 on 2018/7/24.
//  Copyright © 2018年 耿一. All rights reserved.
//

#import "BookDetailModel.h"


@implementation BookBannerModel


@end
@implementation BookDetailModel

//替换关键字
+ (NSDictionary *)mj_replacedKeyFromPropertyName
{
    return @{@"content": @"description",
             @"theId": @"id"
             };
}
+ (NSDictionary *)mj_objectClassInArray
{
    return @{
             @"img_info" :@"BookBannerModel",
             };
}
@end
