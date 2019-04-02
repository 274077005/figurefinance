//
//  GYStockKPIModel.h
//  Treasure
//
//  Created by 蓝蓝色信子 on 2017/3/20.
//  Copyright © 2017年 GY. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GYStockKPIModel : NSObject

//初始化kpi们的值

@property (nonatomic) NSInteger MA1;
@property (nonatomic) NSInteger MA2;
@property (nonatomic) NSInteger MA3;


@property (nonatomic) NSInteger BOLL1;
@property (nonatomic) NSInteger BOLL2;


@property (nonatomic) NSInteger ENV1;


@property (nonatomic) NSInteger MACD1;
@property (nonatomic) NSInteger MACD2;
@property (nonatomic) NSInteger MACD3;


@property (nonatomic) NSInteger RSI1;
@property (nonatomic) NSInteger RSI2;
@property (nonatomic) NSInteger RSI3;


@property (nonatomic) NSInteger KDJ1;
@property (nonatomic) NSInteger KDJ2;
@property (nonatomic) NSInteger KDJ3;

@property (nonatomic) NSInteger WR1;


@end
