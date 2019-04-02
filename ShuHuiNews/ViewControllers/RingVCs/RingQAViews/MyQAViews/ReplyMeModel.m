//
//  ReplyMeModel.m
//  ShuHuiNews
//
//  Created by 耿一 on 2018/5/22.
//  Copyright © 2018年 耿一. All rights reserved.
//

#import "ReplyMeModel.h"






@implementation EvalerModel


//替换关键字
+ (NSDictionary *)mj_replacedKeyFromPropertyName
{
    return @{@"theId": @"id"
             };
}
@end

@implementation DeliveryModel
//替换关键字
+ (NSDictionary *)mj_replacedKeyFromPropertyName
{
    return @{@"theId": @"id"
             };
}
+ (NSDictionary *)mj_objectClassInArray
{
    return @{
             @"user" :@"EvalerModel",
             };
}


@end


@implementation ReplyMeModel


//替换关键字
+ (NSDictionary *)mj_replacedKeyFromPropertyName
{
    return @{@"theId": @"id"
             };
}
+ (NSDictionary *)mj_objectClassInArray
{
    return @{
             @"evaler" :@"EvalerModel",
             };
}


@end
