//
//  GYStockLineIndicators.m
//  Treasure
//
//  Created by 蓝蓝色信子 on 2017/3/21.
//  Copyright © 2017年 GY. All rights reserved.
//

#import "GYStockLineIndicators.h"

@implementation GYStockLineIndicators

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
+ (NSMutableArray *)BollLine:(NSArray *)data days:(NSInteger)ds K:(NSInteger)k
{
    //    NSLog(@"boll==jisuan==%ld",data.count);
    NSMutableArray *man = [[NSMutableArray alloc] init];
    
    for (int i = 0; i<data.count; i++) {
        if (i < ds) {
            [man addObject:[[NSMutableArray alloc] init]];
        }else {
            NSMutableArray *threeValue = [[NSMutableArray alloc] init];
            
            float sma = 0.0;
            float stDev = 0.0;
            float sum1 = 0.0;
            for(int j=i;j>i-ds;j--){
                
                NSArray *temp1 = data[j];
                
                sum1 += [temp1[1] floatValue];
                
            }
            sma = sum1/ds;
            float sum2 = 0;
            for (int  m=i; m>i-ds; m--) {
                NSArray *temp2 = data[m];
                float p = [temp2[1] floatValue];
                sum2 += (p - sma)*(p - sma);
                
            }
            
            stDev = sqrtf(sum2/(ds));
            
            
            float lastDayPrice = [data[i][1] floatValue];
            float firstDayPrice = [data[i-ds][1] floatValue];
            float mb = (sma*ds-lastDayPrice+firstDayPrice)/(ds);
            
            float up = mb + k*stDev;
            float dn = mb - k*stDev;
            
            [threeValue addObject:[NSNumber numberWithFloat:mb]];
            [threeValue addObject:[NSNumber numberWithFloat:up]];
            [threeValue addObject:[NSNumber numberWithFloat:dn]];
            [man addObject:threeValue];
            //            NSLog(@"bolling: mb:%f===up:%f====dn:%f======index:%d",mb,up,dn,i);
            
        }
    }
    return man;
}

/******
 ENV指标是一个压力支撑指标。其公式如下：
 UPPER:(1+M1/100)*MA(CLOSE,N);
 LOWER:(1-M2/100)*MA(CLOSE,N);
 MID:(UPPER+LOWER)/2;
 其中N为25，M1和M2为6，这些参数均为默认参数。
 */

+ (NSMutableArray *)envLine:(NSArray *)data times:(NSInteger)days
{
    
    NSMutableArray *array = [[NSMutableArray alloc] init];
    float m1 = 6.0f;
    float m2 = 6.0f;
    
    for (int i = 0; i<data.count; i++) {
        if (i<days) {
            [array addObject:[[NSMutableArray alloc] init]];
        }else{
            float nowEma = 0.0f;
            NSMutableArray *temp = [[NSMutableArray alloc] init];
            for (int j =i ; j>i-days; j--) {
                nowEma += [[[data objectAtIndex:j] objectAtIndex:1] floatValue];
            }
            
            nowEma = nowEma/days;
            //            NSLog(@"====%d===%f=",i,nowEma);
            float upper = (1.0f + m1/100.0f) * nowEma;
            float lower = (1.0f - m2/100.0f) * nowEma;
            float mid = (upper + lower)/2;
            
            [temp addObject:[NSNumber numberWithFloat:upper]];
            [temp addObject:[NSNumber numberWithFloat:lower]];
            [temp addObject:[NSNumber numberWithFloat:mid]];
            
            [array addObject:temp];
        }
    }
    
    return array;
}
//计算K线数据
+(NSMutableDictionary *)generateKLineData:(NSArray *)data withKPIModel:(GYStockKPIModel *)kpiModel
{                                                                                                     
    NSMutableDictionary * dic = [[NSMutableDictionary alloc]init];
    
    //price
    NSMutableArray *price = [[NSMutableArray alloc] init];
    for(int i = 0;i < data.count;i++){
        [price addObject:data[i]];
    }
    dic[@"price"] = price;
    
    //MA 5
    NSMutableArray *ma5 = [[NSMutableArray alloc] init];
    for(int i = 0;i < data.count;i++){
        float val = 0;
        if (i < kpiModel.MA1) {
            [ma5 addObject:@""];
        } else {
            for(int j=i;j>i-kpiModel.MA1;j--){
                val += [[[data objectAtIndex:j] objectAtIndex:1] floatValue];
            }
            val = val/kpiModel.MA1;
            NSMutableArray *item = [[NSMutableArray alloc] init];
            [item addObject:[@"" stringByAppendingFormat:@"%f",val]];
            [ma5 addObject:item];
        }
    }
    [dic setObject:ma5 forKey:@"ma5"];
    
    //MA 10
    NSMutableArray *ma10 = [[NSMutableArray alloc] init];
    for(int i = 0;i < data.count;i++){
        float val = 0;
        
        if (i < kpiModel.MA2) {
            [ma10 addObject:@""];
        } else {
            for(int j=i;j>i-kpiModel.MA2;j--){
                val += [[[data objectAtIndex:j] objectAtIndex:1] floatValue];
            }
            val = val/kpiModel.MA2;
            NSMutableArray *item = [[NSMutableArray alloc] init];
            [item addObject:[@"" stringByAppendingFormat:@"%f",val]];
            [ma10 addObject:item];
        }
    }
    
    dic[@"ma10"] = ma10;
    
    //MA 20
    NSMutableArray *ma20 = [[NSMutableArray alloc] init];
    for(int i = 0;i < data.count;i++){
        float val = 0;
        if (i < kpiModel.MA3) {
            [ma20 addObject:@""];
        } else {
            for(int j=i;j>i-kpiModel.MA3;j--){
                val += [[[data objectAtIndex:j] objectAtIndex:1] floatValue];
            }
            val = val/kpiModel.MA3;
            NSMutableArray *item = [[NSMutableArray alloc] init];
            [item addObject:[@"" stringByAppendingFormat:@"%f",val]];
            [ma20 addObject:item];
        }
        
    }
    dic[@"ma20"] = ma20;
    
    //BOLL
    NSMutableArray *bollArray = [GYStockLineIndicators BollLine:data days:kpiModel.BOLL1 K:kpiModel.BOLL2];
    NSMutableArray *MAArray = [[NSMutableArray alloc] init];
    NSMutableArray *UPArray = [[NSMutableArray alloc] init];
    NSMutableArray *DNArray = [[NSMutableArray alloc] init];
    
    for (int i=0; i<bollArray.count; i++) {
        NSArray *three = bollArray[i];
        if (i<kpiModel.BOLL1) {
            [MAArray addObject:@""];
            [UPArray addObject:@""];
            [DNArray addObject:@""];
        }else{
            [MAArray addObject:[NSArray arrayWithObject:[NSString stringWithFormat:@"%.2f", [three[0] floatValue]]]];
            [UPArray addObject:[NSArray arrayWithObject:[NSString stringWithFormat:@"%.2f", [three[1] floatValue]]]];
            [DNArray addObject:[NSArray arrayWithObject:[NSString stringWithFormat:@"%.2f", [three[2] floatValue]]]];
        }
    }
    
    [dic setObject:MAArray forKey:@"MID"];
    [dic setObject:UPArray forKey:@"UP"];
    [dic setObject:DNArray forKey:@"DN"];
    
    //ENV
    //    float v = [@"14" floatValue];
    
    NSMutableArray *ENVArray = [GYStockLineIndicators envLine:data times:kpiModel.ENV1];
    NSMutableArray *up = [[NSMutableArray alloc] init];
    NSMutableArray *low = [[NSMutableArray alloc] init];
    NSMutableArray *mid = [[NSMutableArray alloc] init];
    
    for (int i=0; i<ENVArray.count; i++) {
        NSArray *three = ENVArray[i];
        if (i<kpiModel.ENV1) {
            [up addObject:@""];
            [low addObject:@""];
            [mid addObject:@""];
        }else{
            [up addObject:[NSArray arrayWithObject:[NSString stringWithFormat:@"%.2f", [three[0] floatValue]]]];
            [low addObject:[NSArray arrayWithObject:[NSString stringWithFormat:@"%.2f", [three[1] floatValue]]]];
            [mid addObject:[NSArray arrayWithObject:[NSString stringWithFormat:@"%.2f", [three[2] floatValue]]]];
        }
    }
    [dic setObject:up forKey:@"ENVUP"];
    [dic setObject:low forKey:@"ENVLOW"];
    [dic setObject:mid forKey:@"ENVMID"];
    
    //RSI6
    NSMutableArray *rsi6 = [[NSMutableArray alloc] init];
    for (int i= 0; i<data.count; i++) {
        if (i<kpiModel.RSI1) {
            [rsi6 addObject:@""];
        }else{
            float incVal  = 0;
            float decVal = 0;
            float rs = 0;
            for(int j=i;j>i-kpiModel.RSI1;j--){
                float interval = [[[data objectAtIndex:j] objectAtIndex:1] floatValue]-[[[data objectAtIndex:j] objectAtIndex:0] floatValue];
                if(interval >= 0){
                    incVal += interval;
                }else{
                    decVal -= interval;
                }
            }
            
            rs = incVal/decVal;
            float rsi =100-100/(1+rs);
            
            NSMutableArray *item = [[NSMutableArray alloc] init];
            [item addObject:[@"" stringByAppendingFormat:@"%f",rsi]];
            [rsi6 addObject:item];
            
            
        }
    }
    [dic setObject:rsi6 forKey:@"rsi6"];
    
    
    NSMutableArray *rsi12 = [[NSMutableArray alloc] init];
    for (int i= 0; i<data.count; i++) {
        if (i<kpiModel.RSI2) {
            [rsi12 addObject:@""];
        }else{
            //RSI12
            float incVal  = 0;
            float decVal = 0;
            float rs = 0;
            for(int j=i;j>i-kpiModel.RSI2;j--){
                float interval = [[[data objectAtIndex:j] objectAtIndex:1] floatValue]-[[[data objectAtIndex:j] objectAtIndex:0] floatValue];
                if(interval >= 0){
                    incVal += interval;
                }else{
                    decVal -= interval;
                }
            }
            
            rs = incVal/decVal;
            float rsi =100-100/(1+rs);
            
            NSMutableArray *item = [[NSMutableArray alloc] init];
            [item addObject:[@"" stringByAppendingFormat:@"%f",rsi]];
            [rsi12 addObject:item];
            
        }
    }
    [dic setObject:rsi12 forKey:@"rsi12"];
    
    NSMutableArray *rsi24 = [[NSMutableArray alloc] init];
    for (int i= 0; i<data.count; i++) {
        if (i<kpiModel.RSI3) {
            [rsi24 addObject:@""];
        }else{
            //RSI12
            float incVal  = 0;
            float decVal = 0;
            float rs = 0;
            for(int j=i;j>i-kpiModel.RSI3;j--){
                float interval = [[[data objectAtIndex:j] objectAtIndex:1] floatValue]-[[[data objectAtIndex:j] objectAtIndex:0] floatValue];
                if(interval >= 0){
                    incVal += interval;
                }else{
                    decVal -= interval;
                }
            }
            
            rs = incVal/decVal;
            float rsi =100-100/(1+rs);
            
            NSMutableArray *item = [[NSMutableArray alloc] init];
            [item addObject:[@"" stringByAppendingFormat:@"%f",rsi]];
            [rsi24 addObject:item];
            
        }
    }
    [dic setObject:rsi24 forKey:@"rsi24"];
    
    
    //WR
    NSMutableArray *wr = [[NSMutableArray alloc] init];
    for(int i = 0;i < data.count;i++){
        if (i<kpiModel.WR1) {
            [wr addObject:@""];
        }else{
            float h  = [[data[i] objectAtIndex:2] floatValue];
            float l = [[data[i] objectAtIndex:3] floatValue];
            float c = [[data[i] objectAtIndex:1] floatValue];
            
            for(int j=i;j>i-kpiModel.WR1;j--){
                if([[data[j] objectAtIndex:2] floatValue] > h){
                    h = [[data[j] objectAtIndex:2] floatValue];
                }
                
                if([[data[j] objectAtIndex:3] floatValue] < l){
                    l = [[data[j] objectAtIndex:3] floatValue];
                }
            }
            float val = (h-c)/(h-l)*100;
            NSMutableArray *item = [[NSMutableArray alloc] init];
            [item addObject:[@"" stringByAppendingFormat:@"%f",val]];
            [wr addObject:item];
            
        }
    }
    dic[@"wr"] = wr;

    
    //KDJ
    NSMutableArray *kdj_k = [[NSMutableArray alloc] init];
    NSMutableArray *kdj_d = [[NSMutableArray alloc] init];
    NSMutableArray *kdj_j = [[NSMutableArray alloc] init];
    float prev_k = 50;
    float prev_d = 50;
    float rsv = 0;
    for (int i=0; i<data.count; i++) {
        if (i<kpiModel.KDJ1) {
            [kdj_k addObject:@""];
            [kdj_d addObject:@""];
            [kdj_j addObject:@""];
            //[kdj_j addObject:[NSArray arrayWithObject:@""]];
        }else{
            float h  = [[[data objectAtIndex:i] objectAtIndex:2] floatValue];
            float l = [[[data objectAtIndex:i] objectAtIndex:3] floatValue];
            float c = [[[data objectAtIndex:i] objectAtIndex:1] floatValue];
            for(int j=i;j>i-9;j--){
                if([[[data objectAtIndex:j] objectAtIndex:2] floatValue] > h){
                    h = [[[data objectAtIndex:j] objectAtIndex:2] floatValue];
                }
                
                if([[[data objectAtIndex:j] objectAtIndex:3] floatValue] < l){
                    l = [[[data objectAtIndex:j] objectAtIndex:3] floatValue];
                }
            }
            if(h!=l)
                rsv = (c-l)/(h-l)*100;
            float k = 2*prev_k/kpiModel.KDJ2+1*rsv/kpiModel.KDJ2;
            float d = 2*prev_d/kpiModel.KDJ3+1*k/kpiModel.KDJ3;
            float j = k+2*(k-d);
            
            prev_k = k;
            prev_d = d;
            
            NSMutableArray *itemK = [[NSMutableArray alloc] init];
            [itemK addObject:[@"" stringByAppendingFormat:@"%f",k]];
            [kdj_k addObject:itemK];
            
            NSMutableArray *itemD = [[NSMutableArray alloc] init];
            [itemD addObject:[@"" stringByAppendingFormat:@"%f",d]];
            [kdj_d addObject:itemD];
            
            NSMutableArray *itemJ = [[NSMutableArray alloc] init];
            [itemJ addObject:[@"" stringByAppendingFormat:@"%f",j]];
            [kdj_j addObject:itemJ];
            
        }
        
    }
    dic[@"kdj_k"] = kdj_k;
    dic[@"kdj_d"] = kdj_d;
    dic[@"kdj_j"] = kdj_j;
    
    
    
    //MACD
    NSInteger ema12v = kpiModel.MACD1;
    NSInteger ema26v = kpiModel.MACD2;
    NSInteger deav = kpiModel.MACD3;
    
    
    //EMA12,EMA26,DIFF,DEA,MACD,BAR
    NSMutableArray *macd = [[NSMutableArray alloc] init];
    NSMutableArray *diff = [[NSMutableArray alloc] init];
    NSMutableArray *dea = [[NSMutableArray alloc] init];
    float preEma12 = 0;
    float nowEma12 = 0;
    float preEma26 = 0;
    float nowEma26 = 0;
    float nowDiff = 0;
    float preDea = 0;
    float nowDea = 0;
    float nowMacd = 0;
    float tmpColes = 0;
    
    for(int i = 0;i < data.count;i++){
        tmpColes = [[[data objectAtIndex:i] objectAtIndex:1] floatValue];
        if (i == 0) {
            preEma12 = tmpColes;
            preEma26 = tmpColes;
        }
        
        //            nowEma12 = (preEma12 * 11 + tmpColes * 2) / 13;
        nowEma12 = (preEma12 * (ema12v -1) + tmpColes * 2) / (ema12v +1);
        
        preEma12 = nowEma12;
        
        //            nowEma26 = (preEma26 * 25 + tmpColes * 2) / 27;
        nowEma26 = (preEma26 * (ema26v -1) + tmpColes * 2) / (ema26v +1);
        preEma26 = nowEma26;
        
        nowDiff = nowEma12 - nowEma26;
        if (i == 0) {
            preDea = nowDiff;
        }
        //            nowDea = (preDea * 8 + nowDiff * 2) / 10.0f;
        nowDea = (preDea * (deav -1) + nowDiff * 2) / (deav + 1);
        preDea = nowDea;
        //            NSLog(@"======%f==%f",nowDea,(preDea * 8 + nowDiff * 2) / 10.0f);
        
        nowMacd = 2*(nowDiff - nowDea);
        
        if(i > 20){
            NSMutableArray *item = [[NSMutableArray alloc] init];
            [item addObject:[@"" stringByAppendingFormat:@"%f",nowMacd]];
            [macd addObject:item];
        } else {
            NSMutableArray *item = [[NSMutableArray alloc] init];
            [item addObject:@"0"];
            [macd addObject:item];
        }
        
        if(i > 20){
            NSMutableArray *item2 = [[NSMutableArray alloc] init];
            [item2 addObject:[@"" stringByAppendingFormat:@"%f",nowDiff]];
            [diff addObject:item2];
        } else {
            [diff addObject:@""];
        }
        
        if(i > 20){
            NSMutableArray *item3 = [[NSMutableArray alloc] init];
            [item3 addObject:[@"" stringByAppendingFormat:@"%f",nowDea]];
            [dea addObject:item3];
        } else {
            [dea addObject:@""];
        }
        
    }
    [dic setObject:macd forKey:@"macd"];
    [dic setObject:diff forKey:@"diff"];
    [dic setObject:dea forKey:@"dea"];
    
    return dic;
}

//设置分时图的Series
+(NSMutableArray *)setNowKLineSeries
{
    
    NSMutableArray * KlineSeriesArr = [[NSMutableArray alloc]init];
    
    //收集数据的分组
    NSMutableArray *series = [[NSMutableArray alloc] init];
    
    NSMutableArray *secOne = [[NSMutableArray alloc] init];
    NSMutableArray *secTwo = [[NSMutableArray alloc] init];
    
    //均价
    NSMutableDictionary *serie = [[NSMutableDictionary alloc] init];
    NSMutableArray *data = [[NSMutableArray alloc] init];
    [serie setObject:kFenShiAvgNameLine forKey:@"name"]; //用于标记线段名称
    [serie setObject:@"均价" forKey:@"label"]; //当选中时，Label 要显示的名称
    [serie setObject:data forKey:@"data"]; //均线数据 （当获取到实时数据后，就是对此字段赋值；然后实时刷新UI）
    [serie setObject:kFenShiLine forKey:@"type"]; //标记当前绘图类型
    [serie setObject:@"0" forKey:@"yAxisType"]; //标记当前Y轴类型
    [serie setObject:@"0" forKey:@"section"]; //标记当前所属部分
    [serie setObject:kFenShiAvgColor forKey:@"color"]; //均价线段的颜色
    [series addObject:serie];
    [secOne addObject:serie];
    
    
    //实时价
    serie = [[NSMutableDictionary alloc] init];
    data = [[NSMutableArray alloc] init];
    [serie setObject:kFenShiNowNameLine forKey:@"name"];
    [serie setObject:@"数值" forKey:@"label"];
    [serie setObject:data forKey:@"data"];
    [serie setObject:kFenShiLine forKey:@"type"];
    [serie setObject:@"1" forKey:@"yAxisType"];
    [serie setObject:@"0" forKey:@"section"];
    [serie setObject:kFenShiNowColor forKey:@"color"];
    [series addObject:serie];
    [secOne addObject:serie];
    
    //VOL
    serie = [[NSMutableDictionary alloc] init];
    data = [[NSMutableArray alloc] init];
    [serie setObject:kFenShiVolNameColumn forKey:@"name"];
    [serie setObject:@"量" forKey:@"label"];
    [serie setObject:data forKey:@"data"];
    [serie setObject:kFenShiColumn forKey:@"type"];
    [serie setObject:@"1" forKey:@"section"];
    [serie setObject:@"0" forKey:@"decimal"]; //保留几位小数
    [series addObject:serie];
    [secTwo addObject:serie];
    
    [KlineSeriesArr addObject:series];
    [KlineSeriesArr addObject:secOne];
    [KlineSeriesArr addObject:secTwo];
    
    return KlineSeriesArr;
    
}


//设置日线的Series
+(NSMutableArray *)setDayKLineSeriesWithKPIModel:(GYStockKPIModel *)kpiModel
{
    NSMutableArray * KlineSeriesArr = [[NSMutableArray alloc]init];
    
    NSMutableArray *series = [[NSMutableArray alloc] init];
    NSMutableArray *secOne = [[NSMutableArray alloc] init];
    NSMutableArray *secTwo = [[NSMutableArray alloc] init];
    NSMutableArray *secThree = [[NSMutableArray alloc] init];
    
    //price
    NSMutableDictionary *serie = [[NSMutableDictionary alloc] init];
    NSMutableArray *data = [[NSMutableArray alloc] init];
    serie[@"name"] = @"price";
    serie[@"label"] = @"Price";
    serie[@"data"] = data;
    serie[@"type"] = @"candle";
    serie[@"yAxis"] = @"0";
    serie[@"section"] = @"0";
    serie[@"color"] = kFenShiNowColor;
    serie[@"negativeColor"] = kFenShiNowColor;
    serie[@"selectedColor"] = kFenShiNowColor;
    serie[@"negativeSelectedColor"] = kFenShiNowColor;
    serie[@"labelColor"] = [UIColor colorWithRed:176/255.0 green:52/255.0 blue:52/255.0 alpha:1];
    serie[@"labelNegativeColor"] = [UIColor colorWithRed:77/255.0 green:143/255.0 blue:42/255.0 alpha:1];
    [series addObject:serie];
    [secOne addObject:serie];
    
    //MA5 十日平均线
    serie = [[NSMutableDictionary alloc] init];
    data = [[NSMutableArray alloc] init];
    serie[@"name"] = @"ma5";
    serie[@"label"] = [NSString stringWithFormat:@"MA%ld",kpiModel.MA1];
    serie[@"data"] = data;
    serie[@"type"] = @"line";
    serie[@"yAxis"] = @"0";
    serie[@"section"] = @"0";
    serie[@"color"] = MA10Color;
    serie[@"negativeColor"] = MA10Color;
    serie[@"selectedColor"] = MA10Color;
    serie[@"negativeSelectedColor"] = MA10Color;
    [series addObject:serie];
    [secOne addObject:serie];
    
    //MA30  三十日平均线（中期）
    serie = [[NSMutableDictionary alloc] init];
    data = [[NSMutableArray alloc] init];
    serie[@"name"] = @"ma10";
    serie[@"label"] = [NSString stringWithFormat:@"MA%ld",kpiModel.MA2];
    serie[@"data"] = data;
    serie[@"type"] = @"line";
    serie[@"yAxis"] = @"0";
    serie[@"section"] = @"0";
    serie[@"color"] = MA30Color;
    serie[@"negativeColor"] = MA30Color;
    serie[@"selectedColor"] = MA30Color;
    serie[@"negativeSelectedColor"] = MA30Color;
    [series addObject:serie];
    [secOne addObject:serie];
    
    //MA60  六十日平均线（长期）
    serie = [[NSMutableDictionary alloc] init];
    data = [[NSMutableArray alloc] init];
    serie[@"name"] = /**/@"ma20";
    serie[@"label"] = [NSString stringWithFormat:@"MA%ld",kpiModel.MA3];
    serie[@"data"] = data;
    serie[@"type"] = @"line";
    serie[@"yAxis"] = @"0";
    serie[@"section"] = @"0";
    serie[@"color"] = MA60Color;
    serie[@"negativeColor"] = MA60Color;
    serie[@"selectedColor"] = MA60Color;
    serie[@"negativeSelectedColor"] = MA60Color;
    [series addObject:serie];
    [secOne addObject:serie];
    
    //VOL  成交量指标
    serie = [[NSMutableDictionary alloc] init];
    data = [[NSMutableArray alloc] init];
    serie[@"name"] = @"vol";
    serie[@"label"] = @"VOL";
    serie[@"data"] = data;
    serie[@"type"] = @"column";
    serie[@"yAxis"] = @"0";
    serie[@"section"] = @"1";
    serie[@"decimal"] = @"0";
    serie[@"color"] = [UIColor colorWithRed:176/255.0 green:52/255.0 blue:52/255.0 alpha:1];
    serie[@"negativeColor"] = [UIColor colorWithRed:77/255.0 green:143/255.0 blue:42/255.0 alpha:1];
    serie[@"selectedColor"] = [UIColor colorWithRed:176/255.0 green:52/255.0 blue:52/255.0 alpha:1];
    serie[@"negativeSelectedColor"] = [UIColor colorWithRed:77/255.0 green:143/255.0 blue:42/255.0 alpha:1];
    [series addObject:serie];
    [secTwo addObject:serie];
    
    //BOLL
    
    //up
    serie = [[NSMutableDictionary alloc] init];
    data = [[NSMutableArray alloc] init];
    [serie setObject:@"UP" forKey:@"name"];
    [serie setObject:@"UP" forKey:@"label"];
    [serie setObject:data forKey:@"data"];
    [serie setObject:@"line" forKey:@"type"];
    [serie setObject:@"%.3f" forKey:@"precision"];
    [serie setObject:@"0" forKey:@"yAxis"];
    [serie setObject:@"0" forKey:@"section"];
    [serie setObject:MA10Color forKey:@"color"];
    [serie setObject:MA10Color forKey:@"negativeColor"];
    [serie setObject:MA10Color forKey:@"selectedColor"];
    [serie setObject:MA10Color forKey:@"negativeSelectedColor"];
    [series addObject:serie];
    [secOne addObject:serie];
    
    //MID
    serie = [[NSMutableDictionary alloc] init];
    data = [[NSMutableArray alloc] init];
    [serie setObject:@"MID" forKey:@"name"];
    [serie setObject:@"MID" forKey:@"label"];
    [serie setObject:data forKey:@"data"];
    [serie setObject:@"line" forKey:@"type"];
    [serie setObject:@"%.3f" forKey:@"precision"];
    [serie setObject:@"0" forKey:@"yAxis"];
    [serie setObject:@"0" forKey:@"section"];
    [serie setObject:@"4" forKey:@"decimal"];
    [serie setObject:MA30Color forKey:@"color"];
    [serie setObject:MA30Color forKey:@"negativeColor"];
    [serie setObject:MA30Color forKey:@"selectedColor"];
    [serie setObject:MA30Color forKey:@"negativeSelectedColor"];
    [series addObject:serie];
    [secOne addObject:serie];
    
    
    //dn
    serie = [[NSMutableDictionary alloc] init];
    data = [[NSMutableArray alloc] init];
    [serie setObject:@"DN" forKey:@"name"];
    [serie setObject:@"DN" forKey:@"label"];
    [serie setObject:@"%.3f" forKey:@"precision"];
    [serie setObject:data forKey:@"data"];
    [serie setObject:@"line" forKey:@"type"];
    [serie setObject:@"0" forKey:@"yAxis"];
    [serie setObject:@"0" forKey:@"section"];
    [serie setObject:MA60Color forKey:@"color"];
    [serie setObject:MA60Color forKey:@"negativeColor"];
    [series addObject:serie];
    [secOne addObject:serie];
    
    
    //ENV
    serie = [[NSMutableDictionary alloc] init];
    data = [[NSMutableArray alloc] init];
    [serie setObject:@"ENVUP" forKey:@"name"];
    [serie setObject:@"UP" forKey:@"label"];
    [serie setObject:data forKey:@"data"];
    [serie setObject:@"line" forKey:@"type"];
    [serie setObject:@"%.3f" forKey:@"precision"];
    [serie setObject:@"0" forKey:@"yAxis"];
    [serie setObject:@"0" forKey:@"section"];
    [serie setObject:@"4" forKey:@"decimal"];
    [serie setObject:MA10Color forKey:@"color"];
    [serie setObject:MA10Color forKey:@"negativeColor"];
    [serie setObject:MA10Color forKey:@"selectedColor"];
    [serie setObject:MA10Color forKey:@"negativeSelectedColor"];
    [series addObject:serie];
    [secOne addObject:serie];
    
    
    //mid
    serie = [[NSMutableDictionary alloc] init];
    data = [[NSMutableArray alloc] init];
    [serie setObject:@"ENVMID" forKey:@"name"];
    [serie setObject:@"MID" forKey:@"label"];
    [serie setObject:@"%.3f" forKey:@"precision"];
    [serie setObject:data forKey:@"data"];
    [serie setObject:@"line" forKey:@"type"];
    [serie setObject:@"0" forKey:@"yAxis"];
    [serie setObject:@"0" forKey:@"section"];
    [serie setObject:MA30Color forKey:@"color"];
    [serie setObject:MA30Color forKey:@"negativeColor"];
    [series addObject:serie];
    [secOne addObject:serie];
    
    //low
    serie = [[NSMutableDictionary alloc] init];
    data = [[NSMutableArray alloc] init];
    [serie setObject:@"ENVLOW" forKey:@"name"];
    //        [serie setObject:@"LOW(25)" forKey:@"label"];
    [serie setObject:@"LOW" forKey:@"label"];
    [serie setObject:data forKey:@"data"];
    [serie setObject:@"line" forKey:@"type"];
    [serie setObject:@"%.3f" forKey:@"precision"];
    [serie setObject:@"0" forKey:@"yAxis"];
    [serie setObject:@"0" forKey:@"section"];
    [serie setObject:MA60Color forKey:@"color"];
    [serie setObject:MA60Color forKey:@"negativeColor"];
    [serie setObject:MA60Color forKey:@"selectedColor"];
    [serie setObject:MA60Color forKey:@"negativeSelectedColor"];
    [series addObject:serie];
    [secOne addObject:serie];
    
    
    //MACD
    NSMutableArray * macdArray = [[NSMutableArray alloc] init];
    serie = [[NSMutableDictionary alloc] init];
    data = [[NSMutableArray alloc] init];
    [serie setObject:@"macd" forKey:@"name"];
    [serie setObject:data forKey:@"data"];
    [serie setObject:@"MACD" forKey:@"label"];
    [serie setObject:@"column" forKey:@"type"];
    [serie setObject:@"%.3f" forKey:@"precision"];
    [serie setObject:@"0" forKey:@"yAxis"];
    [serie setObject:@"1" forKey:@"section"];
    [serie setObject:@"4" forKey:@"decimal"];
    [serie setObject:KDJ_J forKey:@"color"];
    [serie setObject:KDJ_J forKey:@"negativeColor"];
    [serie setObject:KDJ_J forKey:@"selectedColor"];
    [serie setObject:KDJ_J forKey:@"negativeSelectedColor"];
    [series addObject:serie];
    [macdArray addObject:serie];
    
    //DIFF
    serie = [[NSMutableDictionary alloc] init];
    data = [[NSMutableArray alloc] init];
    [serie setObject:@"diff" forKey:@"name"];
    [serie setObject:@"DIFF" forKey:@"label"];
    [serie setObject:data forKey:@"data"];
    [serie setObject:@"line" forKey:@"type"];
    [serie setObject:@"%.3f" forKey:@"precision"];
    [serie setObject:@"0" forKey:@"yAxis"];
    [serie setObject:@"1" forKey:@"section"];
    [serie setObject:WRColor forKey:@"color"];
    [serie setObject:WRColor forKey:@"negativeColor"];
    [serie setObject:WRColor forKey:@"selectedColor"];
    [serie setObject:WRColor forKey:@"negativeSelectedColor"];
    [series addObject:serie];
    [macdArray addObject:serie];
    
    //DEA
    serie = [[NSMutableDictionary alloc] init];
    data = [[NSMutableArray alloc] init];
    [serie setObject:@"dea" forKey:@"name"];
    [serie setObject:@"DEA" forKey:@"label"];
    [serie setObject:@"%.3f" forKey:@"precision"];
    [serie setObject:data forKey:@"data"];
    [serie setObject:@"line" forKey:@"type"];
    [serie setObject:@"0" forKey:@"yAxis"];
    [serie setObject:@"1" forKey:@"section"];
    [serie setObject:KDJ_J forKey:@"color"];
    [serie setObject:KDJ_J forKey:@"negativeColor"];
    [series addObject:serie];
    [macdArray addObject:serie];
    [secThree addObject:macdArray];
    
    //RSI6
    NSMutableArray * RSIArray = [[NSMutableArray alloc] init];
    serie = [[NSMutableDictionary alloc] init];
    data = [[NSMutableArray alloc] init];
    serie[@"name"] = @"rsi6";
    serie[@"label"] = [NSString stringWithFormat:@"RSI%ld",kpiModel.RSI1];
    serie[@"type"] = @"line";
    serie[@"yAxis"] = @"0";
    serie[@"section"] = @"1";
    serie[@"color"] = KDJ_K;
    serie[@"negativeColor"] = KDJ_K;
    serie[@"selectedColor"] = KDJ_K;
    serie[@"negativeSelectedColor"] = KDJ_K;
    [series addObject:serie];
    [RSIArray addObject:serie];
    
    //RSI12
    serie = [[NSMutableDictionary alloc] init];
    data = [[NSMutableArray alloc] init];
    serie[@"name"] = @"rsi12";
    serie[@"label"] = [NSString stringWithFormat:@"RSI%ld",kpiModel.RSI2];
    serie[@"type"] = @"line";
    serie[@"yAxis"] = @"0";
    serie[@"section"] = @"1";
    serie[@"color"] = KDJ_D;
    serie[@"negativeColor"] = KDJ_D;
    serie[@"selectedColor"] = KDJ_D;
    serie[@"negativeSelectedColor"] = KDJ_D;
    [series addObject:serie];
    [RSIArray addObject:serie];
    
    
    //RSI24
    serie = [[NSMutableDictionary alloc] init];
    data = [[NSMutableArray alloc] init];
    serie[@"name"] = @"rsi24";
    serie[@"label"] = [NSString stringWithFormat:@"RSI%ld",kpiModel.RSI3];
    serie[@"type"] = @"line";
    serie[@"yAxis"] = @"0";
    serie[@"section"] = @"1";
    serie[@"color"] = KDJ_J;
    serie[@"negativeColor"] = KDJ_J;
    serie[@"selectedColor"] = KDJ_J;
    serie[@"negativeSelectedColor"] = KDJ_J;
    [series addObject:serie];
    [RSIArray addObject:serie];
    [secThree addObject:RSIArray];
    
    //kdj_k
    NSMutableArray * kdjArray = [[NSMutableArray alloc] init];
    serie = [[NSMutableDictionary alloc] init];
    data = [[NSMutableArray alloc] init];
    serie[@"name"] = @"kdj_k";
    serie[@"label"] =[NSString stringWithFormat:@"KDJ(%ld,%ld,%ld)",kpiModel.KDJ1,kpiModel.KDJ2,kpiModel.KDJ3];
    serie[@"type"] = @"line";
    serie[@"yAxis"] = @"0";
    serie[@"section"] = @"1";
    serie[@"color"] = KDJ_K;
    serie[@"negativeColor"] = KDJ_K;
    serie[@"selectedColor"] = KDJ_K;
    serie[@"negativeSelectedColor"] = KDJ_K;
    [series addObject:serie];
    [kdjArray addObject:serie];
    
    //kdj_d
    serie = [[NSMutableDictionary alloc] init];
    data = [[NSMutableArray alloc] init];
    serie[@"name"] = @"kdj_d";
    serie[@"label"] = @"D";
    serie[@"type"] = @"line";
    serie[@"yAxis"] = @"0";
    serie[@"section"] = @"1";
    serie[@"color"] = KDJ_D;
    serie[@"negativeColor"] = KDJ_D;
    serie[@"selectedColor"] = KDJ_D;
    serie[@"negativeSelectedColor"] = KDJ_D;
    [series addObject:serie];
    [kdjArray addObject:serie];
    
    //kdj_j
    serie = [[NSMutableDictionary alloc] init];
    data = [[NSMutableArray alloc] init];
    serie[@"name"] = @"kdj_j";
    serie[@"label"] = @"J";
    serie[@"type"] = @"line";
    serie[@"yAxis"] = @"0";
    serie[@"section"] = @"1";
    serie[@"color"] = KDJ_J;
    serie[@"negativeColor"] = KDJ_J;
    serie[@"selectedColor"] = KDJ_J;
    serie[@"negativeSelectedColor"] = KDJ_J;
    [series addObject:serie];
    [kdjArray addObject:serie];
    [secThree addObject:kdjArray];
    
    //WR
    
    serie = [[NSMutableDictionary alloc] init];
    data = [[NSMutableArray alloc] init];
    serie[@"name"] = @"wr";
    serie[@"label"] = @"WR";
    serie[@"type"] = @"line";
    serie[@"yAxis"] = @"0";
    serie[@"section"] = @"1";
    serie[@"color"] = WRColor;
    serie[@"negativeColor"] = WRColor;
    serie[@"selectedColor"] = WRColor;
    serie[@"negativeSelectedColor"] = WRColor;
    [series addObject:serie];
    [secThree addObject:serie];
    
    [KlineSeriesArr addObject:series];
    [KlineSeriesArr addObject:secOne];
    [KlineSeriesArr addObject:secThree];
    
    return KlineSeriesArr;
}
//Lab中数字变化时，渐变
+ (void)gradualChangeLabWithEndNum:(NSString *)endNum Lab:(UILabel *)Lab Timer:(NSTimer *)changeTimer{
    //    NSLog(@"endNum:%@",endNum);
    //如果第一次进某个界面，lab内容为空，直接替换，防止计算闪退
    if (!Lab.text) {
        Lab.text = endNum;
        return;
    }
    //如果变化数值变化超过20个单位，则直接替换
    static int flag = 1;
    //确定每次加减的值
    NSString * changeStr;
    NSArray * sellArray;
    if ([Lab.text length] > [endNum length]) {
        sellArray = [Lab.text componentsSeparatedByString:@"."];
    }else{
        sellArray = [endNum componentsSeparatedByString:@"."];
    }
    
    if (sellArray.count > 1) {
        NSMutableString * str = [[NSMutableString alloc]initWithString:@"0."];
        for (NSInteger i = 1; i < [sellArray[1] length]; i++) {
            [str appendFormat:@"0"];
        }
        [str appendFormat:@"1"];
        changeStr = str;
    }else{
        changeStr = @"1";
    }
    
    NSDecimalNumber * endNumber = [NSDecimalNumber decimalNumberWithString:endNum];
    NSDecimalNumber * labNum= [NSDecimalNumber decimalNumberWithString:Lab.text];
    NSComparisonResult result = [labNum compare:endNumber];

    //如果已经变化了20次，则直接替换
    if (flag == 20) {
        Lab.text = endNum;
        [changeTimer setFireDate:[NSDate distantFuture]];
        flag = 1;
        return;
    }
    //小于
    if (result == NSOrderedAscending) {
        
        NSDecimalNumber * priceNumber = [NSDecimalNumber decimalNumberWithString:Lab.text];
        
        NSDecimalNumber * addNum = [NSDecimalNumber decimalNumberWithString:changeStr];
        
        NSDecimalNumber *product = [priceNumber decimalNumberByAdding:addNum];
        Lab.text = [NSString stringWithFormat:@"%@",product];
        
        
    } else if (result == NSOrderedSame) {
        [changeTimer setFireDate:[NSDate distantFuture]];
        flag = 1;
        return;
    } else if (result == NSOrderedDescending) {
        NSDecimalNumber * priceNumber = [NSDecimalNumber decimalNumberWithString:Lab.text];
        
        NSDecimalNumber * subNum = [NSDecimalNumber decimalNumberWithString:changeStr];
        NSDecimalNumber *product = [priceNumber decimalNumberBySubtracting:subNum];
        //
        //        NSLog(@"subNum:%@",subNum);
        Lab.text = [NSString stringWithFormat:@"%@",product];
    }
    flag++;
    
}

@end
