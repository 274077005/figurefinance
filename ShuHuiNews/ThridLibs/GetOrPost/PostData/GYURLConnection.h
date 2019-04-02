//
//  ZZWUrlSession.h
//  ZZWFashionShows
//
//  Created by qianfeng on 16/1/14.
//  Copyright © 2016年 zhuzhiwen. All rights reserved.
//

#import <Foundation/Foundation.h>


/**
 *  访问网络的block回调
 *
 *  @param id      拿到的网络数据
 *  @param NSError 错误标记
 */
typedef void(^NetHandler) (id,NSError*);
@interface GYURLConnection : NSObject



/**
 *  网络数据加载的类 这个类 只负责网络数据的加载 他是一个单利
 */
+ (GYURLConnection*)defaultSession;
/**
 *  通过url字符串访问服务器 获取结果
 *
 *  @param urlStr URL字符串
 *  fieldArray aes用的
 *  @param bady    请求体字符串
 *  @param handler 返回的回调
 */


- (void)accessServerWithURLStr:(NSString*)urlStr HTTPBody:(NSDictionary*)bodyDic Handler:(NetHandler)handler;

- (void)accessServerWithURLStr:(NSString*)urlStr HeaderFieldArray:(NSArray *)fieldArray HTTPBody:(NSDictionary*)body Handler:(NetHandler)handler;
//有时候后台要json字符串
- (void)accessServerWithURLStr:(NSString*)urlStr HeaderFieldArray:(NSArray *)fieldArray HTTPJsonStr:(NSString*)jsonStr Handler:(NetHandler)handler;
@end
