//
//  GYPostData.h
//  Treasure
//
//  Created by 蓝蓝色信子 on 16/7/20.
//  Copyright © 2016年 GY. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "GYURLConnection.h"


@interface GYPostData : NSObject

/**
 *  获取数据的block回调
 *
 *  @param id      拿到的数据
 *  @param NSError 错误标记
 */
typedef void (^PostDataHandler)(id,NSError *);

@end
