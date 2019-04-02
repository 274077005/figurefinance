//
//  GYStockLineIndicators.h
//  Treasure
//
//  Created by 蓝蓝色信子 on 2017/3/21.
//  Copyright © 2017年 GY. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GYStockKPIModel.h"
@interface GYStockLineIndicators : NSObject
// Boll
/*
 （1）计算MA
 MA=N日内的收盘价之和÷N
 （2）计算标准差MD  c：当天收盘价
 MD=（C－MA）的两次方之和除以N  然后开 (N-1)次方
 （3）计算MB、UP、DN线
 MB=（N－1）日的MA
 UP=MB+k×MD
 DN=MB－k×MD
 （K为参数，可根据股票的特性来做相应的调整，一般默认为2）
 */
+ (NSMutableArray *)BollLine:(NSArray *)data days:(NSInteger)ds K:(NSInteger)k;

/******
 ENV指标是一个压力支撑指标。其公式如下：
 UPPER:(1+M1/100)*MA(CLOSE,N);
 LOWER:(1-M2/100)*MA(CLOSE,N);
 MID:(UPPER+LOWER)/2;
 其中N为25，M1和M2为6，这些参数均为默认参数。
 */

+ (NSMutableArray *)envLine:(NSArray *)data times:(NSInteger)days;


//计算K线数据
+(NSMutableDictionary *)generateKLineData:(NSArray *)data withKPIModel:(GYStockKPIModel *)kpiModel;

//设置分时图的Series
+(NSMutableArray *)setNowKLineSeries;
//设置日线的Series
+(NSMutableArray *)setDayKLineSeriesWithKPIModel:(GYStockKPIModel *)kpiModel;

//Lab中数字变化时，渐变
+ (void)gradualChangeLabWithEndNum:(NSString *)endNum Lab:(UILabel *)Lab Timer:(NSTimer *)changeTimer;
@end
