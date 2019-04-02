//
//  AppDelegate.h
//  ShuHuiNews
//
//  Created by 耿一 on 2018/4/8.
//  Copyright © 2018年 耿一. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JPUSHService.h"
#import <UserNotifications/UserNotifications.h>
#import <ShareSDK/ShareSDK.h>
#import <ShareSDKConnector/ShareSDKConnector.h>
#import <AlipaySDK/AlipaySDK.h>
//微信SDK头文件
#import "WXApi.h"

//新浪微博SDK头文件
#import "WeiboSDK.h"
@interface AppDelegate : UIResponder <UIApplicationDelegate,JPUSHRegisterDelegate,WXApiDelegate>

@property (strong, nonatomic) UIWindow *window;

@property(nonatomic,assign)NSInteger allowRotation;


@end

