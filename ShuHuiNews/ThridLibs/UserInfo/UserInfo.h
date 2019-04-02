//
//  YYUserInfoModel.h
//  Treasure
//
//  Created by 蓝蓝色信子 on 16/7/1.
//  Copyright © 2016年 GY. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UserInfo : NSObject



@property(nonatomic,copy)NSString *uId;
@property(nonatomic,copy)NSString *headerImg;
@property(nonatomic,copy)NSString *tel;
@property(nonatomic,copy)NSString *sex;
@property(nonatomic,copy)NSString *nickName;
@property(nonatomic,copy)NSString *token;
@property(nonatomic,copy)NSString *type;


@property(nonatomic,copy)NSString *netStatus;

//启动广告
@property(nonatomic,copy)NSString *advertUrl;
@property(nonatomic,assign)BOOL advertClick;
@property (copy,nonatomic) NSString * real_pay_pwd_status; //是否已经设置交易密码

@property(nonatomic,copy)NSString *deviceToken;//极光token

@property(nonatomic,copy)NSString *level;//vip等级
@property(nonatomic,copy)NSString *phone;//手机号

@property(nonatomic,copy)NSString *imageUrl;//头像链接
@property(nonatomic,copy)NSString *QQ;
@property(nonatomic,copy)NSString *guid;
@property(nonatomic,copy)NSString *theId;

@property(nonatomic,copy)NSString *thirdUserId;

@property(nonatomic)NSInteger stockDataIsOrNotChange;

@property(nonatomic,assign)BOOL isLogin;//是否登录

+(UserInfo *)share;

//保存用户信息
+(void)saveUserInfoWithJsonMessage:(NSDictionary *)jsonMessage;

//获取用户信息
+(void)getUserInfoDetail;

+(void)userLogOut;
@end
