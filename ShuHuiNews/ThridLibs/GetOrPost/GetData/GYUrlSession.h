//
//  YYUrlSession.h
//  Treasure
//
//  Created by 耿一 on 16/4/6.
//  Copyright © 2016年 GY. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 *  访问网络的block回调
 *
 *  @param id      拿到的网络数据
 *  @param NSError 错误标记
 */
typedef void (^NetHandler)(id,NSError *);
/**
 *  网络数据加载的类，这个类，只负责网络数据的加载
 它，是一个单例
 */
@interface GYUrlSession : NSObject

@property (nonatomic,copy)NSURLSession * session;


/**
 *  单例接口
 *
 *  @return 单例对象
 */
+(GYUrlSession *)defaultSession;
/**
 *  通过url字符串访问服务器，获取结果
 *
 *  @param urlStr  url字符串
 *  @param handler 结果的回调
 */
-(void)accessServerWithURLStr:(NSString *)urlStr Handler:(NetHandler)handler;


@end
