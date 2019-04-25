//
//  BaseDefinition.h
//
//
//  Created by FengDongsheng on 13-10-21.
//  Copyright (c) 2013年 All rights reserved.
//

#ifndef BaseDefinition_h
#define BaseDefinition_h

#import "UIButton+WebCache.h"
#import "UIImageView+WebCache.h"
#import "UIViewExt.h"
#import "UIButton+GYImagePosition.h"
#import "UIColor+Extensions.h"
#import "AFNetworking.h"
#import "UIView+Additions.h"
//#import "UINavigationController+YYPopGesture.h"
#import "MJExtension.h"
#import "SVProgressHUD.h"
#import "LoadAnimateView.h"
#import "MJRefresh.h"
#import "SDPhotoBrowser.h"
#import "GYToolKit.h"
#import "MLInputDodger.h"
#import "SystemNVC.h"
#import "iCarousel.h"
#import "GYPostData+main.h"
#import "Masonry.h"
#import "DXAlertView.h"
#import "BaseDefinition.h"
#import "UserInfo.h"
#import "NetDefine.h"
#import "MD5Tool.h"
#import "Categorys.h"
#import "LoginViewController.h"
#import "DialogView.h"
#import "SystemNVC.h"
#import "GYCollectionLayout.h"
#import "CommentWebVC.h"
#import "UIFactory.h"
#import "YYEverColor.h"
#import "GYTimer.h"
#import "TZImagePickerController.h"
#import "UIView+WHC_AutoLayout.h"
//----------------------系统----------------------------

//获取系统版本
#define IOS_VERSION                                   [[[UIDevice currentDevice] systemVersion] floatValue]
#define CurrentSystemVersion                          [[UIDevice currentDevice] systemVersion]

//获取当前语言
#define CurrentLanguage                               ([[NSLocale preferredLanguages] objectAtIndex:0])

//当前应用的版本号
#define CurrentAppVersion                             [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"]
#define SAVE_APP_VERSION                              @"app_local_version"

//获取应用名称
#define APP_NAME                                      [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleDisplayName"]

#define KeyWindow [[UIApplication sharedApplication] keyWindow]

//判断是否 Retina屏、设备是否%fhone 5、是否是iPad
#define iPhone4 ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(640, 960), [[UIScreen mainScreen] currentMode].size) : NO)
#define iPhone5 ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(640, 1136), [[UIScreen mainScreen] currentMode].size) : NO)
#define iphone6 ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(750, 1334), [[UIScreen mainScreen] currentMode].size) : NO)
#define iPhone6p ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(414, 736), [[UIScreen mainScreen] currentMode].size) : NO)
#define iphone6Plus ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(1242, 2208), [[UIScreen mainScreen] currentMode].size) : NO)
#define iphoneX ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? ([[UIScreen mainScreen] currentMode].size.height==1792 ||[[UIScreen mainScreen] currentMode].size.height >=2436) : NO)
#define isPad  (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)

//这是用来适配X的
#define StatusBarHeight [[UIApplication sharedApplication] statusBarFrame].size.height //状态栏高度
#define NavBarHeight 44.0
#define TabBarHeight ([[UIApplication sharedApplication] statusBarFrame].size.height>20?83:49) //底部tabbar高度
#define TopHeight (StatusBarHeight + NavBarHeight) //整个导航栏高度




//设置 view 圆角和边框
#define ViewBorderRadius(View, Radius, Width, Color)\
\
[View.layer setCornerRadius:(Radius)];\
[View.layer setMasksToBounds:YES];\
[View.layer setBorderWidth:(Width)];\
[View.layer setBorderColor:[Color CGColor]]




//----------------------颜色类---------------------------
// rgb颜色转换（16进制->10进制）
#define RGB(hex)            [UIColor colorWithRed:((float)((hex & 0xFF0000) >> 16))/255.0 green:((float)((hex & 0xFF00) >> 8))/255.0 blue:((float)(hex & 0xFF))/255.0 alpha:1.0]
#define RGBA(hex, a)        [UIColor colorWithRed:((float)((hex & 0xFF0000) >> 16))/255.0 green:((float)((hex & 0xFF00) >> 8))/255.0 blue:((float)(hex & 0xFF))/255.0 alpha:a]

#pragma mark - color functions
#define RGBCOLOR(r,g,b) [UIColor colorWithRed:(r)/255.0f green:(g)/255.0f blue:(b)/255.0f alpha:1]
#define RGBACOLOR(r,g,b,a) [UIColor colorWithRed:(r)/255.0f green:(g)/255.0f blue:(b)/255.0f alpha:(a)]

#define random(r, g, b, a) [UIColor colorWithRed:(r)/255.0 green:(g)/255.0 blue:(b)/255.0 alpha:(a)/255.0]
#define randomColor random(arc4random_uniform(256), arc4random_uniform(256), arc4random_uniform(256), arc4random_uniform(256))
//----------------------其他----------------------------
#define LOAD_ANIMATE [LoadAnimateView showHUDToView:[[UIApplication sharedApplication] keyWindow]]
#define LOAD_DISMISS [LoadAnimateView dismissHUD]
#define SCREEN_WIDTH [UIScreen mainScreen].bounds.size.width
#define SCREEN_HEIGHT [UIScreen mainScreen].bounds.size.height

//主要单例
#define UserDefaults             [NSUserDefaults standardUserDefaults]
#define RGBCOLOR(r,g,b)          [UIColor colorWithRed:(r)/255.0f green:(g)/255.0f blue:(b)/255.0f alpha:1]
#define RGBACOLOR(r,g,b,a)       [UIColor colorWithRed:(r)/255.0f green:(g)/255.0f blue:(b)/255.0f alpha:(a)]

#define YLBlack [UIColor colorWithRed:(38)/255.0f green:(38)/255.0f blue:(38)/255.0f alpha:1]
#define DY_ORANGE [UIColor colorWithRed:251/255.0 green:192/255.0 blue:45/255.0 alpha:1] //大牙橙
#define WD_BACKCOLOR [UIColor colorWithRed:247/255.0 green:248/255.0 blue:249/255.0 alpha:1] //背景色
#define WD_LINECOLOR [UIColor colorWithRed:239/255.0 green:239/255.0 blue:239/255.0 alpha:1] //线
#define WD_BLUE [UIColor colorWithRed:14/255.0 green:124/255.0 blue:244/255.0 alpha:1] //背景色

#define sliderHeight 49
#define STATUS_HEIGHT [[UIApplication sharedApplication] statusBarFrame].size.height//状态栏高度
#define SCREEN_WINDOW_HEIGHT (SCREEN_HEIGHT-(STATUS_HEIGHT+44))
#define kFont_Lable_20 [UIFont systemFontOfSize:20]
#define kFont_Lable_19 [UIFont systemFontOfSize:19]
#define kFont_Lable_18 [UIFont systemFontOfSize:18]
#define kFont_Lable_17 [UIFont systemFontOfSize:17]
#define kFont_Lable_16 [UIFont systemFontOfSize:16]
#define kFont_Lable_15 [UIFont systemFontOfSize:15]
#define kFont_Lable_14 [UIFont systemFontOfSize:14]
#define kFont_Lable_13 [UIFont systemFontOfSize:13]
#define kFont_Lable_12 [UIFont systemFontOfSize:12]
#define kFont_Lable_10 [UIFont systemFontOfSize:10]
#define kFontBlackColor GBCOLOR(30, 30, 30)
#define kFontGrayColor RGB(0xa6a6a6)

typedef NS_ENUM(NSInteger,GetDataType)
{
    //正常请求数据
    GetTypeNomal = 0,
    //下拉刷新请求数据
    GetTypeHeader,
    //上拉加载更多请求数据
    GetTypeFooter
    
};
//圆角
#define ViewRadius(View, Radius)\
\
[View.layer setCornerRadius:(Radius)];\
[View.layer setMasksToBounds:YES]

//weak
#define WeakSelf __weak typeof(self) weakSelf = self;


#define NSLog(FORMAT, ...) fprintf(stderr, "%s:%d\t%s\n", [[[NSString stringWithUTF8String: __FILE__] lastPathComponent] UTF8String], __LINE__, [[NSString stringWithFormat: FORMAT, ## __VA_ARGS__] UTF8String]);

//NSUserDefaults 实例化
#define USER_DEFAULT [NSUserDefaults standardUserDefaults]

//提示
#define ALERT(msg)  [[[UIAlertView alloc]initWithTitle:@"提示" message:msg delegate:nil \
cancelButtonTitle:@"确定" otherButtonTitles:nil,nil] show]
#define IMG_URL(path) [NSURL URLWithString:[NSString stringWithFormat:@"%@",path]]
#define IMG_Name(path) [UIImage imageNamed:[NSString stringWithFormat:@"%@",path]]

#define formatSTR(f, ...)      [NSString stringWithFormat:f, ## __VA_ARGS__]
#define rect2id(x)          NSStringFromCGRect(x)
#define id2rect(x)          CGRectFromString(x)
#define point2id(x)         NSStringFromCGPoint(x)
#define id2point(x)         CGPointFromString(x)
#define sel2id(x)           NSStringFromSelector(@selector(x))
#define id2sel(x)           NSSelectorFromString(x)



#endif
