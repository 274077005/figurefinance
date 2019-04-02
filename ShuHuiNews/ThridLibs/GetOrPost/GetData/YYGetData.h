//
//  YYGetData.h
//  Treasure
//
//  Created by 耿一 on 16/4/6.
//  Copyright © 2016年 GY. All rights reserved.
//

#import <Foundation/Foundation.h>


#import "GYUrlSession.h"
/**
 *  获取数据的block回调
 *
 *  @param id      拿到的数据
 *  @param NSError 错误标记
 */
typedef void (^GetDataHandler)(id,NSError *);

@interface YYGetData : NSObject

@end
