//
//  YYUserInfoModel.m
//  Treasure
//
//  Created by 蓝蓝色信子 on 16/7/1.
//  Copyright © 2016年 GY. All rights reserved.
//

#import "UserInfo.h"
static UserInfo *info;
@implementation UserInfo


+(UserInfo*)share{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        info = [[UserInfo alloc]init];
    });
    return info;
}
//保存用户信息
+(void)saveUserInfoWithJsonMessage:(NSDictionary *)jsonMessage
{
    [UserInfo share].isLogin = YES;
    
    [UserInfo share].uId = [NSString stringWithFormat:@"%@",jsonMessage[@"id"]];
    [UserInfo share].token = jsonMessage[@"app_token"];
    [UserInfo share].headerImg = jsonMessage[@"image"];
    [UserInfo share].tel = [NSString stringWithFormat:@"%@",jsonMessage[@"telephone"]];
    [UserInfo share].sex = [NSString stringWithFormat:@"%@",jsonMessage[@"sex"]];
    [UserInfo share].type = [NSString stringWithFormat:@"%@",jsonMessage[@"attestation_type"]];
    [UserInfo share].nickName = jsonMessage[@"nickname"];
    
    [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"isLogin"];
    [[NSUserDefaults standardUserDefaults] setObject:jsonMessage[@"nickname"] forKey:@"nickName"];
    [[NSUserDefaults standardUserDefaults] setObject:jsonMessage[@"image"] forKey:@"headerImg"];
    [[NSUserDefaults standardUserDefaults] setObject:[NSString stringWithFormat:@"%@",jsonMessage[@"id"]] forKey:@"uId"];
    [[NSUserDefaults standardUserDefaults] setObject:jsonMessage[@"app_token"] forKey:@"uToken"];
    [[NSUserDefaults standardUserDefaults] setObject:[NSString stringWithFormat:@"%@",jsonMessage[@"sex"]] forKey:@"uSex"];
    [[NSUserDefaults standardUserDefaults] setObject:[NSString stringWithFormat:@"%@",jsonMessage[@"telephone"]] forKey:@"uTel"];
    [[NSUserDefaults standardUserDefaults] setObject:[NSString stringWithFormat:@"%@",jsonMessage[@"attestation_type"]] forKey:@"uType"];
}

//获取用户信息
+(void)getUserInfoDetail
{
    BOOL whether = [[NSUserDefaults standardUserDefaults] boolForKey:@"isLogin"];
    if (whether) {
        //        NSDictionary * jsonMessage = [[NSUserDefaults standardUserDefaults] objectForKey:@"userInfoDic"];
        
        [UserInfo share].isLogin = YES;
        [UserInfo share].uId = [[NSUserDefaults standardUserDefaults] objectForKey:@"uId"];
        [UserInfo share].token = [[NSUserDefaults standardUserDefaults] objectForKey:@"uToken"];
        [UserInfo share].nickName = [[NSUserDefaults standardUserDefaults] objectForKey:@"nickName"];
        [UserInfo share].headerImg = [[NSUserDefaults standardUserDefaults] objectForKey:@"headerImg"];
        [UserInfo share].sex = [[NSUserDefaults standardUserDefaults] objectForKey:@"uSex"];
        [UserInfo share].tel = [[NSUserDefaults standardUserDefaults] objectForKey:@"uTel"];
        [UserInfo share].type = [[NSUserDefaults standardUserDefaults] objectForKey:@"uType"];
    } else {
        [UserInfo share].isLogin = NO;
        
    }
}
+(void)userLogOut
{
    [[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"isLogin"];
    [UserInfo share].isLogin = NO;
}
@end
