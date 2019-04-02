//
//  GYPostData+main.h
//  Finance
//
//  Created by 耿一 on 2017/9/7.
//  Copyright © 2017年 GY. All rights reserved.
//

#import "GYPostData.h"
#import "GYAES.h"
@interface GYPostData (main)

//发送信息
+(void)PostInfomationWithDic:(NSMutableDictionary *)bodyDic UrlPath:(NSString *)UrlPath Handler:(PostDataHandler)handler;

//Get发送信息
+(void) GetInfomationWithDic:(NSMutableDictionary *)bodyDic UrlPath:(NSString *)UrlPath Handler:(PostDataHandler)handler;


//发送图片
+(void) PostImgsWithDic:(NSMutableDictionary *)bodyDic ImgsArr:(NSMutableArray *)imgsArr UrlPath:(NSString *)UrlPath Handler:(PostDataHandler)handler;

//扫二维码之后处理
+(void) GetQRCodeInfomationWithHeaderUrl:(NSString *)headerUrl UrlPath:(NSString *)urlPath Handler:(PostDataHandler)handler;
//直接拼接
+(void)GetFastInfomationWithUrlPath:(NSString *)UrlPath bodyUrl:(NSString *)bodyUrl Handler:(PostDataHandler)handler;
//验证内购
+(void) PostIAPWithDic:(NSDictionary *)bodyDic UrlPath:(NSString *)UrlPath Handler:(PostDataHandler)handler;
////获取k线分时数据
//+(void)GetStockNowDataWithUrlPath:(NSString *)UrlPath Handler:(PostDataHandler)handler;
//
////获取k线蜡烛图数据
//+(void)GetStockDayDataWithUrlPath:(NSString *)UrlPath Handler:(PostDataHandler)handler;
//对接金十
+(void) PostCalendarWithDic:(NSDictionary *)bodyDic UrlPath:(NSString *)UrlPath Handler:(PostDataHandler)handler;
//获取k线列表数据
+(void)GetStockDataWithUrlPath:(NSString *)UrlPath Handler:(PostDataHandler)handler;
//获取k线详情数据
+(void)GetStockKLineDataWithUrlPath:(NSString *)UrlPath Handler:(PostDataHandler)handler;
//获取巴比特的区块链数据
+(void) PostBBTInfoWithDic:(NSMutableDictionary *)bodyDic UrlPath:(NSString *)UrlPath Handler:(PostDataHandler)handler;
//获取巴比特的区块链K线数据
+(void)PostBBTKDataInfoWithDic:(NSMutableDictionary *)bodyDic UrlPath:(NSString *)UrlPath Handler:(PostDataHandler)handler;
//发送比特币
+(void) GetBTCDic:(NSMutableDictionary *)bodyDic UrlPath:(NSString *)UrlPath Handler:(PostDataHandler)handler;
//Get启动广告
+(void) GetAdvertInfoWithDic:(NSMutableDictionary *)bodyDic UrlPath:(NSString *)UrlPath Handler:(PostDataHandler)handler;
//踢回首页
+(void)goHomeVC;
@end
