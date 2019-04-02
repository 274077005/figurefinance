//
//  QAListModel.m
//  ShuHuiNews
//
//  Created by 耿一 on 2018/5/14.
//  Copyright © 2018年 耿一. All rights reserved.
//

#import "QAListModel.h"



@implementation EvaluationModel

//替换关键字
+ (NSDictionary *)mj_replacedKeyFromPropertyName
{
    return @{@"content": @"description",
             @"theId": @"id"
             };
}
@end


@implementation AnswersModel

//替换关键字
+ (NSDictionary *)mj_replacedKeyFromPropertyName
{
    return @{@"content": @"description",
             @"theId": @"id"
             };
}
@end


@implementation QAUserModel

//替换关键字
+ (NSDictionary *)mj_replacedKeyFromPropertyName
{
    return @{@"content": @"description",
             @"theId": @"id"
             };
}

@end


@implementation QATypeModel

//替换关键字
+ (NSDictionary *)mj_replacedKeyFromPropertyName
{
    return @{@"content": @"description",
             @"theId": @"id"
             };
    
}
@end


@implementation QAListModel

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
             @"answers" :@"AnswersModel",
             };
}


@end
