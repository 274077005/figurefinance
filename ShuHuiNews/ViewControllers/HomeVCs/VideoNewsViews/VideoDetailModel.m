//
//  VideoDetailModel.m
//  ShuHuiNews
//
//  Created by 耿一 on 2018/7/16.
//  Copyright © 2018年 耿一. All rights reserved.
//

#import "VideoDetailModel.h"




@implementation VNewsModel
//替换关键字
+ (NSDictionary *)mj_replacedKeyFromPropertyName
{
    return @{@"content": @"description",
             @"theId": @"id"
             };
}
@end

@implementation VCommentModel
//替换关键字
+ (NSDictionary *)mj_replacedKeyFromPropertyName
{
    return @{@"content": @"description",
             @"theId": @"id"
             };
}
@end
@implementation VCorrelationModel
//替换关键字
+ (NSDictionary *)mj_replacedKeyFromPropertyName
{
    return @{@"content": @"description",
             @"theId": @"id"
             };
}
@end

@implementation VideoDetailModel
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
             @"correlation" :@"VCorrelationModel",
             @"comment" :@"VCommentModel",
             };
}
@end
