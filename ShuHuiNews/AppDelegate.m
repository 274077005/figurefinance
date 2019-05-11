//
//  AppDelegate.m
//  ShuHuiNews
//
//  Created by 耿一 on 2018/4/8.
//  Copyright © 2018年 耿一. All rights reserved.
//

#import "AppDelegate.h"
#import "RootTabbarVC.h"
#import "LaunchAdvertVC.h"
#import "MusicViewController.h"

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {

    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];

    [UserInfo getUserInfoDetail];
    LaunchAdvertVC * launchVC = [[LaunchAdvertVC alloc]init];
    self.window.rootViewController = launchVC;
    
    if (@available(iOS 11.0, *)) {
        [[UIScrollView appearance] setContentInsetAdjustmentBehavior:UIScrollViewContentInsetAdjustmentNever];
    }
    [self createNetMonitoring];
    [self createShareSDK];
    
    //注册微信支付
    [WXApi registerApp:@"wxa9e9cee77bd0b537"];
    if ([[UIDevice currentDevice].systemVersion floatValue] >= 10.0) {
        
        JPUSHRegisterEntity * entity = [[JPUSHRegisterEntity alloc] init];
        entity.types = UNAuthorizationOptionAlert|UNAuthorizationOptionBadge|UNAuthorizationOptionSound;
        [JPUSHService registerForRemoteNotificationConfig:entity delegate:self];
        
    } else if ([[UIDevice currentDevice].systemVersion floatValue] >= 8.0) {
        //可以添加自定义categories
        [JPUSHService registerForRemoteNotificationTypes:(UIUserNotificationTypeBadge |
                                                          UIUserNotificationTypeSound |
                                                          UIUserNotificationTypeAlert)
                                              categories:nil];
    }
    
    [JPUSHService setupWithOption:launchOptions appKey:@"06d003ed708415f715d0fffc"
                          channel:@"Publish channel"
                 apsForProduction:NO
            advertisingIdentifier:nil];
    //2.1.9版本新增获取registration id block接口。
    [JPUSHService registrationIDCompletionHandler:^(int resCode, NSString *registrationID) {
        if(resCode == 0){
            NSLog(@"registrationID获取成功：%@",registrationID);
        }
        else{
            NSLog(@"registrationID获取失败，code：%d",resCode);
        }
    }];
    
    
    //角标提醒置为0
    
    application.applicationIconBadgeNumber=0;
    [JPUSHService setBadge:0];
    
    
    self.window.backgroundColor = [UIColor whiteColor];
    [self.window makeKeyAndVisible];
    
    // Basic setup
    [self basicSetup];
    return YES;
}


- (void)basicSetup {
    // Remove control
    [[UIApplication sharedApplication] beginReceivingRemoteControlEvents];
    [self becomeFirstResponder];
}

# pragma mark - Remote control

- (void)remoteControlReceivedWithEvent:(UIEvent *)receivedEvent {
    if (receivedEvent.type == UIEventTypeRemoteControl) {
        switch (receivedEvent.subtype) {
            case UIEventSubtypeRemoteControlPause:
                [[MusicViewController sharedInstance].streamer pause];
                break;
            case UIEventSubtypeRemoteControlStop:
                break;
            case UIEventSubtypeRemoteControlPlay:
                [[MusicViewController sharedInstance].streamer play];
                break;
            case UIEventSubtypeRemoteControlTogglePlayPause:
                break;
            case UIEventSubtypeRemoteControlNextTrack:
                [[MusicViewController sharedInstance] playNextMusic:nil];
                break;
            case UIEventSubtypeRemoteControlPreviousTrack:
                [[MusicViewController sharedInstance] playPreviousMusic:nil];
                break;
            default:
                break;
        }
    }
}

//监听网络情况
- (void)createNetMonitoring
{
    AFNetworkReachabilityManager * manager = [AFNetworkReachabilityManager sharedManager];
    [manager startMonitoring];
    
    [manager setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {
        if (status == 1|| status == 2) {
            NSLog(@"网络已连接");
            if ([[UserInfo share].netStatus isEqualToString:@"从未连接过"]) {
                [[NSNotificationCenter defaultCenter]postNotificationName:@"loginOrQuitSuccess" object:nil];
            }
            [UserInfo share].netStatus = @"已连接";
            
        }else{
            if (![[UserInfo share].netStatus isEqualToString:@"已连接"]) {
                [UserInfo share].netStatus = @"从未连接过";
            }
            NSLog(@"网络未连接");
        }
    } ];
}

- (void)createShareSDK
{
    [ShareSDK registerActivePlatforms:@[
                                        @(SSDKPlatformTypeSinaWeibo),
                                        @(SSDKPlatformTypeCopy),
                                        @(SSDKPlatformTypeWechat),
                                        
                                        ]
                             onImport:^(SSDKPlatformType platformType)
     {
         switch (platformType)
         {
             case SSDKPlatformTypeWechat:
                 [ShareSDKConnector connectWeChat:[WXApi class]];
                 break;

             case SSDKPlatformTypeSinaWeibo:
                 [ShareSDKConnector connectWeibo:[WeiboSDK class]];
                 break;
                 
             default:
                 break;
         }
     }
                      onConfiguration:^(SSDKPlatformType platformType, NSMutableDictionary *appInfo)
     {
         
         switch (platformType)
         {
             case SSDKPlatformTypeSinaWeibo:
                 //设置新浪微博应用信息,其中authType设置为使用SSO＋Web形式授权
                 [appInfo SSDKSetupSinaWeiboByAppKey:@"706765257"
                                           appSecret:@"0ce8483e03cd3c522d50bdb4d4d454fd"
                                         redirectUri:@"http://www.figurefinance.com"
                                            authType:SSDKAuthTypeBoth];
                 break;
             case SSDKPlatformTypeWechat:
                 [appInfo SSDKSetupWeChatByAppId:@"wxa9e9cee77bd0b537"
                                       appSecret:@"5d4759184aa5d85212a76ab9b821d0c3"];
                 break;

             default:
                 break;
         }
     }];
    
}
#pragma mark- JPUSHRegisterDelegate
- (void)jpushNotificationCenter:(UNUserNotificationCenter *)center willPresentNotification:(UNNotification *)notification withCompletionHandler:(void (^)(NSInteger))completionHandler {
    NSDictionary * userInfo = notification.request.content.userInfo;
    
    UNNotificationRequest *request = notification.request; // 收到推送的请求
    UNNotificationContent *content = request.content; // 收到推送的消息内容
    
    NSNumber *badge = content.badge;  // 推送消息的角标
    NSString *body = content.body;    // 推送消息体
    UNNotificationSound *sound = content.sound;  // 推送消息的声音
    NSString *subtitle = content.subtitle;  // 推送消息的副标题
    NSString *title = content.title;  // 推送消息的标题
    
    if([notification.request.trigger isKindOfClass:[UNPushNotificationTrigger class]]) {
        [JPUSHService handleRemoteNotification:userInfo];
        NSLog(@"iOS10 前台收到远程通知:%@", userInfo);
        NSLog(@"type:%@",userInfo[@"type"]);
       
        
    }else {
        // 判断为本地通知
        NSLog(@"iOS10 前台收到本地通知:{\nbody:%@，\ntitle:%@,\nsubtitle:%@,\nbadge：%@，\nsound：%@，\nuserInfo：%@\n}",body,title,subtitle,badge,sound,userInfo);
    }
    completionHandler(UNNotificationPresentationOptionAlert);
    //    completionHandler(UNNotificationPresentationOptionNone);
    // 需要执行这个方法，选择是否提醒用户，有Badge、Sound、Alert三种类型可以设置
}
- (void)jpushNotificationCenter:(UNUserNotificationCenter *)center didReceiveNotificationResponse:(UNNotificationResponse *)response withCompletionHandler:(void (^)())completionHandler {
    
    NSDictionary * userInfo = response.notification.request.content.userInfo;
    UNNotificationRequest *request = response.notification.request; // 收到推送的请求
    UNNotificationContent *content = request.content; // 收到推送的消息内容
    
    NSNumber *badge = content.badge;  // 推送消息的角标
    NSString *body = content.body;    // 推送消息体
    UNNotificationSound *sound = content.sound;  // 推送消息的声音
    NSString *subtitle = content.subtitle;  // 推送消息的副标题
    NSString *title = content.title;  // 推送消息的标题
    
    if([response.notification.request.trigger isKindOfClass:[UNPushNotificationTrigger class]]) {
        [JPUSHService handleRemoteNotification:userInfo];
        NSLog(@"iOS10 收到远程通知:%@",userInfo);
        
        //        [self.window.rootViewController presentViewController:Nav animated:YES completion:nil];
    }else{
        // 判断为本地通知
        NSLog(@"iOS10 收到本地通知:{\nbody:%@，\ntitle:%@,\nsubtitle:%@,\nbadge：%@，\nsound：%@，\nuserInfo：%@\n}",body,title,subtitle,badge,sound,userInfo);
    }
    
    completionHandler();  // 系统要求执行这个方法
}
//iOS10以下收到推送执行这个方法
-(void)application:(UIApplication *)application didReceiveRemoteNotification:(nonnull NSDictionary *)userInfo fetchCompletionHandler:(nonnull void (^)(UIBackgroundFetchResult))completionHandler{
    NSLog(@"-->%@",userInfo);
    if (8<=[[UIDevice currentDevice] systemVersion].integerValue && [[UIDevice currentDevice] systemVersion].integerValue < 10) {
       
        
    }
    
    [JPUSHService handleRemoteNotification:userInfo];
    completionHandler(UIBackgroundFetchResultNewData);
}

-(void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error{
    NSLog(@"注册推送失败:%@",error);
}

//极光
- (void)application:(UIApplication *)application
didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken {
    /// Required -    DeviceToken
    NSLog(@"获取到了deviceToken:%@",deviceToken);
//    NSString * deviceTokenStr = [NSString stringWithFormat:@"%@",deviceToken];
    [JPUSHService registerDeviceToken:deviceToken];
}


- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
//    application.applicationIconBadgeNumber=1;
    application.applicationIconBadgeNumber=0;
    [JPUSHService setBadge:0];
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    application.applicationIconBadgeNumber=1;
    application.applicationIconBadgeNumber=0;
    [JPUSHService setBadge:0];
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}
- (UIInterfaceOrientationMask)application:(UIApplication *)application supportedInterfaceOrientationsForWindow:(UIWindow *)window
{
    if (_allowRotation == 1) {
        return UIInterfaceOrientationMaskAll;
    }else if(_allowRotation == 2) {
        
        return UIInterfaceOrientationMaskLandscapeRight;
    }else{
        return (UIInterfaceOrientationMaskPortrait);
    }
}
-(BOOL)application:(UIApplication *)app openURL:(NSURL *)url options:(NSDictionary<NSString*, id> *)options
{
    
    NSString * urlStr = [url absoluteString];
    if ([urlStr containsString:@"wx"]) {
        return [WXApi handleOpenURL:url delegate:self];
    }
    
    if ([url.host isEqualToString:@"safepay"]) {
        //跳转支付宝钱包进行支付，处理支付结果
        [[AlipaySDK defaultService] processOrderWithPaymentResult:url standbyCallback:^(NSDictionary *resultDic) {
            if ([resultDic[@"resultStatus"] integerValue] == 9000) {
                [[NSNotificationCenter defaultCenter] postNotificationName:NPayStatus object:nil];
            }else if ([resultDic[@"resultStatus"] integerValue] == 6001){
                [SVProgressHUD showWithString:@"支付取消"];
            }else if ([resultDic[@"resultStatus"] integerValue] == 4000){
                [SVProgressHUD showWithString:@"支付失败"];
            }
        }];
    }
    return YES;
}
- (BOOL)application:(UIApplication *)application handleOpenURL:(NSURL *)url {
    return  [WXApi handleOpenURL:url delegate:self];
}

- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation {
    return [WXApi handleOpenURL:url delegate:self];
}
/**微信回调*/
- (void)onResp:(BaseResp*)resp{
    
    
    if ([resp isKindOfClass:[PayResp class]]){
        PayResp * response=(PayResp*)resp;
        switch(response.errCode){
            case WXSuccess:
                NSLog(@"支付成功");
                //服务器端查询支付通知或查询API返回的结果再提示成功
                
                [[NSNotificationCenter defaultCenter] postNotificationName:NPayStatus object:nil];
                break;
            case WXErrCodeAuthDeny:
            case WXErrCodeUnsupport:
            case WXErrCodeSentFail:
            case WXErrCodeCommon:
                NSLog(@"支付失败");
                [SVProgressHUD showWithString:@"支付失败"];
                break;
            case WXErrCodeUserCancel:
                NSLog(@"支付取消");
                [SVProgressHUD showWithString:@"支付取消"];
                break;
            default:
                break;
        }
    }
}
- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}


@end
