//
//  YYNetHeader.h
//  Treasure
//
//  Created by 耿一 on 16/3/29.
//  Copyright © 2016年 GY. All rights reserved.
//

#ifndef YYNetHeader_h
#define YYNetHeader_h


#define SCREEN_WIDTH [UIScreen mainScreen].bounds.size.width
#define SCREEN_HEIGHT [UIScreen mainScreen].bounds.size.height


#define RedColor [UIColor colorWithRed:253/255.0 green:62/255.0 blue:57/255.0 alpha:1.0]
#define GreenColor [UIColor colorWithRed:81/255.0 green:215/255.0 blue:106/255.0 alpha:1.0]
#define GrayColor [UIColor colorWithRed:235/255.0 green:235/255.0 blue:235/255.0 alpha:1.0]
#define ThinGrayColor [UIColor colorWithRed:102/255.0 green:102/255.0 blue:102/255.0 alpha:1.0]
#define CellColor [UIColor colorWithRed:31/255.0 green:36/255.0 blue:46/255.0 alpha:1.0]
#define BackColor [UIColor colorWithRed:22/255.0 green:25/255.0 blue:32/255.0 alpha:1.0]
#define UIColorFromRGB(rgbValue) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 \
green:((float)((rgbValue & 0xFF00) >> 8))/255.0 \
blue:((float)(rgbValue & 0xFF))/255.0 \
alpha:1.0]
//资讯滚动视图接口

//获取股票市场
#define Market_Categoryies_Pro (@"http://i.sojex.net/FinanceQuoteServer/client.action/GetQuoteTypesV2")
//股票分类信息
#define Market_Detail_Pro (@"http://kdc.tf099.com/dc0/a/Api/gdata?gid=")

#define Stock_Pro (@"http://kdc.tf099.com/dc0/a/Api/")
//测试接口
//#define Live_School_Url (@"http://www.yydev.cn/yiyinappsoft/school_server/api/a/api")
//#define User_Url @("http://www.yydev.cn/yiyinappsoft/sysmanage_server/api/a/api")
//#define member_serverUrl @("http://www.yydev.cn/yiyinappsoft/member_server/api/a/api")
//#define web_Header_Url @("http://www.yydev.cn/yiyinappsoft/")
//#define web_Chat @("http://www.yydev.cn/yiyinappsoft/chat_web/?guid=")
//#define price_Bell_Url @("http://www.yydev.cn/yiyinappsoft/market_server/api/a/api")
//#define service_Url @("http://www.yydev.cn/yiyinappsoft/sysmanage_server/server/a/OnlineService")
//#define VIDEO_PRO (@"http://www.yydev.cn/yiyinappsoft/class_server/api/a/api")
//#define SERVICE_PRO (@"http://www.yydev.cn/yiyinappsoft/services_server/api/a/api")

//正式接口
#define Live_School_Url (@"http://tf105.applinzi.com/apis/school_api/a/api")
#define User_Url @("http://tf105.applinzi.com/apis/sysmanage_api/a/api")
#define member_serverUrl @("http://yyapimem01.tf099.com/member/api/a/api")
#define web_Header_Url @("http://yyapi01.tf099.com/webs/")
#define web_Chat @("http://yychat.tf099.com/yychat/web/?guid=")
#define price_Bell_Url @("http://tf105.applinzi.com/apis/market_api/a/api/")
#define service_Url @("http://1.tf103.applinzi.com/servers/sysmanage_server/a/OnlineService")
#define VIDEO_PRO (@"http://tf105.applinzi.com/apis/class_api/a/api/")
#define SERVICE_PRO (@"http://tf105.applinzi.com/apis/services_api/a/api")
#endif /* YYNetHeader_h */
