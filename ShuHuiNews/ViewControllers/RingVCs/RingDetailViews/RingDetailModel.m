//
//  RingDetailModel.m
//  ShuHuiNews
//
//  Created by 耿一 on 2018/5/3.
//  Copyright © 2018年 耿一. All rights reserved.
//

#import "RingDetailModel.h"



@implementation RDCommentModel
//替换关键字
+ (NSDictionary *)mj_replacedKeyFromPropertyName
{
    return @{@"theId": @"id"};
}


@end

@implementation RingUserModel



@end
@implementation DetailArrModel



@end


@implementation RingDetailModel

+ (NSDictionary *)mj_objectClassInArray
{
    return @{
             @"relationArr" :@"DetailArrModel",
             @"gradeArr" :@"DetailArrModel",
             @"urlArr" :@"DetailArrModel",
             @"regulationArr" :@"DetailArrModel",
             @"environmentArr" :@"CenterEnvironmentModel",
             @"advertArr" :@"CenterAdvertModel",
             @"commentArr" :@"RDCommentModel",
             };
}

@end
