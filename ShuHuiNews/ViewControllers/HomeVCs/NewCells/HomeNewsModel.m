//
//  HomeNewsModel.m
//  ShuHuiNews
//
//  Created by 耿一 on 2018/4/10.
//  Copyright © 2018年 耿一. All rights reserved.
//

#import "HomeNewsModel.h"

@implementation HQListModel

//替换关键字
+ (NSDictionary *)mj_replacedKeyFromPropertyName
{
    return @{@"content": @"description",
             @"theId": @"id"
             };
}



@end
@implementation ColumnListModel


@end

@implementation ImgListModel


@end


@implementation HomeNewsModel

//替换关键字
+ (NSDictionary *)mj_replacedKeyFromPropertyName
{
    return @{@"content": @"description",
             @"theId": @"id",
             @"noNetContent": @"content"
             };
}

+ (NSDictionary *)mj_objectClassInArray
{
    return @{
             @"images" : @"ImgListModel",
             @"columnist" : @"HomeNewsModel",
             @"question" : @"HQListModel",
             };
}


@end
@implementation HomeBannerModel

@end

@implementation HomeAuthorModel

//替换关键字
+ (NSDictionary *)mj_replacedKeyFromPropertyName
{
    return @{
             @"works_id": @"id"
             };
}



@end
