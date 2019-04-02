//
//  MainCenterModel.m
//  ShuHuiNews
//
//  Created by 耿一 on 2018/8/21.
//  Copyright © 2018年 耿一. All rights reserved.
//

#import "MainCenterModel.h"

@implementation CenterAgencyModel

//替换关键字
+ (NSDictionary *)mj_replacedKeyFromPropertyName
{
    return @{@"theId": @"id"
             };
}
@end

@implementation CenterAdvertModel
//替换关键字
+ (NSDictionary *)mj_replacedKeyFromPropertyName
{
    return @{@"theId": @"id"
             };
}
@end

@implementation CenterAttestationModel


@end

@implementation CenterTagInfoModel


@end

@implementation TheCompanyModel
-(id)init
{
    if (self = [super init]) {
        self.type = @"0";
        self.company_url = @"";
    }
    return self;
}

@end

@implementation CenterCompanyModel
+ (NSDictionary *)mj_objectClassInArray
{
    return @{
             @"urls" :@"TheCompanyModel",
             
             };
}
@end

@implementation TheEnvironmentModel

@end

@implementation CenterEnvironmentModel
+ (NSDictionary *)mj_objectClassInArray
{
    return @{
             @"content" :@"TheEnvironmentModel",

             };
}
//替换关键字
+ (NSDictionary *)mj_replacedKeyFromPropertyName
{
    return @{@"theId": @"id"
             };
}
@end
@implementation CenterRegulationModel
//替换关键字
+ (NSDictionary *)mj_replacedKeyFromPropertyName
{
    return @{@"theId": @"id"
             };
}

@end
@implementation CenterContactModel

@end


@implementation CenterBasicModel

@end

@implementation MainCenterModel
+ (NSDictionary *)mj_objectClassInArray
{
    return @{
             @"regulatory" :@"CenterRegulationModel",
             @"environment" :@"CenterEnvironmentModel",
             @"ad" :@"CenterAdvertModel",
             @"allAgency" :@"CenterAgencyModel",
             };
}
@end
