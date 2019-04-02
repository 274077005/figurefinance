//
//  RingRootModel.m
//  ShuHuiNews
//
//  Created by 耿一 on 2018/4/26.
//  Copyright © 2018年 耿一. All rights reserved.
//

#import "RingRootModel.h"

@implementation RingTagModel

//替换关键字
+ (NSDictionary *)mj_replacedKeyFromPropertyName
{
    return @{@"theId": @"id"};
}
@end

@implementation RingListModel

//替换关键字
+ (NSDictionary *)mj_replacedKeyFromPropertyName
{
    return @{@"theId": @"id"};
}
@end


@implementation RingRootModel


//替换关键字
+ (NSDictionary *)mj_replacedKeyFromPropertyName
{
    return @{@"theId": @"id"};
}

+ (NSDictionary *)mj_objectClassInArray
{
    return @{
             @"person" : @"RingListModel",
             @"person_tag" : @"RingTagModel",
             @"company" : @"RingListModel",
             @"company_tag" : @"RingTagModel",
             };
}

@end

@implementation RingStatusModel
//初始化模型
- (instancetype)init
{
    self = [super init];
    if (self) {
        _sCompanyId = @"";
        _sPersonId = @"";

        
    }
    return self;
}
@end
