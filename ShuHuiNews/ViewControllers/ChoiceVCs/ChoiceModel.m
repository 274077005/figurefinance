//
//  ChoiceModel.m
//  ShuHuiNews
//
//  Created by 耿一 on 2018/4/18.
//  Copyright © 2018年 耿一. All rights reserved.
//

#import "ChoiceModel.h"

@implementation ComListModel

//替换关键字
+ (NSDictionary *)mj_replacedKeyFromPropertyName
{
    return @{@"content": @"description",
             @"theId": @"id",
             };
}

@end

@implementation ChoiceBookModel
+ (NSDictionary *)mj_objectClassInArray
{
    return @{
             @"comList" :@"ComListModel",
             };
}
@end

@implementation ChoiceBannerModel
//替换关键字
+ (NSDictionary *)mj_replacedKeyFromPropertyName
{
    return @{@"content": @"description",
             @"theId": @"id"
             };
}
@end

@implementation ChoiceModel
+ (NSDictionary *)mj_objectClassInArray
{
    return @{
             @"banner" :@"ChoiceBannerModel",
             @"book_list" :@"ChoiceBookModel",
             };
}
@end

@implementation ExtendModel
+ (NSDictionary *)mj_objectClassInArray
{
    return @{
             
             };
}
@end

@implementation UserInfoModel
+ (NSDictionary *)mj_replacedKeyFromPropertyName
{
    return @{@"userId": @"id",
             @"userAvatar": @"image"
             };
}
@end
